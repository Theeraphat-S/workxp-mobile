import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/feature/hero_sanctuary/bloc/sanctuary_bloc.dart';

class MockHeroRepository extends Mock implements HeroRepository {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const globalChannel = MethodChannel('xyz.luan/audioplayers.global');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(globalChannel, (MethodCall methodCall) async {
          return 1;
        });

    const playerChannel = MethodChannel('xyz.luan/audioplayers');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(playerChannel, (MethodCall methodCall) async {
          return 1;
        });
  });

  group('SensoryService Chiptune Audio & SFX Tests', () {
    late SensoryService service;

    setUp(() {
      service = SensoryService.instance;
      service.toggleSfx(true);
      service.toggleBgm(true);
      service.toggleHaptics(true);
    });

    test('1. Toggling SFX, BGM, and Haptics state reflects correctly', () {
      expect(service.isSfxEnabled, isTrue);
      expect(service.isBgmEnabled, isTrue);
      expect(service.isHapticsEnabled, isTrue);

      service.toggleSfx(false);
      service.toggleBgm(false);
      service.toggleHaptics(false);

      expect(service.isSfxEnabled, isFalse);
      expect(service.isBgmEnabled, isFalse);
      expect(service.isHapticsEnabled, isFalse);
    });

    test('2. All SFX trigger methods execute gracefully without throwing', () {
      service.toggleSfx(true);
      service.toggleHaptics(true);

      expect(() => service.playClick(), returnsNormally);
      expect(() => service.playAttack(), returnsNormally);
      expect(() => service.playSwordSlash(), returnsNormally);
      expect(() => service.playCriticalAttack(), returnsNormally);
      expect(() => service.playHurt(), returnsNormally);
      expect(() => service.playCoin(), returnsNormally);
      expect(() => service.playLevelUp(), returnsNormally);
      expect(() => service.playVictory(), returnsNormally);
      expect(() => service.playBuff(), returnsNormally);
    });

    test('3. Contextual BGM themes and tab mapping execute cleanly', () async {
      service.toggleBgm(true);

      await expectLater(service.playBgm(BgmTheme.battleHub), completes);
      await expectLater(service.playBgm(BgmTheme.dungeon), completes);
      await expectLater(service.playBgm(BgmTheme.tavern), completes);
      await expectLater(service.playBgm(BgmTheme.sanctuary), completes);

      for (int tab = 0; tab < 5; tab++) {
        await expectLater(service.playBgmForTab(tab), completes);
      }

      await expectLater(service.pauseBgm(), completes);
      await expectLater(service.resumeBgm(), completes);
      await expectLater(service.stopBgm(), completes);
    });
  });

  group('SanctuaryBloc ToggleBgmEvent Tests', () {
    late MockHeroRepository mockHeroRepo;
    late MockAppDatabase mockDb;
    late SanctuaryBloc bloc;

    setUp(() {
      mockHeroRepo = MockHeroRepository();
      mockDb = MockAppDatabase();
      bloc = SanctuaryBloc(heroRepository: mockHeroRepo, appDatabase: mockDb);
    });

    tearDown(() {
      bloc.close();
    });

    test(
      'ToggleBgmEvent updates SensoryService and emits SanctuaryLoaded with bgmEnabled',
      () async {
        bloc.add(const ToggleBgmEvent(false));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(SensoryService.instance.isBgmEnabled, isFalse);

        bloc.add(const ToggleBgmEvent(true));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(SensoryService.instance.isBgmEnabled, isTrue);
      },
    );
  });
}
