import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'hero_notifier.dart';
import 'dungeon_notifier.dart';

class QuestNotifier extends StateNotifier<List<QuestModel>> {
  QuestNotifier([List<QuestModel>? initial]) : super(initial ?? []);

  void setQuests(List<QuestModel> quests) {
    state = quests;
  }

  void addQuest(QuestModel quest) {
    state = [quest, ...state];
  }

  void editQuest(QuestModel updated) {
    state = [
      for (final q in state)
        if (q.id == updated.id) updated else q,
    ];
  }

  void deleteQuest(String questId) {
    state = state.where((q) => q.id != questId).toList();
  }

  /// Completes a Quest: strikes the boss with rank damage + hero attribute bonus,
  /// grants EXP & Coins to hero, and marks quest as complete.
  int completeQuest(
    String questId, {
    required HeroNotifier heroNotifier,
    required DungeonNotifier dungeonNotifier,
  }) {
    final index = state.indexWhere((q) => q.id == questId);
    if (index == -1) return 0;

    final quest = state[index];
    if (quest.isCompleted) return 0;

    final baseDamage = QuestModel.baseDamageForRank(quest.rank);
    final heroBonus = heroNotifier.state.combatDamageBonus;
    final totalDamage = baseDamage + heroBonus;

    final expReward = QuestModel.expRewardForRank(quest.rank);
    final coinReward = QuestModel.coinRewardForRank(quest.rank);

    // Apply combat strike
    dungeonNotifier.applyDamage(totalDamage);

    // Grant Hero rewards
    heroNotifier.gainExp(expReward);
    heroNotifier.gainCoins(coinReward);

    // Check if boss died and grant boss bonus
    if (dungeonNotifier.state.activeBoss.isDefeated) {
      heroNotifier.gainCoins(dungeonNotifier.state.activeBoss.coinReward);
      heroNotifier.gainExp(dungeonNotifier.state.activeBoss.expReward);
    }

    final updatedQuest = quest.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    final updatedList = List<QuestModel>.from(state);
    updatedList[index] = updatedQuest;
    state = updatedList;

    return totalDamage;
  }
}

final questProvider = StateNotifierProvider<QuestNotifier, List<QuestModel>>((
  ref,
) {
  return QuestNotifier();
});
