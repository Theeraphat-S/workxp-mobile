import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/config/config.dart';
import 'package:workxp/locator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M1 Empirical Stress Test: AppConfig & Dotenv Edge Cases', () {
    test(
      '1. AppConfig.fromEnv handles empty and whitespace env inputs gracefully',
      () async {
        await dotenv.load(
          mergeWith: {
            'APP_ENV': '',
            'APP_NAME': '   ',
            'API_BASE_URL': 'http://localhost:8080/api/v1',
            'ENABLE_ANALYTICS': '   ',
            'ENABLE_SOUND_EFFECTS': '',
            'ENABLE_HAPTIC_FEEDBACK': 'invalid_boolean',
            'DEFAULT_LOCALE': '   ',
            'DB_NAME': '',
          },
        );

        final config = AppConfig.fromEnv();

        // Dotenv trims whitespace on parsing, returning ''
        expect(config.appEnv, isEmpty);
        expect(config.appName, isEmpty);
        expect(config.apiBaseUrl, 'http://localhost:8080/api/v1');
        // Boolean parser treats empty/whitespace/invalid as defaultValue or false
        expect(
          config.enableAnalytics,
          isTrue,
          reason: 'Empty string should fall back to defaultValue (true)',
        );
        expect(
          config.enableSoundEffects,
          isTrue,
          reason: 'Empty string should fall back to defaultValue (true)',
        );
        expect(
          config.enableHapticFeedback,
          isFalse,
          reason: 'Invalid string is not truthy, so false',
        );
        expect(config.isDevelopment, isFalse);
        expect(config.isProduction, isFalse);
        expect(config.isTest, isFalse);
      },
    );

    test(
      '1b. AppConfig.fromEnv when dotenv is completely uninitialized returns default AppConfig',
      () {
        dotenv.clean();
        expect(dotenv.isInitialized, isFalse);

        final config = AppConfig.fromEnv();
        expect(config.appName, 'WorkXP');
        expect(config.appEnv, 'development');
        expect(config.enableAnalytics, isTrue);
        expect(config.enableSoundEffects, isTrue);
        expect(config.enableHapticFeedback, isTrue);
        expect(config.isDevelopment, isTrue);
      },
    );

    test(
      '2. Boolean parsing matrix covers all truthy and falsy edge cases',
      () async {
        final truthyVariants = [
          'true',
          'TRUE',
          'True',
          '1',
          ' 1 ',
          'yes',
          'YES',
          ' Yes ',
        ];
        for (final truthy in truthyVariants) {
          await dotenv.load(
            mergeWith: {
              'ENABLE_ANALYTICS': truthy,
              'ENABLE_SOUND_EFFECTS': truthy,
              'ENABLE_HAPTIC_FEEDBACK': truthy,
            },
          );
          final config = AppConfig.fromEnv();
          expect(
            config.enableAnalytics,
            isTrue,
            reason: 'Variant "$truthy" should evaluate to true',
          );
          expect(
            config.enableSoundEffects,
            isTrue,
            reason: 'Variant "$truthy" should evaluate to true',
          );
          expect(
            config.enableHapticFeedback,
            isTrue,
            reason: 'Variant "$truthy" should evaluate to true',
          );
        }

        final falsyVariants = [
          'false',
          'FALSE',
          'False',
          '0',
          ' 0 ',
          'no',
          'NO',
          ' No ',
          'off',
          'OFF',
          'random',
          '-1',
          '2',
        ];
        for (final falsy in falsyVariants) {
          await dotenv.load(
            mergeWith: {
              'ENABLE_ANALYTICS': falsy,
              'ENABLE_SOUND_EFFECTS': falsy,
              'ENABLE_HAPTIC_FEEDBACK': falsy,
            },
          );
          final config = AppConfig.fromEnv();
          expect(
            config.enableAnalytics,
            isFalse,
            reason: 'Variant "$falsy" should evaluate to false',
          );
          expect(
            config.enableSoundEffects,
            isFalse,
            reason: 'Variant "$falsy" should evaluate to false',
          );
          expect(
            config.enableHapticFeedback,
            isFalse,
            reason: 'Variant "$falsy" should evaluate to false',
          );
        }
      },
    );

    test(
      '3. Environment case-insensitivity and exotic environment strings',
      () async {
        final envTestCases = [
          {
            'input': 'development',
            'isDev': true,
            'isProd': false,
            'isTest': false,
          },
          {
            'input': 'DEVELOPMENT',
            'isDev': true,
            'isProd': false,
            'isTest': false,
          },
          {
            'input': 'Development',
            'isDev': true,
            'isProd': false,
            'isTest': false,
          },
          {
            'input': 'production',
            'isDev': false,
            'isProd': true,
            'isTest': false,
          },
          {
            'input': 'PRODUCTION',
            'isDev': false,
            'isProd': true,
            'isTest': false,
          },
          {
            'input': 'Production',
            'isDev': false,
            'isProd': true,
            'isTest': false,
          },
          {'input': 'test', 'isDev': false, 'isProd': false, 'isTest': true},
          {'input': 'TEST', 'isDev': false, 'isProd': false, 'isTest': true},
          {'input': 'Test', 'isDev': false, 'isProd': false, 'isTest': true},
          {
            'input': 'staging',
            'isDev': false,
            'isProd': false,
            'isTest': false,
          },
          {'input': 'qa', 'isDev': false, 'isProd': false, 'isTest': false},
        ];

        for (final testCase in envTestCases) {
          await dotenv.load(
            mergeWith: {'APP_ENV': testCase['input'] as String},
          );
          final config = AppConfig.fromEnv();
          expect(config.isDevelopment, testCase['isDev']);
          expect(config.isProduction, testCase['isProd']);
          expect(config.isTest, testCase['isTest']);
        }
      },
    );

    test(
      '4. AppConfig.load with corrupt/missing files never crashes runtime',
      () async {
        final nonexistentConfig = await AppConfig.load(
          fileName: '.env.invalid.file.name.12345',
        );
        expect(nonexistentConfig, isNotNull);
        expect(nonexistentConfig.appName, isNotEmpty);

        final emptyNameConfig = await AppConfig.load(fileName: '');
        expect(emptyNameConfig, isNotNull);
      },
    );
  });

  group(
    'M1 Empirical Stress Test: Locator Lifecycle, Re-registration & Memory Collisions',
    () {
      setUp(() async {
        await resetLocator();
      });

      tearDown(() async {
        await resetLocator();
      });

      test(
        '1. Repeated setupLocator invocations do not throw registration collisions',
        () async {
          // Execute setupLocator 50 times consecutively to test idempotency and auto-reset
          for (int i = 0; i < 50; i++) {
            await setupLocator(
              customConfig: AppConfig(
                appName: 'StressApp_$i',
                appEnv: i % 2 == 0 ? 'development' : 'production',
              ),
            );

            expect(locator.isRegistered<AppConfig>(), isTrue);
            final currentConfig = locator<AppConfig>();
            expect(currentConfig.appName, 'StressApp_$i');
          }
        },
      );

      test(
        '2. Rapid interleaving of setupLocator and resetLocator (100 iterations)',
        () async {
          for (int i = 0; i < 100; i++) {
            expect(locator.isRegistered<AppConfig>(), isFalse);

            await setupLocator(customConfig: AppConfig(appName: 'Cycle_$i'));
            expect(locator.isRegistered<AppConfig>(), isTrue);
            expect(locator<AppConfig>().appName, 'Cycle_$i');

            await resetLocator();
            expect(locator.isRegistered<AppConfig>(), isFalse);
          }
        },
      );

      test(
        '3. resetLocator is idempotent when called multiple times consecutively',
        () async {
          await resetLocator();
          await resetLocator();
          await resetLocator();
          expect(locator.isRegistered<AppConfig>(), isFalse);
        },
      );

      test(
        '4. Accessing locator<AppConfig>() before setup or after reset throws predictably',
        () async {
          expect(() => locator<AppConfig>(), throwsA(isA<StateError>()));

          await setupLocator(loadEnvFile: false);
          expect(locator<AppConfig>(), isNotNull);

          await resetLocator();
          expect(() => locator<AppConfig>(), throwsA(isA<StateError>()));
        },
      );

      test(
        '5. customConfig always overrides file loading in setupLocator',
        () async {
          const explicitConfig = AppConfig(
            appEnv: 'production',
            appName: 'Explicit Override',
            apiBaseUrl: 'https://custom.override.app',
          );

          await setupLocator(customConfig: explicitConfig, loadEnvFile: true);

          final registeredConfig = locator<AppConfig>();
          expect(registeredConfig.appName, 'Explicit Override');
          expect(registeredConfig.apiBaseUrl, 'https://custom.override.app');
          expect(registeredConfig.isProduction, isTrue);
        },
      );

      test(
        '6. Complex URLs, query parameters and special characters in .env strings',
        () async {
          await dotenv.load(
            mergeWith: {
              'APP_NAME': 'WorkXP [Retro Edition]™ - 16-Bit RPG',
              'API_BASE_URL':
                  'https://api.workxp.app/v2/gateway?token=xyz==&mode=debug',
              'DB_NAME': 'workxp_special_123.sqlite',
            },
          );

          final config = AppConfig.fromEnv();
          expect(config.appName, 'WorkXP [Retro Edition]™ - 16-Bit RPG');
          expect(
            config.apiBaseUrl,
            'https://api.workxp.app/v2/gateway?token=xyz==&mode=debug',
          );
          expect(config.dbName, 'workxp_special_123.sqlite');
        },
      );

      test(
        '7. 1000-cycle rapid re-registration endurance and stability',
        () async {
          final stopwatch = Stopwatch()..start();
          for (int i = 0; i < 1000; i++) {
            await setupLocator(
              customConfig: AppConfig(appName: 'Endurance_$i'),
            );
          }
          stopwatch.stop();

          expect(locator.isRegistered<AppConfig>(), isTrue);
          expect(locator<AppConfig>().appName, 'Endurance_999');
          // Ensure 1000 async cycles complete in a reasonable time (< 3000ms)
          expect(stopwatch.elapsedMilliseconds, lessThan(3000));
        },
      );
    },
  );
}
