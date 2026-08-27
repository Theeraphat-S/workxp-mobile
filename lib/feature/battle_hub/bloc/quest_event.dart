import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class QuestEvent extends Equatable {
  const QuestEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuests extends QuestEvent {
  const LoadQuests();
}

class QuestsUpdated extends QuestEvent {
  const QuestsUpdated(this.quests);
  final List<Quest> quests;

  @override
  List<Object?> get props => [quests];
}

class CreateQuest extends QuestEvent {
  const CreateQuest({
    required this.title,
    required this.description,
    required this.rank,
    required this.baseDamage,
    required this.expReward,
    required this.coinReward,
    this.id,
  });

  final String title;
  final String description;
  final String rank;
  final int baseDamage;
  final int expReward;
  final int coinReward;
  final String? id;

  @override
  List<Object?> get props => [
    title,
    description,
    rank,
    baseDamage,
    expReward,
    coinReward,
    id,
  ];
}

class CompleteQuest extends QuestEvent {
  const CompleteQuest(this.questId);
  final String questId;

  @override
  List<Object?> get props => [questId];
}

class DeleteQuest extends QuestEvent {
  const DeleteQuest(this.questId);
  final String questId;

  @override
  List<Object?> get props => [questId];
}

class ClearCombatStrikeFeedback extends QuestEvent {
  const ClearCombatStrikeFeedback();
}
