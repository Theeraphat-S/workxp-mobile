import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class DungeonEvent extends Equatable {
  const DungeonEvent();

  @override
  List<Object?> get props => [];
}

class LoadDungeon extends DungeonEvent {
  const LoadDungeon();
}

class DungeonUpdated extends DungeonEvent {
  const DungeonUpdated({
    required this.bosses,
    required this.activeBoss,
  });

  final List<Boss> bosses;
  final Boss? activeBoss;

  @override
  List<Object?> get props => [bosses, activeBoss];
}

class SelectChapter extends DungeonEvent {
  const SelectChapter(this.chapter);
  final int chapter;

  @override
  List<Object?> get props => [chapter];
}

class UnlockNextChapter extends DungeonEvent {
  const UnlockNextChapter();
}

class ResetBossDungeon extends DungeonEvent {
  const ResetBossDungeon(this.bossId);
  final String bossId;

  @override
  List<Object?> get props => [bossId];
}
