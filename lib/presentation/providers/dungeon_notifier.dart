import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/core/services/sensory_service.dart';

class DungeonState {
  const DungeonState({
    required this.activeBoss,
    this.currentChapter = 1,
    this.unlockedChapters = const [1],
    this.defeatedBosses = const [],
    this.lastDamageDealt = 0,
    this.isVictory = false,
  });

  final BossModel activeBoss;
  final int currentChapter;
  final List<int> unlockedChapters;
  final List<BossModel> defeatedBosses;
  final int lastDamageDealt;
  final bool isVictory;

  DungeonState copyWith({
    BossModel? activeBoss,
    int? currentChapter,
    List<int>? unlockedChapters,
    List<BossModel>? defeatedBosses,
    int? lastDamageDealt,
    bool? isVictory,
  }) {
    return DungeonState(
      activeBoss: activeBoss ?? this.activeBoss,
      currentChapter: currentChapter ?? this.currentChapter,
      unlockedChapters: unlockedChapters ?? this.unlockedChapters,
      defeatedBosses: defeatedBosses ?? this.defeatedBosses,
      lastDamageDealt: lastDamageDealt ?? this.lastDamageDealt,
      isVictory: isVictory ?? this.isVictory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeBoss': activeBoss.toJson(),
      'currentChapter': currentChapter,
      'unlockedChapters': unlockedChapters,
      'defeatedBosses': defeatedBosses.map((b) => b.toJson()).toList(),
      'lastDamageDealt': lastDamageDealt,
      'isVictory': isVictory,
    };
  }

  factory DungeonState.fromJson(Map<String, dynamic> json) {
    return DungeonState(
      activeBoss: json['activeBoss'] != null
          ? BossModel.fromJson(json['activeBoss'] as Map<String, dynamic>)
          : BossModel.chapterBoss(1),
      currentChapter: (json['currentChapter'] as num?)?.toInt() ?? 1,
      unlockedChapters:
          (json['unlockedChapters'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [1],
      defeatedBosses:
          (json['defeatedBosses'] as List<dynamic>?)
              ?.map((e) => BossModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastDamageDealt: (json['lastDamageDealt'] as num?)?.toInt() ?? 0,
      isVictory: json['isVictory'] as bool? ?? false,
    );
  }
}

class DungeonNotifier extends StateNotifier<DungeonState> {
  DungeonNotifier([DungeonState? initial])
    : super(initial ?? DungeonState(activeBoss: BossModel.chapterBoss(1)));

  void setDungeonState(DungeonState dungeonState) {
    state = dungeonState;
  }

  /// Deals damage to the active boss
  void applyDamage(int damage) {
    if (damage <= 0 || state.activeBoss.isDefeated) return;

    final newHp = (state.activeBoss.currentHp - damage).clamp(
      0,
      state.activeBoss.maxHp,
    );
    final isDead = newHp == 0;

    if (damage >= 200) {
      SensoryService.instance.playCriticalAttack();
    } else {
      SensoryService.instance.playAttack();
    }

    if (isDead) {
      SensoryService.instance.playVictory();
      final defeated = state.activeBoss.copyWith(
        currentHp: 0,
        isDefeated: true,
      );

      final nextChapter = state.currentChapter + 1;
      final newUnlocked = List<int>.from(state.unlockedChapters);
      if (nextChapter <= 4 && !newUnlocked.contains(nextChapter)) {
        newUnlocked.add(nextChapter);
      }

      final defeatedList = List<BossModel>.from(state.defeatedBosses)
        ..add(defeated);

      state = state.copyWith(
        activeBoss: defeated,
        unlockedChapters: newUnlocked,
        defeatedBosses: defeatedList,
        lastDamageDealt: damage,
        isVictory: true,
      );
    } else {
      state = state.copyWith(
        activeBoss: state.activeBoss.copyWith(currentHp: newHp),
        lastDamageDealt: damage,
        isVictory: false,
      );
    }
  }

  /// Advances to the next unlocked Chapter or selected Chapter
  void selectChapter(int chapter) {
    if (!state.unlockedChapters.contains(chapter)) return;

    state = state.copyWith(
      currentChapter: chapter,
      activeBoss: BossModel.chapterBoss(chapter),
      isVictory: false,
      lastDamageDealt: 0,
    );
    SensoryService.instance.playClick();
  }

  void dismissVictoryDialog() {
    state = state.copyWith(isVictory: false);
  }
}

final dungeonProvider = StateNotifierProvider<DungeonNotifier, DungeonState>((
  ref,
) {
  return DungeonNotifier();
});
