import 'package:uuid/uuid.dart';

/// Item in the Tavern shop catalog
class ShopItemModel {
  const ShopItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.type, // 'consumable', 'skin', 'theme'
    required this.spriteType,
    this.effectValue = 0,
  });

  final String id;
  final String name;
  final String description;
  final int cost;
  final String type;
  final String spriteType;
  final int effectValue;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cost': cost,
      'type': type,
      'spriteType': spriteType,
      'effectValue': effectValue,
    };
  }

  factory ShopItemModel.fromJson(Map<String, dynamic> json) {
    return ShopItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      cost: (json['cost'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'consumable',
      spriteType: json['spriteType'] as String? ?? 'potion_health',
      effectValue: (json['effectValue'] as num?)?.toInt() ?? 0,
    );
  }

  static List<ShopItemModel> defaultCatalog() {
    return const [
      // Consumables
      ShopItemModel(
        id: 'item_potion_health',
        name: 'Health Potion',
        description: 'Restores 50 HP immediately.',
        cost: 25,
        type: 'consumable',
        spriteType: 'potion_health',
        effectValue: 50,
      ),
      ShopItemModel(
        id: 'item_streak_shield',
        name: 'Streak Shield',
        description: 'Shields your HP and streak from 1 missed day.',
        cost: 40,
        type: 'consumable',
        spriteType: 'shield',
        effectValue: 1,
      ),
      ShopItemModel(
        id: 'item_exp_tonic',
        name: 'EXP Tonic',
        description: 'Grants an instant +100 EXP boost.',
        cost: 35,
        type: 'consumable',
        spriteType: 'potion_exp',
        effectValue: 100,
      ),
      ShopItemModel(
        id: 'item_elixir_life',
        name: 'Elixir of Life',
        description: 'Instantly resurrects Hero from Ghost State with 100% HP.',
        cost: 80,
        type: 'consumable',
        spriteType: 'elixir_life',
        effectValue: 100,
      ),

      // Cosmetics (Skins)
      ShopItemModel(
        id: 'paladin',
        name: 'Holy Paladin Skin',
        description: 'Radiant armor forged from golden sunlight.',
        cost: 150,
        type: 'skin',
        spriteType: 'paladin',
      ),
      ShopItemModel(
        id: 'dark_knight',
        name: 'Dark Knight Skin',
        description: 'Shadow-infused plate armor with violet aura.',
        cost: 200,
        type: 'skin',
        spriteType: 'dark_knight',
      ),
      ShopItemModel(
        id: 'archmage',
        name: 'Archmage Robes',
        description: 'Mystic vestments glowing with ancient wisdom.',
        cost: 250,
        type: 'skin',
        spriteType: 'archmage',
      ),
      ShopItemModel(
        id: 'cyber_samurai',
        name: 'Cyber Samurai Skin',
        description: 'Neon-infused futuristic cyber armor.',
        cost: 350,
        type: 'skin',
        spriteType: 'cyber_samurai',
      ),
    ];
  }
}

/// Inventory item holding consumable quantity
class InventoryItemModel {
  const InventoryItemModel({
    required this.shopItemId,
    required this.name,
    required this.description,
    required this.spriteType,
    this.quantity = 1,
    this.effectValue = 0,
  });

  final String shopItemId;
  final String name;
  final String description;
  final String spriteType;
  final int quantity;
  final int effectValue;

  InventoryItemModel copyWith({
    String? shopItemId,
    String? name,
    String? description,
    String? spriteType,
    int? quantity,
    int? effectValue,
  }) {
    return InventoryItemModel(
      shopItemId: shopItemId ?? this.shopItemId,
      name: name ?? this.name,
      description: description ?? this.description,
      spriteType: spriteType ?? this.spriteType,
      quantity: quantity ?? this.quantity,
      effectValue: effectValue ?? this.effectValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopItemId': shopItemId,
      'name': name,
      'description': description,
      'spriteType': spriteType,
      'quantity': quantity,
      'effectValue': effectValue,
    };
  }

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      shopItemId: json['shopItemId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      spriteType: json['spriteType'] as String? ?? 'potion_health',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      effectValue: (json['effectValue'] as num?)?.toInt() ?? 0,
    );
  }
}

/// User-created Custom Real-Life Reward
class CustomRewardModel {
  CustomRewardModel({
    String? id,
    required this.title,
    this.description = '',
    required this.coinCost,
    this.iconName = 'coffee',
    this.timesRedeemed = 0,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String description;
  final int coinCost;
  final String iconName;
  final int timesRedeemed;

  CustomRewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? coinCost,
    String? iconName,
    int? timesRedeemed,
  }) {
    return CustomRewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coinCost: coinCost ?? this.coinCost,
      iconName: iconName ?? this.iconName,
      timesRedeemed: timesRedeemed ?? this.timesRedeemed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coinCost': coinCost,
      'iconName': iconName,
      'timesRedeemed': timesRedeemed,
    };
  }

  factory CustomRewardModel.fromJson(Map<String, dynamic> json) {
    return CustomRewardModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Custom Reward',
      description: json['description'] as String? ?? '',
      coinCost: (json['coinCost'] as num?)?.toInt() ?? 50,
      iconName: json['iconName'] as String? ?? 'coffee',
      timesRedeemed: (json['timesRedeemed'] as num?)?.toInt() ?? 0,
    );
  }
}
