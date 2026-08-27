import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class HabitRepository {
  Stream<List<Habit>> watchHabits();
  Future<List<Habit>> getHabits();
  Future<Habit?> getHabit(String id);
  Future<Habit> createHabit({
    required String title,
    bool isPositive = true,
    bool isNegative = false,
    String? id,
  });
  Future<Habit?> logHabit(String id, bool isPositive);
  Future<void> deleteHabit(String id);
}

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Habit>> watchHabits() {
    return (_db.select(_db.habits)).watch();
  }

  @override
  Future<List<Habit>> getHabits() async {
    return (_db.select(_db.habits)).get();
  }

  @override
  Future<Habit?> getHabit(String id) async {
    return (_db.select(
      _db.habits,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<Habit> createHabit({
    required String title,
    bool isPositive = true,
    bool isNegative = false,
    String? id,
  }) async {
    final habitId = id ?? const Uuid().v4();
    final companion = HabitsCompanion.insert(
      id: habitId,
      title: title,
      isPositive: Value(isPositive),
      isNegative: Value(isNegative),
      positiveCount: const Value(0),
      negativeCount: const Value(0),
      historyDatesJson: const Value('[]'),
    );

    await _db.into(_db.habits).insert(companion);
    return (await getHabit(habitId))!;
  }

  @override
  Future<Habit?> logHabit(String id, bool isPositive) async {
    final habit = await getHabit(id);
    if (habit == null) return null;

    final nowIso = DateTime.now().toIso8601String();
    List<String> dates = [];
    try {
      final decoded = jsonDecode(habit.historyDatesJson);
      if (decoded is List) {
        dates = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    dates.add(nowIso);

    final updatedPositive = isPositive
        ? habit.positiveCount + 1
        : habit.positiveCount;
    final updatedNegative = !isPositive
        ? habit.negativeCount + 1
        : habit.negativeCount;

    await (_db.update(_db.habits)..where((tbl) => tbl.id.equals(id))).write(
      HabitsCompanion(
        positiveCount: Value(updatedPositive),
        negativeCount: Value(updatedNegative),
        historyDatesJson: Value(jsonEncode(dates)),
      ),
    );

    return getHabit(id);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await (_db.delete(_db.habits)..where((tbl) => tbl.id.equals(id))).go();
  }
}
