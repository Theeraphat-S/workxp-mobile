import 'package:uuid/uuid.dart';

/// Domain model for a one-off Quest
class QuestModel {
  QuestModel({
    String? id,
    required this.title,
    this.description = '',
    this.rank = 'E',
    this.attributeTag = 'STR',
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String description;
  final String rank; // E, D, C, B, A, S
  final String attributeTag; // STR, INT, AGI, VIT, WIS
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;

  int get baseDamage => baseDamageForRank(rank);
  int get expReward => expRewardForRank(rank);
  int get coinReward => coinRewardForRank(rank);

  static int baseDamageForRank(String r) {
    switch (r.toUpperCase()) {
      case 'S':
        return 600;
      case 'A':
        return 350;
      case 'B':
        return 200;
      case 'C':
        return 100;
      case 'D':
        return 50;
      case 'E':
      default:
        return 25;
    }
  }

  static int expRewardForRank(String r) {
    switch (r.toUpperCase()) {
      case 'S':
        return 500;
      case 'A':
        return 250;
      case 'B':
        return 150;
      case 'C':
        return 80;
      case 'D':
        return 40;
      case 'E':
      default:
        return 20;
    }
  }

  static int coinRewardForRank(String r) {
    switch (r.toUpperCase()) {
      case 'S':
        return 250;
      case 'A':
        return 120;
      case 'B':
        return 75;
      case 'C':
        return 40;
      case 'D':
        return 20;
      case 'E':
      default:
        return 10;
    }
  }

  QuestModel copyWith({
    String? id,
    String? title,
    String? description,
    String? rank,
    String? attributeTag,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return QuestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rank: rank ?? this.rank,
      attributeTag: attributeTag ?? this.attributeTag,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rank': rank,
      'attributeTag': attributeTag,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Untitled Quest',
      description: json['description'] as String? ?? '',
      rank: json['rank'] as String? ?? 'E',
      attributeTag: json['attributeTag'] as String? ?? 'STR',
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}
