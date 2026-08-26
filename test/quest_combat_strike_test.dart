import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/screens/battle_hub/battle_hub_screen.dart';

void main() {
  group('Ticket 03: Quest System & Boss Combat Strike Slice', () {
    test('Quest rank damage and reward helpers calculate correctly', () {
      expect(QuestModel.baseDamageForRank('E'), 25);
      expect(QuestModel.baseDamageForRank('D'), 50);
      expect(QuestModel.baseDamageForRank('C'), 100);
      expect(QuestModel.baseDamageForRank('B'), 200);
      expect(QuestModel.baseDamageForRank('A'), 350);
      expect(QuestModel.baseDamageForRank('S'), 600);

      expect(QuestModel.expRewardForRank('E'), 20);
      expect(QuestModel.coinRewardForRank('E'), 10);
      expect(QuestModel.expRewardForRank('S'), 500);
      expect(QuestModel.coinRewardForRank('S'), 250);
    });

    test(
      'Completing quest deals strike damage with hero bonus, awards EXP/Coins, and marks quest complete',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            level: 1,
            currentExp: 0,
            coins: 10,
            str: 10, // bonus = 10*2 + 5*1 = 25
            agi: 5,
          ),
        );

        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 200),
          ),
        );

        final quest = QuestModel(
          id: 'q1',
          title: 'Refactor Core Logic',
          rank:
              'C', // 100 base dmg + 25 bonus = 125 total dmg. EXP=80, Coins=40.
          attributeTag: 'INT',
        );

        final questNotifier = QuestNotifier([quest]);

        final totalDmg = questNotifier.completeQuest(
          'q1',
          heroNotifier: heroNotifier,
          dungeonNotifier: dungeonNotifier,
        );

        expect(totalDmg, 125);
        expect(dungeonNotifier.state.activeBoss.currentHp, 75);
        expect(heroNotifier.state.currentExp, 80);
        expect(heroNotifier.state.coins, 50); // 10 + 40
        expect(questNotifier.state.first.isCompleted, true);
      },
    );

    test('Defeating boss triggers victory state and awards boss loot', () {
      final heroNotifier = HeroNotifier(
        const HeroModel(coins: 0, currentExp: 0, str: 5, agi: 5),
      );

      final dungeonNotifier = DungeonNotifier(
        DungeonState(
          activeBoss: BossModel.chapterBoss(
            1,
          ).copyWith(currentHp: 30, coinReward: 100, expReward: 150),
        ),
      );

      final quest = QuestModel(
        id: 'q_kill',
        title: 'Final Boss Strike',
        rank: 'D', // 50 base damage + 15 hero bonus = 65 dmg
      );

      final questNotifier = QuestNotifier([quest]);

      questNotifier.completeQuest(
        'q_kill',
        heroNotifier: heroNotifier,
        dungeonNotifier: dungeonNotifier,
      );

      expect(dungeonNotifier.state.activeBoss.currentHp, 0);
      expect(dungeonNotifier.state.activeBoss.isDefeated, true);
      expect(dungeonNotifier.state.isVictory, true);
      expect(dungeonNotifier.state.unlockedChapters.contains(2), true);
      // Hero gets quest reward (40 EXP + 20 Coins) + boss loot (150 EXP + 100 Coins)
      expect(heroNotifier.state.coins, 120);
    });

    testWidgets('Battle Hub UI renders quest list and displays boss card', (
      tester,
    ) async {
      final heroNotifier = HeroNotifier(
        const HeroModel(name: 'Arthur', level: 1, coins: 10),
      );

      final dungeonNotifier = DungeonNotifier(
        DungeonState(activeBoss: BossModel.chapterBoss(1)),
      );

      final quest = QuestModel(
        id: 'q_test',
        title: 'Complete Daily Review',
        rank: 'E',
      );

      final questNotifier = QuestNotifier([quest]);

      final container = ProviderContainer(
        overrides: [
          heroProvider.overrideWith((ref) => heroNotifier),
          dungeonProvider.overrideWith((ref) => dungeonNotifier),
          questProvider.overrideWith((ref) => questNotifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BattleHubScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('BATTLE HUB'), findsOneWidget);
      expect(find.text('KING SLIME'), findsOneWidget);
      expect(find.text('Complete Daily Review'), findsOneWidget);
      expect(find.text('RANK E'), findsOneWidget);
      expect(find.text('+ NEW QUEST'), findsOneWidget);
    });
  });
}
