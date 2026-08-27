import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'package:workxp/feature/dungeon/bloc/dungeon_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late BossRepository bossRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedStarterKit();
    bossRepo = BossRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Dungeon Feature Slice BLoC Unit Tests', () {
    test(
      '1. Loads campaign chapters and active Chapter 1 King Slime',
      () async {
        final bloc = DungeonBloc(bossRepo);
        bloc.add(const LoadDungeon());

        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<DungeonLoaded>().having(
              (s) => s.bosses.length,
              'chapterCount',
              4,
            ),
          ),
        );

        final state = bloc.state as DungeonLoaded;
        expect(state.activeBoss?.name, 'King Slime');
        expect(state.activeBoss?.chapter, 1);
        expect(state.unlockedChapterMax, 1);

        await bloc.close();
      },
    );

    test('2. Selects active chapter and unlocks boss encounter', () async {
      final bloc = DungeonBloc(bossRepo);
      bloc.add(const LoadDungeon());

      await expectLater(bloc.stream, emitsThrough(isA<DungeonLoaded>()));

      bloc.add(const SelectChapter(2));

      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<DungeonLoaded>().having(
            (s) => s.activeBoss?.chapter,
            'activeChapter',
            2,
          ),
        ),
      );

      final state = bloc.state as DungeonLoaded;
      expect(state.activeBoss?.name, 'Goblin Shaman');

      await bloc.close();
    });
  });
}
