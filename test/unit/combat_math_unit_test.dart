import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1 Unit Test: Quest Combat Math & Strike Multipliers', () {
    test(
      '1. Quest rank base damage, EXP, and Coin reward formulas return exact values',
      () {
        // Rank E
        expect(QuestModel.baseDamageForRank('E'), 25);
        expect(QuestModel.expRewardForRank('E'), 20);
        expect(QuestModel.coinRewardForRank('E'), 10);

        // Rank D
        expect(QuestModel.baseDamageForRank('D'), 50);
        expect(QuestModel.expRewardForRank('D'), 40);
        expect(QuestModel.coinRewardForRank('D'), 20);

        // Rank C
        expect(QuestModel.baseDamageForRank('C'), 100);
        expect(QuestModel.expRewardForRank('C'), 80);
        expect(QuestModel.coinRewardForRank('C'), 40);

        // Rank B
        expect(QuestModel.baseDamageForRank('B'), 200);
        expect(QuestModel.expRewardForRank('B'), 150);
        expect(QuestModel.coinRewardForRank('B'), 75);

        // Rank A
        expect(QuestModel.baseDamageForRank('A'), 350);
        expect(QuestModel.expRewardForRank('A'), 250);
        expect(QuestModel.coinRewardForRank('A'), 120);

        // Rank S
        expect(QuestModel.baseDamageForRank('S'), 600);
        expect(QuestModel.expRewardForRank('S'), 500);
        expect(QuestModel.coinRewardForRank('S'), 250);
      },
    );

    test(
      '2. Standard Quest strike applies base damage plus Hero combat bonus to Boss HP',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(str: 8, agi: 6), // bonus = 8*2 + 6*1 = 22
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 200),
          ),
        );

        final quest = QuestModel(id: 'q_std', title: 'Task D', rank: 'D');
        final questNotifier = QuestNotifier([quest]);

        final damage = questNotifier.completeQuest(
          'q_std',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );

        // Expected damage = 50 (Rank D base) + 22 (Hero bonus) = 72
        expect(damage, 72);
        expect(dungeonNotifier.state.activeBoss.currentHp, 128); // 200 - 72
        expect(heroNotifier.state.currentExp, 40);
        expect(heroNotifier.state.coins, 70); // 50 initial + 20
        expect(questNotifier.state.first.isCompleted, isTrue);
      },
    );

    test('3. Focus Surge buff applies +50% attack damage multiplier', () {
      final heroNotifier = HeroNotifier(
        const HeroModel(str: 10, agi: 5, currentMp: 100), // bonus = 25
      );

      final dungeonNotifier = DungeonNotifier(
        DungeonState(
          activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 500),
        ),
      );

      final skillBuffNotifier = SkillBuffNotifier();
      skillBuffNotifier.castBuff(
        'buff_focus_surge',
        heroNotifier: heroNotifier,
      );

      final quest = QuestModel(id: 'q_surge', title: 'Task B', rank: 'B');
      final questNotifier = QuestNotifier([quest]);

      final damage = questNotifier.completeQuest(
        'q_surge',
        heroNotifier: heroNotifier,
        dungeonNotifier: dungeonNotifier,
        skillBuffNotifier: skillBuffNotifier,
      );

      // Base B = 200, Bonus = 25 -> Raw = 225. With Focus Surge (+50%): (225 * 1.5).round() = 338
      expect(damage, 338);
      expect(dungeonNotifier.state.activeBoss.currentHp, 162); // 500 - 338
    });

    test(
      '4. Double EXP Scroll buff doubles EXP reward on Quest completion',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(currentExp: 0, currentMp: 100),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 500),
          ),
        );

        final skillBuffNotifier = SkillBuffNotifier();
        skillBuffNotifier.castBuff(
          'buff_double_exp',
          heroNotifier: heroNotifier,
        );

        final quest = QuestModel(id: 'q_exp', title: 'Task C', rank: 'C');
        final questNotifier = QuestNotifier([quest]);

        questNotifier.completeQuest(
          'q_exp',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
          skillBuffNotifier: skillBuffNotifier,
        );

        // Base C EXP = 80 -> Double EXP: 80 * 2 = 160.
        // 160 EXP causes Level 1 (100 target) -> Level 2 with 60 remainder EXP.
        expect(heroNotifier.state.level, 2);
        expect(heroNotifier.state.currentExp, 60);
      },
    );

    test(
      '5. Synergistic Buffs: Focus Surge and Double EXP active simultaneously',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            str: 5,
            agi: 5,
            currentMp: 100,
            coins: 0,
            currentExp: 0,
          ),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 1000),
          ),
        );

        final skillBuffNotifier = SkillBuffNotifier();
        // Cast Focus Surge (25 MP) and Double EXP (30 MP)
        expect(
          skillBuffNotifier.castBuff(
            'buff_focus_surge',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(
          skillBuffNotifier.castBuff(
            'buff_double_exp',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(heroNotifier.state.currentMp, 45); // 100 - 25 - 30

        final quest = QuestModel(id: 'q_combo', title: 'Task A', rank: 'A');
        final questNotifier = QuestNotifier([quest]);
        final analyticsNotifier = AnalyticsNotifier(const AnalyticsState());

        final damage = questNotifier.completeQuest(
          'q_combo',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
          skillBuffNotifier: skillBuffNotifier,
          analyticsNotifier: analyticsNotifier,
        );

        // Rank A Base = 350, Bonus = 15 -> Raw = 365. Surge: (365 * 1.5).round() = 548
        expect(damage, 548);
        // Rank A Base EXP = 250 -> Double EXP: 500 EXP
        // 500 EXP progression:
        // Lvl 1->2 (100, 400 left)
        // Lvl 2->3 (125, 275 left)
        // Lvl 3->4 (156, 119 left)
        // Lvl 4 target is 195, so stays at Level 4 with 119 EXP.
        expect(heroNotifier.state.level, 4);
        expect(heroNotifier.state.currentExp, 119);
        expect(heroNotifier.state.coins, 120); // Rank A coins
      },
    );

    test(
      '6. Boss Defeat awards boss victory loot (Coins + EXP) and unlocks next Chapter',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 0, currentExp: 0, str: 5, agi: 5),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(
              1,
            ).copyWith(currentHp: 50, coinReward: 100, expReward: 150),
            currentChapter: 1,
            unlockedChapters: [1],
          ),
        );

        final quest = QuestModel(
          id: 'q_boss_kill',
          title: 'Finish Slime',
          rank: 'E',
        );
        final questNotifier = QuestNotifier([quest]);

        // Damage = 25 (Rank E) + 15 (Bonus) = 40. Boss HP: 50 - 40 = 10 (not dead yet)
        questNotifier.completeQuest(
          'q_boss_kill',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );
        expect(dungeonNotifier.state.activeBoss.isDefeated, isFalse);

        // Second strike: deals 40 damage to 10 HP Boss -> defeats Boss
        final quest2 = QuestModel(
          id: 'q_boss_kill2',
          title: 'Fatal Blow',
          rank: 'E',
        );
        questNotifier.addQuest(quest2);

        questNotifier.completeQuest(
          'q_boss_kill2',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );

        final bossState = dungeonNotifier.state;
        expect(bossState.activeBoss.isDefeated, isTrue);
        expect(bossState.activeBoss.currentHp, 0);
        expect(bossState.isVictory, isTrue);
        expect(bossState.unlockedChapters.contains(2), isTrue);
        expect(bossState.defeatedBosses.length, 1);

        // Total Coins = Quest 1 (10) + Quest 2 (10) + Boss Loot (100) = 120
        expect(heroNotifier.state.coins, 120);
      },
    );
  });
}
