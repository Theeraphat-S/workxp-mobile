import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/day_cycle_service.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 3: Cross-Feature Combinations Suite', () {
    test(
      '1. Combat Strike + Focus Surge + Multi-Level Overflow + Title Unlock + Analytics integration',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            level: 1,
            currentExp: 0,
            currentMp: 100,
            str: 9,
            agi: 5,
            unallocatedPoints: 0,
          ),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(
              1,
            ).copyWith(maxHp: 1000, currentHp: 1000),
          ),
        );

        final skillBuffNotifier = SkillBuffNotifier();
        final analyticsNotifier = AnalyticsNotifier();

        // Step 1: Cast Focus Surge buff
        expect(
          skillBuffNotifier.castBuff(
            'buff_focus_surge',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.currentMp, 75); // 100 - 25

        // Step 2: Complete Rank A Quest (Base Dmg: 350, Base EXP: 250, Base Coins: 120)
        // Hero Bonus = (9 * 2) + (5 * 1) = 23 -> Raw Dmg = 373. Surge (+50%): (373 * 1.5).round() = 560
        final quest = QuestModel(
          id: 'q_combo1',
          title: 'Major Module Refactor',
          rank: 'A',
        );
        final questNotifier = QuestNotifier([quest]);

        final strikeDmg = questNotifier.completeQuest(
          'q_combo1',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
          skillBuffNotifier: skillBuffNotifier,
          analyticsNotifier: analyticsNotifier,
        );

        expect(strikeDmg, 560);
        expect(dungeonNotifier.state.activeBoss.currentHp, 440); // 1000 - 560

        // Step 3: Verify EXP & Leveling progression (250 EXP: 100 for lvl 2, 125 for lvl 3, 25 left)
        expect(heroNotifier.state.level, 3);
        expect(heroNotifier.state.currentExp, 25);
        expect(heroNotifier.state.unallocatedPoints, 6);

        // Step 4: Allocate stat point to STR (9 -> 10) to trigger 'Iron Knight' title
        expect(heroNotifier.allocateStatPoint('STR'), isTrue);
        expect(heroNotifier.state.str, 10);
        expect(
          heroNotifier.state.unlockedTitles.contains('Iron Knight'),
          isTrue,
        );

        // Step 5: Evaluate Analytics achievements
        analyticsNotifier.evaluateAchievements(
          hero: heroNotifier.state,
          dungeon: dungeonNotifier.state,
          quests: questNotifier.state,
          dailies: [],
        );

        final achs = analyticsNotifier.state.achievements;
        expect(
          achs.firstWhere((a) => a.id == 'ach_first_blood').isUnlocked,
          isTrue,
        );
      },
    );

    test(
      '2. Midnight Reset Damage + Ghost State + Blocked Rewards + Revival & Recovery Loop',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(currentHp: 25, coins: 50, currentExp: 10),
        );

        final dailies = [
          DailyQuestModel(id: 'd1', title: 'Task 1', isCompletedToday: false),
          DailyQuestModel(id: 'd2', title: 'Task 2', isCompletedToday: false),
        ];

        // Step 1: Midnight Reset with 2 missed dailies (30 damage vs 25 HP)
        final yesterday = DateTime(2026, 8, 25);
        final today = DateTime(2026, 8, 26);

        final resetResult = DayCycleService.instance.processDayReset(
          lastActiveDate: yesterday,
          currentDate: today,
          dailies: dailies,
          heroNotifier: heroNotifier,
        );

        expect(resetResult.isGhostStateTriggered, isTrue);
        expect(heroNotifier.state.currentHp, 0);
        expect(heroNotifier.state.isGhost, isTrue);

        // Step 2: Attempt actions while in Ghost State (rewards must be blocked)
        final quest = QuestModel(id: 'q_ghost', title: 'Ghost Task', rank: 'D');
        final dungeonNotifier = DungeonNotifier(
          DungeonState(activeBoss: BossModel.chapterBoss(1)),
        );
        final questNotifier = QuestNotifier([quest]);

        questNotifier.completeQuest(
          'q_ghost',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );

        expect(heroNotifier.state.currentExp, 10); // Blocked
        expect(heroNotifier.state.coins, 50); // Blocked

        // Step 3: Complete Revival Quest prompt
        heroNotifier.reviveHero();
        expect(heroNotifier.state.isGhost, isFalse);
        expect(heroNotifier.state.currentHp, 50); // 50% max HP

        // Step 4: Resume normal gameplay and verify reward acquisition
        final quest2 = QuestModel(
          id: 'q_revived',
          title: 'Fresh Start',
          rank: 'E',
        );
        questNotifier.addQuest(quest2);

        questNotifier.completeQuest(
          'q_revived',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );

        expect(heroNotifier.state.currentExp, 30); // 10 + 20
        expect(heroNotifier.state.coins, 60); // 50 + 10
      },
    );

    test(
      '3. Habits Economy + Tavern Inventory + Consumable Shielding + Midnight Immunity',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 10, currentMp: 20, currentHp: 100),
        );

        final habit = HabitModel(
          id: 'h_water',
          title: 'Hydrate',
          hasPositive: true,
        );
        final habitNotifier = HabitNotifier([habit]);

        // Step 1: Log positive habits to accumulate Coins and MP
        for (int i = 0; i < 4; i++) {
          habitNotifier.logPositive('h_water', heroNotifier: heroNotifier);
        }
        expect(heroNotifier.state.coins, 50); // 10 + 40
        expect(heroNotifier.state.currentMp, 80); // 20 + 60

        // Step 2: Purchase Streak Shield (40 Coins) in Tavern
        final tavernNotifier = TavernNotifier();
        expect(
          tavernNotifier.buyItem(
            'item_streak_shield',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.coins, 10); // 50 - 40

        // Step 3: Use Streak Shield from inventory
        expect(
          tavernNotifier.useConsumable(
            'item_streak_shield',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(tavernNotifier.state.activeStreakShields, 1);

        // Step 4: Cast Boss Stun buff (40 MP)
        final skillBuffNotifier = SkillBuffNotifier();
        expect(
          skillBuffNotifier.castBuff(
            'buff_boss_stun',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.currentMp, 40); // 80 - 40

        // Step 5: Midnight Reset with missed dailies — Immunity protects HP completely
        final dailies = [
          DailyQuestModel(
            id: 'd_missed',
            title: 'Missed Routine',
            isCompletedToday: false,
          ),
        ];

        final resetResult = DayCycleService.instance.processDayReset(
          lastActiveDate: DateTime(2026, 8, 25),
          currentDate: DateTime(2026, 8, 26),
          dailies: dailies,
          heroNotifier: heroNotifier,
          isStreakShieldActive: tavernNotifier.state.activeStreakShields > 0,
          isBossStunActive: skillBuffNotifier.isBuffActive('buff_boss_stun'),
        );

        expect(resetResult.counterDamageDealt, 0);
        expect(heroNotifier.state.currentHp, 100); // Intact!
      },
    );

    test(
      '4. Dungeon Boss Defeat + Victory Loot + Tavern Cosmetic Purchase + Sanctuary Equipping',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 60, currentExp: 0, str: 5, agi: 5),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(
              1,
            ).copyWith(currentHp: 20, coinReward: 100, expReward: 150),
            currentChapter: 1,
            unlockedChapters: [1],
          ),
        );

        // Step 1: Strike Boss and trigger defeat
        final quest = QuestModel(
          id: 'q_kill',
          title: 'Finisher Strike',
          rank: 'E',
        );
        final questNotifier = QuestNotifier([quest]);
        final analyticsNotifier = AnalyticsNotifier();

        questNotifier.completeQuest(
          'q_kill',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
          analyticsNotifier: analyticsNotifier,
        );

        expect(dungeonNotifier.state.activeBoss.isDefeated, isTrue);
        expect(dungeonNotifier.state.unlockedChapters.contains(2), isTrue);
        // Coins = 60 + 10 (Quest) + 100 (Boss Loot) = 170
        expect(heroNotifier.state.coins, 170);

        // Step 2: Visit Tavern and purchase Paladin Skin (150 Coins)
        final tavernNotifier = TavernNotifier();
        expect(
          tavernNotifier.buyItem('paladin', heroNotifier: heroNotifier),
          isTrue,
        );
        expect(heroNotifier.state.coins, 20); // 170 - 150
        expect(heroNotifier.state.unlockedSkins.contains('paladin'), isTrue);

        // Step 3: Sanctuary equips the new Paladin skin
        expect(heroNotifier.setActiveSkin('paladin'), isTrue);
        expect(heroNotifier.state.activeSkinId, 'paladin');

        // Step 4: Evaluate achievement for Slime Slayer
        analyticsNotifier.evaluateAchievements(
          hero: heroNotifier.state,
          dungeon: dungeonNotifier.state,
          quests: questNotifier.state,
          dailies: [],
        );

        expect(
          analyticsNotifier.state.achievements
              .firstWhere((a) => a.id == 'ach_slime_slayer')
              .isUnlocked,
          isTrue,
        );
      },
    );
  });
}
