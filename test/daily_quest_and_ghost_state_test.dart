import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/core/services/day_cycle_service.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/screens/battle_hub/battle_hub_screen.dart';

void main() {
  group(
    'Ticket 04: Daily Quest 24-Hour Cycle, Streak Protection & Ghost State Slice',
    () {
      test(
        'Toggling daily quest increments streak, awards EXP/Coins, and grants all-done streak chest',
        () {
          final heroNotifier = HeroNotifier(
            const HeroModel(coins: 10, currentExp: 0),
          );

          final daily1 = DailyQuestModel(
            id: 'd1',
            title: 'Morning Stretch',
            streak: 2,
          );
          final daily2 = DailyQuestModel(
            id: 'd2',
            title: 'Read Chapter',
            streak: 0,
          );

          final dailyNotifier = DailyQuestNotifier([daily1, daily2]);

          // Complete first daily
          dailyNotifier.toggleDailyQuest('d1', heroNotifier: heroNotifier);
          expect(dailyNotifier.state[0].isCompletedToday, true);
          expect(dailyNotifier.state[0].streak, 3);
          expect(heroNotifier.state.coins, 25); // 10 + 15
          expect(heroNotifier.state.currentExp, 30);

          // Complete second daily (all done -> bonus streak coin chest +25)
          dailyNotifier.toggleDailyQuest('d2', heroNotifier: heroNotifier);
          expect(dailyNotifier.state[1].isCompletedToday, true);
          expect(dailyNotifier.state[1].streak, 1);
          expect(heroNotifier.state.coins, 65); // 25 + 15 + 25
          expect(heroNotifier.state.currentExp, 60);
        },
      );

      test(
        'DayCycleService evaluates missed dailies, inflicts counter-damage, and triggers Ghost State at 0 HP',
        () {
          final heroNotifier = HeroNotifier(
            const HeroModel(
              currentHp:
                  20, // Missed 2 dailies = 30 dmg -> drops HP to 0 -> Ghost State
            ),
          );

          final daily1 = DailyQuestModel(
            id: 'd1',
            title: 'Task 1',
            isCompletedToday: false,
          );
          final daily2 = DailyQuestModel(
            id: 'd2',
            title: 'Task 2',
            isCompletedToday: false,
          );

          final yesterday = DateTime(2026, 8, 25);
          final today = DateTime(2026, 8, 26);

          final result = DayCycleService.instance.processDayReset(
            lastActiveDate: yesterday,
            currentDate: today,
            dailies: [daily1, daily2],
            heroNotifier: heroNotifier,
          );

          expect(result.dayChanged, true);
          expect(result.incompleteDailiesCount, 2);
          expect(result.counterDamageDealt, 30);
          expect(result.isGhostStateTriggered, true);
          expect(heroNotifier.state.currentHp, 0);
          expect(heroNotifier.state.isGhost, true);

          // Revive from Ghost State
          heroNotifier.reviveHero();
          expect(heroNotifier.state.isGhost, false);
          expect(heroNotifier.state.currentHp, 50);
        },
      );

      test(
        'DayCycleService respects Boss Stun and Streak Shield buffs preventing counter-damage',
        () {
          final heroNotifier = HeroNotifier(const HeroModel(currentHp: 100));

          final daily1 = DailyQuestModel(
            id: 'd1',
            title: 'Task 1',
            isCompletedToday: false,
          );
          final yesterday = DateTime(2026, 8, 25);
          final today = DateTime(2026, 8, 26);

          // With Boss Stun active
          final resultStun = DayCycleService.instance.processDayReset(
            lastActiveDate: yesterday,
            currentDate: today,
            dailies: [daily1],
            heroNotifier: heroNotifier,
            isBossStunActive: true,
          );

          expect(resultStun.dayChanged, true);
          expect(resultStun.counterDamageDealt, 0);
          expect(heroNotifier.state.currentHp, 100);

          // With Streak Shield active
          final resultShield = DayCycleService.instance.processDayReset(
            lastActiveDate: yesterday,
            currentDate: today,
            dailies: [daily1],
            heroNotifier: heroNotifier,
            isStreakShieldActive: true,
          );

          expect(resultShield.dayChanged, true);
          expect(resultShield.counterDamageDealt, 0);
          expect(heroNotifier.state.currentHp, 100);
        },
      );

      testWidgets(
        'Battle Hub UI switches to Dailies tab and displays streak info',
        (tester) async {
          final heroNotifier = HeroNotifier(
            const HeroModel(name: 'Arthur', level: 1, isGhost: true),
          );

          final daily = DailyQuestModel(
            id: 'd_ui',
            title: 'Drink 2L Water',
            streak: 5,
          );

          final dailyNotifier = DailyQuestNotifier([daily]);

          final container = ProviderContainer(
            overrides: [
              heroProvider.overrideWith((ref) => heroNotifier),
              dailyQuestProvider.overrideWith((ref) => dailyNotifier),
            ],
          );

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: const MaterialApp(home: BattleHubScreen()),
            ),
          );
          await tester.pumpAndSettle();

          // Ghost banner visible
          expect(find.text('GHOST STATE ACTIVE'), findsOneWidget);
          expect(find.text('REVIVE'), findsOneWidget);

          // Switch to DAILIES tab
          await tester.tap(find.textContaining('DAILIES'));
          await tester.pumpAndSettle();

          expect(find.text('Drink 2L Water'), findsOneWidget);
          expect(find.text('5 STREAK'), findsOneWidget);
          expect(find.text('+ DAILY'), findsOneWidget);
        },
      );
    },
  );
}
