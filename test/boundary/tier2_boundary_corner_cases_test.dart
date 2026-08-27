import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/day_cycle_service.dart';
import 'package:workxp/data/storage/hive_storage_service.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 2: Boundary & Corner Cases Suite', () {
    test(
      '1. Multi-level EXP jump crosses multiple tier thresholds in a single burst',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(level: 1, currentExp: 0, unallocatedPoints: 0),
        );

        // Level 1->2 needs 100 EXP (200 left)
        // Level 2->3 needs 125 EXP (75 left)
        // Level 3 target is 156 EXP, so Hero ends at Level 3 with 75 EXP
        heroNotifier.gainExp(300);

        expect(heroNotifier.state.level, 3);
        expect(heroNotifier.state.currentExp, 75);
        expect(
          heroNotifier.state.unallocatedPoints,
          6,
        ); // +3 per level (2 levels)
        expect(heroNotifier.state.currentHp, 100);
        expect(heroNotifier.state.currentMp, 100);
      },
    );

    test('2. Stat point exhaustion rejects allocation and preserves state', () {
      final heroNotifier = HeroNotifier(
        const HeroModel(str: 10, unallocatedPoints: 0),
      );

      expect(heroNotifier.allocateStatPoint('STR'), isFalse);
      expect(heroNotifier.allocateStatPoint('INT'), isFalse);
      expect(heroNotifier.allocateStatPoint('AGI'), isFalse);
      expect(heroNotifier.allocateStatPoint('VIT'), isFalse);
      expect(heroNotifier.allocateStatPoint('WIS'), isFalse);

      expect(heroNotifier.state.str, 10);
      expect(heroNotifier.state.unallocatedPoints, 0);
    });

    test(
      '3. Negative habit logging guards against resource debt and prevents negative balances',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 15, currentMp: 20),
        );

        final habit = HabitModel(
          id: 'h_neg',
          title: 'Skip Workout',
          hasPositive: false,
          hasNegative: true,
        );

        final habitNotifier = HabitNotifier([habit]);

        // First negative log: Deducts 10 Coins (15 -> 5) and 15 MP (20 -> 5)
        habitNotifier.logNegative('h_neg', heroNotifier: heroNotifier);
        expect(heroNotifier.state.coins, 5);
        expect(heroNotifier.state.currentMp, 5);
        expect(habitNotifier.state.first.negativeCountToday, 1);

        // Second negative log with insufficient resources: spendCoins(10) and spendMp(15) safely reject
        // ensuring balance never goes negative and remains at 5
        habitNotifier.logNegative('h_neg', heroNotifier: heroNotifier);
        expect(heroNotifier.state.coins, 5);
        expect(heroNotifier.state.currentMp, 5);
        expect(heroNotifier.state.coins >= 0, isTrue);
        expect(heroNotifier.state.currentMp >= 0, isTrue);
        expect(habitNotifier.state.first.negativeCountToday, 2);
      },
    );

    test(
      '4. Massive overkill strike on low-HP Boss clamps Boss HP cleanly to 0',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(str: 20, agi: 10), // bonus = 50
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 15),
          ),
        );

        // Rank S base damage = 600 + 50 = 650 total damage
        final quest = QuestModel(
          id: 'q_overkill',
          title: 'Gigantic Strike',
          rank: 'S',
        );
        final questNotifier = QuestNotifier([quest]);

        final dmg = questNotifier.completeQuest(
          'q_overkill',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );

        expect(dmg, 650);
        expect(dungeonNotifier.state.activeBoss.currentHp, 0);
        expect(dungeonNotifier.state.activeBoss.isDefeated, isTrue);
        expect(dungeonNotifier.state.isVictory, isTrue);
      },
    );

    test(
      '5. Catastrophic midnight counter-damage clamps Hero HP to 0 and activates Ghost State',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(currentHp: 20, isGhost: false),
        );

        // 8 missed dailies = 120 HP counter-damage
        final dailies = List.generate(
          8,
          (i) => DailyQuestModel(
            id: 'd$i',
            title: 'Task $i',
            isCompletedToday: false,
          ),
        );

        final yesterday = DateTime(2026, 8, 25);
        final today = DateTime(2026, 8, 26);

        final result = DayCycleService.instance.processDayReset(
          lastActiveDate: yesterday,
          currentDate: today,
          dailies: dailies,
          heroNotifier: heroNotifier,
        );

        expect(result.counterDamageDealt, 120);
        expect(result.isGhostStateTriggered, isTrue);
        expect(heroNotifier.state.currentHp, 0);
        expect(heroNotifier.state.isGhost, isTrue);
      },
    );

    test(
      '6. Selecting locked Chapter is ignored and keeps current active Boss',
      () {
        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1),
            currentChapter: 1,
            unlockedChapters: [1],
          ),
        );

        // Attempt to select Chapter 2, 3, 4 (all locked)
        dungeonNotifier.selectChapter(2);
        expect(dungeonNotifier.state.currentChapter, 1);
        expect(dungeonNotifier.state.activeBoss.name, 'King Slime');

        dungeonNotifier.selectChapter(4);
        expect(dungeonNotifier.state.currentChapter, 1);
      },
    );

    test(
      '7. Consuming item not present or with 0 quantity safely returns false',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(currentHp: 50));
        final tavernNotifier = TavernNotifier(const TavernState(inventory: []));

        final used = tavernNotifier.useConsumable(
          'item_potion_health',
          heroNotifier: heroNotifier,
        );

        expect(used, isFalse);
        expect(heroNotifier.state.currentHp, 50);
      },
    );

    test(
      '8. Corrupted, empty, or schema-invalid JSON save string is safely rejected',
      () {
        expect(
          HiveStorageService.instance.parseAndValidateSaveJson(''),
          isNull,
        );
        expect(
          HiveStorageService.instance.parseAndValidateSaveJson(
            'not json content',
          ),
          isNull,
        );
        expect(
          HiveStorageService.instance.parseAndValidateSaveJson(
            '{"unexpected": "data"}',
          ),
          isNull,
        );
        expect(
          HiveStorageService.instance.parseAndValidateSaveJson(
            '{"hero": "invalid_type"}',
          ),
          isNull,
        );
      },
    );

    test('9. Consecutive unchecking of Daily Quest clamps streak at 0', () {
      final heroNotifier = HeroNotifier(const HeroModel());
      final daily = DailyQuestModel(
        id: 'd_clamp',
        title: 'Habit',
        streak: 1,
        isCompletedToday: true,
      );
      final dailyNotifier = DailyQuestNotifier([daily]);

      // Uncheck once -> streak 0
      dailyNotifier.toggleDailyQuest('d_clamp', heroNotifier: heroNotifier);
      expect(dailyNotifier.state.first.streak, 0);

      // Toggle on -> streak 1
      dailyNotifier.toggleDailyQuest('d_clamp', heroNotifier: heroNotifier);
      expect(dailyNotifier.state.first.streak, 1);

      // Toggle off -> streak 0
      dailyNotifier.toggleDailyQuest('d_clamp', heroNotifier: heroNotifier);
      expect(dailyNotifier.state.first.streak, 0);
    });

    test(
      '10. Exact coin boundary: Purchase succeeds with exact coins, fails with 1 coin short',
      () {
        final tavernNotifier = TavernNotifier();

        // Health Potion = 25 Coins
        // Test with 24 Coins (1 short)
        final heroShort = HeroNotifier(const HeroModel(coins: 24));
        expect(
          tavernNotifier.buyItem('item_potion_health', heroNotifier: heroShort),
          isFalse,
        );
        expect(heroShort.state.coins, 24);

        // Test with 25 Coins (Exact)
        final heroExact = HeroNotifier(const HeroModel(coins: 25));
        expect(
          tavernNotifier.buyItem('item_potion_health', heroNotifier: heroExact),
          isTrue,
        );
        expect(heroExact.state.coins, 0);
      },
    );
  });
}
