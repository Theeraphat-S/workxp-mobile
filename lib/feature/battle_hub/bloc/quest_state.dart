import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class QuestState extends Equatable {
  const QuestState();

  @override
  List<Object?> get props => [];
}

class QuestInitial extends QuestState {
  const QuestInitial();
}

class QuestLoading extends QuestState {
  const QuestLoading();
}

class QuestLoaded extends QuestState {
  const QuestLoaded({
    required this.quests,
    this.lastStrikeDamage = 0,
    this.isCritical = false,
    this.completedQuestId,
  });

  final List<Quest> quests;
  final int lastStrikeDamage;
  final bool isCritical;
  final String? completedQuestId;

  List<Quest> get activeQuests => quests.where((q) => !q.isCompleted).toList();
  List<Quest> get completedQuests =>
      quests.where((q) => q.isCompleted).toList();

  QuestLoaded copyWith({
    List<Quest>? quests,
    int? lastStrikeDamage,
    bool? isCritical,
    String? completedQuestId,
  }) {
    return QuestLoaded(
      quests: quests ?? this.quests,
      lastStrikeDamage: lastStrikeDamage ?? this.lastStrikeDamage,
      isCritical: isCritical ?? this.isCritical,
      completedQuestId: completedQuestId,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    lastStrikeDamage,
    isCritical,
    completedQuestId,
  ];
}

class QuestError extends QuestState {
  const QuestError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
