import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables (.env)
/// with safe runtime fallbacks.
class AppConfig {
  final String appEnv;
  final String appName;
  final String apiBaseUrl;
  final bool enableAnalytics;
  final bool enableSoundEffects;
  final bool enableHapticFeedback;
  final String defaultLocale;
  final String dbName;

  const AppConfig({
    this.appEnv = 'development',
    this.appName = 'WorkXP',
    this.apiBaseUrl = 'https://api.workxp.local',
    this.enableAnalytics = true,
    this.enableSoundEffects = true,
    this.enableHapticFeedback = true,
    this.defaultLocale = 'en',
    this.dbName = 'workxp.sqlite',
  });

  /// Factory constructor to parse configuration from loaded dotenv environment.
  factory AppConfig.fromEnv() {
    if (!dotenv.isInitialized) {
      return const AppConfig();
    }
    return AppConfig(
      appEnv: dotenv.maybeGet('APP_ENV') ?? 'development',
      appName: dotenv.maybeGet('APP_NAME') ?? 'WorkXP',
      apiBaseUrl: dotenv.maybeGet('API_BASE_URL') ?? 'https://api.workxp.local',
      enableAnalytics: _parseBool(
        dotenv.maybeGet('ENABLE_ANALYTICS'),
        defaultValue: true,
      ),
      enableSoundEffects: _parseBool(
        dotenv.maybeGet('ENABLE_SOUND_EFFECTS'),
        defaultValue: true,
      ),
      enableHapticFeedback: _parseBool(
        dotenv.maybeGet('ENABLE_HAPTIC_FEEDBACK'),
        defaultValue: true,
      ),
      defaultLocale: dotenv.maybeGet('DEFAULT_LOCALE') ?? 'en',
      dbName: dotenv.maybeGet('DB_NAME') ?? 'workxp.sqlite',
    );
  }

  static bool _parseBool(String? value, {bool defaultValue = false}) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    final lower = value.trim().toLowerCase();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }

  /// Whether the current environment is development.
  bool get isDevelopment => appEnv.toLowerCase() == 'development';

  /// Whether the current environment is production.
  bool get isProduction => appEnv.toLowerCase() == 'production';

  /// Whether the current environment is test.
  bool get isTest => appEnv.toLowerCase() == 'test';

  /// Safely loads environment file and creates an [AppConfig] instance.
  static Future<AppConfig> load({String fileName = '.env'}) async {
    try {
      await dotenv.load(fileName: fileName);
    } catch (_) {
      // Safe fallback if .env file is missing or in unit testing environments
    }
    return AppConfig.fromEnv();
  }
}
