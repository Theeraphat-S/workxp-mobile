import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class SanctuaryEvent extends Equatable {
  const SanctuaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadSanctuary extends SanctuaryEvent {
  const LoadSanctuary();
}

class SanctuaryHeroUpdated extends SanctuaryEvent {
  const SanctuaryHeroUpdated(this.hero);
  final Hero? hero;

  @override
  List<Object?> get props => [hero];
}

class AllocateStatPoint extends SanctuaryEvent {
  const AllocateStatPoint(this.attribute);
  final String attribute;

  @override
  List<Object?> get props => [attribute];
}

class EquipSkinEvent extends SanctuaryEvent {
  const EquipSkinEvent(this.skinId);
  final String skinId;

  @override
  List<Object?> get props => [skinId];
}

class EquipTitleEvent extends SanctuaryEvent {
  const EquipTitleEvent(this.title);
  final String title;

  @override
  List<Object?> get props => [title];
}

class ToggleSfxEvent extends SanctuaryEvent {
  const ToggleSfxEvent(this.enabled);
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class ToggleHapticsEvent extends SanctuaryEvent {
  const ToggleHapticsEvent(this.enabled);
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class ExportBackupEvent extends SanctuaryEvent {
  const ExportBackupEvent();
}

class ImportBackupEvent extends SanctuaryEvent {
  const ImportBackupEvent(this.jsonString);
  final String jsonString;

  @override
  List<Object?> get props => [jsonString];
}
