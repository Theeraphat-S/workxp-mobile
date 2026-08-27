import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/main.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Milestone 4 Vertical Slices Widget Tests', () {
    late AppRouter appRouter;
    late HiveConfig hiveConfig;
    late LanguageBloc languageBloc;

    setUp(() {
      SensoryService.instance.toggleSfx(false);
      SensoryService.instance.toggleHaptics(false);
      appRouter = AppRouter();
      hiveConfig = HiveConfig();
      languageBloc = LanguageBloc(hiveConfig);
    });

    tearDown(() {
      languageBloc.close();
      appRouter.dispose();
    });

    testWidgets('1. BattleHubPage: Renders Hero HUD, Boss Encounter Card, Tabs and Dialogs', (tester) async {
      await tester.pumpWidget(
        WorkXpApp(
          appRouter: appRouter,
          languageBloc: languageBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title & Hero HUD
      expect(find.text('BATTLE HUB'), findsOneWidget);
      expect(find.text('Arthur'), findsOneWidget);
      expect(find.text('KING SLIME'), findsOneWidget);

      // Verify Category Selector
      expect(find.text('QUESTS'), findsWidgets);
      expect(find.text('DAILIES'), findsOneWidget);
      expect(find.text('HABITS'), findsOneWidget);

      // Switch to DAILIES tab
      await tester.ensureVisible(find.text('DAILIES'));
      await tester.tap(find.text('DAILIES'));
      await tester.pumpAndSettle();
      expect(find.text('+ DAILY'), findsOneWidget);

      // Switch to HABITS tab
      await tester.ensureVisible(find.text('HABITS'));
      await tester.tap(find.text('HABITS'));
      await tester.pumpAndSettle();
      expect(find.text('+ HABIT'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('2. DungeonMapPage: Renders Campaign Chapter Nodes and Bestiary', (tester) async {
      await tester.pumpWidget(
        WorkXpApp(
          appRouter: appRouter,
          languageBloc: languageBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Dungeon tab
      await tester.tap(find.byKey(const Key('nav_dungeon')));
      await tester.pumpAndSettle();

      expect(find.text('WORLD MAP'), findsOneWidget);
      expect(find.text('SLIME FOREST'), findsOneWidget);
      expect(find.text('GOBLIN KEEP'), findsOneWidget);
      expect(find.text('SHADOW CRYPT'), findsOneWidget);
      expect(find.text('VOLCANO PEAK'), findsOneWidget);

      // Tap Bestiary button
      await tester.tap(find.text('BESTIARY'));
      await tester.pumpAndSettle();

      expect(find.text('DUNGEON BESTIARY'), findsOneWidget);
      expect(find.text('CLOSE BESTIARY'), findsOneWidget);

      await tester.tap(find.text('CLOSE BESTIARY'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('3. TavernPage: Renders Consumables, Cosmetics, Custom Rewards, and Inventory', (tester) async {
      await tester.pumpWidget(
        WorkXpApp(
          appRouter: appRouter,
          languageBloc: languageBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Tavern tab
      await tester.tap(find.byKey(const Key('nav_tavern')));
      await tester.pumpAndSettle();

      expect(find.text('THE TAVERN'), findsOneWidget);
      expect(find.text('POTIONS'), findsOneWidget);
      expect(find.text('COSMETICS'), findsOneWidget);
      expect(find.text('REWARDS'), findsOneWidget);

      // Switch to Cosmetics tab
      await tester.tap(find.text('COSMETICS'));
      await tester.pumpAndSettle();

      // Switch to Custom Rewards tab
      await tester.tap(find.text('REWARDS'));
      await tester.pumpAndSettle();
      expect(find.text('+ REWARD'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('4. AnalyticsPage: Renders 6 Gamified Charts and Metric Panels', (tester) async {
      await tester.pumpWidget(
        WorkXpApp(
          appRouter: appRouter,
          languageBloc: languageBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Analytics tab
      await tester.tap(find.byKey(const Key('nav_analytics')));
      await tester.pumpAndSettle();

      expect(find.text('HALL OF FAME'), findsOneWidget);
      expect(find.text('EXP GROWTH TRAJECTORY'), findsOneWidget);
      expect(find.text('BOSS DAMAGE DEALT'), findsOneWidget);
      expect(find.text('16-BIT HABIT HEATMAP'), findsOneWidget);
      expect(find.text('ATTRIBUTE BALANCE RADAR'), findsOneWidget);
      expect(find.text('LIFETIME ACHIEVEMENTS'), findsOneWidget);
      expect(find.text('SIMULATED GUILD LEADERBOARD'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('5. HeroSanctuaryPage: Renders Hero Profile, Attributes Allocator, Skins, Titles, and Settings', (tester) async {
      await tester.pumpWidget(
        WorkXpApp(
          appRouter: appRouter,
          languageBloc: languageBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Sanctuary tab
      await tester.tap(find.byKey(const Key('nav_sanctuary')));
      await tester.pumpAndSettle();

      expect(find.text('HERO SANCTUARY'), findsOneWidget);
      expect(find.text('ARTHUR'), findsOneWidget);
      expect(find.text('ATTRIBUTES'), findsOneWidget);
      expect(find.text('AVATAR SKINS'), findsOneWidget);
      expect(find.text('EARNED TITLES'), findsOneWidget);
      expect(find.text('SETTINGS & STORAGE BACKUP'), findsOneWidget);
      expect(find.text('8-BIT SOUND EFFECTS (SFX)'), findsOneWidget);
      expect(find.text('TACTILE HAPTIC FEEDBACK'), findsOneWidget);
      expect(find.text('EXPORT (JSON)'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  });
}
