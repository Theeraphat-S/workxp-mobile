import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/boss_repository.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/quest_repository.dart';
import 'package:workxp/feature/battle_hub/bloc/boss_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/daily_quest_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/habit_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/hero_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/quest_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late HeroRepository heroRepo;
  late BossRepository bossRepo;
  late QuestRepository questRepo;
  late DailyQuestRepository dailyRepo;
  late HabitRepository habitRepo;
  late CombatLogRepository logRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedStarterKit();

    heroRepo = HeroRepositoryImpl(db);
    bossRepo = BossRepositoryImpl(db);
    questRepo = QuestRepositoryImpl(db);
    dailyRepo = DailyQuestRepositoryImpl(db);
    habitRepo = HabitRepositoryImpl(db);
    logRepo = CombatLogRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Battle Hub Feature Slices BLoC Unit Tests', () {
    test('1. HeroBloc: Loads hero, spends MP, and handles ghost state revival', () async {
      final heroBloc = HeroBloc(heroRepo);
      heroBloc.add(const LoadHero());

      await expectLater(
        heroBloc.stream,
        emitsThrough(isA<HeroLoaded>().having((s) => s.hero.name, 'name', 'Arthur')),
      );

      // Spend MP
      heroBloc.add(const SpendMp(20));
      await expectLater(
        heroBloc.stream,
        emitsThrough(isA<HeroLoaded>().having((s) => s.hero.mp, 'mp', 30)),
      );

      // Take lethal damage -> Ghost state
      heroBloc.add(const ApplyDamage(100));
      await expectLater(
        heroBloc.stream,
        emitsThrough(isA<HeroLoaded>().having((s) => s.hero.isGhost, 'isGhost', true)),
      );

      // Revive hero
      heroBloc.add(const ReviveHero());
      await expectLater(
        heroBloc.stream,
        emitsThrough(isA<HeroLoaded>().having((s) => s.hero.isGhost, 'isGhost', false)),
      );

      await heroBloc.close();
    });

    test('2. BossBloc: Loads active chapter boss and applies damage', () async {
      final bossBloc = BossBloc(bossRepo);
      bossBloc.add(const LoadBoss());

      await expectLater(
        bossBloc.stream,
        emitsThrough(isA<BossLoaded>().having((s) => s.activeBoss?.name, 'bossName', 'King Slime')),
      );

      // Apply damage to boss
      bossBloc.add(const DamageBoss(50));
      await expectLater(
        bossBloc.stream,
        emitsThrough(isA<BossLoaded>().having((s) => s.activeBoss?.currentHp, 'hp', 450)),
      );

      await bossBloc.close();
    });

    test('3. QuestBloc: Completing quest applies formula-calculated combat strike damage', () async {
      final questBloc = QuestBloc(
        questRepository: questRepo,
        heroRepository: heroRepo,
        bossRepository: bossRepo,
        combatLogRepository: logRepo,
      );
      questBloc.add(const LoadQuests());

      await expectLater(
        questBloc.stream,
        emitsThrough(isA<QuestLoaded>().having((s) => s.quests.isNotEmpty, 'hasQuests', true)),
      );

      final initialQuests = (questBloc.state as QuestLoaded).quests;
      final targetQuest = initialQuests.first;

      // Complete Quest
      questBloc.add(CompleteQuest(targetQuest.id));

      await expectLater(
        questBloc.stream,
        emitsThrough(isA<QuestLoaded>().having((s) => s.lastStrikeDamage > 0, 'strikeDamage', true)),
      );

      // Verify active boss HP was reduced
      final boss = await bossRepo.getActiveBoss();
      expect(boss?.currentHp, lessThan(500));

      await questBloc.close();
    });

    test('4. DailyQuestBloc: Completing daily quest increments streak and logs combat event', () async {
      final dailyBloc = DailyQuestBloc(
        dailyQuestRepository: dailyRepo,
        heroRepository: heroRepo,
        combatLogRepository: logRepo,
      );
      dailyBloc.add(const LoadDailyQuests());

      await expectLater(
        dailyBloc.stream,
        emitsThrough(isA<DailyQuestLoaded>().having((s) => s.dailies.isNotEmpty, 'hasDailies', true)),
      );

      final dailies = (dailyBloc.state as DailyQuestLoaded).dailies;
      final target = dailies.first;

      dailyBloc.add(ToggleDailyQuest(target.id));

      await expectLater(
        dailyBloc.stream,
        emitsThrough(isA<DailyQuestLoaded>()),
      );

      final updatedDaily = await dailyRepo.getDailyQuest(target.id);
      expect(updatedDaily?.isCompleted, true);
      expect(updatedDaily?.streak, 2);

      await dailyBloc.close();
    });

    test('5. HabitBloc: Positive habit awards coins, negative habit inflicts HP damage penalty', () async {
      final habitBloc = HabitBloc(
        habitRepository: habitRepo,
        heroRepository: heroRepo,
        combatLogRepository: logRepo,
      );
      habitBloc.add(const LoadHabits());

      await expectLater(
        habitBloc.stream,
        emitsThrough(isA<HabitLoaded>().having((s) => s.habits.isNotEmpty, 'hasHabits', true)),
      );

      final habits = (habitBloc.state as HabitLoaded).habits;
      final target = habits.first;

      // Log positive
      habitBloc.add(LogHabit(id: target.id, isPositive: true));
      await expectLater(
        habitBloc.stream,
        emitsThrough(isA<HabitLoaded>()),
      );

      final h1 = await habitRepo.getHabit(target.id);
      expect(h1?.positiveCount, 1);

      // Log negative -> damage to hero
      habitBloc.add(LogHabit(id: target.id, isPositive: false));
      await expectLater(
        habitBloc.stream,
        emitsThrough(isA<HabitLoaded>()),
      );

      final h2 = await habitRepo.getHabit(target.id);
      expect(h2?.negativeCount, 1);

      final hero = await heroRepo.getHero();
      expect(hero?.hp, lessThan(100));

      await habitBloc.close();
    });
  });
}
