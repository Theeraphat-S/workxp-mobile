import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'package:workxp/presentation/screens/hero_sanctuary/hero_sanctuary_screen.dart';
import 'package:workxp/data/storage/hive_storage_service.dart';

void main() {
  group('Ticket 09: Local Persistence, JSON Backup & Starter Kit Slice', () {
    test('Starter Kit generates valid initial game state', () {
      expect(HiveStorageService.instance.hasSaveData(), false);

      final starterKit = HiveStorageService.instance.generateStarterKit();

      final hero = starterKit['hero'] as HeroModel;
      final quests = starterKit['quests'] as List<QuestModel>;
      final dailies = starterKit['dailies'] as List<DailyQuestModel>;
      final habits = starterKit['habits'] as List<HabitModel>;
      final dungeon = starterKit['dungeon'] as DungeonState;
      final tavern = starterKit['tavern'] as TavernState;

      expect(hero.name, 'Arthur');
      expect(hero.level, 1);
      expect(quests.length, 3);
      expect(dailies.length, 3);
      expect(habits.length, 3);
      expect(dungeon.activeBoss.name, 'King Slime');
      expect(tavern.catalog.any((i) => i.id == 'theme_amber_crt'), true);
      expect(tavern.catalog.any((i) => i.id == 'theme_green_crt'), true);
    });

    test('JSON Export and Import cycle preserves complete game state', () {
      const hero = HeroModel(
        name: 'Galahad',
        level: 5,
        currentExp: 75,
        coins: 350,
        str: 14,
        intel: 10,
        agi: 8,
        vit: 12,
        wis: 9,
        activeSkinId: 'paladin',
        activeTitleId: 'Iron Knight',
      );

      final quests = [
        QuestModel(id: 'q1', title: 'Task 1', rank: 'B', isCompleted: true),
      ];

      final dailies = [
        DailyQuestModel(
          id: 'd1',
          title: 'Daily 1',
          streak: 4,
          isCompletedToday: true,
        ),
      ];

      final habits = [
        HabitModel(id: 'h1', title: 'Habit 1', positiveCountToday: 3),
      ];

      final dungeon = DungeonState(
        activeBoss: BossModel.chapterBoss(2).copyWith(currentHp: 250),
        currentChapter: 2,
        unlockedChapters: [1, 2],
      );

      const tavern = TavernState(activeStreakShields: 2);

      final analytics = AnalyticsState();

      // Export JSON
      final jsonString = HiveStorageService.instance.exportSaveFileJson(
        hero: hero,
        quests: quests,
        dailies: dailies,
        habits: habits,
        dungeon: dungeon,
        tavern: tavern,
        analytics: analytics,
      );

      expect(jsonString.isNotEmpty, true);

      // Validate & Parse
      final parsed = HiveStorageService.instance.parseAndValidateSaveJson(
        jsonString,
      );
      expect(parsed != null, true);

      final importedHero = HeroModel.fromJson(
        parsed!['hero'] as Map<String, dynamic>,
      );
      expect(importedHero.name, 'Galahad');
      expect(importedHero.level, 5);
      expect(importedHero.coins, 350);
      expect(importedHero.str, 14);
      expect(importedHero.activeSkinId, 'paladin');

      final importedQuests = (parsed['quests'] as List<dynamic>)
          .map((e) => QuestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(importedQuests.first.title, 'Task 1');
      expect(importedQuests.first.isCompleted, true);

      final importedDungeon = DungeonState.fromJson(
        parsed['dungeon'] as Map<String, dynamic>,
      );
      expect(importedDungeon.currentChapter, 2);
      expect(importedDungeon.activeBoss.currentHp, 250);
    });

    test('Malformed JSON save string is safely rejected', () {
      final invalid = HiveStorageService.instance.parseAndValidateSaveJson(
        '{"invalid": true}',
      );
      expect(invalid, isNull);

      final broken = HiveStorageService.instance.parseAndValidateSaveJson(
        'not json string',
      );
      expect(broken, isNull);
    });

    testWidgets(
      'Hero Sanctuary UI displays settings, toggles and backup buttons',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 3200);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final heroNotifier = HeroNotifier(const HeroModel(name: 'Arthur'));

        final container = ProviderContainer(
          overrides: [
            heroProvider.overrideWith((ref) => heroNotifier),
            questProvider.overrideWith((ref) => QuestNotifier()),
            dailyQuestProvider.overrideWith((ref) => DailyQuestNotifier()),
            habitProvider.overrideWith((ref) => HabitNotifier()),
            dungeonProvider.overrideWith((ref) => DungeonNotifier()),
            tavernProvider.overrideWith((ref) => TavernNotifier()),
            analyticsProvider.overrideWith((ref) => AnalyticsNotifier()),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: HeroSanctuaryScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('SETTINGS & STORAGE BACKUP'), findsOneWidget);
        expect(find.text('8-BIT SOUND EFFECTS (SFX)'), findsOneWidget);
        expect(find.text('TACTILE HAPTIC FEEDBACK'), findsOneWidget);
        expect(find.text('EXPORT JSON'), findsOneWidget);
        expect(find.text('IMPORT JSON'), findsOneWidget);
        expect(find.text('SAVE GAME PROGRESS NOW'), findsOneWidget);
      },
    );
  });
}
