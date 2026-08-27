import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';

void main() {
  group('LanguageBloc Unit Tests', () {
    late HiveConfig hiveConfig;

    setUp(() {
      hiveConfig = HiveConfig();
    });

    test('initial state defaults to HiveConfig locale (en)', () {
      final bloc = LanguageBloc(hiveConfig);
      expect(bloc.state.locale, const Locale('en'));
      expect(bloc.state.languageCode, 'en');
      expect(bloc.state.isEnglish, isTrue);
      expect(bloc.state.isThai, isFalse);
      bloc.close();
    });

    test('initial state respects preexisting HiveConfig locale (th)', () async {
      await hiveConfig.setLocale('th');
      final bloc = LanguageBloc(hiveConfig);
      expect(bloc.state.locale, const Locale('th'));
      expect(bloc.state.languageCode, 'th');
      expect(bloc.state.isThai, isTrue);
      expect(bloc.state.isEnglish, isFalse);
      bloc.close();
    });

    blocTest<LanguageBloc, LanguageState>(
      'emits updated LanguageState and persists to Hive when ChangeLanguage is added',
      build: () => LanguageBloc(hiveConfig),
      act: (bloc) => bloc.add(const ChangeLanguage(Locale('th'))),
      expect: () => [const LanguageState(Locale('th'))],
      verify: (_) {
        expect(hiveConfig.locale, 'th');
      },
    );

    blocTest<LanguageBloc, LanguageState>(
      'emits en LanguageState and persists to Hive when switching back to en',
      build: () {
        hiveConfig.setLocale('th');
        return LanguageBloc(hiveConfig);
      },
      act: (bloc) => bloc.add(const ChangeLanguage(Locale('en'))),
      expect: () => [const LanguageState(Locale('en'))],
      verify: (_) {
        expect(hiveConfig.locale, 'en');
      },
    );

    blocTest<LanguageBloc, LanguageState>(
      'LoadLanguage reloads current locale from Hive',
      build: () => LanguageBloc(hiveConfig),
      act: (bloc) async {
        await hiveConfig.setLocale('th');
        bloc.add(const LoadLanguage());
      },
      expect: () => [const LanguageState(Locale('th'))],
    );

    test('LanguageEvent and LanguageState equality and props', () {
      const event1 = ChangeLanguage(Locale('en'));
      const event2 = ChangeLanguage(Locale('en'));
      const event3 = ChangeLanguage(Locale('th'));
      const loadEvent1 = LoadLanguage();
      const loadEvent2 = LoadLanguage();

      expect(event1, equals(event2));
      expect(event1 == event3, isFalse);
      expect(loadEvent1, equals(loadEvent2));
      expect(loadEvent1.props, isEmpty);

      const state1 = LanguageState(Locale('en'));
      const state2 = LanguageState(Locale('en'));
      const state3 = LanguageState(Locale('th'));

      expect(state1, equals(state2));
      expect(state1 == state3, isFalse);
      expect(state1.props, [const Locale('en')]);
    });
  });
}
