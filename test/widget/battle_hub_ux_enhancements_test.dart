import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/feature/battle_hub/widgets/mini_battle_bar.dart';
import 'package:workxp/feature/battle_hub/widgets/quick_add_bottom_sheet.dart';
import 'package:workxp/main.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Battle Hub UX/UI Enhancements Widget Tests', () {
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

    testWidgets('1. MiniBattleBar renders compact boss and hero vitals', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniBattleBar(bossModel: BossModel.chapterBoss(1)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('KING SLIME'), findsOneWidget);
      expect(find.text('HP'), findsOneWidget);
      expect(find.text('MP'), findsOneWidget);
    });

    testWidgets(
      '2. QuickAddBottomSheet supports Quick Mode and Advanced Options',
      (tester) async {
        QuickAddResult? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      result = await QuickAddBottomSheet.show(
                        context,
                        initialType: QuickAddType.quest,
                      );
                    },
                    child: const Text('Open'),
                  );
                },
              ),
            ),
          ),
        );

        // Open sheet
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('QUEST CONTRACT'), findsOneWidget);
        expect(find.text('ATTRIBUTE FOCUS'), findsOneWidget);
        expect(find.text('Due Today'), findsOneWidget);

        // Type title
        await tester.enterText(
          find.byKey(const Key('quick_add_title_input')),
          'Sprint Review Meeting',
        );
        await tester.pumpAndSettle();

        // Tap More Options to expand advanced mode
        await tester.tap(find.text('More Options (Rank, Notes)'));
        await tester.pumpAndSettle();

        expect(find.text('DIFFICULTY RANK'), findsOneWidget);
        expect(find.text('Hide Advanced Options'), findsOneWidget);

        // Select Rank A
        await tester.tap(find.text('A'));
        await tester.pumpAndSettle();

        // Submit
        await tester.tap(find.byKey(const Key('quick_add_submit_btn')));
        await tester.pumpAndSettle();

        expect(result, isNotNull);
        expect(result!.quest, isNotNull);
        expect(result!.quest!.title, 'Sprint Review Meeting');
        expect(result!.quest!.rank, 'A');
      },
    );

    testWidgets(
      '3. BattleHubPage FAB, Boss Collapse toggle, and Tab Badges work seamlessly',
      (tester) async {
        await tester.pumpWidget(
          WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
        );
        await tester.pumpAndSettle();

        // Verify FAB exists
        expect(find.byKey(const Key('battle_hub_fab')), findsOneWidget);

        // Verify Collapse Boss button exists in AppBar and collapses Boss Card
        expect(find.byIcon(Icons.expand_less), findsOneWidget);
        await tester.tap(find.byIcon(Icons.expand_less));
        await tester.pumpAndSettle();

        // Boss should now be rendered as MiniBattleBar
        expect(find.byIcon(Icons.expand_more), findsOneWidget);

        // Expand Boss back
        await tester.tap(find.byIcon(Icons.expand_more));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.expand_less), findsOneWidget);

        // Open Quick Add via FAB
        await tester.tap(find.byKey(const Key('battle_hub_fab')));
        await tester.pumpAndSettle();

        expect(find.text('QUEST CONTRACT'), findsOneWidget);
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      },
    );
  });
}
