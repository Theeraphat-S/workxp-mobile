/// Domain model for MP-castable Skill Buffs
class SkillBuffModel {
  const SkillBuffModel({
    required this.id,
    required this.name,
    required this.description,
    required this.mpCost,
    required this.durationMinutes,
    this.activatedAt,
    this.expiresAt,
  });

  final String id;
  final String name;
  final String description;
  final int mpCost;
  final int durationMinutes;
  final DateTime? activatedAt;
  final DateTime? expiresAt;

  bool get isActive {
    if (expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt!);
  }

  Duration get remainingDuration {
    if (expiresAt == null) return Duration.zero;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  SkillBuffModel copyWith({
    String? id,
    String? name,
    String? description,
    int? mpCost,
    int? durationMinutes,
    DateTime? activatedAt,
    DateTime? expiresAt,
  }) {
    return SkillBuffModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      mpCost: mpCost ?? this.mpCost,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      activatedAt: activatedAt ?? this.activatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'mpCost': mpCost,
      'durationMinutes': durationMinutes,
      'activatedAt': activatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory SkillBuffModel.fromJson(Map<String, dynamic> json) {
    return SkillBuffModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mpCost: (json['mpCost'] as num?)?.toInt() ?? 25,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 60,
      activatedAt: json['activatedAt'] != null
          ? DateTime.tryParse(json['activatedAt'] as String)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
    );
  }

  static List<SkillBuffModel> defaultBuffs() {
    return [
      const SkillBuffModel(
        id: 'buff_double_exp',
        name: 'Double EXP Scroll',
        description: 'Doubles all EXP earned from Quests for 2 hours.',
        mpCost: 30,
        durationMinutes: 120,
      ),
      const SkillBuffModel(
        id: 'buff_boss_stun',
        name: 'Boss Freeze / Stun',
        description:
            'Stuns the active Boss, preventing counter-damage tonight.',
        mpCost: 40,
        durationMinutes: 720,
      ),
      const SkillBuffModel(
        id: 'buff_focus_surge',
        name: 'Focus Surge',
        description: 'Increases all Quest attack damage by +50% for 1 hour.',
        mpCost: 25,
        durationMinutes: 60,
      ),
    ];
  }
}
