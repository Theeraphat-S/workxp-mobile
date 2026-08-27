import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';

abstract class HeroState extends Equatable {
  const HeroState();

  @override
  List<Object?> get props => [];
}

class HeroInitial extends HeroState {
  const HeroInitial();
}

class HeroLoading extends HeroState {
  const HeroLoading();
}

class HeroLoaded extends HeroState {
  const HeroLoaded(this.hero);
  final Hero hero;

  // Convenience getters
  String get name => hero.name;
  int get level => hero.level;
  int get currentExp => hero.currentExp;
  int get hp => hero.hp;
  int get maxHp => hero.maxHp;
  int get mp => hero.mp;
  int get maxMp => hero.maxMp;
  int get coins => hero.coins;
  int get str => hero.str;
  int get agi => hero.agi;
  int get intAttr => hero.intAttr;
  int get vit => hero.vit;
  int get unspentStatPoints => hero.unspentStatPoints;
  bool get isGhost => hero.isGhost;
  String get activeTitle => hero.activeTitle;
  String get avatarSkinId => hero.avatarSkinId;
  String get bannerId => hero.bannerId;

  int get nextLevelExp => HeroModel.expTargetForLevel(level);
  int get combatDamageBonus => (str * 2) + (agi * 1);

  @override
  List<Object?> get props => [hero];
}

class HeroError extends HeroState {
  const HeroError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
