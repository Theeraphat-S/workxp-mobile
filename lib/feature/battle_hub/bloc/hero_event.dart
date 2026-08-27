import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class HeroEvent extends Equatable {
  const HeroEvent();

  @override
  List<Object?> get props => [];
}

class LoadHero extends HeroEvent {
  const LoadHero();
}

class HeroUpdated extends HeroEvent {
  const HeroUpdated(this.hero);
  final Hero? hero;

  @override
  List<Object?> get props => [hero];
}

class AllocateAttributes extends HeroEvent {
  const AllocateAttributes({this.str, this.agi, this.intAttr, this.vit});

  final int? str;
  final int? agi;
  final int? intAttr;
  final int? vit;

  @override
  List<Object?> get props => [str, agi, intAttr, vit];
}

class ReviveHero extends HeroEvent {
  const ReviveHero();
}

class EquipSkin extends HeroEvent {
  const EquipSkin(this.skinId);
  final String skinId;

  @override
  List<Object?> get props => [skinId];
}

class EquipTitle extends HeroEvent {
  const EquipTitle(this.title);
  final String title;

  @override
  List<Object?> get props => [title];
}

class AwardExpAndCoins extends HeroEvent {
  const AwardExpAndCoins({required this.exp, required this.coins});

  final int exp;
  final int coins;

  @override
  List<Object?> get props => [exp, coins];
}

class ApplyDamage extends HeroEvent {
  const ApplyDamage(this.damage);
  final int damage;

  @override
  List<Object?> get props => [damage];
}

class SpendMp extends HeroEvent {
  const SpendMp(this.mpAmount);
  final int mpAmount;

  @override
  List<Object?> get props => [mpAmount];
}
