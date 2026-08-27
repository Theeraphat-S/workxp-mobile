import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'hero_event.dart';
import 'hero_state.dart';

export 'hero_event.dart';
export 'hero_state.dart';

class HeroBloc extends Bloc<HeroEvent, HeroState> {
  HeroBloc(this._heroRepository) : super(const HeroInitial()) {
    on<LoadHero>(_onLoadHero);
    on<HeroUpdated>(_onHeroUpdated);
    on<AllocateAttributes>(_onAllocateAttributes);
    on<ReviveHero>(_onReviveHero);
    on<EquipSkin>(_onEquipSkin);
    on<EquipTitle>(_onEquipTitle);
    on<AwardExpAndCoins>(_onAwardExpAndCoins);
    on<ApplyDamage>(_onApplyDamage);
    on<SpendMp>(_onSpendMp);
  }

  final HeroRepository _heroRepository;
  StreamSubscription<Hero?>? _heroSubscription;

  Future<void> _onLoadHero(LoadHero event, Emitter<HeroState> emit) async {
    emit(const HeroLoading());
    await _heroSubscription?.cancel();
    _heroSubscription = _heroRepository.watchHero().listen((hero) {
      add(HeroUpdated(hero));
    });
  }

  void _onHeroUpdated(HeroUpdated event, Emitter<HeroState> emit) {
    if (event.hero != null) {
      emit(HeroLoaded(event.hero!));
    } else {
      emit(const HeroError('Hero data not found'));
    }
  }

  Future<void> _onAllocateAttributes(
    AllocateAttributes event,
    Emitter<HeroState> emit,
  ) async {
    try {
      await _heroRepository.allocateAttributes(
        str: event.str ?? 0,
        agi: event.agi ?? 0,
        intAttr: event.intAttr ?? 0,
        vit: event.vit ?? 0,
      );
    } catch (e) {
      emit(HeroError('Failed to allocate attributes: $e'));
    }
  }

  Future<void> _onReviveHero(ReviveHero event, Emitter<HeroState> emit) async {
    try {
      await _heroRepository.setGhostState(false);
    } catch (e) {
      emit(HeroError('Failed to revive hero: $e'));
    }
  }

  Future<void> _onEquipSkin(EquipSkin event, Emitter<HeroState> emit) async {
    try {
      await _heroRepository.equipSkin(event.skinId);
    } catch (e) {
      emit(HeroError('Failed to equip skin: $e'));
    }
  }

  Future<void> _onEquipTitle(EquipTitle event, Emitter<HeroState> emit) async {
    try {
      await _heroRepository.equipTitle(event.title);
    } catch (e) {
      emit(HeroError('Failed to equip title: $e'));
    }
  }

  Future<void> _onAwardExpAndCoins(
    AwardExpAndCoins event,
    Emitter<HeroState> emit,
  ) async {
    try {
      await _heroRepository.awardExp(event.exp);
      await _heroRepository.gainCoins(event.coins);
    } catch (e) {
      emit(HeroError('Failed to award rewards: $e'));
    }
  }

  Future<void> _onApplyDamage(
    ApplyDamage event,
    Emitter<HeroState> emit,
  ) async {
    try {
      await _heroRepository.takeDamage(event.damage);
    } catch (e) {
      emit(HeroError('Failed to apply damage: $e'));
    }
  }

  Future<void> _onSpendMp(SpendMp event, Emitter<HeroState> emit) async {
    try {
      await _heroRepository.spendMp(event.mpAmount);
    } catch (e) {
      emit(HeroError('Failed to spend MP: $e'));
    }
  }

  @override
  Future<void> close() {
    _heroSubscription?.cancel();
    return super.close();
  }
}
