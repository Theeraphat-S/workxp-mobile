import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_theme.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/crt_scanline_overlay.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

void main() {
  group('16-Bit Shared Design System Widgets Test', () {
    testWidgets(
      'PixelButton renders text, icon, and triggers callback on tap',
      (tester) async {
        int tapCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PixelButton(
                text: 'STRIKE BOSS',
                icon: Icons.flash_on,
                onPressed: () {
                  tapCount++;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('STRIKE BOSS'), findsOneWidget);
        expect(find.byIcon(Icons.flash_on), findsOneWidget);

        // Tap button and verify depression & callback
        await tester.tap(find.text('STRIKE BOSS'));
        await tester.pumpAndSettle();
        expect(tapCount, 1);
      },
    );

    testWidgets('PixelButton renders disabled style when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelButton(text: 'LOCKED ACTION', onPressed: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('LOCKED ACTION'), findsOneWidget);
    });

    testWidgets('PixelCard renders child, borders, and handles onTap', (
      tester,
    ) async {
      int cardTaps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PixelCard(
              onTap: () => cardTaps++,
              child: const Text('Quest Card Inside'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quest Card Inside'), findsOneWidget);

      await tester.tap(find.text('Quest Card Inside'));
      await tester.pumpAndSettle();
      expect(cardTaps, 1);
    });

    testWidgets(
      'PixelProgressBar calculates ratios and clamps boundary values correctly',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  PixelProgressBar(current: 50, max: 100, label: 'HEALTH'),
                  PixelProgressBar(current: 0, max: 100, label: 'MANA_EMPTY'),
                  PixelProgressBar(
                    current: 120,
                    max: 100,
                    label: 'OVERFLOW_EXP',
                  ),
                  PixelProgressBar(current: 10, max: 0, label: 'ZERO_MAX'),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('HEALTH'), findsOneWidget);
        expect(find.text('50 / 100'), findsOneWidget);
        expect(find.text('MANA_EMPTY'), findsOneWidget);
        expect(find.text('0 / 100'), findsOneWidget);
        expect(find.text('OVERFLOW_EXP'), findsOneWidget);
        expect(find.text('120 / 100'), findsOneWidget);
        expect(find.text('ZERO_MAX'), findsOneWidget);
      },
    );

    testWidgets('PixelBadge factory renders all rank and attribute tiers', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PixelBadge.rank('S'),
                PixelBadge.rank('A'),
                PixelBadge.rank('B'),
                PixelBadge.rank('C'),
                PixelBadge.rank('D'),
                PixelBadge.rank('E'),
                PixelBadge.attribute('STR'),
                PixelBadge.attribute('INT'),
                PixelBadge.attribute('AGI'),
                PixelBadge.attribute('VIT'),
                PixelBadge.attribute('WIS'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('RANK S'), findsOneWidget);
      expect(find.text('RANK A'), findsOneWidget);
      expect(find.text('RANK B'), findsOneWidget);
      expect(find.text('RANK C'), findsOneWidget);
      expect(find.text('RANK D'), findsOneWidget);
      expect(find.text('RANK E'), findsOneWidget);

      expect(find.text('STR'), findsOneWidget);
      expect(find.text('INT'), findsOneWidget);
      expect(find.text('AGI'), findsOneWidget);
      expect(find.text('VIT'), findsOneWidget);
      expect(find.text('WIS'), findsOneWidget);
    });

    testWidgets(
      'PixelSprite paints knight, mages, samurais, bosses, and items',
      (tester) async {
        const sprites = [
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
          'boss_dragon',
          'red_dragon',
          'potion_health',
          'potion_mana',
          'potion_exp',
          'elixir_life',
          'coin',
          'shield',
          'sword',
          'trophy',
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: sprites
                      .map(
                        (s) => PixelSprite(
                          spriteType: s,
                          isGhost: s == 'hero_novice',
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PixelSprite), findsNWidgets(sprites.length));
      },
    );

    testWidgets('CrtScanlineOverlay wraps child with scanline effects', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrtScanlineOverlay(enabled: true, child: Text('CRT Content')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CRT Content'), findsOneWidget);
      expect(find.byType(CrtScanlineOverlay), findsOneWidget);
    });

    test('PixelTheme builds dark themes with amber and green variants', () {
      final defaultDark = PixelTheme.darkTheme();
      expect(defaultDark.brightness, Brightness.dark);
      expect(defaultDark.primaryColor, PixelColors.coinGold);

      final amberTheme = PixelTheme.darkTheme(themeName: 'theme_amber');
      expect(amberTheme.primaryColor, PixelColors.coinAmber);

      final greenTheme = PixelTheme.darkTheme(themeName: 'theme_green');
      expect(greenTheme.primaryColor, PixelColors.hpGreen);
    });

    test('PixelTypography provides fallback text styles cleanly', () {
      final header = PixelTypography.pixelHeader(fontSize: 18);
      expect(header.fontSize, 18);

      final subheader = PixelTypography.pixelSubheader(fontSize: 12);
      expect(subheader.fontSize, 12);

      final body = PixelTypography.pixelBody(fontSize: 14);
      expect(body.fontSize, 14);

      final standard = PixelTypography.standardBody(fontSize: 13);
      expect(standard.fontSize, 13);
    });
  });
}
