import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/quest_repository.dart';

void main() {
  late AppDatabase db;
  late QuestRepository questRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    questRepo = QuestRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('QuestRepository Tests', () {
    test('1. watchQuests and getQuests return seeded starter quests', () async {
      final quests = await questRepo.getQuests();
      expect(quests.length, equals(3));

      final active = await questRepo.watchActiveQuests().first;
      expect(active.length, equals(3));

      final completed = await questRepo.watchCompletedQuests().first;
      expect(completed.length, equals(0));
    });

    test(
      '2. createQuest adds a new quest with rank-based reward defaults',
      () async {
        final newQuest = await questRepo.createQuest(
          title: 'Master Advanced Flutter BLoC',
          description: 'Implement complex state streams',
          rank: 'S',
        );

        expect(newQuest.title, equals('Master Advanced Flutter BLoC'));
        expect(newQuest.rank, equals('S'));
        expect(newQuest.baseDamage, equals(600));
        expect(newQuest.expReward, equals(500));
        expect(newQuest.coinReward, equals(250));
        expect(newQuest.isCompleted, isFalse);

        final all = await questRepo.getQuests();
        expect(all.length, equals(4));
      },
    );

    test(
      '3. completeQuest marks quest complete and updates reactive streams',
      () async {
        await questRepo.completeQuest('quest_starter_1');

        final quest = await questRepo.getQuest('quest_starter_1');
        expect(quest, isNotNull);
        expect(quest!.isCompleted, isTrue);
        expect(quest.completedAt, isNotNull);

        final active = await questRepo.watchActiveQuests().first;
        expect(active.length, equals(2));

        final completed = await questRepo.watchCompletedQuests().first;
        expect(completed.length, equals(1));
        expect(completed.first.id, equals('quest_starter_1'));
      },
    );

    test('4. deleteQuest removes quest from database', () async {
      await questRepo.deleteQuest('quest_starter_2');

      final quest = await questRepo.getQuest('quest_starter_2');
      expect(quest, isNull);

      final all = await questRepo.getQuests();
      expect(all.length, equals(2));
    });
  });
}
