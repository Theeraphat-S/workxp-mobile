import 'package:uuid/uuid.dart';

/// Domain model for recurring Daily Quests
class DailyQuestModel {
  DailyQuestModel({
    String? id,
    required this.title,
    this.description = '',
    this.streak = 0,
    this.isCompletedToday = false,
    this.lastCompletedDate,
    this.attributeTag = 'VIT',
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String description;
  final int streak;
  final bool isCompletedToday;
  final DateTime? lastCompletedDate;
  final String attributeTag;

  DailyQuestModel copyWith({
    String? id,
    String? title,
    String? description,
    int? streak,
    bool? isCompletedToday,
    DateTime? lastCompletedDate,
    String? attributeTag,
  }) {
    return DailyQuestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      streak: streak ?? this.streak,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      attributeTag: attributeTag ?? this.attributeTag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'streak': streak,
      'isCompletedToday': isCompletedToday,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'attributeTag': attributeTag,
    };
  }

  factory DailyQuestModel.fromJson(Map<String, dynamic> json) {
    return DailyQuestModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Daily Routine',
      description: json['description'] as String? ?? '',
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      isCompletedToday: json['isCompletedToday'] as bool? ?? false,
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.tryParse(json['lastCompletedDate'] as String)
          : null,
      attributeTag: json['attributeTag'] as String? ?? 'VIT',
    );
  }
}
