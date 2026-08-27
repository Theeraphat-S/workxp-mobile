import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class DailyQuestState extends Equatable {
  const DailyQuestState();

  @override
  List<Object?> get props => [];
}

class DailyQuestInitial extends DailyQuestState {
  const DailyQuestInitial();
}

class DailyQuestLoading extends DailyQuestState {
  const DailyQuestLoading();
}

class DailyQuestLoaded extends DailyQuestState {
  const DailyQuestLoaded({
    required this.dailies,
    this.allCompletedToday = false,
  });

  final List<DailyQuest> dailies;
  final bool allCompletedToday;

  int get completedCount => dailies.where((d) => d.isCompleted).length;
  int get totalCount => dailies.length;
  bool get hasDailies => dailies.isNotEmpty;

  DailyQuestLoaded copyWith({
    List<DailyQuest>? dailies,
    bool? allCompletedToday,
  }) {
    return DailyQuestLoaded(
      dailies: dailies ?? this.dailies,
      allCompletedToday: allCompletedToday ?? this.allCompletedToday,
    );
  }

  @override
  List<Object?> get props => [dailies, allCompletedToday];
}

class DailyQuestError extends DailyQuestState {
  const DailyQuestError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
