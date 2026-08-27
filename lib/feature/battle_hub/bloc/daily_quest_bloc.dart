import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'daily_quest_event.dart';
import 'daily_quest_state.dart';

export 'daily_quest_event.dart';
export 'daily_quest_state.dart';

class DailyQuestBloc extends Bloc<DailyQuestEvent, DailyQuestState> {
  DailyQuestBloc({
    required DailyQuestRepository dailyQuestRepository,
    required HeroRepository heroRepository,
    required CombatLogRepository combatLogRepository,
  }) : _dailyQuestRepository = dailyQuestRepository,
       _heroRepository = heroRepository,
       _combatLogRepository = combatLogRepository,
       super(const DailyQuestInitial()) {
    on<LoadDailyQuests>(_onLoadDailyQuests);
    on<DailyQuestsUpdated>(_onDailyQuestsUpdated);
    on<ToggleDailyQuest>(_onToggleDailyQuest);
    on<CreateDailyQuest>(_onCreateDailyQuest);
    on<DeleteDailyQuest>(_onDeleteDailyQuest);
    on<ProcessMidnightReset>(_onProcessMidnightReset);
  }

  final DailyQuestRepository _dailyQuestRepository;
  final HeroRepository _heroRepository;
  final CombatLogRepository _combatLogRepository;

  StreamSubscription<List<DailyQuest>>? _dailiesSubscription;
  List<DailyQuest> _cachedDailies = [];

  Future<void> _onLoadDailyQuests(
    LoadDailyQuests event,
    Emitter<DailyQuestState> emit,
  ) async {
    emit(const DailyQuestLoading());
    await _dailiesSubscription?.cancel();
    _dailiesSubscription = _dailyQuestRepository.watchDailyQuests().listen((
      dailies,
    ) {
      add(DailyQuestsUpdated(dailies));
    });
  }

  void _onDailyQuestsUpdated(
    DailyQuestsUpdated event,
    Emitter<DailyQuestState> emit,
  ) {
    _cachedDailies = event.dailies;
    emit(DailyQuestLoaded(dailies: _cachedDailies));
  }

  Future<void> _onToggleDailyQuest(
    ToggleDailyQuest event,
    Emitter<DailyQuestState> emit,
  ) async {
    try {
      final hero = await _heroRepository.watchHero().first;
      final updatedDaily = await _dailyQuestRepository.toggleDailyQuest(
        event.id,
      );
      final isNowCompleted = updatedDaily?.isCompleted ?? false;
      final target = _cachedDailies.where((d) => d.id == event.id).firstOrNull;

      if (isNowCompleted) {
        if (hero?.isGhost != true) {
          // Award +30 EXP, +15 Coins for completing daily
          await _heroRepository.awardExp(30);
          await _heroRepository.gainCoins(15);
        }
        await _combatLogRepository.addLog(
          damage: 0,
          text:
              'Daily Quest "${target?.title ?? 'Daily'}" completed! +30 EXP, +15 Coins.',
        );

        // Check if all dailies completed today for all-done bonus chest (+25 coins)
        final allDone = _cachedDailies.every(
          (d) => d.id == event.id ? true : d.isCompleted,
        );
        if (allDone && _cachedDailies.isNotEmpty && hero?.isGhost != true) {
          await _heroRepository.awardExp(50);
          await _heroRepository.gainCoins(25);
          await _combatLogRepository.addLog(
            damage: 0,
            text:
                'All Daily Quests Completed! Chest Bonus: +50 EXP, +25 Coins.',
          );
        }

        SensoryService.instance.playVictory();
      } else {
        SensoryService.instance.playClick();
      }
    } catch (e) {
      emit(DailyQuestError('Failed to toggle daily quest: $e'));
    }
  }

  Future<void> _onCreateDailyQuest(
    CreateDailyQuest event,
    Emitter<DailyQuestState> emit,
  ) async {
    try {
      await _dailyQuestRepository.createDailyQuest(
        title: event.title,
        description: event.description,
        streak: event.streak,
        id: event.id,
      );
      SensoryService.instance.playClick();
    } catch (e) {
      emit(DailyQuestError('Failed to create daily quest: $e'));
    }
  }

  Future<void> _onDeleteDailyQuest(
    DeleteDailyQuest event,
    Emitter<DailyQuestState> emit,
  ) async {
    try {
      await _dailyQuestRepository.deleteDailyQuest(event.id);
      SensoryService.instance.playClick();
    } catch (e) {
      emit(DailyQuestError('Failed to delete daily quest: $e'));
    }
  }

  Future<void> _onProcessMidnightReset(
    ProcessMidnightReset event,
    Emitter<DailyQuestState> emit,
  ) async {
    try {
      final missedCount = await _dailyQuestRepository.processMidnightReset();
      if (missedCount > 0) {
        final penaltyDamage = missedCount * 15;
        await _heroRepository.takeDamage(penaltyDamage);
        await _combatLogRepository.addLog(
          damage: penaltyDamage,
          text:
              'Midnight penalty! Missed $missedCount Daily Quests: Hero took $penaltyDamage HP damage.',
        );
        SensoryService.instance.playHurt();
      }
    } catch (e) {
      emit(DailyQuestError('Failed to process midnight reset: $e'));
    }
  }

  @override
  Future<void> close() {
    _dailiesSubscription?.cancel();
    return super.close();
  }
}
