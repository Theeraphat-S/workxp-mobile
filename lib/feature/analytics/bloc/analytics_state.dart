import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/analytics_model.dart';
import 'package:workxp/domain/models/hero_model.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded({
    required this.combatLogs,
    required this.hero,
    required this.heroModel,
    required this.dailies,
    required this.habits,
    required this.dailyLogs,
    required this.achievements,
    required this.leaderboard,
  });

  final List<CombatLog> combatLogs;
  final Hero? hero;
  final HeroModel heroModel;
  final List<DailyQuest> dailies;
  final List<Habit> habits;
  final List<DailyActivityLog> dailyLogs;
  final List<AchievementModel> achievements;
  final List<LeaderboardEntryModel> leaderboard;

  int get totalDamageDealt =>
      combatLogs.fold<int>(0, (sum, log) => sum + log.damage);

  @override
  List<Object?> get props => [
    combatLogs,
    hero,
    heroModel,
    dailies,
    habits,
    dailyLogs,
    achievements,
    leaderboard,
  ];
}

class AnalyticsError extends AnalyticsState {
  const AnalyticsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
