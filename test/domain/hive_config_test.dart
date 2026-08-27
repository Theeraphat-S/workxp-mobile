import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:workxp/domain/datasource/hive_config.dart';

void main() {
  late Directory tempDir;
  late HiveConfig hiveConfig;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('workxp_hive_test_');
    Hive.init(tempDir.path);
    hiveConfig = HiveConfig();
    await hiveConfig.init(boxName: 'test_preferences');
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HiveConfig Tests', () {
    test('1. Default values match standard specifications', () {
      expect(hiveConfig.audioEnabled, isTrue);
      expect(hiveConfig.hapticEnabled, isTrue);
      expect(hiveConfig.locale, equals('en'));
      expect(hiveConfig.crtScanlinesEnabled, isTrue);
      expect(hiveConfig.visualTheme, equals('default'));
      expect(hiveConfig.streakShields, equals(0));
      expect(hiveConfig.lastActiveDate, isNull);
    });

    test('2. Modifying settings persists to Hive storage', () async {
      await hiveConfig.setAudioEnabled(false);
      await hiveConfig.setHapticEnabled(false);
      await hiveConfig.setLocale('th');
      await hiveConfig.setCrtScanlinesEnabled(false);
      await hiveConfig.setVisualTheme('theme_amber');
      await hiveConfig.setStreakShields(3);

      final now = DateTime(2026, 8, 27, 12, 0);
      await hiveConfig.setLastActiveDate(now);

      expect(hiveConfig.audioEnabled, isFalse);
      expect(hiveConfig.hapticEnabled, isFalse);
      expect(hiveConfig.locale, equals('th'));
      expect(hiveConfig.crtScanlinesEnabled, isFalse);
      expect(hiveConfig.visualTheme, equals('theme_amber'));
      expect(hiveConfig.streakShields, equals(3));
      expect(hiveConfig.lastActiveDate, equals(now));
    });

    test('3. Generic key-value and clear methods', () async {
      await hiveConfig.put('custom_key', 'custom_value');
      expect(hiveConfig.get<String>('custom_key'), equals('custom_value'));

      await hiveConfig.delete('custom_key');
      expect(hiveConfig.get<String>('custom_key'), isNull);

      await hiveConfig.setLocale('th');
      await hiveConfig.clear();
      expect(hiveConfig.locale, equals('en')); // Reverts to default
    });
  });
}
