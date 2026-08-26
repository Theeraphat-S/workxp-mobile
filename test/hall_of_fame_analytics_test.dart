import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/screens/hall_of_fame/hall_of_fame_screen.dart';

void main() {
  group('Ticket 08: Hall of Fame, FL Chart Analytics & Leaderboard Slice', () {
    test(
      'Analytics records logs and evaluates achievement unlock milestones',
      () {
        final notifier = AnalyticsNotifier();

        final hero = const HeroModel(coins: 250, str: 16);

        final dungeon = DungeonState(
          activeBoss: BossModel.chapterBoss(2),
          defeatedBosses: [BossModel.chapterBoss(1)],
        );

        final quests = [QuestModel(id: 'q1', title: 'Task', isCompleted: true)];

        notifier.evaluateAchievements(
          hero: hero,
          dungeon: dungeon,
          quests: quests,
          dailies: [],
        );

        final achs = notifier.state.achievements;
        expect(
          achs.firstWhere((a) => a.id == 'ach_first_blood').isUnlocked,
          true,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_slime_slayer').isUnlocked,
          true,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_coin_hoarder').isUnlocked,
          true,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_attribute_master').isUnlocked,
          true,
        );
        expect(
          achs.firstWhere((a) => a.id == 'ach_dragon_slayer').isUnlocked,
          false,
        );
      },
    );

    testWidgets(
      'Hall of Fame UI renders all charts, heatmap, radar, achievements, and leaderboard',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 3200);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final heroNotifier = HeroNotifier(
          const HeroModel(
            name: 'Arthur',
            level: 3,
            str: 12,
            intel: 8,
            agi: 10,
            vit: 14,
            wis: 9,
          ),
        );

        final container = ProviderContainer(
          overrides: [
            heroProvider.overrideWith((ref) => heroNotifier),
            analyticsProvider.overrideWith((ref) => AnalyticsNotifier()),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: HallOfFameScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('HALL OF FAME'), findsOneWidget);
        expect(find.text('EXP GROWTH TRAJECTORY'), findsOneWidget);
        expect(find.text('7D'), findsOneWidget);
        expect(find.text('30D'), findsOneWidget);

        // Tap 30D toggle
        await tester.tap(find.text('30D'));
        await tester.pumpAndSettle();

        expect(find.text('BOSS DAMAGE DEALT'), findsOneWidget);
        expect(find.text('16-BIT HABIT HEATMAP'), findsOneWidget);
        expect(find.text('ATTRIBUTE BALANCE RADAR'), findsOneWidget);
        expect(find.text('LIFETIME ACHIEVEMENTS'), findsOneWidget);
        expect(find.text('SIMULATED GUILD LEADERBOARD'), findsOneWidget);
      },
    );
  });
}
