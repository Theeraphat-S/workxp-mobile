import 'dart:math';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class DailyQuestRepository {
  Stream<List<DailyQuest>> watchDailyQuests();
  Future<List<DailyQuest>> getDailyQuests();
  Future<DailyQuest?> getDailyQuest(String id);
  Future<DailyQuest> createDailyQuest({
    required String title,
    String description = '',
    int streak = 0,
    String? id,
  });
  Future<DailyQuest?> toggleDailyQuest(String id);
  Future<int> processMidnightReset();
  Future<void> deleteDailyQuest(String id);
}

class DailyQuestRepositoryImpl implements DailyQuestRepository {
  DailyQuestRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<DailyQuest>> watchDailyQuests() {
    return (_db.select(_db.dailyQuests)).watch();
  }

  @override
  Future<List<DailyQuest>> getDailyQuests() async {
    return (_db.select(_db.dailyQuests)).get();
  }

  @override
  Future<DailyQuest?> getDailyQuest(String id) async {
    return (_db.select(
      _db.dailyQuests,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<DailyQuest> createDailyQuest({
    required String title,
    String description = '',
    int streak = 0,
    String? id,
  }) async {
    final dailyId = id ?? const Uuid().v4();
    final companion = DailyQuestsCompanion.insert(
      id: dailyId,
      title: title,
      description: Value(description),
      isCompleted: const Value(false),
      streak: Value(streak),
    );

    await _db.into(_db.dailyQuests).insert(companion);
    return (await getDailyQuest(dailyId))!;
  }

  @override
  Future<DailyQuest?> toggleDailyQuest(String id) async {
    final daily = await getDailyQuest(id);
    if (daily == null) return null;

    final willBeCompleted = !daily.isCompleted;
    final newStreak = willBeCompleted
        ? daily.streak + 1
        : max(0, daily.streak - 1);
    final now = DateTime.now();

    await (_db.update(
      _db.dailyQuests,
    )..where((tbl) => tbl.id.equals(id))).write(
      DailyQuestsCompanion(
        isCompleted: Value(willBeCompleted),
        streak: Value(newStreak),
        lastCompletedDate: Value(
          willBeCompleted ? now : daily.lastCompletedDate,
        ),
      ),
    );

    return getDailyQuest(id);
  }

  @override
  Future<int> processMidnightReset() async {
    final all = await getDailyQuests();
    final missedCount = all.where((d) => !d.isCompleted).length;

    await _db
        .update(_db.dailyQuests)
        .write(const DailyQuestsCompanion(isCompleted: Value(false)));

    return missedCount;
  }

  @override
  Future<void> deleteDailyQuest(String id) async {
    await (_db.delete(_db.dailyQuests)..where((tbl) => tbl.id.equals(id))).go();
  }
}
