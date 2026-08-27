import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class DailyQuestEvent extends Equatable {
  const DailyQuestEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyQuests extends DailyQuestEvent {
  const LoadDailyQuests();
}

class DailyQuestsUpdated extends DailyQuestEvent {
  const DailyQuestsUpdated(this.dailies);
  final List<DailyQuest> dailies;

  @override
  List<Object?> get props => [dailies];
}

class ToggleDailyQuest extends DailyQuestEvent {
  const ToggleDailyQuest(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class CreateDailyQuest extends DailyQuestEvent {
  const CreateDailyQuest({
    required this.title,
    required this.description,
    this.streak = 0,
    this.id,
  });

  final String title;
  final String description;
  final int streak;
  final String? id;

  @override
  List<Object?> get props => [title, description, streak, id];
}

class DeleteDailyQuest extends DailyQuestEvent {
  const DeleteDailyQuest(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class ProcessMidnightReset extends DailyQuestEvent {
  const ProcessMidnightReset();
}
