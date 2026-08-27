import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

/// Local preferences and caching datasource backed by Hive.
class HiveConfig {
  HiveConfig([Box? box]) : _injectedBox = box;

  final Box? _injectedBox;
  Box? _box;
  final Map<String, dynamic> _memoryFallback = {};

  static const String defaultBoxName = 'workxp_preferences';

  // Keys
  static const String keyAudioEnabled = 'audio_enabled';
  static const String keyHapticEnabled = 'haptic_enabled';
  static const String keyLocale = 'locale';
  static const String keyCrtScanlines = 'crt_scanlines_enabled';
  static const String keyVisualTheme = 'visual_theme';
  static const String keyStreakShields = 'streak_shields';
  static const String keyLastActiveDate = 'last_active_date';

  /// Initializes Hive storage and opens the preferences box.
  Future<void> init({String boxName = defaultBoxName}) async {
    if (_injectedBox != null) {
      _box = _injectedBox;
      return;
    }

    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        try {
          final tempDir = Directory.systemTemp.createTempSync(
            'workxp_hive_fallback_',
          );
          Hive.init(tempDir.path);
        } catch (_) {}
        try {
          _box = await Hive.openBox(boxName);
        } catch (_) {
          _box = null;
        }
      }
    } catch (_) {
      _box = null;
    }
  }

  dynamic _getValue(String key, dynamic defaultValue) {
    if (_box != null && _box!.isOpen) {
      return _box!.get(key, defaultValue: defaultValue);
    }
    return _memoryFallback[key] ?? defaultValue;
  }

  Future<void> _setValue(String key, dynamic value) async {
    _memoryFallback[key] = value;
    if (_box != null && _box!.isOpen) {
      await _box!.put(key, value);
    }
  }

  // Audio Settings
  bool get audioEnabled => _getValue(keyAudioEnabled, true) as bool;

  Future<void> setAudioEnabled(bool value) async {
    await _setValue(keyAudioEnabled, value);
  }

  // Haptic Settings
  bool get hapticEnabled => _getValue(keyHapticEnabled, true) as bool;

  Future<void> setHapticEnabled(bool value) async {
    await _setValue(keyHapticEnabled, value);
  }

  // Locale Settings ('en' / 'th')
  String get locale => _getValue(keyLocale, 'en') as String;

  Future<void> setLocale(String value) async {
    await _setValue(keyLocale, value);
  }

  // Visual CRT Scanlines
  bool get crtScanlinesEnabled => _getValue(keyCrtScanlines, true) as bool;

  Future<void> setCrtScanlinesEnabled(bool value) async {
    await _setValue(keyCrtScanlines, value);
  }

  // Visual Theme Name ('default', 'theme_amber', 'theme_green', etc.)
  String get visualTheme => _getValue(keyVisualTheme, 'default') as String;

  Future<void> setVisualTheme(String value) async {
    await _setValue(keyVisualTheme, value);
  }

  // Active Streak Shield Buff Count
  int get streakShields => (_getValue(keyStreakShields, 0) as num).toInt();

  Future<void> setStreakShields(int value) async {
    await _setValue(keyStreakShields, value);
  }

  // Last Active Date for Day Cycle / Midnight Tracking
  DateTime? get lastActiveDate {
    final raw = _getValue(keyLastActiveDate, null) as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setLastActiveDate(DateTime value) async {
    await _setValue(keyLastActiveDate, value.toIso8601String());
  }

  // Generic key-value accessors
  T? get<T>(String key, {T? defaultValue}) {
    return _getValue(key, defaultValue) as T?;
  }

  Future<void> put(String key, dynamic value) async {
    await _setValue(key, value);
  }

  Future<void> delete(String key) async {
    _memoryFallback.remove(key);
    if (_box != null && _box!.isOpen) {
      await _box!.delete(key);
    }
  }

  Future<void> clear() async {
    _memoryFallback.clear();
    if (_box != null && _box!.isOpen) {
      await _box!.clear();
    }
  }
}
