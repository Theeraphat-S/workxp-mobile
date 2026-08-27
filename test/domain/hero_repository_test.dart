import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';

void main() {
  late AppDatabase db;
  late HeroRepository heroRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    heroRepo = HeroRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('HeroRepository Tests', () {
    test('1. watchHero and getHero retrieve seeded Hero Arthur', () async {
      final hero = await heroRepo.getHero();
      expect(hero, isNotNull);
      expect(hero!.name, equals('Arthur'));
      expect(hero.level, equals(1));
      expect(hero.hp, equals(100));
      expect(hero.mp, equals(50));
      expect(hero.coins, equals(0));
      expect(hero.isGhost, isFalse);

      // Verify stream emission
      final streamHero = await heroRepo.watchHero().first;
      expect(streamHero?.name, equals('Arthur'));
    });

    test(
      '2. awardExp single level up with excess EXP and +3 stat points',
      () async {
        // Level 1 needs 100 EXP. Awarding 120 EXP should reach Level 2 with 20 EXP remaining.
        await heroRepo.awardExp(120);

        final hero = await heroRepo.getHero();
        expect(hero!.level, equals(2));
        expect(hero.currentExp, equals(20));
        expect(hero.unspentStatPoints, equals(3));
        expect(hero.hp, equals(100));
        expect(hero.mp, equals(50));
      },
    );

    test('3. awardExp multi-level jump (Level 1 -> Level 3)', () async {
      // Level 1 -> 2 needs 100 EXP. Level 2 -> 3 needs floor(100 * 1.25) = 125 EXP.
      // Total needed for Lvl 3 = 225 EXP.
      // Awarding 250 EXP should reach Level 3 with 25 EXP remaining and +6 stat points.
      await heroRepo.awardExp(250);

      final hero = await heroRepo.getHero();
      expect(hero!.level, equals(3));
      expect(hero.currentExp, equals(25));
      expect(hero.unspentStatPoints, equals(6));
    });

    test('4. Ghost State blocks awardExp and gainCoins', () async {
      await heroRepo.setGhostState(true);
      var hero = await heroRepo.getHero();
      expect(hero!.isGhost, isTrue);

      // Attempt to gain EXP and Coins while in Ghost State
      await heroRepo.awardExp(50);
      await heroRepo.gainCoins(100);

      hero = await heroRepo.getHero();
      expect(hero!.currentExp, equals(0));
      expect(hero.coins, equals(0));
    });

    test(
      '5. takeDamage reduces HP, clamps to 0, and triggers Ghost State at 0 HP',
      () async {
        // Take 40 damage: 100 -> 60
        await heroRepo.takeDamage(40);
        var hero = await heroRepo.getHero();
        expect(hero!.hp, equals(60));
        expect(hero.isGhost, isFalse);

        // Take 80 damage: 60 -> 0 (clamped, triggers ghost)
        await heroRepo.takeDamage(80);
        hero = await heroRepo.getHero();
        expect(hero!.hp, equals(0));
        expect(hero.isGhost, isTrue);
      },
    );

    test('6. heal restores HP clamped to maxHp', () async {
      await heroRepo.takeDamage(50); // HP: 50
      await heroRepo.heal(30); // HP: 80
      var hero = await heroRepo.getHero();
      expect(hero!.hp, equals(80));

      await heroRepo.heal(50); // HP: 100 (clamped to maxHp)
      hero = await heroRepo.getHero();
      expect(hero!.hp, equals(100));
    });

    test('7. allocateAttributes distributes unspent points properly', () async {
      // Award EXP to gain 3 unspent stat points
      await heroRepo.awardExp(100);
      var hero = await heroRepo.getHero();
      expect(hero!.unspentStatPoints, equals(3));

      // Attempt to allocate 5 points (more than available) -> should fail
      final failResult = await heroRepo.allocateAttributes(str: 3, agi: 2);
      expect(failResult, isFalse);

      // Allocate 2 STR and 1 AGI -> should succeed
      final successResult = await heroRepo.allocateAttributes(str: 2, agi: 1);
      expect(successResult, isTrue);

      hero = await heroRepo.getHero();
      expect(hero!.str, equals(7)); // 5 + 2
      expect(hero.agi, equals(6)); // 5 + 1
      expect(hero.unspentStatPoints, equals(0));
    });

    test('8. setGhostState revival restores 50% HP', () async {
      await heroRepo.takeDamage(100); // HP: 0, isGhost: true
      var hero = await heroRepo.getHero();
      expect(hero!.isGhost, isTrue);
      expect(hero.hp, equals(0));

      // Revive
      await heroRepo.setGhostState(false);
      hero = await heroRepo.getHero();
      expect(hero!.isGhost, isFalse);
      expect(hero.hp, equals(50)); // 50% of 100 max HP
    });

    test('9. gainCoins and spendCoins economy transactions', () async {
      await heroRepo.gainCoins(150);
      var hero = await heroRepo.getHero();
      expect(hero!.coins, equals(150));

      // Spend 50 coins -> succeeds
      final spendSuccess = await heroRepo.spendCoins(50);
      expect(spendSuccess, isTrue);
      hero = await heroRepo.getHero();
      expect(hero!.coins, equals(100));

      // Spend 200 coins -> fails
      final spendFail = await heroRepo.spendCoins(200);
      expect(spendFail, isFalse);
      hero = await heroRepo.getHero();
      expect(hero!.coins, equals(100));
    });

    test('10. equipSkin and equipTitle update customization', () async {
      await heroRepo.equipSkin('paladin');
      await heroRepo.equipTitle('Titan Berserker');

      final hero = await heroRepo.getHero();
      expect(hero!.avatarSkinId, equals('paladin'));
      expect(hero.activeTitle, equals('Titan Berserker'));
    });

    test('11. restoreMp and spendMp pool management', () async {
      // Initial MP is 50/50
      final spendOk = await heroRepo.spendMp(30);
      expect(spendOk, isTrue);
      var hero = await heroRepo.getHero();
      expect(hero!.mp, equals(20));

      final spendTooMuch = await heroRepo.spendMp(40);
      expect(spendTooMuch, isFalse);

      await heroRepo.restoreMp(20);
      hero = await heroRepo.getHero();
      expect(hero!.mp, equals(40));
    });
  });
}
