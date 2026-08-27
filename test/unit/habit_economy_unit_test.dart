import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1 Unit Test: Habit Economy & MP Skill Buffs', () {
    test(
      '1. Positive habit logging grants +10 Coins and +15 MP, updating daily and total counters',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 50, currentMp: 30, maxMp: 100),
        );

        final habit = HabitModel(
          id: 'h_water',
          title: 'Drink 1 Glass of Water',
          hasPositive: true,
          hasNegative: false,
        );

        final habitNotifier = HabitNotifier([habit]);
        final analyticsNotifier = AnalyticsNotifier(const AnalyticsState());

        habitNotifier.logPositive(
          'h_water',
          heroNotifier: heroNotifier,
          analyticsNotifier: analyticsNotifier,
        );

        expect(habitNotifier.state.first.positiveCountToday, 1);
        expect(habitNotifier.state.first.totalPositiveCount, 1);
        expect(heroNotifier.state.coins, 60); // 50 + 10
        expect(heroNotifier.state.currentMp, 45); // 30 + 15
      },
    );

    test(
      '2. Positive habit MP gain is strictly capped at Hero maxMp (100)',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 20, currentMp: 95, maxMp: 100),
        );

        final habit = HabitModel(
          id: 'h_posture',
          title: 'Good Posture',
          hasPositive: true,
        );
        final habitNotifier = HabitNotifier([habit]);

        habitNotifier.logPositive('h_posture', heroNotifier: heroNotifier);

        expect(heroNotifier.state.currentMp, 100); // 95 + 15 clamped to 100
        expect(heroNotifier.state.coins, 30);
      },
    );

    test(
      '3. Negative habit logging deducts -10 Coins and -15 MP, updating negative counters',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 60, currentMp: 70),
        );

        final habit = HabitModel(
          id: 'h_scroll',
          title: 'Doomscrolling',
          hasPositive: false,
          hasNegative: true,
        );

        final habitNotifier = HabitNotifier([habit]);

        habitNotifier.logNegative('h_scroll', heroNotifier: heroNotifier);

        expect(habitNotifier.state.first.negativeCountToday, 1);
        expect(habitNotifier.state.first.totalNegativeCount, 1);
        expect(heroNotifier.state.coins, 50); // 60 - 10
        expect(heroNotifier.state.currentMp, 55); // 70 - 15
      },
    );

    test(
      '4. Casting MP Skill Buff deducts precise MP cost and activates duration timer',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(currentMp: 80));

        final skillBuffNotifier = SkillBuffNotifier(
          SkillBuffModel.defaultBuffs(),
        );

        // Cast Double EXP Scroll (Cost: 30 MP, Duration: 120 Mins)
        final success = skillBuffNotifier.castBuff(
          'buff_double_exp',
          heroNotifier: heroNotifier,
        );

        expect(success, isTrue);
        expect(heroNotifier.state.currentMp, 50); // 80 - 30
        expect(skillBuffNotifier.isBuffActive('buff_double_exp'), isTrue);

        final activeBuff = skillBuffNotifier.state.firstWhere(
          (b) => b.id == 'buff_double_exp',
        );
        expect(activeBuff.isActive, isTrue);
        expect(activeBuff.activatedAt, isNotNull);
        expect(activeBuff.expiresAt, isNotNull);
        expect(activeBuff.remainingDuration.inMinutes > 0, isTrue);
      },
    );

    test(
      '5. Skill Buff cast fails and preserves MP when Hero MP is insufficient',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(currentMp: 20));

        final skillBuffNotifier = SkillBuffNotifier(
          SkillBuffModel.defaultBuffs(),
        );

        // Attempt to cast Boss Stun (Cost: 40 MP) with only 20 MP
        final failStun = skillBuffNotifier.castBuff(
          'buff_boss_stun',
          heroNotifier: heroNotifier,
        );

        expect(failStun, isFalse);
        expect(heroNotifier.state.currentMp, 20); // MP unchanged
        expect(skillBuffNotifier.isBuffActive('buff_boss_stun'), isFalse);

        // Attempt to cast Focus Surge (Cost: 25 MP) with only 20 MP
        final failSurge = skillBuffNotifier.castBuff(
          'buff_focus_surge',
          heroNotifier: heroNotifier,
        );

        expect(failSurge, isFalse);
        expect(heroNotifier.state.currentMp, 20);
      },
    );

    test(
      '6. Reset habits for new day clears daily count while preserving total lifetime count',
      () {
        final habit = HabitModel(
          id: 'h_test',
          title: 'Exercise',
          positiveCountToday: 5,
          totalPositiveCount: 25,
          negativeCountToday: 2,
          totalNegativeCount: 8,
        );

        final habitNotifier = HabitNotifier([habit]);

        habitNotifier.resetHabitsForNewDay();

        final resetHabit = habitNotifier.state.first;
        expect(resetHabit.positiveCountToday, 0);
        expect(resetHabit.negativeCountToday, 0);
        expect(resetHabit.totalPositiveCount, 25);
        expect(resetHabit.totalNegativeCount, 8);
      },
    );
  });
}
