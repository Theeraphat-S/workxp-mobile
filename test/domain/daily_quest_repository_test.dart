import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';

void main() {
  late AppDatabase db;
  late DailyQuestRepository dailyRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dailyRepo = DailyQuestRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DailyQuestRepository Tests', () {
    test(
      '1. watchDailyQuests and getDailyQuests return 3 seeded dailies',
      () async {
        final dailies = await dailyRepo.getDailyQuests();
        expect(dailies.length, equals(3));

        final streamDailies = await dailyRepo.watchDailyQuests().first;
        expect(streamDailies.length, equals(3));
      },
    );

    test(
      '2. toggleDailyQuest increments streak on check and decrements on uncheck',
      () async {
        // Toggle daily 1 (initial streak: 1, isCompleted: false)
        final checked = await dailyRepo.toggleDailyQuest('daily_starter_1');
        expect(checked, isNotNull);
        expect(checked!.isCompleted, isTrue);
        expect(checked.streak, equals(2));
        expect(checked.lastCompletedDate, isNotNull);

        // Untoggle daily 1 (isCompleted: true -> false, streak: 2 -> 1)
        final unchecked = await dailyRepo.toggleDailyQuest('daily_starter_1');
        expect(unchecked!.isCompleted, isFalse);
        expect(unchecked.streak, equals(1));
      },
    );

    test(
      '3. processMidnightReset counts missed dailies and resets completions',
      () async {
        // Mark daily 1 as completed, leave daily 2 and 3 uncompleted
        await dailyRepo.toggleDailyQuest('daily_starter_1');

        // Midnight reset: 2 missed dailies
        final missedCount = await dailyRepo.processMidnightReset();
        expect(missedCount, equals(2));

        // Verify all dailies are reset to isCompleted = false
        final all = await dailyRepo.getDailyQuests();
        for (final daily in all) {
          expect(daily.isCompleted, isFalse);
        }
      },
    );

    test('4. createDailyQuest and deleteDailyQuest manage routines', () async {
      final created = await dailyRepo.createDailyQuest(
        title: 'Drink 2L Water Daily',
        description: 'Hydration goal',
        streak: 0,
      );
      expect(created.title, equals('Drink 2L Water Daily'));

      var all = await dailyRepo.getDailyQuests();
      expect(all.length, equals(4));

      await dailyRepo.deleteDailyQuest(created.id);
      all = await dailyRepo.getDailyQuests();
      expect(all.length, equals(3));
    });
  });
}
