import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {
  const LoadAnalytics();
}

class AnalyticsUpdated extends AnalyticsEvent {
  const AnalyticsUpdated({
    required this.combatLogs,
    required this.hero,
    required this.dailies,
    required this.habits,
  });

  final List<CombatLog> combatLogs;
  final Hero? hero;
  final List<DailyQuest> dailies;
  final List<Habit> habits;

  @override
  List<Object?> get props => [combatLogs, hero, dailies, habits];
}

class RefreshAnalytics extends AnalyticsEvent {
  const RefreshAnalytics();
}
