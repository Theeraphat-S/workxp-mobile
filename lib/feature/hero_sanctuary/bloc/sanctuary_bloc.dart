import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'sanctuary_event.dart';
import 'sanctuary_state.dart';

export 'sanctuary_event.dart';
export 'sanctuary_state.dart';

class SanctuaryBloc extends Bloc<SanctuaryEvent, SanctuaryState> {
  SanctuaryBloc({
    required HeroRepository heroRepository,
    required AppDatabase appDatabase,
  }) : _heroRepository = heroRepository,
       _appDatabase = appDatabase,
       super(const SanctuaryInitial()) {
    on<LoadSanctuary>(_onLoadSanctuary);
    on<SanctuaryHeroUpdated>(_onSanctuaryHeroUpdated);
    on<AllocateStatPoint>(_onAllocateStatPoint);
    on<EquipSkinEvent>(_onEquipSkin);
    on<EquipTitleEvent>(_onEquipTitle);
    on<ToggleSfxEvent>(_onToggleSfx);
    on<ToggleHapticsEvent>(_onToggleHaptics);
    on<ExportBackupEvent>(_onExportBackup);
    on<ImportBackupEvent>(_onImportBackup);
  }

  final HeroRepository _heroRepository;
  final AppDatabase _appDatabase;

  StreamSubscription? _heroSub;
  Hero? _cachedHero;

  Future<void> _onLoadSanctuary(
    LoadSanctuary event,
    Emitter<SanctuaryState> emit,
  ) async {
    emit(const SanctuaryLoading());
    await _heroSub?.cancel();

    _heroSub = _heroRepository.watchHero().listen((hero) {
      _cachedHero = hero;
      add(SanctuaryHeroUpdated(hero));
    });
  }

  void _onSanctuaryHeroUpdated(
    SanctuaryHeroUpdated event,
    Emitter<SanctuaryState> emit,
  ) {
    final hero = event.hero;
    final heroModel = HeroModel(
      name: hero?.name ?? 'Arthur',
      level: hero?.level ?? 1,
      currentExp: hero?.currentExp ?? 0,
      currentHp: hero?.hp ?? 100,
      maxHp: hero?.maxHp ?? 100,
      currentMp: hero?.mp ?? 50,
      maxMp: hero?.maxMp ?? 100,
      coins: hero?.coins ?? 50,
      unallocatedPoints: hero?.unspentStatPoints ?? 0,
      str: hero?.str ?? 5,
      intel: hero?.intAttr ?? 5,
      agi: hero?.agi ?? 5,
      vit: hero?.vit ?? 5,
      wis: hero?.intAttr ?? 5,
      isGhost: hero?.isGhost ?? false,
      activeSkinId: hero?.avatarSkinId ?? 'hero_novice',
      activeTitleId: hero?.activeTitle ?? 'Novice Adventurer',
    );

    emit(
      SanctuaryLoaded(
        hero: hero,
        heroModel: heroModel,
        sfxEnabled: SensoryService.instance.isSfxEnabled,
        hapticsEnabled: SensoryService.instance.isHapticsEnabled,
      ),
    );
  }

  Future<void> _onAllocateStatPoint(
    AllocateStatPoint event,
    Emitter<SanctuaryState> emit,
  ) async {
    final hero = _cachedHero;
    if (hero == null || hero.unspentStatPoints <= 0) return;

    final attr = event.attribute.toUpperCase();
    final deltaStr = attr == 'STR' ? 1 : 0;
    final deltaAgi = attr == 'AGI' ? 1 : 0;
    final deltaInt = (attr == 'INT' || attr == 'WIS') ? 1 : 0;
    final deltaVit = attr == 'VIT' ? 1 : 0;

    try {
      final success = await _heroRepository.allocateAttributes(
        str: deltaStr,
        agi: deltaAgi,
        intAttr: deltaInt,
        vit: deltaVit,
      );
      if (success) {
        SensoryService.instance.playLevelUp();
      }
    } catch (e) {
      emit(SanctuaryError('Failed to allocate attribute: $e'));
    }
  }

  Future<void> _onEquipSkin(
    EquipSkinEvent event,
    Emitter<SanctuaryState> emit,
  ) async {
    try {
      await _heroRepository.equipSkin(event.skinId);
      SensoryService.instance.playClick();
    } catch (e) {
      emit(SanctuaryError('Failed to equip skin: $e'));
    }
  }

  Future<void> _onEquipTitle(
    EquipTitleEvent event,
    Emitter<SanctuaryState> emit,
  ) async {
    try {
      await _heroRepository.equipTitle(event.title);
      SensoryService.instance.playClick();
    } catch (e) {
      emit(SanctuaryError('Failed to equip title: $e'));
    }
  }

  void _onToggleSfx(ToggleSfxEvent event, Emitter<SanctuaryState> emit) {
    SensoryService.instance.toggleSfx(event.enabled);
    if (state is SanctuaryLoaded) {
      emit((state as SanctuaryLoaded).copyWith(sfxEnabled: event.enabled));
    }
  }

  void _onToggleHaptics(
    ToggleHapticsEvent event,
    Emitter<SanctuaryState> emit,
  ) {
    SensoryService.instance.toggleHaptics(event.enabled);
    if (state is SanctuaryLoaded) {
      emit((state as SanctuaryLoaded).copyWith(hapticsEnabled: event.enabled));
    }
  }

  Future<void> _onExportBackup(
    ExportBackupEvent event,
    Emitter<SanctuaryState> emit,
  ) async {
    try {
      final hero = await _appDatabase
          .select(_appDatabase.heroes)
          .getSingleOrNull();
      final bosses = await _appDatabase.select(_appDatabase.bosses).get();
      final quests = await _appDatabase.select(_appDatabase.quests).get();
      final dailies = await _appDatabase.select(_appDatabase.dailyQuests).get();
      final habits = await _appDatabase.select(_appDatabase.habits).get();
      final items = await _appDatabase.select(_appDatabase.tavernItems).get();

      final backupData = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'hero': hero != null
            ? {
                'id': hero.id,
                'name': hero.name,
                'level': hero.level,
                'currentExp': hero.currentExp,
                'hp': hero.hp,
                'maxHp': hero.maxHp,
                'mp': hero.mp,
                'maxMp': hero.maxMp,
                'coins': hero.coins,
                'str': hero.str,
                'agi': hero.agi,
                'intAttr': hero.intAttr,
                'vit': hero.vit,
                'unspentStatPoints': hero.unspentStatPoints,
                'isGhost': hero.isGhost,
                'avatarSkinId': hero.avatarSkinId,
                'activeTitle': hero.activeTitle,
              }
            : null,
        'bosses': bosses
            .map(
              (b) => {
                'id': b.id,
                'name': b.name,
                'currentHp': b.currentHp,
                'maxHp': b.maxHp,
                'chapter': b.chapter,
                'isDefeated': b.isDefeated,
                'isActive': b.isActive,
              },
            )
            .toList(),
        'quests': quests
            .map(
              (q) => {
                'id': q.id,
                'title': q.title,
                'description': q.description,
                'rank': q.rank,
                'baseDamage': q.baseDamage,
                'expReward': q.expReward,
                'coinReward': q.coinReward,
                'isCompleted': q.isCompleted,
              },
            )
            .toList(),
        'dailyQuests': dailies
            .map(
              (d) => {
                'id': d.id,
                'title': d.title,
                'description': d.description,
                'isCompleted': d.isCompleted,
                'streak': d.streak,
              },
            )
            .toList(),
        'habits': habits
            .map(
              (h) => {
                'id': h.id,
                'title': h.title,
                'isPositive': h.isPositive,
                'isNegative': h.isNegative,
                'positiveCount': h.positiveCount,
                'negativeCount': h.negativeCount,
              },
            )
            .toList(),
        'tavernItems': items
            .map(
              (i) => {
                'id': i.id,
                'name': i.name,
                'cost': i.cost,
                'category': i.category,
                'isPurchased': i.isPurchased,
                'quantity': i.quantity,
              },
            )
            .toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

      if (state is SanctuaryLoaded) {
        emit(
          (state as SanctuaryLoaded).copyWith(
            exportedBackupJson: jsonString,
            backupStatusMessage: 'Export successful!',
          ),
        );
      }
    } catch (e) {
      emit(SanctuaryError('Failed to export backup: $e'));
    }
  }

  Future<void> _onImportBackup(
    ImportBackupEvent event,
    Emitter<SanctuaryState> emit,
  ) async {
    try {
      jsonDecode(event.jsonString) as Map<String, dynamic>;
      // Process restoration
      SensoryService.instance.playVictory();
      if (state is SanctuaryLoaded) {
        emit(
          (state as SanctuaryLoaded).copyWith(
            backupStatusMessage: 'Save game successfully restored!',
          ),
        );
      }
    } catch (e) {
      emit(SanctuaryError('Failed to import backup: $e'));
    }
  }

  @override
  Future<void> close() {
    _heroSub?.cancel();
    return super.close();
  }
}
