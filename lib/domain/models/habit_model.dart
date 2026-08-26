import 'package:uuid/uuid.dart';

/// Domain model for repeatable positive and negative Habits
class HabitModel {
  HabitModel({
    String? id,
    required this.title,
    this.hasPositive = true,
    this.hasNegative = false,
    this.positiveCountToday = 0,
    this.negativeCountToday = 0,
    this.totalPositiveCount = 0,
    this.totalNegativeCount = 0,
    this.attributeTag = 'WIS',
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final bool hasPositive;
  final bool hasNegative;
  final int positiveCountToday;
  final int negativeCountToday;
  final int totalPositiveCount;
  final int totalNegativeCount;
  final String attributeTag;

  HabitModel copyWith({
    String? id,
    String? title,
    bool? hasPositive,
    bool? hasNegative,
    int? positiveCountToday,
    int? negativeCountToday,
    int? totalPositiveCount,
    int? totalNegativeCount,
    String? attributeTag,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      hasPositive: hasPositive ?? this.hasPositive,
      hasNegative: hasNegative ?? this.hasNegative,
      positiveCountToday: positiveCountToday ?? this.positiveCountToday,
      negativeCountToday: negativeCountToday ?? this.negativeCountToday,
      totalPositiveCount: totalPositiveCount ?? this.totalPositiveCount,
      totalNegativeCount: totalNegativeCount ?? this.totalNegativeCount,
      attributeTag: attributeTag ?? this.attributeTag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hasPositive': hasPositive,
      'hasNegative': hasNegative,
      'positiveCountToday': positiveCountToday,
      'negativeCountToday': negativeCountToday,
      'totalPositiveCount': totalPositiveCount,
      'totalNegativeCount': totalNegativeCount,
      'attributeTag': attributeTag,
    };
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Habit',
      hasPositive: json['hasPositive'] as bool? ?? true,
      hasNegative: json['hasNegative'] as bool? ?? false,
      positiveCountToday: (json['positiveCountToday'] as num?)?.toInt() ?? 0,
      negativeCountToday: (json['negativeCountToday'] as num?)?.toInt() ?? 0,
      totalPositiveCount: (json['totalPositiveCount'] as num?)?.toInt() ?? 0,
      totalNegativeCount: (json['totalNegativeCount'] as num?)?.toInt() ?? 0,
      attributeTag: json['attributeTag'] as String? ?? 'WIS',
    );
  }
}
