import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/quest_repository.dart';
import 'quest_event.dart';
import 'quest_state.dart';

export 'quest_event.dart';
export 'quest_state.dart';

class QuestBloc extends Bloc<QuestEvent, QuestState> {
  QuestBloc({
    required QuestRepository questRepository,
    required HeroRepository heroRepository,
    required BossRepository bossRepository,
    required CombatLogRepository combatLogRepository,
  })  : _questRepository = questRepository,
        _heroRepository = heroRepository,
        _bossRepository = bossRepository,
        _combatLogRepository = combatLogRepository,
        super(const QuestInitial()) {
    on<LoadQuests>(_onLoadQuests);
    on<QuestsUpdated>(_onQuestsUpdated);
    on<CreateQuest>(_onCreateQuest);
    on<CompleteQuest>(_onCompleteQuest);
    on<DeleteQuest>(_onDeleteQuest);
    on<ClearCombatStrikeFeedback>(_onClearCombatStrikeFeedback);
  }

  final QuestRepository _questRepository;
  final HeroRepository _heroRepository;
  final BossRepository _bossRepository;
  final CombatLogRepository _combatLogRepository;

  StreamSubscription<List<Quest>>? _questsSubscription;
  List<Quest> _cachedQuests = [];

  Future<void> _onLoadQuests(LoadQuests event, Emitter<QuestState> emit) async {
    emit(const QuestLoading());
    await _questsSubscription?.cancel();
    _questsSubscription = _questRepository.watchQuests().listen((quests) {
      add(QuestsUpdated(quests));
    });
  }

  void _onQuestsUpdated(QuestsUpdated event, Emitter<QuestState> emit) {
    _cachedQuests = event.quests;
    final lastDamage =
        state is QuestLoaded ? (state as QuestLoaded).lastStrikeDamage : 0;
    emit(QuestLoaded(
      quests: _cachedQuests,
      lastStrikeDamage: lastDamage,
    ));
  }

  Future<void> _onCreateQuest(
    CreateQuest event,
    Emitter<QuestState> emit,
  ) async {
    try {
      await _questRepository.createQuest(
        title: event.title,
        description: event.description,
        rank: event.rank,
        baseDamage: event.baseDamage,
        expReward: event.expReward,
        coinReward: event.coinReward,
        id: event.id,
      );
      SensoryService.instance.playClick();
    } catch (e) {
      emit(QuestError('Failed to create quest: $e'));
    }
  }

  Future<void> _onCompleteQuest(
    CompleteQuest event,
    Emitter<QuestState> emit,
  ) async {
    try {
      final hero = await _heroRepository.watchHero().first;
      final targetQuest = _cachedQuests.where((q) => q.id == event.questId).firstOrNull;

      if (targetQuest == null) return;

      // 1. Calculate Combat Damage strike bonus: baseDamage + (str * 2 + agi * 1)
      final str = hero?.str ?? 5;
      final agi = hero?.agi ?? 5;
      final totalStrikeDamage = targetQuest.baseDamage + (str * 2) + (agi * 1);

      // 2. Damage Active Boss
      await _bossRepository.applyDamage(totalStrikeDamage);

      // 3. Mark Quest as Completed
      await _questRepository.completeQuest(event.questId);

      // 4. Award EXP and Coins to Hero if not in Ghost state
      if (hero?.isGhost != true) {
        await _heroRepository.awardExp(targetQuest.expReward);
        await _heroRepository.gainCoins(targetQuest.coinReward);
      }

      // 5. Add Combat Log
      await _combatLogRepository.addLog(
        damage: totalStrikeDamage,
        text:
            'Completed "${targetQuest.title}"! Dealt $totalStrikeDamage dmg to Boss and gained +${targetQuest.expReward} EXP, +${targetQuest.coinReward} Coins.',
      );

      // 6. Trigger Sensory Feedback
      SensoryService.instance.playSwordSlash();
      SensoryService.instance.playCoin();

      emit(QuestLoaded(
        quests: _cachedQuests,
        lastStrikeDamage: totalStrikeDamage,
      ));
    } catch (e) {
      emit(QuestError('Failed to complete quest: $e'));
    }
  }

  Future<void> _onDeleteQuest(
    DeleteQuest event,
    Emitter<QuestState> emit,
  ) async {
    try {
      await _questRepository.deleteQuest(event.questId);
      SensoryService.instance.playClick();
    } catch (e) {
      emit(QuestError('Failed to delete quest: $e'));
    }
  }

  void _onClearCombatStrikeFeedback(
    ClearCombatStrikeFeedback event,
    Emitter<QuestState> emit,
  ) {
    if (state is QuestLoaded) {
      emit(QuestLoaded(
        quests: _cachedQuests,
        lastStrikeDamage: 0,
      ));
    }
  }

  @override
  Future<void> close() {
    _questsSubscription?.cancel();
    return super.close();
  }
}
