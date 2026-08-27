import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/config/config.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/quest_repository.dart';
import 'package:workxp/domain/repositories/tavern_repository.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await resetLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  group('Service Locator (GetIt) Unit Tests', () {
    test(
      '1. setupLocator registers AppConfig singleton with default config',
      () async {
        await setupLocator(
          loadEnvFile: false,
          customDatabase: AppDatabase(NativeDatabase.memory()),
          initHive: false,
        );

        expect(locator.isRegistered<AppConfig>(), isTrue);
        final config = locator<AppConfig>();
        expect(config.appName, 'WorkXP');
        expect(config.dbName, 'workxp.sqlite');
      },
    );

    test('2. setupLocator supports custom injected AppConfig', () async {
      const customConfig = AppConfig(
        appEnv: 'test',
        appName: 'WorkXP Test Rig',
        apiBaseUrl: 'https://test.workxp.local',
      );

      await setupLocator(
        customConfig: customConfig,
        customDatabase: AppDatabase(NativeDatabase.memory()),
        initHive: false,
      );

      expect(locator.isRegistered<AppConfig>(), isTrue);
      final config = locator<AppConfig>();
      expect(config.appName, 'WorkXP Test Rig');
      expect(config.isTest, isTrue);
    });

    test('3. resetLocator unregisters instances cleanly', () async {
      await setupLocator(
        loadEnvFile: false,
        customDatabase: AppDatabase(NativeDatabase.memory()),
        initHive: false,
      );
      expect(locator.isRegistered<AppConfig>(), isTrue);
      expect(locator.isRegistered<AppDatabase>(), isTrue);

      await resetLocator();
      expect(locator.isRegistered<AppConfig>(), isFalse);
      expect(locator.isRegistered<AppDatabase>(), isFalse);
    });

    test(
      '4. setupLocator registers Database, HiveConfig, and all 7 Domain Repositories',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        final hiveConfig = HiveConfig();

        await setupLocator(
          customDatabase: db,
          customHiveConfig: hiveConfig,
          loadEnvFile: false,
          initHive: false,
        );

        // Verify Data Sources
        expect(locator.isRegistered<AppDatabase>(), isTrue);
        expect(locator.isRegistered<HiveConfig>(), isTrue);

        // Verify Repositories
        expect(locator.isRegistered<HeroRepository>(), isTrue);
        expect(locator.isRegistered<BossRepository>(), isTrue);
        expect(locator.isRegistered<QuestRepository>(), isTrue);
        expect(locator.isRegistered<DailyQuestRepository>(), isTrue);
        expect(locator.isRegistered<HabitRepository>(), isTrue);
        expect(locator.isRegistered<TavernRepository>(), isTrue);
        expect(locator.isRegistered<CombatLogRepository>(), isTrue);

        // Verify Router & Shared BLoCs
        expect(locator.isRegistered<AppRouter>(), isTrue);
        expect(locator.isRegistered<LanguageBloc>(), isTrue);

        // Verify repository instantiation & operation
        final heroRepo = locator<HeroRepository>();
        final hero = await heroRepo.getHero();
        expect(hero?.name, equals('Arthur'));

        final bossRepo = locator<BossRepository>();
        final boss = await bossRepo.getActiveBoss();
        expect(boss?.name, equals('King Slime'));

        final router = locator<AppRouter>();
        expect(router, isNotNull);

        final langBloc = locator<LanguageBloc>();
        expect(langBloc.state.languageCode, equals('en'));

        await db.close();
      },
    );
  });
}
