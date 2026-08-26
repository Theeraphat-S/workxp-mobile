import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';

class DayCycleResult {
  const DayCycleResult({
    required this.dayChanged,
    required this.incompleteDailiesCount,
    required this.counterDamageDealt,
    required this.isGhostStateTriggered,
  });

  final bool dayChanged;
  final int incompleteDailiesCount;
  final int counterDamageDealt;
  final bool isGhostStateTriggered;
}

class DayCycleService {
  DayCycleService._();
  static final DayCycleService instance = DayCycleService._();

  static const int damagePerIncompleteDaily = 15;

  /// Check if date transition occurred
  bool isDifferentDay(DateTime? lastDate, DateTime currentDate) {
    if (lastDate == null) return false;
    return lastDate.year != currentDate.year ||
        lastDate.month != currentDate.month ||
        lastDate.day != currentDate.day;
  }

  /// Processes daily midnight reset: calculates boss counter-attacks,
  /// inflicts hero HP damage, triggers ghost state if HP <= 0, and resets completion flags.
  DayCycleResult processDayReset({
    required DateTime? lastActiveDate,
    required DateTime currentDate,
    required List<DailyQuestModel> dailies,
    required HeroNotifier heroNotifier,
    bool isStreakShieldActive = false,
  }) {
    if (lastActiveDate == null || !isDifferentDay(lastActiveDate, currentDate)) {
      return const DayCycleResult(
        dayChanged: false,
        incompleteDailiesCount: 0,
        counterDamageDealt: 0,
        isGhostStateTriggered: false,
      );
    }

    // Count dailies that were left incomplete yesterday
    final incompleteCount = dailies.where((d) => !d.isCompletedToday).length;

    int damage = 0;
    if (incompleteCount > 0 && !isStreakShieldActive) {
      damage = incompleteCount * damagePerIncompleteDaily;
      heroNotifier.takeDamage(damage);
    }

    final isGhost = heroNotifier.isGhost;

    return DayCycleResult(
      dayChanged: true,
      incompleteDailiesCount: incompleteCount,
      counterDamageDealt: damage,
      isGhostStateTriggered: isGhost,
    );
  }
}
