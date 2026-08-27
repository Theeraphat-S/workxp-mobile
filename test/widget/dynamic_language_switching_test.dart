import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/main.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

void main() {
  group('Dynamic Real-Time Language Switching Widget Tests', () {
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

    testWidgets('Isolated LanguageBloc BlocBuilder test', (tester) async {
      await tester.pumpWidget(
        BlocProvider<LanguageBloc>.value(
          value: languageBloc,
          child: MaterialApp(
            home: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                return Text('LANG: ${state.locale.languageCode}');
              },
            ),
          ),
        ),
      );
      expect(find.text('LANG: en'), findsOneWidget);

      languageBloc.add(const ChangeLanguage(Locale('th')));
      await tester.runAsync(
        () async => languageBloc.stream.firstWhere(
          (s) => s.locale.languageCode == 'th',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('LANG: th'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('Language switches dynamically between English and Thai', (
      tester,
    ) async {
      await tester.pumpWidget(
        WorkXpApp(appRouter: appRouter, languageBloc: languageBloc),
      );
      await tester.pumpAndSettle();

      // 1. Initial English state
      expect(find.text('BATTLE'), findsOneWidget);
      expect(find.text('DUNGEON'), findsOneWidget);
      expect(find.text('TAVERN'), findsOneWidget);
      expect(find.text('ANALYTICS'), findsOneWidget);
      expect(find.text('SANCTUARY'), findsOneWidget);

      // 2. Switch to Thai dynamically
      languageBloc.add(const ChangeLanguage(Locale('th')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_dungeon')));
      await tester.pumpAndSettle();

      expect(find.text('การรบ'), findsOneWidget);
      expect(find.text('ดันเจี้ยน'), findsOneWidget);
      expect(find.text('โรงเตี๊ยม'), findsOneWidget);
      expect(find.text('สถิติ'), findsOneWidget);
      expect(find.text('วิหาร'), findsOneWidget);

      // 3. Switch back to English
      languageBloc.add(const ChangeLanguage(Locale('en')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_battle')));
      await tester.pumpAndSettle();

      expect(find.text('BATTLE'), findsOneWidget);
      expect(find.text('DUNGEON'), findsOneWidget);
      expect(find.text('TAVERN'), findsOneWidget);
      expect(find.text('ANALYTICS'), findsOneWidget);
      expect(find.text('SANCTUARY'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  });
}
