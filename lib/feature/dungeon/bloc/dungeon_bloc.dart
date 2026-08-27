import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'dungeon_event.dart';
import 'dungeon_state.dart';

export 'dungeon_event.dart';
export 'dungeon_state.dart';

class DungeonBloc extends Bloc<DungeonEvent, DungeonState> {
  DungeonBloc(this._bossRepository) : super(const DungeonInitial()) {
    on<LoadDungeon>(_onLoadDungeon);
    on<DungeonUpdated>(_onDungeonUpdated);
    on<SelectChapter>(_onSelectChapter);
    on<UnlockNextChapter>(_onUnlockNextChapter);
    on<ResetBossDungeon>(_onResetBossDungeon);
  }

  final BossRepository _bossRepository;
  StreamSubscription? _allBossesSub;
  StreamSubscription? _activeBossSub;

  List<Boss> _cachedBosses = [];
  Boss? _cachedActiveBoss;

  Future<void> _onLoadDungeon(
    LoadDungeon event,
    Emitter<DungeonState> emit,
  ) async {
    emit(const DungeonLoading());
    await _allBossesSub?.cancel();
    await _activeBossSub?.cancel();

    _allBossesSub = _bossRepository.watchAllBosses().listen((bosses) {
      _cachedBosses = bosses;
      add(DungeonUpdated(bosses: _cachedBosses, activeBoss: _cachedActiveBoss));
    });

    _activeBossSub = _bossRepository.watchActiveBoss().listen((boss) {
      _cachedActiveBoss = boss;
      add(DungeonUpdated(bosses: _cachedBosses, activeBoss: _cachedActiveBoss));
    });
  }

  void _onDungeonUpdated(DungeonUpdated event, Emitter<DungeonState> emit) {
    int maxUnlocked = 1;
    for (final boss in event.bosses) {
      if (boss.isDefeated) {
        if (boss.chapter + 1 > maxUnlocked) {
          maxUnlocked = boss.chapter + 1;
        }
      }
    }
    if (maxUnlocked > 4) maxUnlocked = 4;

    emit(
      DungeonLoaded(
        bosses: event.bosses,
        activeBoss: event.activeBoss,
        unlockedChapterMax: maxUnlocked,
      ),
    );
  }

  Future<void> _onSelectChapter(
    SelectChapter event,
    Emitter<DungeonState> emit,
  ) async {
    try {
      await _bossRepository.selectActiveChapter(event.chapter);
    } catch (e) {
      emit(DungeonError('Failed to select chapter: $e'));
    }
  }

  Future<void> _onUnlockNextChapter(
    UnlockNextChapter event,
    Emitter<DungeonState> emit,
  ) async {
    try {
      await _bossRepository.advanceToNextBoss();
    } catch (e) {
      emit(DungeonError('Failed to advance to next boss: $e'));
    }
  }

  Future<void> _onResetBossDungeon(
    ResetBossDungeon event,
    Emitter<DungeonState> emit,
  ) async {
    try {
      await _bossRepository.resetBoss(event.bossId);
    } catch (e) {
      emit(DungeonError('Failed to reset boss: $e'));
    }
  }

  @override
  Future<void> close() {
    _allBossesSub?.cancel();
    _activeBossSub?.cancel();
    return super.close();
  }
}
