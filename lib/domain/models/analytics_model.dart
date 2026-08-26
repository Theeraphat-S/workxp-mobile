/// Domain model for daily productivity logs and charts
class DailyActivityLog {
  const DailyActivityLog({
    required this.date,
    this.expEarned = 0,
    this.damageDealt = 0,
    this.habitCompletions = 0,
  });

  final DateTime date;
  final int expEarned;
  final int damageDealt;
  final int habitCompletions;

  DailyActivityLog copyWith({
    DateTime? date,
    int? expEarned,
    int? damageDealt,
    int? habitCompletions,
  }) {
    return DailyActivityLog(
      date: date ?? this.date,
      expEarned: expEarned ?? this.expEarned,
      damageDealt: damageDealt ?? this.damageDealt,
      habitCompletions: habitCompletions ?? this.habitCompletions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'expEarned': expEarned,
      'damageDealt': damageDealt,
      'habitCompletions': habitCompletions,
    };
  }

  factory DailyActivityLog.fromJson(Map<String, dynamic> json) {
    return DailyActivityLog(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      expEarned: (json['expEarned'] as num?)?.toInt() ?? 0,
      damageDealt: (json['damageDealt'] as num?)?.toInt() ?? 0,
      habitCompletions: (json['habitCompletions'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Permanent achievement trophy
class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
    );
  }

  static List<AchievementModel> defaultAchievements() {
    return const [
      AchievementModel(
        id: 'ach_first_blood',
        title: 'First Blood',
        description: 'Complete your first Quest strike against a Boss.',
      ),
      AchievementModel(
        id: 'ach_slime_slayer',
        title: 'Slime Slayer',
        description: 'Conquer Chapter 1 and defeat King Slime.',
      ),
      AchievementModel(
        id: 'ach_dragon_slayer',
        title: 'Dragon Slayer',
        description: 'Conquer Chapter 4 and defeat the Red Dragon.',
      ),
      AchievementModel(
        id: 'ach_streak_master',
        title: 'Iron Discipline',
        description: 'Maintain an unbroken Daily Quest Streak for 7 days.',
      ),
      AchievementModel(
        id: 'ach_coin_hoarder',
        title: 'Dragon Treasury',
        description: 'Accumulate over 200 spendable Coins in your purse.',
      ),
      AchievementModel(
        id: 'ach_attribute_master',
        title: 'Ascended Hero',
        description: 'Raise any single Attribute to 15 or higher.',
      ),
    ];
  }
}

/// Simulated Guild Leaderboard rank entry
class LeaderboardEntryModel {
  const LeaderboardEntryModel({
    required this.rank,
    required this.name,
    required this.title,
    required this.skinId,
    required this.weeklyDamage,
    required this.streak,
    this.isHero = false,
  });

  final int rank;
  final String name;
  final String title;
  final String skinId;
  final int weeklyDamage;
  final int streak;
  final bool isHero;
  bool get isPlayer => isHero;

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'name': name,
      'title': title,
      'skinId': skinId,
      'weeklyDamage': weeklyDamage,
      'streak': streak,
      'isHero': isHero,
      'isPlayer': isHero,
    };
  }

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: (json['rank'] as num?)?.toInt() ?? 1,
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      skinId: json['skinId'] as String? ?? 'hero_novice',
      weeklyDamage: (json['weeklyDamage'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      isHero: (json['isHero'] as bool?) ?? (json['isPlayer'] as bool?) ?? false,
    );
  }

  static List<LeaderboardEntryModel> simulatedRivals() {
    return const [
      LeaderboardEntryModel(
        rank: 1,
        name: 'Valkyrie_Rose',
        title: 'Titan Berserker',
        skinId: 'paladin',
        weeklyDamage: 3200,
        streak: 18,
      ),
      LeaderboardEntryModel(
        rank: 2,
        name: 'ShadowBlade99',
        title: 'Swift Phantom',
        skinId: 'dark_knight',
        weeklyDamage: 2450,
        streak: 12,
      ),
      LeaderboardEntryModel(
        rank: 3,
        name: 'GrandMage_Zeno',
        title: 'Archmage Scholar',
        skinId: 'archmage',
        weeklyDamage: 1800,
        streak: 9,
      ),
      LeaderboardEntryModel(
        rank: 4,
        name: 'Cyber_Shinobi',
        title: 'Shadow Runner',
        skinId: 'cyber_samurai',
        weeklyDamage: 1200,
        streak: 6,
      ),
      LeaderboardEntryModel(
        rank: 5,
        name: 'Pixel_Rookie',
        title: 'Novice Adventurer',
        skinId: 'hero_novice',
        weeklyDamage: 450,
        streak: 2,
      ),
    ];
  }
}
