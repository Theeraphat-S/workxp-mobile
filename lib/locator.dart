import 'package:get_it/get_it.dart';
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
import 'package:workxp/feature/analytics/bloc/analytics_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/boss_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/daily_quest_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/habit_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/hero_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/quest_bloc.dart';
import 'package:workxp/feature/dungeon/bloc/dungeon_bloc.dart';
import 'package:workxp/feature/hero_sanctuary/bloc/sanctuary_bloc.dart';
import 'package:workxp/feature/tavern/bloc/tavern_bloc.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

/// Centralized GetIt service locator instance.
final GetIt locator = GetIt.instance;

/// Initializes application dependencies, environment configurations,
/// services, database instances, repositories, router, and shared BLoCs.
Future<void> setupLocator({
  AppConfig? customConfig,
  AppDatabase? customDatabase,
  HiveConfig? customHiveConfig,
  AppRouter? customRouter,
  LanguageBloc? customLanguageBloc,
  bool loadEnvFile = true,
  bool initHive = true,
}) async {
  // If already registered, reset first to allow re-initialization in tests
  if (locator.isRegistered<AppConfig>()) {
    await resetLocator();
  }

  // 1. Config & Environment
  final config =
      customConfig ??
      (loadEnvFile ? await AppConfig.load() : AppConfig.fromEnv());
  locator.registerSingleton<AppConfig>(config);

  // 2. Data Sources & Persistence
  if (customDatabase != null) {
    locator.registerSingleton<AppDatabase>(customDatabase);
  } else {
    locator.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }

  if (customHiveConfig != null) {
    if (initHive) {
      await customHiveConfig.init();
    }
    locator.registerSingleton<HiveConfig>(customHiveConfig);
  } else {
    final hive = HiveConfig();
    if (initHive) {
      await hive.init();
    }
    locator.registerLazySingleton<HiveConfig>(() => hive);
  }

  // 3. Domain Repositories
  locator.registerLazySingleton<HeroRepository>(
    () => HeroRepositoryImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<BossRepository>(
    () => BossRepositoryImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<QuestRepository>(
    () => QuestRepositoryImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<DailyQuestRepository>(
    () => DailyQuestRepositoryImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<TavernRepository>(
    () => TavernRepositoryImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<CombatLogRepository>(
    () => CombatLogRepositoryImpl(locator<AppDatabase>()),
  );

  // 4. Router & Navigation
  if (customRouter != null) {
    locator.registerSingleton<AppRouter>(customRouter);
  } else {
    locator.registerLazySingleton<AppRouter>(() => AppRouter());
  }

  // 5. Shared & Feature BLoCs
  if (customLanguageBloc != null) {
    locator.registerSingleton<LanguageBloc>(customLanguageBloc);
  } else {
    locator.registerLazySingleton<LanguageBloc>(
      () => LanguageBloc(locator<HiveConfig>()),
    );
  }
  locator.registerFactory<HeroBloc>(
    () => HeroBloc(locator<HeroRepository>()),
  );
  locator.registerFactory<BossBloc>(
    () => BossBloc(locator<BossRepository>()),
  );
  locator.registerFactory<QuestBloc>(
    () => QuestBloc(
      questRepository: locator<QuestRepository>(),
      heroRepository: locator<HeroRepository>(),
      bossRepository: locator<BossRepository>(),
      combatLogRepository: locator<CombatLogRepository>(),
    ),
  );
  locator.registerFactory<DailyQuestBloc>(
    () => DailyQuestBloc(
      dailyQuestRepository: locator<DailyQuestRepository>(),
      heroRepository: locator<HeroRepository>(),
      combatLogRepository: locator<CombatLogRepository>(),
    ),
  );
  locator.registerFactory<HabitBloc>(
    () => HabitBloc(
      habitRepository: locator<HabitRepository>(),
      heroRepository: locator<HeroRepository>(),
      combatLogRepository: locator<CombatLogRepository>(),
    ),
  );
  locator.registerFactory<DungeonBloc>(
    () => DungeonBloc(locator<BossRepository>()),
  );
  locator.registerFactory<TavernBloc>(
    () => TavernBloc(
      tavernRepository: locator<TavernRepository>(),
      heroRepository: locator<HeroRepository>(),
    ),
  );
  locator.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(
      combatLogRepository: locator<CombatLogRepository>(),
      heroRepository: locator<HeroRepository>(),
      dailyQuestRepository: locator<DailyQuestRepository>(),
      habitRepository: locator<HabitRepository>(),
    ),
  );
  locator.registerFactory<SanctuaryBloc>(
    () => SanctuaryBloc(
      heroRepository: locator<HeroRepository>(),
      appDatabase: locator<AppDatabase>(),
    ),
  );
}

/// Reset locator registrations, useful for unit and integration testing.
Future<void> resetLocator() async {
  if (locator.isRegistered<AppDatabase>()) {
    try {
      // Only close if already constructed
      if (locator.isRegistered<AppDatabase>()) {
        // AppDatabase instance close
      }
    } catch (_) {}
  }
  await locator.reset();
}
