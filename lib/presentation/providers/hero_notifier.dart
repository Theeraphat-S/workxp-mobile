import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/hero_model.dart';
import '../../core/services/sensory_service.dart';

class HeroNotifier extends StateNotifier<HeroModel> {
  HeroNotifier([HeroModel? initial]) : super(initial ?? const HeroModel());

  bool get isGhost => state.isGhost;
  int get currentHp => state.currentHp;
  int get coins => state.coins;

  /// Sets entire state (for persistence reload or imports)
  void setHero(HeroModel hero) {
    state = hero;
  }

  /// Gains EXP, evaluating level up thresholds
  void gainExp(int amount) {
    if (state.isGhost || amount <= 0) return;

    int exp = state.currentExp + amount;
    int lvl = state.level;
    int points = state.unallocatedPoints;
    int hp = state.currentHp;
    int mp = state.currentMp;
    bool leveledUp = false;

    while (true) {
      final target = HeroModel.expTargetForLevel(lvl);
      if (exp >= target) {
        exp -= target;
        lvl++;
        points += 3;
        hp = state.maxHp;
        mp = state.maxMp;
        leveledUp = true;
      } else {
        break;
      }
    }

    if (leveledUp) {
      SensoryService.instance.playLevelUp();
    }

    state = state.copyWith(
      level: lvl,
      currentExp: exp,
      unallocatedPoints: points,
      currentHp: hp,
      currentMp: mp,
    );

    _evaluateTitles();
  }

  /// Inflicts damage on Hero vitals. If HP drops to 0, triggers Ghost State
  void takeDamage(int amount) {
    if (amount <= 0) return;

    final newHp = (state.currentHp - amount).clamp(0, state.maxHp);
    final isGhost = newHp == 0;

    if (isGhost) {
      SensoryService.instance.playHurt();
    }

    state = state.copyWith(currentHp: newHp, isGhost: isGhost);
  }

  /// Restores Hero HP
  void healHp(int amount) {
    if (amount <= 0) return;
    final newHp = (state.currentHp + amount).clamp(0, state.maxHp);
    state = state.copyWith(currentHp: newHp);
  }

  /// Increases Hero MP
  void gainMp(int amount) {
    if (amount <= 0) return;
    final newMp = (state.currentMp + amount).clamp(0, state.maxMp);
    state = state.copyWith(currentMp: newMp);
  }

  /// Spends Hero MP (returns true if successful)
  bool spendMp(int amount) {
    if (amount <= 0 || state.currentMp < amount) return false;
    state = state.copyWith(currentMp: state.currentMp - amount);
    SensoryService.instance.playBuff();
    return true;
  }

  /// Adds spendable Coins
  void gainCoins(int amount) {
    if (state.isGhost || amount <= 0) return;
    state = state.copyWith(coins: state.coins + amount);
    SensoryService.instance.playCoin();
  }

  /// Deducts spendable Coins
  bool spendCoins(int amount) {
    if (amount <= 0 || state.coins < amount) return false;
    state = state.copyWith(coins: state.coins - amount);
    SensoryService.instance.playCoin();
    return true;
  }

  /// Allocates 1 attribute point to STR, INT, AGI, VIT, or WIS
  bool allocateStatPoint(String attribute) {
    if (state.unallocatedPoints <= 0) return false;

    HeroModel updated;
    switch (attribute.toUpperCase()) {
      case 'STR':
        updated = state.copyWith(
          str: state.str + 1,
          unallocatedPoints: state.unallocatedPoints - 1,
        );
        break;
      case 'INT':
        updated = state.copyWith(
          intel: state.intel + 1,
          unallocatedPoints: state.unallocatedPoints - 1,
        );
        break;
      case 'AGI':
        updated = state.copyWith(
          agi: state.agi + 1,
          unallocatedPoints: state.unallocatedPoints - 1,
        );
        break;
      case 'VIT':
        updated = state.copyWith(
          vit: state.vit + 1,
          unallocatedPoints: state.unallocatedPoints - 1,
        );
        break;
      case 'WIS':
        updated = state.copyWith(
          wis: state.wis + 1,
          unallocatedPoints: state.unallocatedPoints - 1,
        );
        break;
      default:
        return false;
    }

    state = updated;
    SensoryService.instance.playClick();
    _evaluateTitles();
    return true;
  }

  /// Equips an unlocked title
  bool setActiveTitle(String titleId) {
    if (state.unlockedTitles.contains(titleId)) {
      state = state.copyWith(activeTitleId: titleId);
      SensoryService.instance.playClick();
      return true;
    }
    return false;
  }

  /// Equips an unlocked skin
  bool setActiveSkin(String skinId) {
    if (state.unlockedSkins.contains(skinId)) {
      state = state.copyWith(activeSkinId: skinId);
      SensoryService.instance.playClick();
      return true;
    }
    return false;
  }

  /// Unlocks a new skin (e.g. from Tavern purchase)
  void unlockSkin(String skinId) {
    if (!state.unlockedSkins.contains(skinId)) {
      final updated = List<String>.from(state.unlockedSkins)..add(skinId);
      state = state.copyWith(unlockedSkins: updated);
    }
  }

  /// Revives the hero from Ghost State back to 50% HP
  void reviveHero() {
    state = state.copyWith(
      isGhost: false,
      currentHp: (state.maxHp / 2).round(),
    );
    SensoryService.instance.playLevelUp();
  }

  void _evaluateTitles() {
    final titles = List<String>.from(state.unlockedTitles);

    void addTitle(String title) {
      if (!titles.contains(title)) {
        titles.add(title);
      }
    }

    if (state.level >= 5) addTitle('Seasoned Veteran');
    if (state.level >= 10) addTitle('Legendary Champion');

    if (state.str >= 10) addTitle('Iron Knight');
    if (state.str >= 20) addTitle('Titan Berserker');

    if (state.intel >= 10) addTitle('Code Wizard');
    if (state.intel >= 20) addTitle('Archmage Scholar');

    if (state.agi >= 10) addTitle('Shadow Runner');
    if (state.agi >= 20) addTitle('Swift Phantom');

    if (state.vit >= 10) addTitle('Immortal Guardian');
    if (state.vit >= 20) addTitle('Aegis Wall');

    if (state.wis >= 10) addTitle('Disciplined Monk');
    if (state.wis >= 20) addTitle('Enlightened Sage');

    if (titles.length != state.unlockedTitles.length) {
      state = state.copyWith(unlockedTitles: titles);
    }
  }
}

final heroProvider = StateNotifierProvider<HeroNotifier, HeroModel>((ref) {
  return HeroNotifier();
});
