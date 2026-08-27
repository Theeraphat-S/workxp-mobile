import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'habit_event.dart';
import 'habit_state.dart';

export 'habit_event.dart';
export 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc({
    required HabitRepository habitRepository,
    required HeroRepository heroRepository,
    required CombatLogRepository combatLogRepository,
  })  : _habitRepository = habitRepository,
        _heroRepository = heroRepository,
        _combatLogRepository = combatLogRepository,
        super(const HabitInitial()) {
    on<LoadHabits>(_onLoadHabits);
    on<HabitsUpdated>(_onHabitsUpdated);
    on<LogHabit>(_onLogHabit);
    on<CreateHabit>(_onCreateHabit);
    on<DeleteHabit>(_onDeleteHabit);
  }

  final HabitRepository _habitRepository;
  final HeroRepository _heroRepository;
  final CombatLogRepository _combatLogRepository;

  StreamSubscription<List<Habit>>? _habitsSubscription;
  List<Habit> _cachedHabits = [];

  Future<void> _onLoadHabits(
    LoadHabits event,
    Emitter<HabitState> emit,
  ) async {
    emit(const HabitLoading());
    await _habitsSubscription?.cancel();
    _habitsSubscription = _habitRepository.watchHabits().listen((habits) {
      add(HabitsUpdated(habits));
    });
  }

  void _onHabitsUpdated(HabitsUpdated event, Emitter<HabitState> emit) {
    _cachedHabits = event.habits;
    emit(HabitLoaded(_cachedHabits));
  }

  Future<void> _onLogHabit(
    LogHabit event,
    Emitter<HabitState> emit,
  ) async {
    try {
      final hero = await _heroRepository.watchHero().first;
      await _habitRepository.logHabit(
        event.id,
        event.isPositive,
      );

      final target = _cachedHabits.where((h) => h.id == event.id).firstOrNull;
      final habitTitle = target?.title ?? 'Habit';

      if (event.isPositive) {
        if (hero?.isGhost != true) {
          // Positive habit awards +10 Coins and +15 MP
          await _heroRepository.awardExp(15);
          await _heroRepository.gainCoins(10);
        }
        await _combatLogRepository.addLog(
          damage: 0,
          text:
              'Positive habit "$habitTitle" logged! +15 EXP, +10 Coins.',
        );
        SensoryService.instance.playCoin();
      } else {
        // Negative habit penalty: 10 HP loss
        await _heroRepository.takeDamage(10);
        await _combatLogRepository.addLog(
          damage: 10,
          text:
              'Negative habit "$habitTitle" logged! Took 10 HP damage penalty.',
        );
        SensoryService.instance.playHurt();
      }
    } catch (e) {
      emit(HabitError('Failed to log habit: $e'));
    }
  }

  Future<void> _onCreateHabit(
    CreateHabit event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.createHabit(
        title: event.title,
        isPositive: event.isPositive,
        isNegative: event.isNegative,
        id: event.id,
      );
      SensoryService.instance.playClick();
    } catch (e) {
      emit(HabitError('Failed to create habit: $e'));
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabit event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.deleteHabit(event.id);
      SensoryService.instance.playClick();
    } catch (e) {
      emit(HabitError('Failed to delete habit: $e'));
    }
  }

  @override
  Future<void> close() {
    _habitsSubscription?.cancel();
    return super.close();
  }
}
