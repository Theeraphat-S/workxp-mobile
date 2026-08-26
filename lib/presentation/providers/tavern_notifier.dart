import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'hero_notifier.dart';

class TavernState {
  const TavernState({
    this.catalog = const [],
    this.inventory = const [],
    this.customRewards = const [],
    this.activeStreakShields = 0,
  });

  final List<ShopItemModel> catalog;
  final List<InventoryItemModel> inventory;
  final List<CustomRewardModel> customRewards;
  final int activeStreakShields;

  TavernState copyWith({
    List<ShopItemModel>? catalog,
    List<InventoryItemModel>? inventory,
    List<CustomRewardModel>? customRewards,
    int? activeStreakShields,
  }) {
    return TavernState(
      catalog: catalog ?? this.catalog,
      inventory: inventory ?? this.inventory,
      customRewards: customRewards ?? this.customRewards,
      activeStreakShields: activeStreakShields ?? this.activeStreakShields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'catalog': catalog.map((i) => i.toJson()).toList(),
      'inventory': inventory.map((i) => i.toJson()).toList(),
      'customRewards': customRewards.map((r) => r.toJson()).toList(),
      'activeStreakShields': activeStreakShields,
    };
  }

  factory TavernState.fromJson(Map<String, dynamic> json) {
    return TavernState(
      catalog:
          (json['catalog'] as List<dynamic>?)
              ?.map((e) => ShopItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          ShopItemModel.defaultCatalog(),
      inventory:
          (json['inventory'] as List<dynamic>?)
              ?.map(
                (e) => InventoryItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      customRewards:
          (json['customRewards'] as List<dynamic>?)
              ?.map(
                (e) => CustomRewardModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      activeStreakShields: (json['activeStreakShields'] as num?)?.toInt() ?? 0,
    );
  }
}

class TavernNotifier extends StateNotifier<TavernState> {
  TavernNotifier([TavernState? initial])
    : super(
        initial ??
            TavernState(
              catalog: ShopItemModel.defaultCatalog(),
              customRewards: [
                CustomRewardModel(
                  id: 'rew_tea',
                  title: '1 Delicious Boba Tea',
                  coinCost: 50,
                  iconName: 'coffee',
                ),
                CustomRewardModel(
                  id: 'rew_gaming',
                  title: '1 Hour Video Game Session',
                  coinCost: 40,
                  iconName: 'sports_esports',
                ),
              ],
            ),
      );

  void setTavernState(TavernState tavernState) {
    state = tavernState;
  }

  /// Purchase an item from the Tavern
  bool buyItem(String shopItemId, {required HeroNotifier heroNotifier}) {
    final item = state.catalog.firstWhere(
      (i) => i.id == shopItemId,
      orElse: () => const ShopItemModel(
        id: '',
        name: '',
        description: '',
        cost: 9999,
        type: 'consumable',
        spriteType: 'potion_health',
      ),
    );

    if (item.id.isEmpty || heroNotifier.state.coins < item.cost) {
      return false;
    }

    final success = heroNotifier.spendCoins(item.cost);
    if (!success) return false;

    if (item.type == 'consumable') {
      final inv = List<InventoryItemModel>.from(state.inventory);
      final idx = inv.indexWhere((i) => i.shopItemId == item.id);
      if (idx != -1) {
        inv[idx] = inv[idx].copyWith(quantity: inv[idx].quantity + 1);
      } else {
        inv.add(
          InventoryItemModel(
            shopItemId: item.id,
            name: item.name,
            description: item.description,
            spriteType: item.spriteType,
            quantity: 1,
            effectValue: item.effectValue,
          ),
        );
      }
      state = state.copyWith(inventory: inv);
    } else if (item.type == 'skin') {
      heroNotifier.unlockSkin(item.id);
    }

    SensoryService.instance.playCoin();
    return true;
  }

  /// Consumes an item from inventory
  bool useConsumable(String shopItemId, {required HeroNotifier heroNotifier}) {
    final inv = List<InventoryItemModel>.from(state.inventory);
    final idx = inv.indexWhere((i) => i.shopItemId == shopItemId);
    if (idx == -1 || inv[idx].quantity <= 0) return false;

    final item = inv[idx];

    // Apply specific effect
    switch (shopItemId) {
      case 'item_potion_health':
        heroNotifier.healHp(item.effectValue > 0 ? item.effectValue : 50);
        SensoryService.instance.playLevelUp();
        break;
      case 'item_exp_tonic':
        heroNotifier.gainExp(item.effectValue > 0 ? item.effectValue : 100);
        SensoryService.instance.playLevelUp();
        break;
      case 'item_elixir_life':
        heroNotifier.reviveHero();
        heroNotifier.healHp(100);
        SensoryService.instance.playLevelUp();
        break;
      case 'item_streak_shield':
        state = state.copyWith(
          activeStreakShields: state.activeStreakShields + 1,
        );
        SensoryService.instance.playBuff();
        break;
    }

    if (item.quantity == 1) {
      inv.removeAt(idx);
    } else {
      inv[idx] = item.copyWith(quantity: item.quantity - 1);
    }

    state = state.copyWith(inventory: inv);
    return true;
  }

  void addCustomReward(CustomRewardModel reward) {
    state = state.copyWith(customRewards: [reward, ...state.customRewards]);
  }

  void editCustomReward(CustomRewardModel updated) {
    state = state.copyWith(
      customRewards: [
        for (final r in state.customRewards)
          if (r.id == updated.id) updated else r,
      ],
    );
  }

  void deleteCustomReward(String id) {
    state = state.copyWith(
      customRewards: state.customRewards.where((r) => r.id != id).toList(),
    );
  }

  /// Redeems a user custom reward with coins
  bool redeemCustomReward(String id, {required HeroNotifier heroNotifier}) {
    final reward = state.customRewards.firstWhere((r) => r.id == id);
    if (heroNotifier.state.coins < reward.coinCost) return false;

    final success = heroNotifier.spendCoins(reward.coinCost);
    if (!success) return false;

    final updated = [
      for (final r in state.customRewards)
        if (r.id == id) r.copyWith(timesRedeemed: r.timesRedeemed + 1) else r,
    ];

    state = state.copyWith(customRewards: updated);
    SensoryService.instance.playLevelUp();
    return true;
  }
}

final tavernProvider = StateNotifierProvider<TavernNotifier, TavernState>((
  ref,
) {
  return TavernNotifier();
});
