import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';

void main() {
  late AppDatabase db;
  late HabitRepository habitRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    habitRepo = HabitRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('HabitRepository Tests', () {
    test('1. watchHabits and getHabits return 3 seeded habits', () async {
      final habits = await habitRepo.getHabits();
      expect(habits.length, equals(3));

      final streamHabits = await habitRepo.watchHabits().first;
      expect(streamHabits.length, equals(3));
    });

    test(
      '2. logHabit positive increments positiveCount and appends history date',
      () async {
        final updated = await habitRepo.logHabit('habit_starter_1', true);
        expect(updated, isNotNull);
        expect(updated!.positiveCount, equals(1));
        expect(updated.negativeCount, equals(0));

        final dates = jsonDecode(updated.historyDatesJson) as List<dynamic>;
        expect(dates.length, equals(1));
      },
    );

    test(
      '3. logHabit negative increments negativeCount and appends history date',
      () async {
        final updated = await habitRepo.logHabit('habit_starter_3', false);
        expect(updated, isNotNull);
        expect(updated!.positiveCount, equals(0));
        expect(updated.negativeCount, equals(1));

        final dates = jsonDecode(updated.historyDatesJson) as List<dynamic>;
        expect(dates.length, equals(1));
      },
    );

    test('4. createHabit and deleteHabit CRUD operations', () async {
      final created = await habitRepo.createHabit(
        title: 'Read Documentation',
        isPositive: true,
        isNegative: false,
      );
      expect(created.title, equals('Read Documentation'));

      var all = await habitRepo.getHabits();
      expect(all.length, equals(4));

      await habitRepo.deleteHabit(created.id);
      all = await habitRepo.getHabits();
      expect(all.length, equals(3));
    });
  });
}
