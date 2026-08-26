import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/screens/hero_sanctuary/hero_sanctuary_screen.dart';

void main() {
  group('Ticket 02: Hero Vitals, Attribute Stats & Leveling Slice', () {
    test('EXP progression formula calculates expected thresholds', () {
      expect(HeroModel.expTargetForLevel(1), 100);
      expect(HeroModel.expTargetForLevel(2), 125);
      expect(HeroModel.expTargetForLevel(3), 156);
      expect(HeroModel.expTargetForLevel(4), 195);
    });

    test(
      'HeroNotifier gains EXP, levels up, grants stat points and heals vitals',
      () {
        final notifier = HeroNotifier(
          const HeroModel(
            level: 1,
            currentExp: 0,
            currentHp: 40,
            currentMp: 20,
            unallocatedPoints: 0,
          ),
        );

        notifier.gainExp(150); // 100 needed for level 2, 50 left over

        final state = notifier.state;
        expect(state.level, 2);
        expect(state.currentExp, 50);
        expect(state.unallocatedPoints, 3);
        expect(state.currentHp, 100);
        expect(state.currentMp, 100);
      },
    );

    test('Hero damage drains HP and activates Ghost State at 0 HP', () {
      final notifier = HeroNotifier(const HeroModel(currentHp: 20, coins: 100));

      notifier.takeDamage(20);
      expect(notifier.state.currentHp, 0);
      expect(notifier.state.isGhost, true);

      // In Ghost State, EXP and Coins cannot be gained
      notifier.gainExp(50);
      notifier.gainCoins(50);
      expect(notifier.state.currentExp, 0);
      expect(notifier.state.coins, 100);

      // Revive
      notifier.reviveHero();
      expect(notifier.state.isGhost, false);
      expect(notifier.state.currentHp, 50);
    });

    test('Stat point allocation increases attribute and unlocks titles', () {
      final notifier = HeroNotifier(
        const HeroModel(str: 9, unallocatedPoints: 1),
      );

      final success = notifier.allocateStatPoint('STR');
      expect(success, true);
      expect(notifier.state.str, 10);
      expect(notifier.state.unallocatedPoints, 0);
      expect(notifier.state.unlockedTitles.contains('Iron Knight'), true);

      // Cannot allocate when 0 points remaining
      final fail = notifier.allocateStatPoint('STR');
      expect(fail, false);
    });

    testWidgets(
      'Hero Sanctuary UI displays stats and allows point allocation',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            heroProvider.overrideWith(
              (ref) => HeroNotifier(
                const HeroModel(
                  name: 'Arthur',
                  level: 1,
                  str: 5,
                  unallocatedPoints: 2,
                ),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: HeroSanctuaryScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('ARTHUR'), findsOneWidget);
        expect(find.text('POINTS: 2'), findsOneWidget);
        expect(find.text('ATTRIBUTES'), findsOneWidget);
        expect(find.text('EARNED TITLES'), findsOneWidget);
        expect(find.text('AVATAR SKINS'), findsOneWidget);

        // Tap + button for STR
        final plusButtons = find.text('+');
        expect(plusButtons, findsWidgets);
        await tester.tap(plusButtons.first);
        await tester.pumpAndSettle();

        expect(container.read(heroProvider).str, 6);
        expect(container.read(heroProvider).unallocatedPoints, 1);
      },
    );
  });
}
