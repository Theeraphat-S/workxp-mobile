import 'dart:math';
import 'package:drift/drift.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';

abstract class HeroRepository {
  Stream<Hero?> watchHero();
  Future<Hero?> getHero();
  Future<void> updateHero(HeroesCompanion hero);
  Future<void> awardExp(int exp);
  Future<void> takeDamage(int amount);
  Future<void> heal(int amount);
  Future<bool> allocateAttributes({
    int str = 0,
    int agi = 0,
    int intAttr = 0,
    int vit = 0,
  });
  Future<void> setGhostState(bool isGhost);
  Future<void> gainCoins(int amount);
  Future<bool> spendCoins(int amount);
  Future<void> equipSkin(String skinId);
  Future<void> equipTitle(String title);
  Future<void> restoreMp(int amount);
  Future<bool> spendMp(int amount);
}

class HeroRepositoryImpl implements HeroRepository {
  HeroRepositoryImpl(this._db);

  final AppDatabase _db;

  static const String defaultHeroId = 'hero_player';

  @override
  Stream<Hero?> watchHero() {
    return (_db.select(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).watchSingleOrNull();
  }

  @override
  Future<Hero?> getHero() async {
    return (_db.select(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).getSingleOrNull();
  }

  @override
  Future<void> updateHero(HeroesCompanion hero) async {
    await (_db.update(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).write(hero);
  }

  @override
  Future<void> awardExp(int exp) async {
    if (exp <= 0) return;
    final hero = await getHero();
    if (hero == null) return;

    // Ghost State strictly prevents EXP gain
    if (hero.isGhost) return;

    int newLevel = hero.level;
    int newExp = hero.currentExp + exp;
    int newUnspentPoints = hero.unspentStatPoints;
    int newHp = hero.hp;
    int newMaxHp = hero.maxHp;
    int newMp = hero.mp;
    int newMaxMp = hero.maxMp;
    String newTitle = hero.activeTitle;

    while (newExp >= HeroModel.expTargetForLevel(newLevel)) {
      newExp -= HeroModel.expTargetForLevel(newLevel);
      newLevel += 1;
      newUnspentPoints += 3;
      newHp = newMaxHp;
      newMp = newMaxMp;
    }

    if (newLevel >= 10 && newTitle == 'Novice Adventurer') {
      newTitle = 'Legendary Champion';
    } else if (newLevel >= 5 && newTitle == 'Novice Adventurer') {
      newTitle = 'Seasoned Veteran';
    }

    await (_db.update(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).write(
      HeroesCompanion(
        level: Value(newLevel),
        currentExp: Value(newExp),
        unspentStatPoints: Value(newUnspentPoints),
        hp: Value(newHp),
        mp: Value(newMp),
        activeTitle: Value(newTitle),
      ),
    );
  }

  @override
  Future<void> takeDamage(int amount) async {
    if (amount <= 0) return;
    final hero = await getHero();
    if (hero == null) return;

    final newHp = max(0, hero.hp - amount);
    final isGhost = newHp == 0 ? true : hero.isGhost;

    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(hp: Value(newHp), isGhost: Value(isGhost)));
  }

  @override
  Future<void> heal(int amount) async {
    if (amount <= 0) return;
    final hero = await getHero();
    if (hero == null) return;

    final newHp = min(hero.maxHp, hero.hp + amount);
    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(hp: Value(newHp)));
  }

  @override
  Future<bool> allocateAttributes({
    int str = 0,
    int agi = 0,
    int intAttr = 0,
    int vit = 0,
  }) async {
    final total = str + agi + intAttr + vit;
    if (total <= 0) return false;

    final hero = await getHero();
    if (hero == null) return false;

    if (hero.unspentStatPoints < total) {
      return false;
    }

    await (_db.update(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).write(
      HeroesCompanion(
        str: Value(hero.str + str),
        agi: Value(hero.agi + agi),
        intAttr: Value(hero.intAttr + intAttr),
        vit: Value(hero.vit + vit),
        unspentStatPoints: Value(hero.unspentStatPoints - total),
      ),
    );
    return true;
  }

  @override
  Future<void> setGhostState(bool isGhost) async {
    final hero = await getHero();
    if (hero == null) return;

    int newHp = hero.hp;
    if (!isGhost && hero.isGhost) {
      // Revive from ghost state: restore to 50% HP if HP is 0
      if (newHp <= 0) {
        newHp = max(1, hero.maxHp ~/ 2);
      }
    }

    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(isGhost: Value(isGhost), hp: Value(newHp)));
  }

  @override
  Future<void> gainCoins(int amount) async {
    if (amount <= 0) return;
    final hero = await getHero();
    if (hero == null || hero.isGhost) return; // Ghost State blocks coin gain

    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(coins: Value(hero.coins + amount)));
  }

  @override
  Future<bool> spendCoins(int amount) async {
    if (amount <= 0) return true;
    final hero = await getHero();
    if (hero == null || hero.coins < amount) return false;

    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(coins: Value(hero.coins - amount)));
    return true;
  }

  @override
  Future<void> equipSkin(String skinId) async {
    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(avatarSkinId: Value(skinId)));
  }

  @override
  Future<void> equipTitle(String title) async {
    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(activeTitle: Value(title)));
  }

  @override
  Future<void> restoreMp(int amount) async {
    if (amount <= 0) return;
    final hero = await getHero();
    if (hero == null) return;

    final newMp = min(hero.maxMp, hero.mp + amount);
    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(mp: Value(newMp)));
  }

  @override
  Future<bool> spendMp(int amount) async {
    if (amount <= 0) return true;
    final hero = await getHero();
    if (hero == null || hero.mp < amount) return false;

    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(mp: Value(hero.mp - amount)));
    return true;
  }
}
