import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_theme.dart';
import 'package:workxp/data/storage/hive_storage_service.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/screens/main_navigation_screen.dart';

import 'package:workxp/core/services/day_cycle_service.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local persistence
  try {
    await HiveStorageService.instance.init();
  } catch (_) {
    // In environments where hive flutter isn't fully bound (e.g. some headless unit runners), fallback gracefully
  }

  runApp(const ProviderScope(child: WorkXpApp()));
}

class WorkXpApp extends ConsumerStatefulWidget {
  const WorkXpApp({super.key});

  @override
  ConsumerState<WorkXpApp> createState() => _WorkXpAppState();
}

class _WorkXpAppState extends ConsumerState<WorkXpApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    // 1. Try loading existing saved game state from Hive box
    final savedData = HiveStorageService.instance.loadSavedGameState();
    if (savedData != null) {
      ref.read(heroProvider.notifier).setHero(savedData['hero'] as HeroModel);
      ref
          .read(questProvider.notifier)
          .setQuests(savedData['quests'] as List<QuestModel>);
      ref
          .read(dailyQuestProvider.notifier)
          .setDailyQuests(savedData['dailies'] as List<DailyQuestModel>);
      ref
          .read(habitProvider.notifier)
          .setHabits(savedData['habits'] as List<HabitModel>);
      ref
          .read(dungeonProvider.notifier)
          .setDungeonState(savedData['dungeon'] as DungeonState);
      ref
          .read(tavernProvider.notifier)
          .setTavernState(savedData['tavern'] as TavernState);
      ref
          .read(analyticsProvider.notifier)
          .setAnalyticsState(savedData['analytics'] as AnalyticsState);

      // Evaluate DayCycleService reset if day transitioned
      final lastSavedAt = savedData['lastSavedAt'] as DateTime?;
      final tavernState = savedData['tavern'] as TavernState;
      final isBossStun = ref
          .read(skillBuffProvider.notifier)
          .isBuffActive('buff_boss_stun');
      final result = DayCycleService.instance.processDayReset(
        lastActiveDate: lastSavedAt,
        currentDate: DateTime.now(),
        dailies: savedData['dailies'] as List<DailyQuestModel>,
        heroNotifier: ref.read(heroProvider.notifier),
        isStreakShieldActive: tavernState.activeStreakShields > 0,
        isBossStunActive: isBossStun,
      );

      if (result.dayChanged) {
        ref.read(dailyQuestProvider.notifier).resetDailiesForNewDay();
        ref.read(habitProvider.notifier).resetHabitsForNewDay();
      }
      return;
    }

    // 2. Otherwise initialize starter kit for fresh installs
    if (ref.read(questProvider).isEmpty) {
      final starterKit = HiveStorageService.instance.generateStarterKit();
      ref.read(heroProvider.notifier).setHero(starterKit['hero'] as HeroModel);
      ref
          .read(questProvider.notifier)
          .setQuests(starterKit['quests'] as List<QuestModel>);
      ref
          .read(dailyQuestProvider.notifier)
          .setDailyQuests(starterKit['dailies'] as List<DailyQuestModel>);
      ref
          .read(habitProvider.notifier)
          .setHabits(starterKit['habits'] as List<HabitModel>);
      ref
          .read(dungeonProvider.notifier)
          .setDungeonState(starterKit['dungeon'] as DungeonState);
      ref
          .read(tavernProvider.notifier)
          .setTavernState(starterKit['tavern'] as TavernState);
      ref
          .read(analyticsProvider.notifier)
          .setAnalyticsState(starterKit['analytics'] as AnalyticsState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkXP (Pocket Quest)',
      debugShowCheckedModeBanner: false,
      theme: PixelTheme.darkTheme(),
      home: const MainNavigationScreen(),
    );
  }
}
