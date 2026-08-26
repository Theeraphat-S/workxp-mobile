import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';
import 'package:workxp/presentation/screens/battle_hub/battle_hub_screen.dart';

void main() {
  group('Ticket 05: Habit Tracker, Coin Economy & MP Skill Buffs Slice', () {
    test('Logging positive habit awards +10 Coins and +15 MP', () {
      final heroNotifier = HeroNotifier(
        const HeroModel(coins: 20, currentMp: 30),
      );

      final habit = HabitModel(
        id: 'h1',
        title: 'Meditation',
        hasPositive: true,
        hasNegative: false,
      );

      final habitNotifier = HabitNotifier([habit]);

      habitNotifier.logPositive('h1', heroNotifier: heroNotifier);

      expect(habitNotifier.state.first.positiveCountToday, 1);
      expect(habitNotifier.state.first.totalPositiveCount, 1);
      expect(heroNotifier.state.coins, 30); // 20 + 10
      expect(heroNotifier.state.currentMp, 45); // 30 + 15
    });

    test('Logging negative habit deducts -10 Coins and -15 MP', () {
      final heroNotifier = HeroNotifier(
        const HeroModel(coins: 50, currentMp: 50),
      );

      final habit = HabitModel(
        id: 'h2',
        title: 'Late Night Snacking',
        hasPositive: false,
        hasNegative: true,
      );

      final habitNotifier = HabitNotifier([habit]);

      habitNotifier.logNegative('h2', heroNotifier: heroNotifier);

      expect(habitNotifier.state.first.negativeCountToday, 1);
      expect(heroNotifier.state.coins, 40); // 50 - 10
      expect(heroNotifier.state.currentMp, 35); // 50 - 15
    });

    test('Casting MP Skill Buff deducts MP and activates buff timer', () {
      final heroNotifier = HeroNotifier(const HeroModel(currentMp: 50));

      final buffNotifier = SkillBuffNotifier(SkillBuffModel.defaultBuffs());

      final castSuccess = buffNotifier.castBuff(
        'buff_double_exp', // cost 30 MP
        heroNotifier: heroNotifier,
      );

      expect(castSuccess, true);
      expect(heroNotifier.state.currentMp, 20); // 50 - 30
      expect(buffNotifier.isBuffActive('buff_double_exp'), true);

      // Attempt to cast another buff costing 40 MP with only 20 MP left
      final fail = buffNotifier.castBuff(
        'buff_boss_stun',
        heroNotifier: heroNotifier,
      );
      expect(fail, false);
    });

    testWidgets(
      'Battle Hub UI switches to Habits tab and allows habit actions',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final heroNotifier = HeroNotifier(
          const HeroModel(name: 'Arthur', level: 1, coins: 10, currentMp: 80),
        );

        final habit = HabitModel(
          id: 'h_ui',
          title: 'Push-ups',
          hasPositive: true,
          hasNegative: true,
        );

        final habitNotifier = HabitNotifier([habit]);
        final buffNotifier = SkillBuffNotifier(SkillBuffModel.defaultBuffs());

        final container = ProviderContainer(
          overrides: [
            heroProvider.overrideWith((ref) => heroNotifier),
            habitProvider.overrideWith((ref) => habitNotifier),
            skillBuffProvider.overrideWith((ref) => buffNotifier),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: BattleHubScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // Switch to HABITS tab
        await tester.tap(find.textContaining('HABITS'));
        await tester.pumpAndSettle();

        expect(find.text('MP SKILL BUFFS'), findsOneWidget);
        expect(find.text('Double EXP Scroll'), findsOneWidget);
        expect(find.text('Push-ups'), findsOneWidget);
        expect(find.text('+ HABIT'), findsOneWidget);

        // Tap + button on Push-ups habit
        final plusBtn = find.widgetWithText(PixelButton, '+');
        expect(plusBtn, findsOneWidget);
        await tester.ensureVisible(plusBtn);
        await tester.pumpAndSettle();
        await tester.tap(plusBtn);
        await tester.pumpAndSettle();

        expect(container.read(heroProvider).coins, 20); // 10 + 10
        expect(container.read(heroProvider).currentMp, 95); // 80 + 15
      },
    );
  });
}
