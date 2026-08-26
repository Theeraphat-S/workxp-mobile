import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/screens/world_map/world_map_screen.dart';

void main() {
  group('Ticket 06: Dungeon World Map & Boss Chapter Progression Slice', () {
    test(
      'DungeonNotifier applies damage and unlocks sequential chapters on boss defeat',
      () {
        final notifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1).copyWith(currentHp: 50),
            currentChapter: 1,
            unlockedChapters: [1],
          ),
        );

        // Deal 50 damage -> defeats King Slime
        notifier.applyDamage(50);

        expect(notifier.state.activeBoss.currentHp, 0);
        expect(notifier.state.activeBoss.isDefeated, true);
        expect(notifier.state.isVictory, true);
        expect(notifier.state.unlockedChapters.contains(2), true);
        expect(notifier.state.defeatedBosses.length, 1);
        expect(notifier.state.defeatedBosses.first.name, 'King Slime');

        // Select Chapter 2
        notifier.selectChapter(2);
        expect(notifier.state.currentChapter, 2);
        expect(notifier.state.activeBoss.name, 'Goblin Shaman');
        expect(notifier.state.activeBoss.maxHp, 500);
      },
    );

    testWidgets(
      'World Map UI renders chapters, displays nodes and Bestiary dialog',
      (tester) async {
        final dungeonNotifier = DungeonNotifier(
          DungeonState(
            activeBoss: BossModel.chapterBoss(1),
            currentChapter: 1,
            unlockedChapters: [1],
          ),
        );

        final container = ProviderContainer(
          overrides: [dungeonProvider.overrideWith((ref) => dungeonNotifier)],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: WorldMapScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('WORLD MAP'), findsOneWidget);
        expect(find.text('DUNGEON EXPEDITION'), findsOneWidget);
        expect(find.text('CHAPTER 1'), findsOneWidget);
        expect(find.text('SLIME FOREST'), findsOneWidget);
        expect(find.text('CHAPTER 2'), findsOneWidget);
        expect(find.text('GOBLIN KEEP'), findsOneWidget);

        // Open Bestiary Dialog
        final bestiaryBtn = find.text('BESTIARY');
        expect(bestiaryBtn, findsOneWidget);
        await tester.tap(bestiaryBtn);
        await tester.pumpAndSettle();

        expect(find.text('DUNGEON BESTIARY'), findsOneWidget);
        expect(find.text('CLOSE BESTIARY'), findsOneWidget);

        await tester.tap(find.text('CLOSE BESTIARY'));
        await tester.pumpAndSettle();
        expect(find.text('DUNGEON BESTIARY'), findsNothing);
      },
    );
  });
}
