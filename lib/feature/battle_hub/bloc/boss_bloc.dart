import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'boss_event.dart';
import 'boss_state.dart';

export 'boss_event.dart';
export 'boss_state.dart';

class BossBloc extends Bloc<BossEvent, BossState> {
  BossBloc(this._bossRepository) : super(const BossInitial()) {
    on<LoadBoss>(_onLoadBoss);
    on<BossUpdated>(_onBossUpdated);
    on<DamageBoss>(_onDamageBoss);
    on<AdvanceChapterBoss>(_onAdvanceChapterBoss);
    on<ResetCurrentBoss>(_onResetCurrentBoss);
  }

  final BossRepository _bossRepository;
  StreamSubscription<Boss?>? _activeBossSub;
  StreamSubscription<List<Boss>>? _allBossesSub;

  Boss? _cachedActiveBoss;
  List<Boss> _cachedAllBosses = [];

  Future<void> _onLoadBoss(LoadBoss event, Emitter<BossState> emit) async {
    emit(const BossLoading());
    await _activeBossSub?.cancel();
    await _allBossesSub?.cancel();

    _activeBossSub = _bossRepository.watchActiveBoss().listen((boss) {
      _cachedActiveBoss = boss;
      add(BossUpdated(
        activeBoss: _cachedActiveBoss,
        allBosses: _cachedAllBosses,
      ));
    });

    _allBossesSub = _bossRepository.watchAllBosses().listen((all) {
      _cachedAllBosses = all;
      add(BossUpdated(
        activeBoss: _cachedActiveBoss,
        allBosses: _cachedAllBosses,
      ));
    });
  }

  void _onBossUpdated(BossUpdated event, Emitter<BossState> emit) {
    emit(BossLoaded(
      activeBoss: event.activeBoss,
      allBosses: event.allBosses,
    ));
  }

  Future<void> _onDamageBoss(
    DamageBoss event,
    Emitter<BossState> emit,
  ) async {
    try {
      await _bossRepository.applyDamage(event.damage);
    } catch (e) {
      emit(BossError('Failed to damage boss: $e'));
    }
  }

  Future<void> _onAdvanceChapterBoss(
    AdvanceChapterBoss event,
    Emitter<BossState> emit,
  ) async {
    try {
      await _bossRepository.advanceToNextBoss();
    } catch (e) {
      emit(BossError('Failed to advance boss: $e'));
    }
  }

  Future<void> _onResetCurrentBoss(
    ResetCurrentBoss event,
    Emitter<BossState> emit,
  ) async {
    try {
      await _bossRepository.resetBoss(event.bossId);
    } catch (e) {
      emit(BossError('Failed to reset boss: $e'));
    }
  }

  @override
  Future<void> close() {
    _activeBossSub?.cancel();
    _allBossesSub?.cancel();
    return super.close();
  }
}
