import 'dart:math';

/// Domain Model for Hero entity
class HeroModel {
  const HeroModel({
    this.name = 'Hero',
    this.level = 1,
    this.currentExp = 0,
    this.currentHp = 100,
    this.maxHp = 100,
    this.currentMp = 50,
    this.maxMp = 100,
    this.coins = 50,
    this.unallocatedPoints = 0,
    this.str = 5,
    this.intel = 5,
    this.agi = 5,
    this.vit = 5,
    this.wis = 5,
    this.isGhost = false,
    this.activeSkinId = 'hero_novice',
    this.activeTitleId = 'Novice Adventurer',
    this.unlockedTitles = const ['Novice Adventurer'],
    this.unlockedSkins = const ['hero_novice'],
  });

  final String name;
  final int level;
  final int currentExp;
  final int currentHp;
  final int maxHp;
  final int currentMp;
  final int maxMp;
  final int coins;
  final int unallocatedPoints;
  final int str;
  final int intel;
  final int agi;
  final int vit;
  final int wis;
  final bool isGhost;
  final String activeSkinId;
  final String activeTitleId;
  final List<String> unlockedTitles;
  final List<String> unlockedSkins;

  /// Target EXP to reach next level: floor(100 * 1.25^(level - 1))
  static int expTargetForLevel(int lvl) {
    if (lvl <= 1) return 100;
    return (100 * pow(1.25, lvl - 1)).floor();
  }

  int get nextLevelExp => expTargetForLevel(level);

  /// Damage scaling bonus derived from Hero STR and AGI attributes
  int get combatDamageBonus => (str * 2) + (agi * 1);

  HeroModel copyWith({
    String? name,
    int? level,
    int? currentExp,
    int? currentHp,
    int? maxHp,
    int? currentMp,
    int? maxMp,
    int? coins,
    int? unallocatedPoints,
    int? str,
    int? intel,
    int? agi,
    int? vit,
    int? wis,
    bool? isGhost,
    String? activeSkinId,
    String? activeTitleId,
    List<String>? unlockedTitles,
    List<String>? unlockedSkins,
  }) {
    return HeroModel(
      name: name ?? this.name,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      currentMp: currentMp ?? this.currentMp,
      maxMp: maxMp ?? this.maxMp,
      coins: coins ?? this.coins,
      unallocatedPoints: unallocatedPoints ?? this.unallocatedPoints,
      str: str ?? this.str,
      intel: intel ?? this.intel,
      agi: agi ?? this.agi,
      vit: vit ?? this.vit,
      wis: wis ?? this.wis,
      isGhost: isGhost ?? this.isGhost,
      activeSkinId: activeSkinId ?? this.activeSkinId,
      activeTitleId: activeTitleId ?? this.activeTitleId,
      unlockedTitles: unlockedTitles ?? this.unlockedTitles,
      unlockedSkins: unlockedSkins ?? this.unlockedSkins,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'currentExp': currentExp,
      'currentHp': currentHp,
      'maxHp': maxHp,
      'currentMp': currentMp,
      'maxMp': maxMp,
      'coins': coins,
      'unallocatedPoints': unallocatedPoints,
      'str': str,
      'intel': intel,
      'agi': agi,
      'vit': vit,
      'wis': wis,
      'isGhost': isGhost,
      'activeSkinId': activeSkinId,
      'activeTitleId': activeTitleId,
      'unlockedTitles': unlockedTitles,
      'unlockedSkins': unlockedSkins,
    };
  }

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      name: json['name'] as String? ?? 'Hero',
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentExp: (json['currentExp'] as num?)?.toInt() ?? 0,
      currentHp: (json['currentHp'] as num?)?.toInt() ?? 100,
      maxHp: (json['maxHp'] as num?)?.toInt() ?? 100,
      currentMp: (json['currentMp'] as num?)?.toInt() ?? 50,
      maxMp: (json['maxMp'] as num?)?.toInt() ?? 100,
      coins: (json['coins'] as num?)?.toInt() ?? 50,
      unallocatedPoints: (json['unallocatedPoints'] as num?)?.toInt() ?? 0,
      str: (json['str'] as num?)?.toInt() ?? 5,
      intel: (json['intel'] as num?)?.toInt() ?? 5,
      agi: (json['agi'] as num?)?.toInt() ?? 5,
      vit: (json['vit'] as num?)?.toInt() ?? 5,
      wis: (json['wis'] as num?)?.toInt() ?? 5,
      isGhost: json['isGhost'] as bool? ?? false,
      activeSkinId: json['activeSkinId'] as String? ?? 'hero_novice',
      activeTitleId: json['activeTitleId'] as String? ?? 'Novice Adventurer',
      unlockedTitles:
          (json['unlockedTitles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Novice Adventurer'],
      unlockedSkins:
          (json['unlockedSkins'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['hero_novice'],
    );
  }
}
