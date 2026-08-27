import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';

void main() {
  late AppDatabase db;
  late BossRepository bossRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    bossRepo = BossRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BossRepository Tests', () {
    test(
      '1. watchActiveBoss and getActiveBoss return King Slime for Chapter 1',
      () async {
        final boss = await bossRepo.getActiveBoss();
        expect(boss, isNotNull);
        expect(boss!.name, equals('King Slime'));
        expect(boss.chapter, equals(1));
        expect(boss.maxHp, equals(500));
        expect(boss.currentHp, equals(500));
        expect(boss.isActive, isTrue);
        expect(boss.isDefeated, isFalse);

        final streamBoss = await bossRepo.watchActiveBoss().first;
        expect(streamBoss?.id, equals('boss_slime'));
      },
    );

    test('2. watchAllBosses retrieves all 4 chapters in order', () async {
      final bosses = await bossRepo.watchAllBosses().first;
      expect(bosses.length, equals(4));
      expect(bosses[0].chapter, equals(1));
      expect(bosses[1].chapter, equals(2));
      expect(bosses[2].chapter, equals(3));
      expect(bosses[3].chapter, equals(4));
    });

    test('3. applyDamage reduces HP and flags isDefeated on zero HP', () async {
      // Apply 200 damage to King Slime (500 -> 300)
      await bossRepo.applyDamage(200);
      var boss = await bossRepo.getActiveBoss();
      expect(boss!.currentHp, equals(300));
      expect(boss.isDefeated, isFalse);

      // Apply 400 damage (overkill) -> HP should clamp to 0 and isDefeated = true
      await bossRepo.applyDamage(400);
      boss = await bossRepo.getActiveBoss();
      expect(boss!.currentHp, equals(0));
      expect(boss.isDefeated, isTrue);
    });

    test(
      '4. advanceToNextBoss unlocks and activates Chapter 2 Goblin Shaman',
      () async {
        final nextBoss = await bossRepo.advanceToNextBoss();
        expect(nextBoss, isNotNull);
        expect(nextBoss!.id, equals('boss_goblin'));
        expect(nextBoss.chapter, equals(2));
        expect(nextBoss.isActive, isTrue);

        final oldBoss = await bossRepo.getBossByChapter(1);
        expect(oldBoss!.isActive, isFalse);
      },
    );

    test('5. selectActiveChapter switches active boss encounter', () async {
      await bossRepo.selectActiveChapter(3);

      final active = await bossRepo.getActiveBoss();
      expect(active, isNotNull);
      expect(active!.id, equals('boss_necromancer'));
      expect(active.chapter, equals(3));
    });

    test('6. resetBoss restores maxHp and clears defeat flag', () async {
      await bossRepo.applyDamage(500, bossId: 'boss_slime');
      var slime = await bossRepo.getBossByChapter(1);
      expect(slime!.currentHp, equals(0));
      expect(slime.isDefeated, isTrue);

      await bossRepo.resetBoss('boss_slime');
      slime = await bossRepo.getBossByChapter(1);
      expect(slime!.currentHp, equals(500));
      expect(slime.isDefeated, isFalse);
    });
  });
}
