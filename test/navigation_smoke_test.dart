import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/main.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/core/widgets/pixel_progress_bar.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';

void main() {
  group('Ticket 01: Foundation & Navigation Smoke Test', () {
    testWidgets('App renders and switches through all 5 tabs', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: WorkXpApp()));
      await tester.pumpAndSettle();

      // Verify Initial Screen: Battle Hub
      expect(find.text('BATTLE HUB'), findsOneWidget);
      expect(find.text('KING SLIME'), findsOneWidget);

      // Tap World Map Tab
      await tester.tap(find.text('MAP'));
      await tester.pumpAndSettle();
      expect(find.text('WORLD MAP'), findsOneWidget);
      expect(find.text('DUNGEON EXPEDITION'), findsOneWidget);

      // Tap Tavern Tab
      await tester.tap(find.text('TAVERN'));
      await tester.pumpAndSettle();
      expect(find.text('THE TAVERN'), findsOneWidget);
      expect(find.text('HERO PURSE'), findsOneWidget);

      // Tap Stats Tab
      await tester.tap(find.text('STATS'));
      await tester.pumpAndSettle();
      expect(find.text('HALL OF FAME'), findsOneWidget);
      expect(find.text('STATS & ANALYTICS ARCHIVES'), findsOneWidget);

      // Tap Hero Sanctuary Tab
      await tester.tap(find.text('HERO'));
      await tester.pumpAndSettle();
      expect(find.text('HERO SANCTUARY'), findsOneWidget);
      expect(find.text('ATTRIBUTES'), findsOneWidget);
    });

    testWidgets('Design System Components render without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const PixelCard(child: Text('Card Content')),
                  PixelButton(text: 'Attack', onPressed: () {}),
                  PixelBadge.rank('S'),
                  PixelBadge.attribute('STR'),
                  const PixelProgressBar(current: 75, max: 100, label: 'HP'),
                  const PixelSprite(spriteType: 'hero_novice', size: 32),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.text('Attack'), findsOneWidget);
      expect(find.text('RANK S'), findsOneWidget);
      expect(find.text('STR'), findsOneWidget);
      expect(find.text('75 / 100'), findsOneWidget);
    });
  });
}
