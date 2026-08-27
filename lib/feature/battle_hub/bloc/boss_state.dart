import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class BossState extends Equatable {
  const BossState();

  @override
  List<Object?> get props => [];
}

class BossInitial extends BossState {
  const BossInitial();
}

class BossLoading extends BossState {
  const BossLoading();
}

class BossLoaded extends BossState {
  const BossLoaded({required this.activeBoss, required this.allBosses});

  final Boss? activeBoss;
  final List<Boss> allBosses;

  // Convenience getters
  String get name => activeBoss?.name ?? 'Boss Encounter';
  int get currentHp => activeBoss?.currentHp ?? 0;
  int get maxHp => activeBoss?.maxHp ?? 100;
  int get chapter => activeBoss?.chapter ?? 1;
  String get iconAsset => activeBoss?.iconAsset ?? 'boss_slime';
  bool get isDefeated => activeBoss?.isDefeated ?? false;

  @override
  List<Object?> get props => [activeBoss, allBosses];
}

class BossError extends BossState {
  const BossError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
