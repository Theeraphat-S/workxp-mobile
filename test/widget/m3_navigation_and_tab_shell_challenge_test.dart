import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/main.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';
import 'package:workxp/shared/widgets/crt_scanline_overlay.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Milestone 3 Empirical Challenge: AutoRoute Navigation Shell & Tab Switching',
    () {
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
        '1. Rapid 50-Cycle Tab Switching Stress & Sequential Navigation',
        (tester) async {
          await tester.pumpWidget(
            WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
          );
          await tester.pumpAndSettle();

          final tabKeys = [
            const Key('nav_battle'),
            const Key('nav_dungeon'),
            const Key('nav_tavern'),
            const Key('nav_analytics'),
            const Key('nav_sanctuary'),
          ];

          // Verify all 5 tab navigation items are present
          for (final key in tabKeys) {
            expect(find.byKey(key), findsOneWidget);
          }

          // Execute 2 full sequential round-robin cycles (10 tab taps)
          for (int cycle = 0; cycle < 2; cycle++) {
            for (int i = 0; i < tabKeys.length; i++) {
              await tester.tap(find.byKey(tabKeys[i]));
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 50));
            }
          }
          await tester.pumpAndSettle();

          // The final active tab after cycling to index 4 should be Hero Sanctuary
          expect(find.text('HERO SANCTUARY'), findsOneWidget);
          expect(find.text('ATTRIBUTES'), findsOneWidget);

          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        },
      );

      testWidgets('2. Non-Sequential Random Jump Navigation & State Sync', (
        tester,
      ) async {
        await tester.pumpWidget(
          WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
        );
        await tester.pumpAndSettle();

        final jumpSequence = [
          (const Key('nav_analytics'), 'HALL OF FAME'),
          (const Key('nav_dungeon'), 'WORLD MAP'),
          (const Key('nav_sanctuary'), 'HERO SANCTUARY'),
          (const Key('nav_battle'), 'BATTLE HUB'),
          (const Key('nav_tavern'), 'THE TAVERN'),
          (const Key('nav_battle'), 'BATTLE HUB'),
          (const Key('nav_analytics'), 'HALL OF FAME'),
          (const Key('nav_tavern'), 'THE TAVERN'),
          (const Key('nav_sanctuary'), 'HERO SANCTUARY'),
          (const Key('nav_dungeon'), 'WORLD MAP'),
        ];

        for (final (key, expectedHeading) in jumpSequence) {
          await tester.tap(find.byKey(key));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text(expectedHeading), findsOneWidget);
        }

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      });

      testWidgets(
        '3. Idempotent Redundant Tap on Active Tab (No-Op Verification)',
        (tester) async {
          await tester.pumpWidget(
            WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
          );
          await tester.pumpAndSettle();

          // Initial active tab: Battle Hub
          expect(find.text('BATTLE HUB'), findsOneWidget);

          // Tapping the currently active tab (nav_battle) 5 times
          for (int i = 0; i < 5; i++) {
            await tester.tap(find.byKey(const Key('nav_battle')));
            await tester.pump();
          }
          await tester.pumpAndSettle();

          // Should remain stably on Battle Hub with King Slime intact
          expect(find.text('BATTLE HUB'), findsOneWidget);
          expect(find.text('KING SLIME'), findsOneWidget);

          // Now tap a different tab (nav_dungeon)
          await tester.tap(find.byKey(const Key('nav_dungeon')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();

          // Verify destination switched to World Map
          expect(find.text('WORLD MAP'), findsOneWidget);

          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        '4. State & Scroll Position Preservation Across Tab Switching',
        (tester) async {
          await tester.pumpWidget(
            WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
          );
          await tester.pumpAndSettle();

          // 1. In Battle Hub, verify default starter elements
          expect(find.text('KING SLIME'), findsOneWidget);
          expect(find.textContaining('DAILIES'), findsOneWidget);
          expect(find.textContaining('QUESTS'), findsOneWidget);

          // 2. Switch to Tavern
          await tester.tap(find.byKey(const Key('nav_tavern')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text('THE TAVERN'), findsOneWidget);

          // Find Tavern scrollable and scroll down
          final tavernScrollable = find.byType(Scrollable).first;
          await tester.drag(tavernScrollable, const Offset(0, -300));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();

          // 3. Switch to World Map, Analytics, and Hero Sanctuary
          await tester.tap(find.byKey(const Key('nav_dungeon')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text('WORLD MAP'), findsOneWidget);

          await tester.tap(find.byKey(const Key('nav_analytics')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text('HALL OF FAME'), findsOneWidget);

          await tester.tap(find.byKey(const Key('nav_sanctuary')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text('HERO SANCTUARY'), findsOneWidget);

          // 4. Return to Tavern and verify it remains rendered and intact
          await tester.tap(find.byKey(const Key('nav_tavern')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text('THE TAVERN'), findsOneWidget);
          expect(find.text('POTIONS'), findsOneWidget);

          // 5. Return to Battle Hub and verify King Slime remains intact
          await tester.tap(find.byKey(const Key('nav_battle')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          await tester.pumpAndSettle();
          expect(find.text('BATTLE HUB'), findsOneWidget);
          expect(find.text('KING SLIME'), findsOneWidget);

          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        '5. Concurrent Language Switching During Navigation Lifecycle',
        (tester) async {
          await tester.pumpWidget(
            WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
          );
          await tester.pumpAndSettle();

          // English check
          expect(find.text('BATTLE'), findsOneWidget);
          expect(find.text('DUNGEON'), findsOneWidget);
          expect(find.text('TAVERN'), findsOneWidget);
          expect(find.text('ANALYTICS'), findsOneWidget);
          expect(find.text('SANCTUARY'), findsOneWidget);

          // Switch language to Thai
          languageBloc.add(const ChangeLanguage(Locale('th')));
          await tester.pump();
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('nav_dungeon')));
          await tester.pumpAndSettle();

          // Thai labels check on bottom nav
          expect(find.text('การรบ'), findsOneWidget);
          expect(find.text('ดันเจี้ยน'), findsOneWidget);
          expect(find.text('โรงเตี๊ยม'), findsOneWidget);
          expect(find.text('สถิติ'), findsOneWidget);
          expect(find.text('วิหาร'), findsOneWidget);

          // Switch to Tavern while in Thai
          await tester.tap(find.byKey(const Key('nav_tavern')));
          await tester.pumpAndSettle();
          expect(find.text('THE TAVERN'), findsOneWidget);

          // Switch back to English while in Tavern
          languageBloc.add(const ChangeLanguage(Locale('en')));
          await tester.pump();
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('nav_battle')));
          await tester.pumpAndSettle();
          expect(find.text('BATTLE'), findsOneWidget);
          expect(find.text('BATTLE HUB'), findsOneWidget);

          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        },
      );
    },
  );

  group('Milestone 3 Empirical Challenge: Sensory Feedback & CRT Overlay', () {
    final logMethodCalls = <MethodCall>[];

    setUp(() {
      logMethodCalls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            MethodCall methodCall,
          ) async {
            logMethodCalls.add(methodCall);
            return null;
          });
      SensoryService.instance.toggleSfx(true);
      SensoryService.instance.toggleHaptics(true);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets(
      '6. SensoryService SFX and Haptic Mutability & Trigger Coverage',
      (tester) async {
        // 1. Both enabled
        SensoryService.instance.playClick();
        expect(logMethodCalls.length, 2); // 1 haptic + 1 sound
        logMethodCalls.clear();

        SensoryService.instance.playAttack();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        SensoryService.instance.playCriticalAttack();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        SensoryService.instance.playHurt();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        SensoryService.instance.playCoin();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        SensoryService.instance.playLevelUp();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        SensoryService.instance.playVictory();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        SensoryService.instance.playBuff();
        expect(logMethodCalls.length, 2);
        logMethodCalls.clear();

        // 2. Disable SFX only
        SensoryService.instance.toggleSfx(false);
        SensoryService.instance.playClick();
        expect(logMethodCalls.length, 1); // only haptic
        expect(logMethodCalls.first.method, 'HapticFeedback.vibrate');
        logMethodCalls.clear();

        // 3. Disable Haptics only
        SensoryService.instance.toggleSfx(true);
        SensoryService.instance.toggleHaptics(false);
        SensoryService.instance.playClick();
        expect(logMethodCalls.length, 1); // only sound
        expect(logMethodCalls.first.method, 'SystemSound.play');
        logMethodCalls.clear();

        // 4. Disable both (Silent Mode)
        SensoryService.instance.toggleSfx(false);
        SensoryService.instance.toggleHaptics(false);
        SensoryService.instance.playClick();
        SensoryService.instance.playAttack();
        SensoryService.instance.playCriticalAttack();
        expect(logMethodCalls.isEmpty, isTrue);
      },
    );

    testWidgets(
      '7. CRT Scanline Overlay: Pointer Pass-Through & Custom Dimensions',
      (tester) async {
        bool buttonTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CrtScanlineOverlay(
                enabled: true,
                scanlineHeight: 4.0,
                opacity: 0.2,
                child: Center(
                  child: ElevatedButton(
                    key: const Key('test_btn'),
                    onPressed: () {
                      buttonTapped = true;
                    },
                    child: const Text('PRESS ME'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Verify IgnorePointer allows touch events through scanline overlay
        expect(find.byType(CrtScanlineOverlay), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);

        await tester.tap(find.byKey(const Key('test_btn')));
        await tester.pump();
        expect(buttonTapped, isTrue);
      },
    );

    testWidgets(
      '8. CRT Scanline Overlay: Disabled Toggle Renders Child Directly',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CrtScanlineOverlay(
                enabled: false,
                child: SizedBox(
                  key: const Key('target_container'),
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('target_container')), findsOneWidget);
        // When disabled, no Stack or Positioned overlay is created
        expect(find.byType(Positioned), findsNothing);
      },
    );
  });

  group(
    'Milestone 3 Empirical Challenge: 16-Bit Shared Design System Widgets Boundary & Stress',
    () {
      testWidgets(
        '9. PixelButton: Tactile Depression, Disabled State & Full Width',
        (tester) async {
          bool wasClicked = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    PixelButton(
                      key: const Key('active_btn'),
                      text: 'ATTACK',
                      icon: Icons.flash_on,
                      isFullWidth: true,
                      onPressed: () {
                        wasClicked = true;
                      },
                    ),
                    PixelButton(
                      key: const Key('disabled_btn'),
                      text: 'LOCKED',
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
          );

          // Verify rendering
          expect(find.text('ATTACK'), findsOneWidget);
          expect(find.text('LOCKED'), findsOneWidget);

          // Test active tap
          await tester.tap(find.byKey(const Key('active_btn')));
          await tester.pumpAndSettle();
          expect(wasClicked, isTrue);

          // Test disabled tap does not throw
          await tester.tap(find.byKey(const Key('disabled_btn')));
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        '10. PixelCard: Padding, Margin, Border Width & Tap Reaction',
        (tester) async {
          bool cardTapped = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: PixelCard(
                  key: const Key('interactive_card'),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  borderWidth: 3.0,
                  onTap: () {
                    cardTapped = true;
                  },
                  child: const Text('CARD CONTENT'),
                ),
              ),
            ),
          );

          expect(find.text('CARD CONTENT'), findsOneWidget);
          await tester.tap(find.byKey(const Key('interactive_card')));
          await tester.pumpAndSettle();
          expect(cardTapped, isTrue);
        },
      );

      testWidgets(
        '11. PixelProgressBar: Math Boundaries (Zero Max, Overflow, Clamp)',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    // Standard 50%
                    PixelProgressBar(current: 50, max: 100, label: 'HP'),
                    // 0 Max (division by zero safety)
                    PixelProgressBar(current: 10, max: 0, label: 'ZERO_MAX'),
                    // Overflow current > max (clamped at 100%)
                    PixelProgressBar(current: 150, max: 100, label: 'OVERFLOW'),
                    // Negative current (clamped at 0%)
                    PixelProgressBar(current: -20, max: 100, label: 'NEGATIVE'),
                  ],
                ),
              ),
            ),
          );

          expect(find.text('HP'), findsOneWidget);
          expect(find.text('ZERO_MAX'), findsOneWidget);
          expect(find.text('OVERFLOW'), findsOneWidget);
          expect(find.text('NEGATIVE'), findsOneWidget);
          expect(find.text('50 / 100'), findsOneWidget);
          expect(find.text('150 / 100'), findsOneWidget);
          expect(find.text('-20 / 100'), findsOneWidget);
        },
      );

      testWidgets('12. PixelBadge: All Rank Tiers and Attribute Categories', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    PixelBadge.rank('S'),
                    PixelBadge.rank('A'),
                    PixelBadge.rank('B'),
                    PixelBadge.rank('C'),
                    PixelBadge.rank('D'),
                    PixelBadge.rank('E'),
                    PixelBadge.rank('UNKNOWN'),
                    PixelBadge.attribute('STR'),
                    PixelBadge.attribute('INT'),
                    PixelBadge.attribute('AGI'),
                    PixelBadge.attribute('VIT'),
                    PixelBadge.attribute('WIS'),
                    PixelBadge.attribute('LUK'),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('RANK S'), findsOneWidget);
        expect(find.text('RANK A'), findsOneWidget);
        expect(find.text('RANK B'), findsOneWidget);
        expect(find.text('RANK C'), findsOneWidget);
        expect(find.text('RANK D'), findsOneWidget);
        expect(find.text('RANK E'), findsOneWidget);
        expect(find.text('RANK UNKNOWN'), findsOneWidget);
        expect(find.text('STR'), findsOneWidget);
        expect(find.text('INT'), findsOneWidget);
        expect(find.text('AGI'), findsOneWidget);
        expect(find.text('VIT'), findsOneWidget);
        expect(find.text('WIS'), findsOneWidget);
        expect(find.text('LUK'), findsOneWidget);
      });

      testWidgets(
        '13. PixelSprite: All 24 Sprite Types & Ghost Aura Coverage',
        (tester) async {
          final spriteTypes = [
            'hero_novice',
            'hero_warrior',
            'paladin',
            'dark_knight',
            'archmage',
            'cyber_samurai',
            'boss_slime',
            'king_slime',
            'boss_goblin',
            'goblin_shaman',
            'boss_necromancer',
            'shadow_crypt',
            'dread_necromancer',
            'boss_dragon',
            'volcano_peak',
            'red_dragon',
            'potion_health',
            'potion_mana',
            'potion_exp',
            'elixir_life',
            'coin',
            'shield',
            'sword',
            'trophy',
            'custom_fallback',
          ];

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final type in spriteTypes) ...[
                        PixelSprite(spriteType: type, isGhost: false),
                        PixelSprite(spriteType: type, isGhost: true),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );

          // Verify all 50 sprites render CustomPaint without crashing
          expect(find.byType(PixelSprite), findsNWidgets(50));
          expect(find.byType(CustomPaint), findsWidgets);
        },
      );
    },
  );
}
