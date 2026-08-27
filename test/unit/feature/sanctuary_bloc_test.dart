import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/feature/hero_sanctuary/bloc/sanctuary_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late HeroRepository heroRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedStarterKit();
    heroRepo = HeroRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Hero Sanctuary Feature Slice BLoC Unit Tests', () {
    test(
      '1. Loads hero profile, allocates stat points, equips skins and titles',
      () async {
        final bloc = SanctuaryBloc(heroRepository: heroRepo, appDatabase: db);
        bloc.add(const LoadSanctuary());

        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<SanctuaryLoaded>().having(
              (s) => s.hero?.name,
              'heroName',
              'Arthur',
            ),
          ),
        );

        // Award EXP so hero levels up and gets 3 unspent stat points
        await heroRepo.awardExp(120);

        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<SanctuaryLoaded>().having(
              (s) => (s.hero?.unspentStatPoints ?? 0) > 0,
              'hasStatPoints',
              true,
            ),
          ),
        );

        // Allocate STR point
        bloc.add(const AllocateStatPoint('STR'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<SanctuaryLoaded>().having((s) => s.hero?.str, 'str', 6),
          ),
        );

        // Equip skin
        bloc.add(const EquipSkinEvent('paladin'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<SanctuaryLoaded>().having(
              (s) => s.hero?.avatarSkinId,
              'skin',
              'paladin',
            ),
          ),
        );

        // Equip title
        bloc.add(const EquipTitleEvent('Dragon Champion'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<SanctuaryLoaded>().having(
              (s) => s.hero?.activeTitle,
              'title',
              'Dragon Champion',
            ),
          ),
        );

        await bloc.close();
      },
    );

    test('2. Exports complete game state to formatted JSON backup', () async {
      final bloc = SanctuaryBloc(heroRepository: heroRepo, appDatabase: db);
      bloc.add(const LoadSanctuary());

      await expectLater(bloc.stream, emitsThrough(isA<SanctuaryLoaded>()));

      bloc.add(const ExportBackupEvent());

      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<SanctuaryLoaded>().having(
            (s) => s.exportedBackupJson?.contains('"hero"'),
            'hasHeroBackup',
            true,
          ),
        ),
      );

      final state = bloc.state as SanctuaryLoaded;
      expect(state.exportedBackupJson?.contains('"bosses"'), true);
      expect(state.exportedBackupJson?.contains('"quests"'), true);

      await bloc.close();
    });
  });
}
