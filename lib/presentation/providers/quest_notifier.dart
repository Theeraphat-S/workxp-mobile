import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'hero_notifier.dart';
import 'dungeon_notifier.dart';

import 'skill_buff_notifier.dart';
import 'analytics_notifier.dart';

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
  /// grants EXP & Coins to hero, records analytics, and marks quest as complete.
  int completeQuest(
    String questId, {
    required HeroNotifier heroNotifier,
    required DungeonNotifier dungeonNotifier,
    SkillBuffNotifier? skillBuffNotifier,
    AnalyticsNotifier? analyticsNotifier,
  }) {
    final index = state.indexWhere((q) => q.id == questId);
    if (index == -1) return 0;

    final quest = state[index];
    if (quest.isCompleted) return 0;

    final baseDamage = QuestModel.baseDamageForRank(quest.rank);
    final heroBonus = heroNotifier.state.combatDamageBonus;
    int totalDamage = baseDamage + heroBonus;

    // Apply Focus Surge buff (+50% attack damage) if active
    if (skillBuffNotifier?.isBuffActive('buff_focus_surge') == true) {
      totalDamage = (totalDamage * 1.5).round();
    }

    int expReward = QuestModel.expRewardForRank(quest.rank);
    // Apply Double EXP Scroll buff (2x EXP) if active
    if (skillBuffNotifier?.isBuffActive('buff_double_exp') == true) {
      expReward *= 2;
    }

    final coinReward = QuestModel.coinRewardForRank(quest.rank);

    // Apply combat strike
    dungeonNotifier.applyDamage(totalDamage);

    // Grant Hero rewards
    heroNotifier.gainExp(expReward);
    heroNotifier.gainCoins(coinReward);

    // Record Live Analytics
    analyticsNotifier?.recordExp(expReward);
    analyticsNotifier?.recordDamage(totalDamage);

    // Check if boss died and grant boss bonus
    if (dungeonNotifier.state.activeBoss.isDefeated) {
      final bossCoins = dungeonNotifier.state.activeBoss.coinReward;
      final bossExp = dungeonNotifier.state.activeBoss.expReward;
      heroNotifier.gainCoins(bossCoins);
      heroNotifier.gainExp(bossExp);
      analyticsNotifier?.recordExp(bossExp);
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
