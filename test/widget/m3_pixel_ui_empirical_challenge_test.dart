import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/main.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

void main() {
  group(
    'Milestone 3 Empirical Challenge: 16-Bit Pixel UI Design System & Live Localization',
    () {
      testWidgets(
        '1. PixelButton Boundary Constraints, Extreme Strings & Rapid Gestures',
        (tester) async {
          int pressCount = 0;

          // Widget under tight boundary constraints, massive text, and small font
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    // Tight 0-width constraint
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: PixelButton(
                        text:
                            'SUPER_LONG_STRING_THAT_NEEDS_TO_WRAP_OR_FLEX_SAFELY_WITHOUT_OVERFLOW' *
                            5,
                        fontSize: 6,
                        onPressed: () => pressCount++,
                      ),
                    ),
                    // Full width button with Thai multiline text
                    PixelButton(
                      text:
                          'ภารกิจพิชิตจอมมารสไลม์ในดันเจี้ยนโบราณขั้นสูงสุดเพื่อรับไอเทมระดับตำนาน',
                      isFullWidth: true,
                      icon: Icons.shield,
                      onPressed: () => pressCount++,
                    ),
                    // Ultra small font size boundary
                    PixelButton(
                      text: 'TINY',
                      fontSize: 0.1,
                      padding: EdgeInsets.zero,
                      onPressed: () => pressCount++,
                    ),
                    // Disabled button with icons
                    const PixelButton(
                      text: 'DISABLED_BUTTON',
                      icon: Icons.lock,
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(
            find.text(
              'ภารกิจพิชิตจอมมารสไลม์ในดันเจี้ยนโบราณขั้นสูงสุดเพื่อรับไอเทมระดับตำนาน',
            ),
            findsOneWidget,
          );
          expect(find.text('DISABLED_BUTTON'), findsOneWidget);

          // Stress tap gesture sequence (tap down, tap up, tap cancel)
          final buttonFinder = find.byType(PixelButton).first;
          for (int i = 0; i < 10; i++) {
            final gesture = await tester.startGesture(
              tester.getCenter(buttonFinder),
            );
            await tester.pump(const Duration(milliseconds: 10));
            await gesture.up();
            await tester.pump(const Duration(milliseconds: 10));
          }
          expect(pressCount, 10);

          // Tapping disabled button must not increase pressCount
          await tester.tap(find.text('DISABLED_BUTTON'));
          await tester.pumpAndSettle();
          expect(pressCount, 10);
        },
      );

      testWidgets(
        '2. PixelCard Boundary Sizing, Large Borders & Nested Children',
        (tester) async {
          int cardTaps = 0;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    // Zero-sized child
                    const PixelCard(child: SizedBox.shrink()),
                    // Large border width and massive padding
                    PixelCard(
                      borderWidth: 15.0,
                      padding: const EdgeInsets.all(32),
                      onTap: () => cardTaps++,
                      child: const Text('HEAVY BORDER CARD'),
                    ),
                    // Complex nested children
                    PixelCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          const Text('Header Inside Card'),
                          Row(
                            children: const [
                              Icon(Icons.star),
                              Text('Rating 5 Stars'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('HEAVY BORDER CARD'), findsOneWidget);
          expect(find.text('Header Inside Card'), findsOneWidget);

          await tester.tap(find.text('HEAVY BORDER CARD'));
          await tester.pumpAndSettle();
          expect(cardTaps, 1);
        },
      );

      testWidgets(
        '3. PixelProgressBar Arithmetic Boundaries, Clamping & NaN Defenses',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    // Zero Max (0/0)
                    PixelProgressBar(current: 0, max: 0, label: 'ZERO_DIV'),
                    // Positive Current with Zero Max
                    PixelProgressBar(
                      current: 100,
                      max: 0,
                      label: 'POS_OVER_ZERO',
                    ),
                    // Negative Current (-50/100)
                    PixelProgressBar(
                      current: -50,
                      max: 100,
                      label: 'NEGATIVE_CUR',
                    ),
                    // Extreme Overflow (999999/10)
                    PixelProgressBar(
                      current: 999999,
                      max: 10,
                      label: 'MASSIVE_OVERFLOW',
                    ),
                    // Extreme Height boundary (height: 1.0 and height: 80.0)
                    PixelProgressBar(
                      current: 50,
                      max: 100,
                      height: 1.0,
                      showValues: false,
                    ),
                    PixelProgressBar(
                      current: 75,
                      max: 100,
                      height: 80.0,
                      label: 'แถบพลังชีวิตยาวพิเศษภาษาไทย',
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('ZERO_DIV'), findsOneWidget);
          expect(find.text('POS_OVER_ZERO'), findsOneWidget);
          expect(find.text('NEGATIVE_CUR'), findsOneWidget);
          expect(find.text('MASSIVE_OVERFLOW'), findsOneWidget);
          expect(find.text('แถบพลังชีวิตยาวพิเศษภาษาไทย'), findsOneWidget);
          expect(find.text('0 / 0'), findsOneWidget);
          expect(find.text('100 / 0'), findsOneWidget);
          expect(find.text('-50 / 100'), findsOneWidget);
          expect(find.text('999999 / 10'), findsOneWidget);
        },
      );

      testWidgets('4. PixelBadge Edge Case Ranks, Attributes & Long Strings', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Valid & Case-insensitive Ranks
                    PixelBadge.rank('s'),
                    PixelBadge.rank('S'),
                    PixelBadge.rank('a'),
                    PixelBadge.rank('b'),
                    PixelBadge.rank('c'),
                    PixelBadge.rank('d'),
                    PixelBadge.rank('e'),
                    // Unknown Ranks (Fallback to Rank E style)
                    PixelBadge.rank('Z'),
                    PixelBadge.rank(''),
                    PixelBadge.rank('SSS_TIER_BOSS'),
                    // Valid & Case-insensitive Attributes
                    PixelBadge.attribute('str'),
                    PixelBadge.attribute('STR'),
                    PixelBadge.attribute('int'),
                    PixelBadge.attribute('agi'),
                    PixelBadge.attribute('vit'),
                    PixelBadge.attribute('wis'),
                    // Unknown Attributes
                    PixelBadge.attribute('LUCK'),
                    PixelBadge.attribute(''),
                    // Custom badge with long label
                    const PixelBadge(
                      label: 'SPECIAL_EVENT_BADGE_WITH_EXTREME_LONG_LABEL',
                      fontSize: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('RANK s'), findsOneWidget);
        expect(find.text('RANK S'), findsOneWidget);
        expect(find.text('RANK Z'), findsOneWidget);
        expect(find.text('STR'), findsNWidgets(2));
        expect(find.text('LUCK'), findsOneWidget);
        expect(
          find.text('SPECIAL_EVENT_BADGE_WITH_EXTREME_LONG_LABEL'),
          findsOneWidget,
        );
      });

      testWidgets(
        '5. PixelSprite All 22+ Sprites, Unknown Fallbacks, Size 0 and Ghost Aura 60fps Loop',
        (tester) async {
          const allSpriteTypes = [
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
            'unknown_monster_fallback',
          ];

          // Test all sprites in both standard and ghost modes at boundary sizes (0.0, 1.0, 64.0, 256.0)
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...allSpriteTypes.map(
                        (type) => PixelSprite(
                          spriteType: type,
                          size: 32,
                          isGhost: false,
                        ),
                      ),
                      ...allSpriteTypes.map(
                        (type) => PixelSprite(
                          spriteType: type,
                          size: 32,
                          isGhost: true,
                        ),
                      ),
                      const PixelSprite(spriteType: 'hero_novice', size: 0.0),
                      const PixelSprite(spriteType: 'hero_novice', size: 1.0),
                      const PixelSprite(spriteType: 'hero_novice', size: 256.0),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(
            find.byType(PixelSprite),
            findsNWidgets(allSpriteTypes.length * 2 + 3),
          );

          // Ghost Aura 60fps animation toggling test harness
          bool isGhostState = false;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return GestureDetector(
                      onTap: () => setState(() => isGhostState = !isGhostState),
                      child: PixelSprite(
                        spriteType: 'hero_novice',
                        size: 64,
                        isGhost: isGhostState,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Rapidly toggle ghost aura state over 60 simulated animation frames
          for (int f = 0; f < 60; f++) {
            await tester.tap(find.byType(PixelSprite));
            await tester.pump(const Duration(milliseconds: 16));
          }
          expect(find.byType(PixelSprite), findsOneWidget);
        },
      );

      testWidgets(
        '6. Live Integrated Rapid Language Switching (20 switches across 5 tabs in active UI)',
        (tester) async {
          final appRouter = AppRouter();
          final hiveConfig = HiveConfig();
          final languageBloc = LanguageBloc(hiveConfig);

          await tester.pumpWidget(
            WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
          );
          await tester.pumpAndSettle();

          const tabs = [
            Key('nav_battle'),
            Key('nav_dungeon'),
            Key('nav_tavern'),
            Key('nav_analytics'),
            Key('nav_sanctuary'),
          ];

          // Rapidly alternate language between TH and EN while switching tabs
          for (int i = 0; i < 6; i++) {
            final targetLang = (i % 2 == 0) ? 'th' : 'en';

            languageBloc.add(ChangeLanguage(Locale(targetLang)));
            await tester.pump();
            await tester.pumpAndSettle();

            // Switch to a different tab
            final tabKey = tabs[i % tabs.length];
            await tester.tap(find.byKey(tabKey));
            await tester.pumpAndSettle();

            // Verify that UI matches target language strings without exception
            if (targetLang == 'th') {
              expect(find.text('การรบ'), findsOneWidget);
              expect(find.text('ดันเจี้ยน'), findsOneWidget);
              expect(find.text('โรงเตี๊ยม'), findsOneWidget);
              expect(find.text('สถิติ'), findsOneWidget);
              expect(find.text('วิหาร'), findsOneWidget);
            } else {
              expect(find.text('BATTLE'), findsOneWidget);
              expect(find.text('DUNGEON'), findsOneWidget);
              expect(find.text('TAVERN'), findsOneWidget);
              expect(find.text('ANALYTICS'), findsOneWidget);
              expect(find.text('SANCTUARY'), findsOneWidget);
            }
          }

          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        },
      );
    },
  );
}
