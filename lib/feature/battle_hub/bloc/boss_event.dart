import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class BossEvent extends Equatable {
  const BossEvent();

  @override
  List<Object?> get props => [];
}

class LoadBoss extends BossEvent {
  const LoadBoss();
}

class BossUpdated extends BossEvent {
  const BossUpdated({
    required this.activeBoss,
    required this.allBosses,
  });

  final Boss? activeBoss;
  final List<Boss> allBosses;

  @override
  List<Object?> get props => [activeBoss, allBosses];
}

class DamageBoss extends BossEvent {
  const DamageBoss(this.damage);
  final int damage;

  @override
  List<Object?> get props => [damage];
}

class AdvanceChapterBoss extends BossEvent {
  const AdvanceChapterBoss();
}

class ResetCurrentBoss extends BossEvent {
  const ResetCurrentBoss(this.bossId);
  final String bossId;

  @override
  List<Object?> get props => [bossId];
}
