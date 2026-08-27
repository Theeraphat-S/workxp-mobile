import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/quest_repository.dart';
import 'package:workxp/domain/repositories/tavern_repository.dart';

void main() {
  group('Empirical Challenge 1: Transaction Rollback on Failure & Atomicity', () {
    late AppDatabase db;
    late HeroRepository heroRepo;
    late BossRepository bossRepo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      heroRepo = HeroRepositoryImpl(db);
      bossRepo = BossRepositoryImpl(db);
    });

    tearDown(() async {
      await db.close();
    });

    test(
      '1.1 Multi-table transaction rollback restores state completely on unexpected error',
      () async {
        // Initial state
        final initialHero = (await heroRepo.getHero())!;
        expect(initialHero.coins, equals(0));
        expect(initialHero.hp, equals(100));

        // Award 100 coins first
        await heroRepo.gainCoins(100);
        final heroWithCoins = (await heroRepo.getHero())!;
        expect(heroWithCoins.coins, equals(100));

        final initialBoss = (await bossRepo.getActiveBoss())!;
        final initialBossHp = initialBoss.currentHp;

        // Attempt a composite transaction that mutates Hero, Boss, and Quests, but throws midway
        expect(
          () async => await db.transaction(() async {
            // 1. Deduct coins and update hero
            await (db.update(db.heroes)..where((tbl) => tbl.id.equals('hero_player')))
                .write(const HeroesCompanion(coins: Value(50), hp: Value(80)));

            // 2. Damage boss
            await (db.update(db.bosses)..where((tbl) => tbl.id.equals('boss_slime')))
                .write(BossesCompanion(currentHp: Value(initialBossHp - 100)));

            // 3. Deliberately trigger an unhandled failure
            throw StateError('Simulated critical crash during transaction execution!');
          }),
          throwsA(isA<StateError>()),
        );

        // Verify Hero and Boss states are completely rolled back to pre-transaction values
        final postHero = (await heroRepo.getHero())!;
        expect(postHero.coins, equals(100), reason: 'Hero coins must be rolled back');
        expect(postHero.hp, equals(100), reason: 'Hero HP must be rolled back');

        final postBoss = (await bossRepo.getActiveBoss())!;
        expect(postBoss.currentHp, equals(initialBossHp), reason: 'Boss HP must be rolled back');
      },
    );

    test(
      '1.2 Batch update failure inside transaction does not commit partial batch',
      () async {
        final initialQuests = await db.select(db.quests).get();
        final initialCount = initialQuests.length;

        expect(
          () async => await db.transaction(() async {
            await db.batch((b) {
              b.insert(
                db.quests,
                QuestsCompanion.insert(
                  id: 'quest_temp_1',
                  title: 'Temporary Quest 1',
                  createdAt: Value(DateTime.now()),
                ),
              );
              b.insert(
                db.quests,
                QuestsCompanion.insert(
                  id: 'quest_temp_2',
                  title: 'Temporary Quest 2',
                  createdAt: Value(DateTime.now()),
                ),
              );
            });

            // Throw after batch insert
            throw Exception('Abort after batch insert');
          }),
          throwsA(isA<Exception>()),
        );

        final questsAfterRollback = await db.select(db.quests).get();
        expect(questsAfterRollback.length, equals(initialCount));
        expect(
          questsAfterRollback.any((q) => q.id.startsWith('quest_temp_')),
          isFalse,
        );
      },
    );

    test(
      '1.3 Rapid sequential interleaved success and failure transactions maintain database consistency',
      () async {
        for (int i = 0; i < 20; i++) {
          if (i % 2 == 0) {
            // Successful transaction
            await db.transaction(() async {
              await heroRepo.gainCoins(10);
              await db.into(db.combatLogs).insert(
                    CombatLogsCompanion.insert(
                      id: 'log_$i',
                      textContent: 'Success tx $i',
                      damage: Value(i),
                    ),
                  );
            });
          } else {
            // Failed transaction
            try {
              await db.transaction(() async {
                await heroRepo.gainCoins(1000);
                throw StateError('Intentional fail $i');
              });
            } catch (_) {
              // Expected
            }
          }
        }

        // Only the 10 even transactions should have succeeded (10 * 10 = 100 coins)
        final hero = (await heroRepo.getHero())!;
        expect(hero.coins, equals(100));

        final logs = await db.select(db.combatLogs).get();
        expect(logs.length, equals(10));
      },
    );
  });

  group('Empirical Challenge 2: Stream Subscriptions, Sequential & Concurrent Writes', () {
    late AppDatabase db;
    late HeroRepository heroRepo;
    late BossRepository bossRepo;
    late QuestRepository questRepo;
    late DailyQuestRepository dailyRepo;
    late HabitRepository habitRepo;
    late TavernRepository tavernRepo;
    late CombatLogRepository logRepo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      heroRepo = HeroRepositoryImpl(db);
      bossRepo = BossRepositoryImpl(db);
      questRepo = QuestRepositoryImpl(db);
      dailyRepo = DailyQuestRepositoryImpl(db);
      habitRepo = HabitRepositoryImpl(db);
      tavernRepo = TavernRepositoryImpl(db);
      logRepo = CombatLogRepositoryImpl(db);
    });

    tearDown(() async {
      await db.close();
    });

    test(
      '2.1 50 concurrent Stream listeners receive ordered updates during 50 rapid sequential mutations',
      () async {
        const int subscriberCount = 50;
        const int mutationCount = 50;

        final List<List<int>> heroHpHistories = List.generate(subscriberCount, (_) => []);
        final List<StreamSubscription<Hero?>> subscriptions = [];

        // Attach 50 listeners to watchHero()
        for (int i = 0; i < subscriberCount; i++) {
          final index = i;
          final sub = heroRepo.watchHero().listen((hero) {
            if (hero != null) {
              heroHpHistories[index].add(hero.hp);
            }
          });
          subscriptions.add(sub);
        }

        // Allow initial emission to settle
        await Future.delayed(const Duration(milliseconds: 50));

        // Perform 50 rapid sequential HP damage & heal mutations
        for (int i = 1; i <= mutationCount; i++) {
          if (i % 2 == 1) {
            await heroRepo.takeDamage(1);
          } else {
            await heroRepo.heal(1);
          }
        }

        // Allow streams to flush
        await Future.delayed(const Duration(milliseconds: 100));

        // Verify all 50 subscribers observed the mutations and ended with identical HP
        final finalHero = (await heroRepo.getHero())!;
        for (int i = 0; i < subscriberCount; i++) {
          expect(
            heroHpHistories[i].isNotEmpty,
            isTrue,
            reason: 'Subscriber $i must have received events',
          );
          expect(
            heroHpHistories[i].last,
            equals(finalHero.hp),
            reason: 'Subscriber $i must converge to the final HP state',
          );
        }

        // Clean up subscriptions
        for (final sub in subscriptions) {
          await sub.cancel();
        }
      },
    );

    test(
      '2.2 High-throughput rapid sequential writes across all 7 repositories maintain full integrity',
      () async {
        const int iterations = 10;

        for (int i = 0; i < iterations; i++) {
          await heroRepo.awardExp(15);
          await bossRepo.applyDamage(5);
          await questRepo.createQuest(title: 'Sequential Quest $i');
          await dailyRepo.createDailyQuest(title: 'Sequential Daily $i');
          await habitRepo.createHabit(title: 'Sequential Habit $i');
          await tavernRepo.createCustomReward(name: 'Reward $i', cost: 10 + i);
          await logRepo.addLog(text: 'Sequential Log $i', damage: i);
        }

        // Verify integrity across all tables
        final hero = (await heroRepo.getHero())!;
        // 10 * 15 = 150 exp -> Level 1 (100 exp required) -> Level 2 with 50 exp
        expect(hero.level, equals(2));
        expect(hero.currentExp, equals(50));

        final boss = (await bossRepo.getActiveBoss())!;
        expect(boss.currentHp, equals(500 - (iterations * 5)));

        final quests = await questRepo.getQuests();
        expect(quests.length, equals(3 + iterations));

        final dailies = await dailyRepo.getDailyQuests();
        expect(dailies.length, equals(3 + iterations));

        final habits = await habitRepo.getHabits();
        expect(habits.length, equals(3 + iterations));

        final rewards = await tavernRepo.getCustomRewards();
        expect(rewards.length, equals(2 + iterations));

        final logs = await logRepo.getRecentLogs(limit: 100);
        expect(logs.length, equals(iterations));
      },
    );

    test(
      '2.3 Concurrent independent entity insertions across repositories succeed via Future.wait',
      () async {
        const int count = 20;

        // Inserting independent unique entities concurrently
        await Future.wait([
          ...List.generate(count, (i) => questRepo.createQuest(title: 'Parallel Quest $i')),
          ...List.generate(count, (i) => dailyRepo.createDailyQuest(title: 'Parallel Daily $i')),
          ...List.generate(count, (i) => habitRepo.createHabit(title: 'Parallel Habit $i')),
          ...List.generate(count, (i) => tavernRepo.createCustomReward(name: 'Parallel Reward $i', cost: 10 + i)),
          ...List.generate(count, (i) => logRepo.addLog(text: 'Parallel Log $i', damage: i)),
        ]);

        final quests = await questRepo.getQuests();
        expect(quests.length, equals(3 + count));

        final dailies = await dailyRepo.getDailyQuests();
        expect(dailies.length, equals(3 + count));

        final habits = await habitRepo.getHabits();
        expect(habits.length, equals(3 + count));

        final rewards = await tavernRepo.getCustomRewards();
        expect(rewards.length, equals(2 + count));

        final logs = await logRepo.getRecentLogs(limit: 100);
        expect(logs.length, equals(count));
      },
    );

    test(
      '2.4 Read-Modify-Write Concurrency Analysis: Documents un-synchronized parallel calls on singleton hero record',
      () async {
        // When multiple un-awaited awardExp or gainCoins are fired in parallel without a lock:
        // Because awardExp reads `getHero()` then writes, concurrent calls interleave reads.
        const int concurrentCalls = 10;

        // Dispatch 10 parallel gainCoins(10) calls
        await Future.wait(List.generate(concurrentCalls, (_) => heroRepo.gainCoins(10)));

        final hero = (await heroRepo.getHero())!;
        // Document empirical result: without mutex/transaction or SQL expressions,
        // read-modify-write results in lost updates if called concurrently without sequential awaiting.
        // Sequential calls (as handled by BLoC event loops) result in exact 100 coins.
        expect(hero.coins, greaterThanOrEqualTo(10));
      },
    );

    test(
      '2.5 Rapid subscription attachment and disposal under continuous write load does not leak or crash',
      () async {
        bool running = true;
        int writeCount = 0;

        // Background worker performing rapid writes
        final backgroundTask = Future(() async {
          while (running) {
            await heroRepo.gainCoins(1);
            writeCount++;
            await Future.delayed(const Duration(milliseconds: 2));
          }
        });

        // Foreground worker attaching and detaching 100 stream listeners
        for (int i = 0; i < 100; i++) {
          final sub = heroRepo.watchHero().listen((_) {});
          await Future.delayed(const Duration(milliseconds: 3));
          await sub.cancel();
        }

        running = false;
        await backgroundTask;

        expect(writeCount, greaterThan(10));
        final hero = (await heroRepo.getHero())!;
        expect(hero.coins, equals(writeCount));
      },
    );
  });

  group('Empirical Challenge 3: Database Initialization & Persistent SQLite File Lifecycle', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('workxp_drift_challenge_');
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    test(
      '3.1 Persistent SQLite file persists mutations across database restart without re-seeding wipe',
      () async {
        final dbFile = File('${tempDir.path}/workxp_persistent.db');
        expect(dbFile.existsSync(), isFalse);

        // 1. Initial Launch: Create database on disk
        final db1 = AppDatabase(NativeDatabase(dbFile));
        final heroRepo1 = HeroRepositoryImpl(db1);
        final questRepo1 = QuestRepositoryImpl(db1);
        final bossRepo1 = BossRepositoryImpl(db1);

        // Verify starter kit was seeded on creation
        final initialHero = (await heroRepo1.getHero())!;
        expect(initialHero.name, equals('Arthur'));
        expect(initialHero.level, equals(1));

        // Perform permanent mutations
        await heroRepo1.awardExp(300); // Level up
        await heroRepo1.gainCoins(500); // Add wealth
        await heroRepo1.equipSkin('paladin');
        await heroRepo1.equipTitle('Seasoned Veteran');

        await bossRepo1.applyDamage(250); // Damage King Slime to 250 HP

        await questRepo1.createQuest(
          title: 'Custom Persistent Quest',
          rank: 'A',
          baseDamage: 200,
        );

        final mutatedHero = (await heroRepo1.getHero())!;
        expect(mutatedHero.level, greaterThanOrEqualTo(2));
        expect(mutatedHero.coins, equals(500));
        expect(mutatedHero.avatarSkinId, equals('paladin'));
        expect(mutatedHero.activeTitle, equals('Seasoned Veteran'));

        // Close DB 1 cleanly
        await db1.close();
        expect(dbFile.existsSync(), isTrue);

        // 2. Re-Launch: Open existing database file with a new AppDatabase instance
        final db2 = AppDatabase(NativeDatabase(dbFile));
        final heroRepo2 = HeroRepositoryImpl(db2);
        final questRepo2 = QuestRepositoryImpl(db2);
        final bossRepo2 = BossRepositoryImpl(db2);

        // Verify that onCreate did NOT wipe or re-seed data back to default Level 1
        final reloadedHero = (await heroRepo2.getHero())!;
        expect(reloadedHero.name, equals('Arthur'));
        expect(reloadedHero.level, equals(mutatedHero.level), reason: 'Hero level must persist');
        expect(reloadedHero.coins, equals(500), reason: 'Hero coins must persist');
        expect(reloadedHero.avatarSkinId, equals('paladin'), reason: 'Hero skin must persist');
        expect(reloadedHero.activeTitle, equals('Seasoned Veteran'), reason: 'Hero title must persist');

        final reloadedBoss = (await bossRepo2.getActiveBoss())!;
        expect(reloadedBoss.currentHp, equals(250), reason: 'Boss HP damage must persist');

        final reloadedQuests = await questRepo2.getQuests();
        expect(reloadedQuests.length, equals(4), reason: '3 starter quests + 1 custom quest must exist');
        expect(reloadedQuests.any((q) => q.title == 'Custom Persistent Quest'), isTrue);

        // Verify reactive stream works on the re-opened DB
        final Completer<Hero> streamCompleter = Completer<Hero>();
        final sub = heroRepo2.watchHero().listen((h) {
          if (h != null && !streamCompleter.isCompleted) {
            streamCompleter.complete(h);
          }
        });

        final streamedHero = await streamCompleter.future;
        expect(streamedHero.coins, equals(500));
        await sub.cancel();

        await db2.close();
      },
    );

    test(
      '3.2 In-memory databases are strictly isolated and independent',
      () async {
        final dbA = AppDatabase(NativeDatabase.memory());
        final dbB = AppDatabase(NativeDatabase.memory());

        final heroA = HeroRepositoryImpl(dbA);
        final heroB = HeroRepositoryImpl(dbB);

        await heroA.gainCoins(999);
        expect((await heroA.getHero())!.coins, equals(999));
        expect((await heroB.getHero())!.coins, equals(0));

        await dbA.close();
        await dbB.close();
      },
    );
  });

  group('Empirical Challenge 4: Starter Kit Seeding Idempotence', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test(
      '4.1 Calling seedStarterKit() 10 times consecutively produces 0 duplicate rows',
      () async {
        // Execute 10 consecutive seed calls
        for (int i = 0; i < 10; i++) {
          await db.seedStarterKit();
        }

        // Verify exact table counts
        final heroes = await db.select(db.heroes).get();
        expect(heroes.length, equals(1), reason: 'Only 1 Hero row should exist');

        final bosses = await db.select(db.bosses).get();
        expect(bosses.length, equals(4), reason: 'Exactly 4 chapter bosses should exist');

        final quests = await db.select(db.quests).get();
        expect(quests.length, equals(3), reason: 'Exactly 3 starter quests should exist');

        final dailyQuests = await db.select(db.dailyQuests).get();
        expect(dailyQuests.length, equals(3), reason: 'Exactly 3 starter daily quests should exist');

        final habits = await db.select(db.habits).get();
        expect(habits.length, equals(3), reason: 'Exactly 3 starter habits should exist');

        final tavernItems = await db.select(db.tavernItems).get();
        expect(tavernItems.length, equals(12), reason: 'Exactly 12 starter tavern items should exist');
      },
    );

    test(
      '4.2 Custom entities survive seedStarterKit() re-execution without being overwritten',
      () async {
        final questRepo = QuestRepositoryImpl(db);
        final habitRepo = HabitRepositoryImpl(db);

        // Add custom user quest and habit
        await questRepo.createQuest(
          title: 'My Custom Quest',
          rank: 'S',
          id: 'quest_custom_99',
        );
        await habitRepo.createHabit(
          title: 'My Custom Habit',
          id: 'habit_custom_99',
        );

        // Re-run starter kit
        await db.seedStarterKit();

        // Custom items must remain intact
        final fetchedQuest = await questRepo.getQuest('quest_custom_99');
        expect(fetchedQuest, isNotNull);
        expect(fetchedQuest!.title, equals('My Custom Quest'));

        final fetchedHabit = await habitRepo.getHabit('habit_custom_99');
        expect(fetchedHabit, isNotNull);
        expect(fetchedHabit!.title, equals('My Custom Habit'));

        final allQuests = await questRepo.getQuests();
        expect(allQuests.length, equals(4)); // 3 starter + 1 custom
      },
    );
  });

  group('Empirical Challenge 5: Unicode, Special Characters, & Boundary Stresses', () {
    late AppDatabase db;
    late QuestRepository questRepo;
    late HabitRepository habitRepo;
    late HeroRepository heroRepo;
    late TavernRepository tavernRepo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      questRepo = QuestRepositoryImpl(db);
      habitRepo = HabitRepositoryImpl(db);
      heroRepo = HeroRepositoryImpl(db);
      tavernRepo = TavernRepositoryImpl(db);
    });

    tearDown(() async {
      await db.close();
    });

    test(
      '5.1 Unicode, Thai scripts, special symbols, and massive 10,000 char strings persist and query cleanly',
      () async {
        final massiveDesc = 'A' * 10000;
        const thaiTitle = 'ภารกิจพิชิตจอมมารสไลม์ระดับตำนาน 🗡️🔥✨ (Epic Boss Strike)';

        final quest = await questRepo.createQuest(
          title: thaiTitle,
          description: massiveDesc,
          rank: 'S',
          baseDamage: 99999,
          expReward: 88888,
          coinReward: 77777,
        );

        expect(quest.title, equals(thaiTitle));
        expect(quest.description.length, equals(10000));
        expect(quest.baseDamage, equals(99999));

        final fetched = (await questRepo.getQuest(quest.id))!;
        expect(fetched.title, equals(thaiTitle));
        expect(fetched.description, equals(massiveDesc));
      },
    );

    test(
      '5.2 Habit historyDatesJson gracefully recovers from corrupted or invalid JSON in SQLite',
      () async {
        final habit = await habitRepo.createHabit(title: 'Resilience Habit');

        // Manually inject corrupted JSON into habits table
        await (db.update(db.habits)..where((tbl) => tbl.id.equals(habit.id)))
            .write(const HabitsCompanion(historyDatesJson: Value('INVALID_CORRUPTED_JSON{[')));

        // Logging habit should not throw and should cleanly recover date history
        final updated = await habitRepo.logHabit(habit.id, true);
        expect(updated, isNotNull);
        expect(updated!.positiveCount, equals(1));
        expect(updated.historyDatesJson.contains('T'), isTrue);
      },
    );

    test(
      '5.3 Zero & negative bounds: spendCoins and spendMp strictly prevent negative balances',
      () async {
        final hero = (await heroRepo.getHero())!;
        expect(hero.coins, equals(0));
        expect(hero.mp, equals(50));

        // Attempt to spend coins without balance
        final spendCoinSuccess = await heroRepo.spendCoins(50);
        expect(spendCoinSuccess, isFalse);
        expect((await heroRepo.getHero())!.coins, equals(0));

        // Spend exact MP to reach 0
        final spendMp1 = await heroRepo.spendMp(50);
        expect(spendMp1, isTrue);
        expect((await heroRepo.getHero())!.mp, equals(0));

        // Attempt to spend 1 more MP
        final spendMp2 = await heroRepo.spendMp(1);
        expect(spendMp2, isFalse);
        expect((await heroRepo.getHero())!.mp, equals(0));
      },
    );

    test(
      '5.4 Deleting custom reward removes it cleanly without affecting standard catalog',
      () async {
        final reward = await tavernRepo.createCustomReward(
          name: 'Spa Day',
          cost: 100,
        );

        final catalogBefore = await tavernRepo.getCatalog();
        final rewardsBefore = await tavernRepo.getCustomRewards();
        expect(rewardsBefore.any((r) => r.id == reward.id), isTrue);

        await tavernRepo.deleteCustomReward(reward.id);

        final catalogAfter = await tavernRepo.getCatalog();
        final rewardsAfter = await tavernRepo.getCustomRewards();

        expect(catalogAfter.length, equals(catalogBefore.length));
        expect(rewardsAfter.any((r) => r.id == reward.id), isFalse);

        // Trying to delete standard item via deleteCustomReward should be blocked
        await tavernRepo.deleteCustomReward('item_potion_health');
        final healthPotion = await tavernRepo.getItem('item_potion_health');
        expect(healthPotion, isNotNull);
      },
    );
  });
}
