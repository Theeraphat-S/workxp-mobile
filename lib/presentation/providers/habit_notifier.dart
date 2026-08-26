import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'hero_notifier.dart';

import 'analytics_notifier.dart';

class HabitNotifier extends StateNotifier<List<HabitModel>> {
  HabitNotifier([List<HabitModel>? initial]) : super(initial ?? []);

  void setHabits(List<HabitModel> habits) {
    state = habits;
  }

  void addHabit(HabitModel habit) {
    state = [habit, ...state];
  }

  void editHabit(HabitModel updated) {
    state = [
      for (final h in state)
        if (h.id == updated.id) updated else h,
    ];
  }

  void deleteHabit(String id) {
    state = state.where((h) => h.id != id).toList();
  }

  /// Logs positive (+) habit occurrence: +10 Coins, +15 MP
  void logPositive(
    String id, {
    required HeroNotifier heroNotifier,
    AnalyticsNotifier? analyticsNotifier,
  }) {
    final index = state.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = state[index];
    final updatedHabit = habit.copyWith(
      positiveCountToday: habit.positiveCountToday + 1,
      totalPositiveCount: habit.totalPositiveCount + 1,
    );

    final updatedList = List<HabitModel>.from(state);
    updatedList[index] = updatedHabit;
    state = updatedList;

    SensoryService.instance.playCoin();
    heroNotifier.gainCoins(10);
    heroNotifier.gainMp(15);
    analyticsNotifier?.recordHabit();
  }

  /// Logs negative (-) habit occurrence: -10 Coins, -15 MP
  void logNegative(
    String id, {
    required HeroNotifier heroNotifier,
    AnalyticsNotifier? analyticsNotifier,
  }) {
    final index = state.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = state[index];
    final updatedHabit = habit.copyWith(
      negativeCountToday: habit.negativeCountToday + 1,
      totalNegativeCount: habit.totalNegativeCount + 1,
    );

    final updatedList = List<HabitModel>.from(state);
    updatedList[index] = updatedHabit;
    state = updatedList;

    SensoryService.instance.playHurt();
    heroNotifier.spendCoins(10);
    heroNotifier.spendMp(15);
  }

  void resetHabitsForNewDay() {
    state = state
        .map((h) => h.copyWith(positiveCountToday: 0, negativeCountToday: 0))
        .toList();
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<HabitModel>>((
  ref,
) {
  return HabitNotifier();
});
