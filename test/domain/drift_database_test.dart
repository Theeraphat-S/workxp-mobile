import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Schema & Starter Kit Seeding', () {
    test(
      '1. AppDatabase creates schema version 1 and seeds Starter Hero Arthur',
      () async {
        expect(db.schemaVersion, equals(1));

        final hero = await (db.select(
          db.heroes,
        )..where((tbl) => tbl.id.equals('hero_player'))).getSingleOrNull();

        expect(hero, isNotNull);
        expect(hero!.name, equals('Arthur'));
        expect(hero.level, equals(1));
        expect(hero.currentExp, equals(0));
        expect(hero.hp, equals(100));
        expect(hero.maxHp, equals(100));
        expect(hero.mp, equals(50));
        expect(hero.maxMp, equals(50));
        expect(hero.coins, equals(0));
        expect(hero.str, equals(5));
        expect(hero.agi, equals(5));
        expect(hero.intAttr, equals(5));
        expect(hero.vit, equals(5));
        expect(hero.unspentStatPoints, equals(0));
        expect(hero.isGhost, isFalse);
        expect(hero.activeTitle, equals('Novice Adventurer'));
        expect(hero.avatarSkinId, equals('hero_novice'));
        expect(hero.bannerId, equals('default_banner'));
      },
    );

    test(
      '2. AppDatabase seeds all 4 Bosses with King Slime active in Chapter 1',
      () async {
        final bosses = await (db.select(
          db.bosses,
        )..orderBy([(tbl) => OrderingTerm.asc(tbl.chapter)])).get();

        expect(bosses.length, equals(4));

        // Chapter 1: King Slime (Active)
        final slime = bosses[0];
        expect(slime.id, equals('boss_slime'));
        expect(slime.name, equals('King Slime'));
        expect(slime.chapter, equals(1));
        expect(slime.maxHp, equals(500));
        expect(slime.currentHp, equals(500));
        expect(slime.iconAsset, equals('boss_slime'));
        expect(slime.isActive, isTrue);
        expect(slime.isDefeated, isFalse);

        // Chapter 2: Goblin Shaman (Inactive)
        final goblin = bosses[1];
        expect(goblin.id, equals('boss_goblin'));
        expect(goblin.name, equals('Goblin Shaman'));
        expect(goblin.chapter, equals(2));
        expect(goblin.maxHp, equals(1000));
        expect(goblin.isActive, isFalse);

        // Chapter 3: Dread Necromancer
        final necro = bosses[2];
        expect(necro.id, equals('boss_necromancer'));
        expect(necro.chapter, equals(3));
        expect(necro.maxHp, equals(2000));

        // Chapter 4: Red Dragon
        final dragon = bosses[3];
        expect(dragon.id, equals('boss_dragon'));
        expect(dragon.chapter, equals(4));
        expect(dragon.maxHp, equals(5000));
      },
    );

    test('3. AppDatabase seeds 3 Starter Quests (E, D, C ranks)', () async {
      final quests = await db.select(db.quests).get();
      expect(quests.length, equals(3));

      final q1 = quests.firstWhere((q) => q.id == 'quest_starter_1');
      expect(q1.title, equals('Explore Battle Hub & Strike King Slime'));
      expect(q1.rank, equals('D'));
      expect(q1.baseDamage, equals(50));
      expect(q1.expReward, equals(40));
      expect(q1.coinReward, equals(20));
      expect(q1.isCompleted, isFalse);

      final q2 = quests.firstWhere((q) => q.id == 'quest_starter_2');
      expect(q2.title, equals('Tidy Workspace & Prepare Battle Station'));
      expect(q2.rank, equals('E'));
      expect(q2.baseDamage, equals(25));
      expect(q2.expReward, equals(20));
      expect(q2.coinReward, equals(10));

      final q3 = quests.firstWhere((q) => q.id == 'quest_starter_3');
      expect(q3.title, equals('Read 10 Pages of Knowledge'));
      expect(q3.rank, equals('C'));
      expect(q3.baseDamage, equals(100));
      expect(q3.expReward, equals(80));
      expect(q3.coinReward, equals(40));
    });

    test('4. AppDatabase seeds 3 Starter Daily Quests', () async {
      final dailies = await db.select(db.dailyQuests).get();
      expect(dailies.length, equals(3));

      final d1 = dailies.firstWhere((d) => d.id == 'daily_starter_1');
      expect(d1.title, equals('Morning Physical Exercise (30 Mins)'));
      expect(d1.streak, equals(1));
      expect(d1.isCompleted, isFalse);

      final d2 = dailies.firstWhere((d) => d.id == 'daily_starter_2');
      expect(d2.title, equals('Daily Deep Work / Coding Session'));
      expect(d2.streak, equals(2));

      final d3 = dailies.firstWhere((d) => d.id == 'daily_starter_3');
      expect(d3.title, equals('Mindful Evening Review & Plan Tomorrow'));
      expect(d3.streak, equals(1));
    });

    test(
      '5. AppDatabase seeds 3 Starter Habits (positive and negative)',
      () async {
        final habits = await db.select(db.habits).get();
        expect(habits.length, equals(3));

        final h1 = habits.firstWhere((h) => h.id == 'habit_starter_1');
        expect(h1.title, equals('Drink 1 Glass of Fresh Water'));
        expect(h1.isPositive, isTrue);
        expect(h1.isNegative, isFalse);

        final h2 = habits.firstWhere((h) => h.id == 'habit_starter_2');
        expect(h2.title, equals('Good Posture Check'));
        expect(h2.isPositive, isTrue);

        final h3 = habits.firstWhere((h) => h.id == 'habit_starter_3');
        expect(h3.title, equals('Mindless Social Media Scrolling'));
        expect(h3.isPositive, isFalse);
        expect(h3.isNegative, isTrue);
      },
    );

    test(
      '6. AppDatabase seeds Tavern items (Consumables, Skins, Themes, Custom)',
      () async {
        final items = await db.select(db.tavernItems).get();
        expect(items.length, greaterThanOrEqualTo(12));

        final healthPotion = items.firstWhere(
          (i) => i.id == 'item_potion_health',
        );
        expect(healthPotion.name, equals('Health Potion'));
        expect(healthPotion.category, equals('consumable'));
        expect(healthPotion.cost, equals(25));
        expect(healthPotion.effectValue, equals(50));
        expect(healthPotion.quantity, equals(0));

        final paladin = items.firstWhere((i) => i.id == 'paladin');
        expect(paladin.name, equals('Holy Paladin Skin'));
        expect(paladin.category, equals('skin'));
        expect(paladin.cost, equals(150));
        expect(paladin.isPurchased, isFalse);

        final boba = items.firstWhere((i) => i.id == 'starter_boba');
        expect(boba.name, equals('1 Delicious Boba Tea'));
        expect(boba.category, equals('custom_reward'));
        expect(boba.cost, equals(50));
      },
    );
  });
}
