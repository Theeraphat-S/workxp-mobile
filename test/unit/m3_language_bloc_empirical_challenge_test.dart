import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

void main() {
  group('Milestone 3 Empirical Challenge: LanguageBloc Stress & Concurrency', () {
    late HiveConfig hiveConfig;

    setUp(() {
      hiveConfig = HiveConfig();
    });

    test('1. Rapid Language Oscillation (100 alternating switches synchronously)', () async {
      final bloc = LanguageBloc(hiveConfig);
      final emittedStates = <LanguageState>[];
      final subscription = bloc.stream.listen(emittedStates.add);

      const cycles = 100;
      for (int i = 0; i < cycles; i++) {
        final targetLocale = (i % 2 == 0) ? const Locale('th') : const Locale('en');
        bloc.add(ChangeLanguage(targetLocale));
      }

      // Allow event queue to drain
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(emittedStates.length, cycles);
      // Final state must be 'en' (since 99 % 2 == 1 -> 'en')
      expect(bloc.state.languageCode, 'en');
      expect(bloc.state.isEnglish, isTrue);
      expect(bloc.state.isThai, isFalse);
      expect(hiveConfig.locale, 'en');

      await subscription.cancel();
      await bloc.close();
    });

    test('2. Concurrent Asynchronous Language Switching (30 parallel Futures)', () async {
      final bloc = LanguageBloc(hiveConfig);
      final futures = <Future<void>>[];

      for (int i = 0; i < 30; i++) {
        final code = (i % 2 == 0) ? 'th' : 'en';
        futures.add(Future.microtask(() {
          bloc.add(ChangeLanguage(Locale(code)));
        }));
      }

      await Future.wait(futures);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Must remain in a consistent state without throw
      expect(bloc.state.languageCode, isIn(['th', 'en']));
      expect(hiveConfig.locale, bloc.state.languageCode);

      await bloc.close();
    });

    test('3. Fallback, International Locales and State Invariants', () async {
      final bloc = LanguageBloc(hiveConfig);

      // Non-standard locales (e.g. Japanese)
      bloc.add(const ChangeLanguage(Locale('ja')));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.languageCode, 'ja');
      expect(bloc.state.isThai, isFalse);
      expect(bloc.state.isEnglish, isFalse);

      // German locale
      bloc.add(const ChangeLanguage(Locale('de')));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.languageCode, 'de');
      expect(bloc.state.isThai, isFalse);
      expect(bloc.state.isEnglish, isFalse);

      // Re-switch to Thai
      bloc.add(const ChangeLanguage(Locale('th')));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.languageCode, 'th');
      expect(bloc.state.isThai, isTrue);
      expect(bloc.state.isEnglish, isFalse);

      // Switch to English
      bloc.add(const ChangeLanguage(Locale('en')));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.languageCode, 'en');
      expect(bloc.state.isThai, isFalse);
      expect(bloc.state.isEnglish, isTrue);

      await bloc.close();
    });

    test('4. Hive Persistence Synchronization & Immediate Reload', () async {
      final bloc = LanguageBloc(hiveConfig);

      bloc.add(const ChangeLanguage(Locale('th')));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(hiveConfig.locale, 'th');

      // Mutate storage externally and trigger LoadLanguage
      await hiveConfig.setLocale('en');
      bloc.add(const LoadLanguage());
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.languageCode, 'en');
      expect(bloc.state.isEnglish, isTrue);

      await bloc.close();
    });

    test('5. Lifecycle Stress: 50 Rapid Instantiations & Disposals', () async {
      for (int i = 0; i < 50; i++) {
        final config = HiveConfig();
        final code = (i % 2 == 0) ? 'th' : 'en';
        await config.setLocale(code);

        final bloc = LanguageBloc(config);
        expect(bloc.state.languageCode, code);

        bloc.add(ChangeLanguage(Locale(code == 'th' ? 'en' : 'th')));
        await Future<void>.delayed(const Duration(milliseconds: 2));

        await bloc.close();
      }
    });

    test('6. Dispatching events to Closed Bloc throws StateError defensively', () async {
      final bloc = LanguageBloc(hiveConfig);
      await bloc.close();

      expect(
        () => bloc.add(const ChangeLanguage(Locale('th'))),
        throwsA(isA<StateError>()),
      );
    });
  });
}
