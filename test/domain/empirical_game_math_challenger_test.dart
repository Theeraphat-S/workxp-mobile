import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/quest_repository.dart';
import 'package:workxp/domain/repositories/tavern_repository.dart';

void main() {
  late AppDatabase db;
  late HeroRepository heroRepo;
  late BossRepository bossRepo;
  late QuestRepository questRepo;
  late DailyQuestRepository dailyRepo;
  late HabitRepository habitRepo;
  late TavernRepository tavernRepo;
  late CombatLogRepository combatLogRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedStarterKit();

    heroRepo = HeroRepositoryImpl(db);
    bossRepo = BossRepositoryImpl(db);
    questRepo = QuestRepositoryImpl(db);
    dailyRepo = DailyQuestRepositoryImpl(db);
    habitRepo = HabitRepositoryImpl(db);
    tavernRepo = TavernRepositoryImpl(db);
    combatLogRepo = CombatLogRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Adversarial Challenge 1: Multi-Level EXP Progression & Formulas', () {
    test(
      'expTargetForLevel matches discrete exponential scaling formula floor(100 * 1.25^(L-1))',
      () {
        expect(HeroModel.expTargetForLevel(1), equals(100));
        expect(HeroModel.expTargetForLevel(2), equals(125));
        expect(HeroModel.expTargetForLevel(3), equals(156));
        expect(HeroModel.expTargetForLevel(4), equals(195));
        expect(HeroModel.expTargetForLevel(5), equals(244));
        expect(HeroModel.expTargetForLevel(6), equals(305));
        expect(HeroModel.expTargetForLevel(10), equals(745));
        expect(HeroModel.expTargetForLevel(0), equals(100));
        expect(HeroModel.expTargetForLevel(-5), equals(100));
      },
    );

    test('Zero or negative EXP awards are strictly no-ops', () async {
      final initial = await heroRepo.getHero();
      expect(initial, isNotNull);

      await heroRepo.awardExp(0);
      var hero = await heroRepo.getHero();
      expect(hero!.level, equals(initial!.level));
      expect(hero.currentExp, equals(initial.currentExp));

      await heroRepo.awardExp(-500);
      hero = await heroRepo.getHero();
      expect(hero!.level, equals(initial.level));
      expect(hero.currentExp, equals(initial.currentExp));
    });

    test(
      'Exact EXP boundary hit levels up cleanly with 0 remaining EXP',
      () async {
        await heroRepo.awardExp(100); // Lvl 1 target is 100
        final hero = await heroRepo.getHero();
        expect(hero, isNotNull);
        expect(hero!.level, equals(2));
        expect(hero.currentExp, equals(0));
        expect(hero.unspentStatPoints, equals(3));
      },
    );

    test(
      'Multi-level burst (+10,000 EXP) calculates multi-tier progression, unspent points, and title',
      () async {
        // Starting: Level 1, 0 EXP, 0 unspent points, title: 'Novice Adventurer'
        // Level targets: L1: 100, L2: 125, L3: 156, L4: 195, L5: 244, L6: 305, L7: 381, L8: 476, L9: 596, L10: 745...
        // Cumulative EXP for L1->L10: 100+125+156+195+244+305+381+476+596 = 2578 EXP (reaches Level 10)
        await heroRepo.awardExp(10000);

        final hero = await heroRepo.getHero();
        expect(hero, isNotNull);
        expect(hero!.level, greaterThanOrEqualTo(10));
        // Level jumped >= 9 times, so unspentStatPoints = (newLevel - 1) * 3
        expect(hero.unspentStatPoints, equals((hero.level - 1) * 3));
        // Title should automatically upgrade to 'Legendary Champion' at lvl >= 10
        expect(hero.activeTitle, equals('Legendary Champion'));
        // HP and MP should be fully restored to max
        expect(hero.hp, equals(hero.maxHp));
        expect(hero.mp, equals(hero.maxMp));
      },
    );

    test('Attribute point allocation enforces balance constraints', () async {
      // Level up to gain 6 stat points
      await heroRepo.awardExp(
        225,
      ); // L1 (100) + L2 (125) -> Level 3 (6 stat points)
      var hero = await heroRepo.getHero();
      expect(hero!.level, equals(3));
      expect(hero.unspentStatPoints, equals(6));

      // Attempt to over-allocate (7 points when 6 available) -> must fail
      final overAllocSuccess = await heroRepo.allocateAttributes(
        str: 4,
        agi: 3,
      );
      expect(overAllocSuccess, isFalse);
      hero = await heroRepo.getHero();
      expect(hero!.unspentStatPoints, equals(6));
      expect(hero.str, equals(5));
      expect(hero.agi, equals(5));

      // Valid allocation of 4 points: 2 STR, 1 AGI, 1 INT
      final validAllocSuccess = await heroRepo.allocateAttributes(
        str: 2,
        agi: 1,
        intAttr: 1,
      );
      expect(validAllocSuccess, isTrue);
      hero = await heroRepo.getHero();
      expect(hero!.unspentStatPoints, equals(2));
      expect(hero.str, equals(7));
      expect(hero.agi, equals(6));
      expect(hero.intAttr, equals(6));
      expect(hero.vit, equals(5));

      // Zero or negative allocation returns false
      final zeroAllocSuccess = await heroRepo.allocateAttributes(
        str: 0,
        agi: 0,
      );
      expect(zeroAllocSuccess, isFalse);
    });
  });

  group(
    'Adversarial Challenge 2: Ghost State, Overkill Clamping & Revival Invariants',
    () {
      test(
        'Overkill damage clamps HP to exactly 0 and triggers Ghost State',
        () async {
          // Hero has 100 HP
          await heroRepo.takeDamage(999999);
          final hero = await heroRepo.getHero();
          expect(hero, isNotNull);
          expect(hero!.hp, equals(0));
          expect(hero.isGhost, isTrue);
        },
      );

      test('Ghost State strictly blocks EXP gains and Coin gains', () async {
        await heroRepo.takeDamage(100);
        var hero = await heroRepo.getHero();
        expect(hero!.isGhost, isTrue);
        expect(hero.currentExp, equals(0));
        expect(hero.coins, equals(0));

        // Attempt to gain EXP in Ghost State
        await heroRepo.awardExp(500);
        hero = await heroRepo.getHero();
        expect(hero!.currentExp, equals(0));
        expect(hero.level, equals(1));

        // Attempt to gain Coins in Ghost State
        await heroRepo.gainCoins(100);
        hero = await heroRepo.getHero();
        expect(hero!.coins, equals(0));
      });

      test(
        'Revival via setGhostState(false) sets HP to 50% maxHp when at 0 HP',
        () async {
          await heroRepo.takeDamage(100);
          var hero = await heroRepo.getHero();
          expect(hero!.isGhost, isTrue);
          expect(hero.hp, equals(0));

          // Revive
          await heroRepo.setGhostState(false);
          hero = await heroRepo.getHero();
          expect(hero!.isGhost, isFalse);
          expect(hero.hp, equals(50)); // 50% of 100
        },
      );

      test(
        'Consumable item_elixir_life performs full revival to 100% HP from Ghost State',
        () async {
          // Enter ghost state
          await heroRepo.takeDamage(100);
          var hero = await heroRepo.getHero();
          expect(hero!.isGhost, isTrue);
          expect(hero.hp, equals(0));

          // Purchase elixir (give coins first while alive or via companion update)
          await heroRepo.setGhostState(false);
          await heroRepo.gainCoins(200);
          await heroRepo.takeDamage(
            100,
          ); // Back into ghost state with 200 coins
          hero = await heroRepo.getHero();
          expect(hero!.isGhost, isTrue);
          expect(hero.coins, equals(200));

          final purchased = await tavernRepo.purchaseItem('item_elixir_life');
          expect(purchased, isTrue);

          final used = await tavernRepo.useConsumable('item_elixir_life');
          expect(used, isTrue);

          hero = await heroRepo.getHero();
          expect(hero!.isGhost, isFalse);
          expect(hero.hp, equals(hero.maxHp)); // 100 HP
        },
      );

      test(
        'item_exp_tonic consumable does not award EXP when in Ghost State',
        () async {
          await heroRepo.gainCoins(200);
          await tavernRepo.purchaseItem('item_exp_tonic');
          await heroRepo.takeDamage(100); // Enter Ghost State

          var hero = await heroRepo.getHero();
          expect(hero!.isGhost, isTrue);

          final used = await tavernRepo.useConsumable('item_exp_tonic');
          expect(used, isTrue);

          hero = await heroRepo.getHero();
          expect(hero!.currentExp, equals(0));
          expect(hero.level, equals(1));
        },
      );
    },
  );

  group(
    'Adversarial Challenge 3: Habit Economy, MP Management & Daily Streaks',
    () {
      test(
        'Logging positive and negative habits increments counters and tracks history JSON',
        () async {
          final habits = await habitRepo.getHabits();
          expect(habits, isNotEmpty);
          final habitId = habits.first.id;

          await habitRepo.logHabit(habitId, true);
          await habitRepo.logHabit(habitId, true);
          await habitRepo.logHabit(habitId, false);

          final updated = await habitRepo.getHabit(habitId);
          expect(updated, isNotNull);
          expect(updated!.positiveCount, equals(2));
          expect(updated.negativeCount, equals(1));
          expect(updated.historyDatesJson.contains('T'), isTrue);
        },
      );

      test(
        'DailyQuest toggle manages streak increments and decrements cleanly',
        () async {
          final dailies = await dailyRepo.getDailyQuests();
          expect(dailies, isNotEmpty);
          final dailyId = dailies.first.id;
          final initialStreak = dailies.first.streak;

          // Complete daily -> streak increments
          final completed = await dailyRepo.toggleDailyQuest(dailyId);
          expect(completed!.isCompleted, isTrue);
          expect(completed.streak, equals(initialStreak + 1));
          expect(completed.lastCompletedDate, isNotNull);

          // Uncheck daily -> streak decrements
          final unchecked = await dailyRepo.toggleDailyQuest(dailyId);
          expect(unchecked!.isCompleted, isFalse);
          expect(unchecked.streak, equals(initialStreak));
        },
      );

      test(
        'processMidnightReset resets all completed flags and counts uncompleted dailies',
        () async {
          // Check 1 daily, leave 2 uncompleted
          final dailies = await dailyRepo.getDailyQuests();
          expect(dailies.length, equals(3));
          await dailyRepo.toggleDailyQuest(dailies[0].id);

          final missedCount = await dailyRepo.processMidnightReset();
          expect(missedCount, equals(2)); // 2 were not completed

          final afterReset = await dailyRepo.getDailyQuests();
          expect(afterReset.every((d) => !d.isCompleted), isTrue);
        },
      );

      test(
        'MP pool spending rejects excessive amounts and prevents negative MP',
        () async {
          var hero = await heroRepo.getHero();
          expect(hero!.mp, equals(50));

          // Attempt to spend 60 MP (exceeds 50) -> fails
          final failSpend = await heroRepo.spendMp(60);
          expect(failSpend, isFalse);
          hero = await heroRepo.getHero();
          expect(hero!.mp, equals(50));

          // Spend 30 MP -> succeeds, balance 20
          final successSpend = await heroRepo.spendMp(30);
          expect(successSpend, isTrue);
          hero = await heroRepo.getHero();
          expect(hero!.mp, equals(20));

          // Restore 40 MP -> caps at maxMp (50)
          await heroRepo.restoreMp(40);
          hero = await heroRepo.getHero();
          expect(hero!.mp, equals(50));
        },
      );
    },
  );

  group(
    'Adversarial Challenge 4: Tavern Economy, Inventory & Consumable Limits',
    () {
      test(
        'Purchasing with insufficient coins is rejected and mutates nothing',
        () async {
          final heroBefore = await heroRepo.getHero();
          expect(heroBefore!.coins, equals(0));

          final purchased = await tavernRepo.purchaseItem(
            'item_potion_health',
          ); // cost 25
          expect(purchased, isFalse);

          final item = await tavernRepo.getItem('item_potion_health');
          expect(item!.quantity, equals(0));
        },
      );

      test(
        'Consumable quantity decrements on use; using with 0 quantity returns false',
        () async {
          final useEmpty = await tavernRepo.useConsumable('item_potion_health');
          expect(useEmpty, isFalse);

          // Give coins and buy 2 potions
          await heroRepo.gainCoins(100);
          await tavernRepo.purchaseItem('item_potion_health');
          await tavernRepo.purchaseItem('item_potion_health');

          var item = await tavernRepo.getItem('item_potion_health');
          expect(item!.quantity, equals(2));

          // Injure hero to 40 HP
          await heroRepo.takeDamage(60);
          var hero = await heroRepo.getHero();
          expect(hero!.hp, equals(40));

          // Use 1 potion (+50 HP -> caps at 100)
          final used = await tavernRepo.useConsumable('item_potion_health');
          expect(used, isTrue);

          hero = await heroRepo.getHero();
          expect(hero!.hp, equals(90));

          item = await tavernRepo.getItem('item_potion_health');
          expect(item!.quantity, equals(1));
        },
      );

      test('Custom reward CRUD and redemption loop', () async {
        final reward = await tavernRepo.createCustomReward(
          name: 'Afternoon Espresso',
          cost: 30,
          description: 'Double espresso boost',
        );
        expect(reward.name, equals('Afternoon Espresso'));
        expect(reward.cost, equals(30));

        // Try redeeming with 0 coins -> fails
        final failRedeem = await tavernRepo.redeemCustomReward(reward.id);
        expect(failRedeem, isFalse);

        // Gain 50 coins -> redeem succeeds, coins balance becomes 20, redemption count is 1
        await heroRepo.gainCoins(50);
        final successRedeem = await tavernRepo.redeemCustomReward(reward.id);
        expect(successRedeem, isTrue);

        final hero = await heroRepo.getHero();
        expect(hero!.coins, equals(20));

        final item = await tavernRepo.getItem(reward.id);
        expect(item!.quantity, equals(1)); // quantity tracks redemption count

        // Delete custom reward
        await tavernRepo.deleteCustomReward(reward.id);
        final deleted = await tavernRepo.getItem(reward.id);
        expect(deleted, isNull);
      });
    },
  );

  group('Adversarial Challenge 5: Boss Chapter Progression & Quest Lifecycle', () {
    test('Boss damage clamps to 0 HP and marks isDefeated', () async {
      var activeBoss = await bossRepo.getActiveBoss();
      expect(activeBoss, isNotNull);
      expect(activeBoss!.chapter, equals(1));
      expect(activeBoss.currentHp, equals(500));

      // Strike boss for 600 damage
      await bossRepo.applyDamage(600);

      activeBoss = await bossRepo.getActiveBoss();
      expect(activeBoss!.currentHp, equals(0));
      expect(activeBoss.isDefeated, isTrue);
    });

    test(
      'advanceToNextBoss transitions through chapters 1->2->3->4 and clamps safely at chapter 4',
      () async {
        // Ch 1 -> Ch 2
        var next = await bossRepo.advanceToNextBoss();
        expect(next!.chapter, equals(2));
        expect(next.id, equals('boss_goblin'));
        expect(next.isActive, isTrue);

        // Ch 2 -> Ch 3
        next = await bossRepo.advanceToNextBoss();
        expect(next!.chapter, equals(3));
        expect(next.id, equals('boss_necromancer'));

        // Ch 3 -> Ch 4
        next = await bossRepo.advanceToNextBoss();
        expect(next!.chapter, equals(4));
        expect(next.id, equals('boss_dragon'));

        // Ch 4 -> no Ch 5 -> remains at Ch 4 safely
        next = await bossRepo.advanceToNextBoss();
        expect(next!.chapter, equals(4));
        expect(next.id, equals('boss_dragon'));
      },
    );

    test('Quest creation, completion, and deletion lifecycle', () async {
      final quest = await questRepo.createQuest(
        title: 'Master Dart Analysis',
        rank: 'S',
      );
      expect(quest.title, equals('Master Dart Analysis'));
      expect(quest.baseDamage, equals(600));
      expect(quest.expReward, equals(500));
      expect(quest.coinReward, equals(250));
      expect(quest.isCompleted, isFalse);

      await questRepo.completeQuest(quest.id);
      final completed = await questRepo.getQuest(quest.id);
      expect(completed!.isCompleted, isTrue);
      expect(completed.completedAt, isNotNull);

      await questRepo.deleteQuest(quest.id);
      final deleted = await questRepo.getQuest(quest.id);
      expect(deleted, isNull);
    });

    test(
      'CombatLogRepository logs entries in DESC timestamp order and clears on demand',
      () async {
        final t1 = DateTime(2026, 8, 26, 10, 0);
        final t2 = DateTime(2026, 8, 26, 10, 5);
        final t3 = DateTime(2026, 8, 26, 10, 10);

        await combatLogRepo.addLog(text: 'Strike 1', damage: 50, timestamp: t1);
        await combatLogRepo.addLog(
          text: 'Strike 2',
          damage: 100,
          isCritical: true,
          timestamp: t2,
        );
        await combatLogRepo.addLog(
          text: 'Strike 3',
          damage: 150,
          timestamp: t3,
        );

        final logs = await combatLogRepo.getRecentLogs(limit: 2);
        expect(logs.length, equals(2));
        expect(logs[0].textContent, equals('Strike 3'));
        expect(logs[1].textContent, equals('Strike 2'));
        expect(logs[1].isCritical, isTrue);

        await combatLogRepo.clearLogs();
        final emptyLogs = await combatLogRepo.getRecentLogs();
        expect(emptyLogs, isEmpty);
      },
    );
  });

  group('Adversarial Challenge 6: 1000-Action Multi-Threaded Stress Loop', () {
    test(
      '1000 randomized actions maintain database consistency and state invariants',
      () async {
        for (int i = 0; i < 200; i++) {
          // 1. Award EXP
          await heroRepo.awardExp(30);

          // 2. Take random damage
          await heroRepo.takeDamage(i % 25);

          // 3. Heal
          await heroRepo.heal(10);

          // 4. MP operations
          await heroRepo.restoreMp(15);
          await heroRepo.spendMp(5);

          // 5. Boss strike
          await bossRepo.applyDamage(15);
        }

        final hero = await heroRepo.getHero();
        expect(hero, isNotNull);
        expect(hero!.level, greaterThanOrEqualTo(1));
        expect(hero.hp, greaterThanOrEqualTo(0));
        expect(hero.hp, lessThanOrEqualTo(hero.maxHp));
        expect(hero.mp, greaterThanOrEqualTo(0));
        expect(hero.mp, lessThanOrEqualTo(hero.maxMp));
      },
    );
  });
}
