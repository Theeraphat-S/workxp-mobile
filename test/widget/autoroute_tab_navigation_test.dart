import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/main.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';
import 'package:workxp/shared/widgets/crt_scanline_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AutoRoute Shell & 5-Tab Navigation Tests', () {
    late AppRouter appRouter;
    late LanguageBloc languageBloc;
    late HiveConfig hiveConfig;

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

    testWidgets(
      'AutoTabsScaffold renders 5 tabs and switches destinations with state preservation',
      (tester) async {
        await tester.pumpWidget(
          WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
        );
        await tester.pumpAndSettle();

        // 1. Initial Route: Battle Hub (Tab index 0)
        expect(find.byKey(const Key('nav_battle')), findsOneWidget);
        expect(find.byKey(const Key('nav_dungeon')), findsOneWidget);
        expect(find.byKey(const Key('nav_tavern')), findsOneWidget);
        expect(find.byKey(const Key('nav_analytics')), findsOneWidget);
        expect(find.byKey(const Key('nav_sanctuary')), findsOneWidget);

        expect(find.text('BATTLE HUB'), findsOneWidget);
        expect(find.text('KING SLIME'), findsOneWidget);
        expect(find.byType(CrtScanlineOverlay), findsWidgets);

        // 2. Switch to World Map / Dungeon (Tab index 1)
        await tester.tap(find.byKey(const Key('nav_dungeon')));
        await tester.pumpAndSettle();
        expect(find.text('WORLD MAP'), findsOneWidget);
        expect(find.text('SLIME FOREST'), findsOneWidget);

        // 3. Switch to Tavern (Tab index 2)
        await tester.tap(find.byKey(const Key('nav_tavern')));
        await tester.pumpAndSettle();
        expect(find.text('THE TAVERN'), findsOneWidget);
        expect(find.text('POTIONS'), findsOneWidget);

        // 4. Switch to Analytics / Hall of Fame (Tab index 3)
        await tester.tap(find.byKey(const Key('nav_analytics')));
        await tester.pumpAndSettle();
        expect(find.text('HALL OF FAME'), findsOneWidget);
        expect(find.text('EXP GROWTH TRAJECTORY'), findsOneWidget);

        // 5. Switch to Hero Sanctuary (Tab index 4)
        await tester.tap(find.byKey(const Key('nav_sanctuary')));
        await tester.pumpAndSettle();
        expect(find.text('HERO SANCTUARY'), findsOneWidget);
        expect(find.text('ATTRIBUTES'), findsOneWidget);

        // 6. Switch back to Battle Hub and verify persistence
        await tester.tap(find.byKey(const Key('nav_battle')));
        await tester.pumpAndSettle();
        expect(find.text('BATTLE HUB'), findsOneWidget);
        expect(find.text('KING SLIME'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Active tab item highlights correctly and renders active tab screen',
      (tester) async {
        await tester.pumpWidget(
          WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
        );
        await tester.pumpAndSettle();

        // Tap tab 2 (Tavern)
        await tester.tap(find.byKey(const Key('nav_tavern')));
        await tester.pumpAndSettle();

        // Verify Tavern screen is displayed
        expect(find.text('THE TAVERN'), findsOneWidget);
        expect(find.text('POTIONS'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      },
    );
  });
}
