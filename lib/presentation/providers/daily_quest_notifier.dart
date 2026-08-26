import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'hero_notifier.dart';

class DailyQuestNotifier extends StateNotifier<List<DailyQuestModel>> {
  DailyQuestNotifier([List<DailyQuestModel>? initial]) : super(initial ?? []);

  void setDailyQuests(List<DailyQuestModel> dailies) {
    state = dailies;
  }

  void addDailyQuest(DailyQuestModel daily) {
    state = [daily, ...state];
  }

  void editDailyQuest(DailyQuestModel updated) {
    state = [
      for (final d in state)
        if (d.id == updated.id) updated else d,
    ];
  }

  void deleteDailyQuest(String id) {
    state = state.where((d) => d.id != id).toList();
  }

  /// Toggles daily quest completion status
  void toggleDailyQuest(String id, {required HeroNotifier heroNotifier}) {
    final index = state.indexWhere((d) => d.id == id);
    if (index == -1) return;

    final daily = state[index];
    final wasCompleted = daily.isCompletedToday;
    final newCompleted = !wasCompleted;

    final newStreak = newCompleted
        ? daily.streak + 1
        : (daily.streak > 0 ? daily.streak - 1 : 0);

    final updatedDaily = daily.copyWith(
      isCompletedToday: newCompleted,
      streak: newStreak,
      lastCompletedDate: newCompleted
          ? DateTime.now()
          : daily.lastCompletedDate,
    );

    final updatedList = List<DailyQuestModel>.from(state);
    updatedList[index] = updatedDaily;
    state = updatedList;

    if (newCompleted) {
      SensoryService.instance.playCoin();
      heroNotifier.gainExp(30);
      heroNotifier.gainCoins(15);

      // Check if all dailies completed today for bonus streak rewards
      final allDone =
          state.isNotEmpty && state.every((d) => d.isCompletedToday);
      if (allDone) {
        SensoryService.instance.playLevelUp();
        heroNotifier.gainCoins(25); // Bonus streak coin chest
      }
    }
  }

  /// Resets daily completion status on new day cycle
  void resetDailiesForNewDay() {
    state = state.map((d) => d.copyWith(isCompletedToday: false)).toList();
  }
}

final dailyQuestProvider =
    StateNotifierProvider<DailyQuestNotifier, List<DailyQuestModel>>((ref) {
      return DailyQuestNotifier();
    });
