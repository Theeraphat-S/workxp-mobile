import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/day_cycle_service.dart';
import 'package:workxp/data/storage/hive_storage_service.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 4: Real-World Application Scenarios (E2E User Journeys)', () {
    test(
      'Journey 1: Day 1 Adventurer Onboarding, Stat Allocation & First Boss Strike',
      () {
        // 1. Generate clean Starter Kit
        final starterKit = HiveStorageService.instance.generateStarterKit();
        final heroModel = starterKit['hero'] as HeroModel;
        final questsList = starterKit['quests'] as List<QuestModel>;
        final habitsList = starterKit['habits'] as List<HabitModel>;
        final dungeonState = starterKit['dungeon'] as DungeonState;

        final heroNotifier = HeroNotifier(heroModel);
        final questNotifier = QuestNotifier(questsList);
        final habitNotifier = HabitNotifier(habitsList);
        final dungeonNotifier = DungeonNotifier(dungeonState);
        final skillBuffNotifier = SkillBuffNotifier();
        final analyticsNotifier = AnalyticsNotifier();

        expect(heroNotifier.state.name, 'Arthur');
        expect(heroNotifier.state.level, 1);
        expect(heroNotifier.state.unallocatedPoints, 2);
        expect(dungeonNotifier.state.activeBoss.name, 'King Slime');

        // 2. Allocate the 2 initial stat points to STR and VIT
        expect(heroNotifier.allocateStatPoint('STR'), isTrue);
        expect(heroNotifier.allocateStatPoint('VIT'), isTrue);
        expect(heroNotifier.state.str, 7); // 6 + 1
        expect(heroNotifier.state.vit, 7); // 6 + 1
        expect(heroNotifier.state.unallocatedPoints, 0);

        // 3. Complete Quest 1 (Rank D: 50 Base Dmg, 40 EXP, 20 Coins)
        // Hero Bonus = (7 * 2) + (5 * 1) = 19 -> Total Dmg = 69
        final firstQuestId = questsList.first.id;
        final dmg = questNotifier.completeQuest(
          firstQuestId,
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
          analyticsNotifier: analyticsNotifier,
        );

        expect(dmg, 69);
        expect(dungeonNotifier.state.activeBoss.currentHp, 131); // 200 - 69
        expect(heroNotifier.state.currentExp, 40);
        expect(heroNotifier.state.coins, 70); // 50 initial + 20

        // 4. Log positive habit (Drink Fresh Water)
        final waterHabit = habitsList.first;
        habitNotifier.logPositive(
          waterHabit.id,
          heroNotifier: heroNotifier,
          analyticsNotifier: analyticsNotifier,
        );
        expect(heroNotifier.state.coins, 80); // 70 + 10
        expect(heroNotifier.state.currentMp, 65); // 50 + 15

        // 5. Cast Focus Surge skill buff (25 MP)
        expect(
          skillBuffNotifier.castBuff(
            'buff_focus_surge',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.currentMp, 40); // 65 - 25
        expect(skillBuffNotifier.isBuffActive('buff_focus_surge'), isTrue);
      },
    );

    test(
      'Journey 2: The Midnight Crisis, Ghost State Transition & Heroic Revival',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            name: 'Arthur',
            currentHp: 30,
            coins: 100,
            currentExp: 20,
          ),
        );

        final dailies = [
          DailyQuestModel(id: 'd1', title: 'Exercise', isCompletedToday: false),
          DailyQuestModel(
            id: 'd2',
            title: 'Deep Work',
            isCompletedToday: false,
          ),
          DailyQuestModel(id: 'd3', title: 'Reading', isCompletedToday: false),
        ];

        // 1. Midnight rolls over with 3 incomplete dailies (45 damage vs 30 HP)
        final yesterday = DateTime(2026, 8, 25);
        final today = DateTime(2026, 8, 26);

        final result = DayCycleService.instance.processDayReset(
          lastActiveDate: yesterday,
          currentDate: today,
          dailies: dailies,
          heroNotifier: heroNotifier,
        );

        expect(result.counterDamageDealt, 45);
        expect(result.isGhostStateTriggered, isTrue);
        expect(heroNotifier.state.currentHp, 0);
        expect(heroNotifier.state.isGhost, isTrue);

        // 2. Actions while in Ghost State are restricted from gaining rewards
        heroNotifier.gainExp(100);
        heroNotifier.gainCoins(100);
        expect(heroNotifier.state.currentExp, 20); // Unchanged
        expect(heroNotifier.state.coins, 100); // Unchanged

        // 3. Complete emergency Revival Quest prompt
        heroNotifier.reviveHero();
        expect(heroNotifier.state.isGhost, isFalse);
        expect(heroNotifier.state.currentHp, 50); // 50% HP restored

        // 4. Visit Tavern and buy a Health Potion (25 Coins)
        final tavernNotifier = TavernNotifier();
        expect(
          tavernNotifier.buyItem(
            'item_potion_health',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.coins, 75); // 100 - 25

        // 5. Drink Health Potion (+50 HP)
        expect(
          tavernNotifier.useConsumable(
            'item_potion_health',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.currentHp, 100); // 50 + 50 = 100 (Full HP!)
      },
    );

    test(
      'Journey 3: Dungeon Expedition, Boss Defeat & Custom Real-Life Reward Celebration',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            coins: 20,
            currentExp: 0,
            str: 10,
            agi: 5, // bonus = 25
          ),
        );

        final dailies = [
          DailyQuestModel(id: 'd1', title: 'Daily A', streak: 2),
          DailyQuestModel(id: 'd2', title: 'Daily B', streak: 1),
        ];
        final dailyNotifier = DailyQuestNotifier(dailies);

        // 1. Complete all daily quests to earn base rewards + All-Done Streak Chest
        dailyNotifier.toggleDailyQuest('d1', heroNotifier: heroNotifier);
        dailyNotifier.toggleDailyQuest('d2', heroNotifier: heroNotifier);
        // Dailies reward = 2 * (15 coins + 30 exp) + 25 bonus chest = 55 coins + 60 exp
        expect(heroNotifier.state.coins, 75); // 20 + 55
        expect(heroNotifier.state.currentExp, 60);

        // 2. Deliver Rank S strike to finish off King Slime Boss (200 HP)
        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 200),
            currentChapter: 1,
            unlockedChapters: [1],
          ),
        );

        final quest = QuestModel(
          id: 'q_s_rank',
          title: 'Deliver Master Project',
          rank: 'S',
        );
        final questNotifier = QuestNotifier([quest]);
        final analyticsNotifier = AnalyticsNotifier();

        // Rank S Base Dmg = 600 + 25 bonus = 625 damage
        final strikeDmg = questNotifier.completeQuest(
          'q_s_rank',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
          analyticsNotifier: analyticsNotifier,
        );

        expect(strikeDmg, 625);
        expect(dungeonNotifier.state.activeBoss.isDefeated, isTrue);
        expect(dungeonNotifier.state.unlockedChapters.contains(2), isTrue);

        // Total Coins = 75 + 250 (Quest S) + 100 (Boss Loot) = 425 Coins!
        expect(heroNotifier.state.coins, 425);

        // 3. Visit Tavern, create custom real-life reward "Boba Tea" (50 Coins)
        final tavernNotifier = TavernNotifier();
        final customReward = CustomRewardModel(
          id: 'rew_boba',
          title: 'Delicious Boba Milk Tea',
          coinCost: 50,
          iconName: 'coffee',
        );
        tavernNotifier.addCustomReward(customReward);

        // 4. Redeem Custom Reward
        expect(
          tavernNotifier.redeemCustomReward(
            'rew_boba',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.coins, 375); // 425 - 50
        expect(
          tavernNotifier.state.customRewards
              .firstWhere((r) => r.id == 'rew_boba')
              .timesRedeemed,
          1,
        );

        // 5. Save Game Progress to JSON Backup
        final jsonBackup = HiveStorageService.instance.exportSaveFileJson(
          hero: heroNotifier.state,
          quests: questNotifier.state,
          dailies: dailyNotifier.state,
          habits: [],
          dungeon: dungeonNotifier.state,
          tavern: tavernNotifier.state,
          analytics: analyticsNotifier.state,
        );

        expect(jsonBackup.isNotEmpty, isTrue);
        final parsed = HiveStorageService.instance.parseAndValidateSaveJson(
          jsonBackup,
        );
        expect(parsed, isNotNull);
        expect(parsed!['hero']['coins'], 375);
        expect(parsed['dungeon']['currentChapter'], 1);
        expect(
          (parsed['dungeon']['unlockedChapters'] as List).contains(2),
          isTrue,
        );
      },
    );

    test(
      'Journey 4: Hall of Fame Legend, Title Accolades & Leaderboard Triumph',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            name: 'Arthur',
            level: 1,
            str: 8,
            intel: 8,
            agi: 8,
            vit: 8,
            wis: 8,
            unallocatedPoints: 0,
          ),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1),
            defeatedBosses: [BossModel.chapterBoss(1)],
          ),
        );

        final analyticsNotifier = AnalyticsNotifier();

        // 1. Gain massive EXP to reach Level 5
        // Lvl 1->2 (100), Lvl 2->3 (125), Lvl 3->4 (156), Lvl 4->5 (195) = 576 EXP
        heroNotifier.gainExp(600);
        expect(heroNotifier.state.level >= 5, isTrue);
        expect(
          heroNotifier.state.unlockedTitles.contains('Seasoned Veteran'),
          isTrue,
        );
        expect(heroNotifier.state.unallocatedPoints, 12); // +3 * 4 levels

        // 2. Allocate 7 points into STR (8 -> 15) to achieve Attribute Master
        for (int i = 0; i < 7; i++) {
          heroNotifier.allocateStatPoint('STR');
        }
        expect(heroNotifier.state.str, 15);
        expect(
          heroNotifier.state.unlockedTitles.contains('Iron Knight'),
          isTrue,
        );

        // 3. Record heavy combat damage and evaluate achievements
        analyticsNotifier.recordDamage(4500);

        analyticsNotifier.evaluateAchievements(
          hero: heroNotifier.state,
          dungeon: dungeonNotifier.state,
          quests: [
            QuestModel(id: 'q_done', title: 'Finished', isCompleted: true),
          ],
          dailies: [DailyQuestModel(id: 'd_done', title: 'Daily', streak: 7)],
        );

        final achs = analyticsNotifier.state.achievements;
        expect(
          achs.firstWhere((a) => a.id == 'ach_first_blood').isUnlocked,
          isTrue,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_slime_slayer').isUnlocked,
          isTrue,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_streak_master').isUnlocked,
          isTrue,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_attribute_master').isUnlocked,
          isTrue,
        );

        // 4. Verify Leaderboard ranking: Hero with 4500 weekly damage climbs to Rank 1!
        final leaderboard = analyticsNotifier.state.leaderboard;
        expect(leaderboard.first.isHero, isTrue);
        expect(leaderboard.first.rank, 1);
        expect(leaderboard.first.weeklyDamage >= 4500, isTrue);
      },
    );
  });
}
