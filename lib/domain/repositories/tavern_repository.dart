import 'dart:math';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';

abstract class TavernRepository {
  Stream<List<TavernItem>> watchCatalog();
  Stream<List<TavernItem>> watchCustomRewards();
  Stream<List<TavernItem>> watchInventory();
  Future<List<TavernItem>> getCatalog();
  Future<List<TavernItem>> getCustomRewards();
  Future<List<TavernItem>> getInventory();
  Future<TavernItem?> getItem(String id);
  Future<bool> purchaseItem(String id);
  Future<TavernItem> createCustomReward({
    required String name,
    required int cost,
    String description = '',
    String iconAsset = 'coffee',
    String? id,
  });
  Future<bool> redeemCustomReward(String id);
  Future<void> deleteCustomReward(String id);
  Future<bool> useConsumable(String id);
}

class TavernRepositoryImpl implements TavernRepository {
  TavernRepositoryImpl(this._db);

  final AppDatabase _db;
  static const String defaultHeroId = 'hero_player';

  @override
  Stream<List<TavernItem>> watchCatalog() {
    return (_db.select(
      _db.tavernItems,
    )..where((tbl) => tbl.category.isNotValue('custom_reward'))).watch();
  }

  @override
  Stream<List<TavernItem>> watchCustomRewards() {
    return (_db.select(
      _db.tavernItems,
    )..where((tbl) => tbl.category.equals('custom_reward'))).watch();
  }

  @override
  Stream<List<TavernItem>> watchInventory() {
    return (_db.select(_db.tavernItems)..where(
          (tbl) =>
              tbl.quantity.isBiggerThanValue(0) | tbl.isPurchased.equals(true),
        ))
        .watch();
  }

  @override
  Future<List<TavernItem>> getCatalog() async {
    return (_db.select(
      _db.tavernItems,
    )..where((tbl) => tbl.category.isNotValue('custom_reward'))).get();
  }

  @override
  Future<List<TavernItem>> getCustomRewards() async {
    return (_db.select(
      _db.tavernItems,
    )..where((tbl) => tbl.category.equals('custom_reward'))).get();
  }

  @override
  Future<List<TavernItem>> getInventory() async {
    return (_db.select(_db.tavernItems)..where(
          (tbl) =>
              tbl.quantity.isBiggerThanValue(0) | tbl.isPurchased.equals(true),
        ))
        .get();
  }

  @override
  Future<TavernItem?> getItem(String id) async {
    return (_db.select(
      _db.tavernItems,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<bool> purchaseItem(String id) async {
    final item = await getItem(id);
    if (item == null) return false;

    final hero = await (_db.select(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).getSingleOrNull();
    if (hero == null) return false;

    if (hero.coins < item.cost) return false;

    // Deduct coins from Hero
    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(coins: Value(hero.coins - item.cost)));

    // Update Tavern Item
    if (item.category == 'consumable') {
      await (_db.update(_db.tavernItems)..where((tbl) => tbl.id.equals(id)))
          .write(TavernItemsCompanion(quantity: Value(item.quantity + 1)));
    } else {
      await (_db.update(
        _db.tavernItems,
      )..where((tbl) => tbl.id.equals(id))).write(
        const TavernItemsCompanion(
          isPurchased: Value(true),
          quantity: Value(1),
        ),
      );
    }

    return true;
  }

  @override
  Future<TavernItem> createCustomReward({
    required String name,
    required int cost,
    String description = '',
    String iconAsset = 'coffee',
    String? id,
  }) async {
    final rewardId = id ?? const Uuid().v4();
    final companion = TavernItemsCompanion.insert(
      id: rewardId,
      name: name,
      description: Value(description),
      category: 'custom_reward',
      cost: cost,
      effectType: const Value('custom'),
      effectValue: const Value(0),
      iconAsset: iconAsset,
      isPurchased: const Value(false),
      quantity: const Value(0),
    );

    await _db.into(_db.tavernItems).insert(companion);
    return (await getItem(rewardId))!;
  }

  @override
  Future<bool> redeemCustomReward(String id) async {
    final item = await getItem(id);
    if (item == null || item.category != 'custom_reward') return false;

    final hero = await (_db.select(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).getSingleOrNull();
    if (hero == null || hero.coins < item.cost) return false;

    // Deduct coins from Hero
    await (_db.update(_db.heroes)..where((tbl) => tbl.id.equals(defaultHeroId)))
        .write(HeroesCompanion(coins: Value(hero.coins - item.cost)));

    // Increment redemption counter (stored in quantity)
    await (_db.update(_db.tavernItems)..where((tbl) => tbl.id.equals(id)))
        .write(TavernItemsCompanion(quantity: Value(item.quantity + 1)));

    return true;
  }

  @override
  Future<void> deleteCustomReward(String id) async {
    await (_db.delete(_db.tavernItems)..where(
          (tbl) => tbl.id.equals(id) & tbl.category.equals('custom_reward'),
        ))
        .go();
  }

  @override
  Future<bool> useConsumable(String id) async {
    final item = await getItem(id);
    if (item == null || item.quantity <= 0) return false;

    final hero = await (_db.select(
      _db.heroes,
    )..where((tbl) => tbl.id.equals(defaultHeroId))).getSingleOrNull();
    if (hero == null) return false;

    // Decrement item quantity
    await (_db.update(_db.tavernItems)..where((tbl) => tbl.id.equals(id)))
        .write(TavernItemsCompanion(quantity: Value(item.quantity - 1)));

    // Apply consumable effect
    if (item.id == 'item_potion_health' || item.effectType == 'heal_hp') {
      final newHp = min(hero.maxHp, hero.hp + item.effectValue);
      await (_db.update(_db.heroes)
            ..where((tbl) => tbl.id.equals(defaultHeroId)))
          .write(HeroesCompanion(hp: Value(newHp)));
    } else if (item.id == 'item_exp_tonic' || item.effectType == 'exp_boost') {
      if (!hero.isGhost) {
        int newLevel = hero.level;
        int newExp = hero.currentExp + item.effectValue;
        int newUnspent = hero.unspentStatPoints;
        int newHp = hero.hp;
        int newMp = hero.mp;

        while (newExp >= HeroModel.expTargetForLevel(newLevel)) {
          newExp -= HeroModel.expTargetForLevel(newLevel);
          newLevel += 1;
          newUnspent += 3;
          newHp = hero.maxHp;
          newMp = hero.maxMp;
        }

        await (_db.update(
          _db.heroes,
        )..where((tbl) => tbl.id.equals(defaultHeroId))).write(
          HeroesCompanion(
            level: Value(newLevel),
            currentExp: Value(newExp),
            unspentStatPoints: Value(newUnspent),
            hp: Value(newHp),
            mp: Value(newMp),
          ),
        );
      }
    } else if (item.id == 'item_elixir_life' ||
        item.effectType == 'revive_full') {
      await (_db.update(
        _db.heroes,
      )..where((tbl) => tbl.id.equals(defaultHeroId))).write(
        HeroesCompanion(isGhost: const Value(false), hp: Value(hero.maxHp)),
      );
    }

    return true;
  }
}
