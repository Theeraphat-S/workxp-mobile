import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/analytics_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'dungeon_notifier.dart';

class AnalyticsState {
  const AnalyticsState({
    this.dailyLogs = const [],
    this.achievements = const [],
    this.leaderboard = const [],
  });

  final List<DailyActivityLog> dailyLogs;
  final List<AchievementModel> achievements;
  final List<LeaderboardEntryModel> leaderboard;

  AnalyticsState copyWith({
    List<DailyActivityLog>? dailyLogs,
    List<AchievementModel>? achievements,
    List<LeaderboardEntryModel>? leaderboard,
  }) {
    return AnalyticsState(
      dailyLogs: dailyLogs ?? this.dailyLogs,
      achievements: achievements ?? this.achievements,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyLogs': dailyLogs.map((l) => l.toJson()).toList(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'leaderboard': leaderboard.map((b) => b.toJson()).toList(),
    };
  }

  factory AnalyticsState.fromJson(Map<String, dynamic> json) {
    return AnalyticsState(
      dailyLogs:
          (json['dailyLogs'] as List<dynamic>?)
              ?.map((e) => DailyActivityLog.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          AchievementModel.defaultAchievements(),
      leaderboard:
          (json['leaderboard'] as List<dynamic>?)
              ?.map(
                (e) =>
                    LeaderboardEntryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          LeaderboardEntryModel.simulatedRivals(),
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier([AnalyticsState? initial])
    : super(
        initial ??
            AnalyticsState(
              achievements: AchievementModel.defaultAchievements(),
              leaderboard: LeaderboardEntryModel.simulatedRivals(),
              dailyLogs: _seedPastLogs(),
            ),
      );

  static List<DailyActivityLog> _seedPastLogs() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DailyActivityLog(
        date: d,
        expEarned: 50 + (i * 25),
        damageDealt: 100 + (i * 40),
        habitCompletions: 2 + (i % 3),
      );
    });
  }

  void setAnalyticsState(AnalyticsState analyticsState) {
    state = analyticsState;
  }

  void recordExp(int amount) {
    if (amount <= 0) return;
    _updateTodayLog((log) => log.copyWith(expEarned: log.expEarned + amount));
  }

  void recordDamage(int amount) {
    if (amount <= 0) return;
    _updateTodayLog(
      (log) => log.copyWith(damageDealt: log.damageDealt + amount),
    );
  }

  void recordHabit() {
    _updateTodayLog(
      (log) => log.copyWith(habitCompletions: log.habitCompletions + 1),
    );
  }

  void _updateTodayLog(DailyActivityLog Function(DailyActivityLog) updater) {
    final now = DateTime.now();
    final logs = List<DailyActivityLog>.from(state.dailyLogs);
    final idx = logs.indexWhere(
      (l) =>
          l.date.year == now.year &&
          l.date.month == now.month &&
          l.date.day == now.day,
    );

    if (idx != -1) {
      logs[idx] = updater(logs[idx]);
    } else {
      logs.add(updater(DailyActivityLog(date: now)));
    }
    state = state.copyWith(dailyLogs: logs);
  }

  /// Evaluates achievement unlocks based on current hero & game state
  void evaluateAchievements({
    required HeroModel hero,
    required DungeonState dungeon,
    required List<QuestModel> quests,
    required List<DailyQuestModel> dailies,
  }) {
    final updated = List<AchievementModel>.from(state.achievements);
    bool anyNew = false;

    void check(String id, bool condition) {
      final index = updated.indexWhere((a) => a.id == id);
      if (index != -1 && !updated[index].isUnlocked && condition) {
        updated[index] = updated[index].copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        anyNew = true;
      }
    }

    // 1. First Blood
    check('ach_first_blood', quests.any((q) => q.isCompleted));
    // 2. Slime Slayer
    check(
      'ach_slime_slayer',
      dungeon.defeatedBosses.any((b) => b.id == 'boss_slime'),
    );
    // 3. Dragon Slayer
    check(
      'ach_dragon_slayer',
      dungeon.defeatedBosses.any((b) => b.id == 'boss_dragon'),
    );
    // 4. Streak Master
    check('ach_streak_master', dailies.any((d) => d.streak >= 7));
    // 5. Coin Hoarder
    check('ach_coin_hoarder', hero.coins >= 200);
    // 6. Attribute Master
    check(
      'ach_attribute_master',
      hero.str >= 15 ||
          hero.intel >= 15 ||
          hero.agi >= 15 ||
          hero.vit >= 15 ||
          hero.wis >= 15,
    );

    if (anyNew) {
      SensoryService.instance.playVictory();
      state = state.copyWith(achievements: updated);
    }

    _updateLeaderboard(hero);
  }

  void _updateLeaderboard(HeroModel hero) {
    final totalDamage = state.dailyLogs.fold<int>(
      0,
      (sum, l) => sum + l.damageDealt,
    );
    final maxStreak = hero.level * 2; // derived streak rank

    final playerEntry = LeaderboardEntryModel(
      rank: 1,
      name: '${hero.name} (You)',
      title: hero.activeTitleId,
      skinId: hero.activeSkinId,
      weeklyDamage: totalDamage > 0 ? totalDamage : 850,
      streak: maxStreak > 0 ? maxStreak : 3,
      isPlayer: true,
    );

    final entries = List<LeaderboardEntryModel>.from(
      LeaderboardEntryModel.simulatedRivals(),
    )..add(playerEntry);

    entries.sort((a, b) => b.weeklyDamage.compareTo(a.weeklyDamage));

    final ranked = List.generate(entries.length, (i) {
      final e = entries[i];
      return LeaderboardEntryModel(
        rank: i + 1,
        name: e.name,
        title: e.title,
        skinId: e.skinId,
        weeklyDamage: e.weeklyDamage,
        streak: e.streak,
        isPlayer: e.isPlayer,
      );
    });

    state = state.copyWith(leaderboard: ranked);
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      return AnalyticsNotifier();
    });
