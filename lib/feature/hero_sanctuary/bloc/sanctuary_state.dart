import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';

abstract class SanctuaryState extends Equatable {
  const SanctuaryState();

  @override
  List<Object?> get props => [];
}

class SanctuaryInitial extends SanctuaryState {
  const SanctuaryInitial();
}

class SanctuaryLoading extends SanctuaryState {
  const SanctuaryLoading();
}

class SanctuaryLoaded extends SanctuaryState {
  const SanctuaryLoaded({
    required this.hero,
    required this.heroModel,
    this.sfxEnabled = true,
    this.hapticsEnabled = true,
    this.exportedBackupJson,
    this.backupStatusMessage,
  });

  final Hero? hero;
  final HeroModel heroModel;
  final bool sfxEnabled;
  final bool hapticsEnabled;
  final String? exportedBackupJson;
  final String? backupStatusMessage;

  int get unallocatedPoints =>
      hero?.unspentStatPoints ?? heroModel.unallocatedPoints;

  SanctuaryLoaded copyWith({
    Hero? hero,
    HeroModel? heroModel,
    bool? sfxEnabled,
    bool? hapticsEnabled,
    String? exportedBackupJson,
    String? backupStatusMessage,
  }) {
    return SanctuaryLoaded(
      hero: hero ?? this.hero,
      heroModel: heroModel ?? this.heroModel,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      exportedBackupJson: exportedBackupJson,
      backupStatusMessage: backupStatusMessage,
    );
  }

  @override
  List<Object?> get props => [
    hero,
    heroModel,
    sfxEnabled,
    hapticsEnabled,
    exportedBackupJson,
    backupStatusMessage,
  ];
}

class SanctuaryError extends SanctuaryState {
  const SanctuaryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
