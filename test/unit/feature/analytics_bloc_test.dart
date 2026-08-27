import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/feature/analytics/bloc/analytics_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late CombatLogRepository logRepo;
  late HeroRepository heroRepo;
  late DailyQuestRepository dailyRepo;
  late HabitRepository habitRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedStarterKit();

    logRepo = CombatLogRepositoryImpl(db);
    heroRepo = HeroRepositoryImpl(db);
    dailyRepo = DailyQuestRepositoryImpl(db);
    habitRepo = HabitRepositoryImpl(db);

    // Add some combat logs
    await logRepo.addLog(
      text: 'Struck King Slime for 120 damage!',
      damage: 120,
    );
    await logRepo.addLog(text: 'Completed Quest for 250 damage!', damage: 250);
  });

  tearDown(() async {
    await db.close();
  });

  group('Analytics Feature Slice BLoC Unit Tests', () {
    test(
      '1. Loads 30-day activity logs, unlocks dynamic achievements, and ranks guild leaderboard',
      () async {
        final bloc = AnalyticsBloc(
          combatLogRepository: logRepo,
          heroRepository: heroRepo,
          dailyQuestRepository: dailyRepo,
          habitRepository: habitRepo,
        );
        bloc.add(const LoadAnalytics());

        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<AnalyticsLoaded>().having(
              (s) => s.combatLogs.length,
              'logCount',
              2,
            ),
          ),
        );

        final state = bloc.state as AnalyticsLoaded;
        expect(state.dailyLogs.length, 30);
        expect(state.achievements.isNotEmpty, true);

        // Verify First Blood achievement unlocked because damage was dealt
        final firstBlood = state.achievements.firstWhere(
          (a) => a.id == 'ach_first_blood',
        );
        expect(firstBlood.isUnlocked, true);

        // Verify leaderboard contains hero entry
        expect(state.leaderboard.any((e) => e.isHero), true);

        await bloc.close();
      },
    );
  });
}
