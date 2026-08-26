/// Domain model for Dungeon Boss and Chapters
class BossModel {
  const BossModel({
    required this.id,
    required this.name,
    required this.chapter,
    required this.chapterName,
    required this.spriteType,
    required this.maxHp,
    required this.currentHp,
    required this.coinReward,
    required this.expReward,
    this.isDefeated = false,
  });

  final String id;
  final String name;
  final int chapter;
  final String chapterName;
  final String spriteType;
  final int maxHp;
  final int currentHp;
  final int coinReward;
  final int expReward;
  final bool isDefeated;

  BossModel copyWith({
    String? id,
    String? name,
    int? chapter,
    String? chapterName,
    String? spriteType,
    int? maxHp,
    int? currentHp,
    int? coinReward,
    int? expReward,
    bool? isDefeated,
  }) {
    return BossModel(
      id: id ?? this.id,
      name: name ?? this.name,
      chapter: chapter ?? this.chapter,
      chapterName: chapterName ?? this.chapterName,
      spriteType: spriteType ?? this.spriteType,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      coinReward: coinReward ?? this.coinReward,
      expReward: expReward ?? this.expReward,
      isDefeated: isDefeated ?? this.isDefeated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chapter': chapter,
      'chapterName': chapterName,
      'spriteType': spriteType,
      'maxHp': maxHp,
      'currentHp': currentHp,
      'coinReward': coinReward,
      'expReward': expReward,
      'isDefeated': isDefeated,
    };
  }

  factory BossModel.fromJson(Map<String, dynamic> json) {
    return BossModel(
      id: json['id'] as String? ?? 'boss_slime',
      name: json['name'] as String? ?? 'King Slime',
      chapter: (json['chapter'] as num?)?.toInt() ?? 1,
      chapterName: json['chapterName'] as String? ?? 'Slime Forest',
      spriteType: json['spriteType'] as String? ?? 'boss_slime',
      maxHp: (json['maxHp'] as num?)?.toInt() ?? 200,
      currentHp: (json['currentHp'] as num?)?.toInt() ?? 200,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 100,
      expReward: (json['expReward'] as num?)?.toInt() ?? 150,
      isDefeated: json['isDefeated'] as bool? ?? false,
    );
  }

  static BossModel chapterBoss(int chapter) {
    switch (chapter) {
      case 2:
        return const BossModel(
          id: 'boss_goblin',
          name: 'Goblin Shaman',
          chapter: 2,
          chapterName: 'Goblin Keep',
          spriteType: 'boss_goblin',
          maxHp: 500,
          currentHp: 500,
          coinReward: 250,
          expReward: 350,
        );
      case 3:
        return const BossModel(
          id: 'boss_necromancer',
          name: 'Dread Necromancer',
          chapter: 3,
          chapterName: 'Shadow Crypt',
          spriteType: 'boss_necromancer',
          maxHp: 1000,
          currentHp: 1000,
          coinReward: 500,
          expReward: 700,
        );
      case 4:
        return const BossModel(
          id: 'boss_dragon',
          name: 'Red Dragon',
          chapter: 4,
          chapterName: 'Volcano Peak',
          spriteType: 'boss_dragon',
          maxHp: 2500,
          currentHp: 2500,
          coinReward: 1200,
          expReward: 1500,
        );
      case 1:
      default:
        return const BossModel(
          id: 'boss_slime',
          name: 'King Slime',
          chapter: 1,
          chapterName: 'Slime Forest',
          spriteType: 'boss_slime',
          maxHp: 200,
          currentHp: 200,
          coinReward: 100,
          expReward: 150,
        );
    }
  }
}
