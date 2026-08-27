import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class DungeonState extends Equatable {
  const DungeonState();

  @override
  List<Object?> get props => [];
}

class DungeonInitial extends DungeonState {
  const DungeonInitial();
}

class DungeonLoading extends DungeonState {
  const DungeonLoading();
}

class DungeonLoaded extends DungeonState {
  const DungeonLoaded({
    required this.bosses,
    required this.activeBoss,
    this.unlockedChapterMax = 1,
  });

  final List<Boss> bosses;
  final Boss? activeBoss;
  final int unlockedChapterMax;

  int get currentChapter => activeBoss?.chapter ?? 1;
  List<Boss> get defeatedBosses => bosses.where((b) => b.isDefeated).toList();

  bool isChapterUnlocked(int chapter) {
    if (chapter <= 1) return true;
    return chapter <= unlockedChapterMax;
  }

  bool isChapterDefeated(int chapter) {
    final b = bosses.where((b) => b.chapter == chapter).firstOrNull;
    return b?.isDefeated ?? false;
  }

  @override
  List<Object?> get props => [bosses, activeBoss, unlockedChapterMax];
}

class DungeonError extends DungeonState {
  const DungeonError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
