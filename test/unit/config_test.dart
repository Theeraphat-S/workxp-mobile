import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/config/config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M1: AppConfig Unit Tests', () {
    test('1. AppConfig default constructor values match FLDP defaults', () {
      const config = AppConfig();

      expect(config.appEnv, 'development');
      expect(config.appName, 'WorkXP');
      expect(config.apiBaseUrl, 'https://api.workxp.local');
      expect(config.enableAnalytics, isTrue);
      expect(config.enableSoundEffects, isTrue);
      expect(config.enableHapticFeedback, isTrue);
      expect(config.defaultLocale, 'en');
      expect(config.dbName, 'workxp.sqlite');
      expect(config.isDevelopment, isTrue);
      expect(config.isProduction, isFalse);
      expect(config.isTest, isFalse);
    });

    test(
      '2. AppConfig.fromEnv correctly parses environment variables from dotenv',
      () async {
        await dotenv.load(
          mergeWith: {
            'APP_ENV': 'production',
            'APP_NAME': 'WorkXP Pro',
            'API_BASE_URL': 'https://api.workxp.app',
            'ENABLE_ANALYTICS': 'false',
            'ENABLE_SOUND_EFFECTS': '0',
            'ENABLE_HAPTIC_FEEDBACK': 'true',
            'DEFAULT_LOCALE': 'th',
            'DB_NAME': 'production.sqlite',
          },
        );

        final config = AppConfig.fromEnv();

        expect(config.appEnv, 'production');
        expect(config.appName, 'WorkXP Pro');
        expect(config.apiBaseUrl, 'https://api.workxp.app');
        expect(config.enableAnalytics, isFalse);
        expect(config.enableSoundEffects, isFalse);
        expect(config.enableHapticFeedback, isTrue);
        expect(config.defaultLocale, 'th');
        expect(config.dbName, 'production.sqlite');
        expect(config.isDevelopment, isFalse);
        expect(config.isProduction, isTrue);
      },
    );

    test('3. AppConfig.load handles missing or fallback gracefully', () async {
      final config = await AppConfig.load(fileName: '.env.nonexistent');
      expect(config.appName, isNotEmpty);
      expect(config.dbName, isNotEmpty);
    });
  });
}
