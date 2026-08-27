import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

enum BgmTheme { battleHub, dungeon, tavern, sanctuary }

/// Sensory Service managing 16-bit retro chiptune audio triggers, contextual BGM, and device tactile haptics
class SensoryService {
  SensoryService._() {
    _initAudio();
  }

  static final SensoryService instance = SensoryService._();

  bool isSfxEnabled = true;
  bool isBgmEnabled = true;
  bool isHapticsEnabled = true;

  AudioPlayer? _bgmPlayer;
  BgmTheme? _currentTheme;

  void _initAudio() {
    try {
      _bgmPlayer = AudioPlayer();
      _bgmPlayer?.setReleaseMode(ReleaseMode.loop);
      _bgmPlayer?.setVolume(0.5);
    } catch (_) {}
  }

  void toggleSfx(bool enabled) {
    isSfxEnabled = enabled;
  }

  void toggleHaptics(bool enabled) {
    isHapticsEnabled = enabled;
  }

  void toggleBgm(bool enabled) {
    isBgmEnabled = enabled;
    if (!isBgmEnabled) {
      stopBgm();
    } else if (_currentTheme != null) {
      playBgm(_currentTheme!);
    }
  }

  Future<void> playBgm(BgmTheme theme) async {
    _currentTheme = theme;
    if (!isBgmEnabled) return;

    try {
      String assetPath;
      switch (theme) {
        case BgmTheme.battleHub:
          assetPath = 'audio/bgm_battle_hub.wav';
          break;
        case BgmTheme.dungeon:
          assetPath = 'audio/bgm_dungeon_map.wav';
          break;
        case BgmTheme.tavern:
          assetPath = 'audio/bgm_tavern_cozy.wav';
          break;
        case BgmTheme.sanctuary:
          assetPath = 'audio/bgm_sanctuary.wav';
          break;
      }
      await _bgmPlayer?.stop().catchError((_) {});
      await _bgmPlayer?.play(AssetSource(assetPath)).catchError((_) {});
    } catch (_) {}
  }

  Future<void> playBgmForTab(int tabIndex) async {
    switch (tabIndex) {
      case 0:
        await playBgm(BgmTheme.battleHub);
        break;
      case 1:
        await playBgm(BgmTheme.dungeon);
        break;
      case 2:
        await playBgm(BgmTheme.tavern);
        break;
      case 3:
      case 4:
      default:
        await playBgm(BgmTheme.sanctuary);
        break;
    }
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer?.stop().catchError((_) {});
    } catch (_) {}
  }

  Future<void> pauseBgm() async {
    try {
      await _bgmPlayer?.pause().catchError((_) {});
    } catch (_) {}
  }

  Future<void> resumeBgm() async {
    if (isBgmEnabled && _currentTheme != null) {
      try {
        await _bgmPlayer?.resume().catchError((_) {});
      } catch (_) {
        await playBgm(_currentTheme!);
      }
    }
  }

  void _playSfxAsset(
    String assetPath, {
    SystemSoundType fallbackSound = SystemSoundType.click,
  }) {
    if (isSfxEnabled) {
      SystemSound.play(fallbackSound);
      try {
        final player = AudioPlayer();
        player
            .play(AssetSource(assetPath), mode: PlayerMode.lowLatency)
            .catchError((_) {});
      } catch (_) {}
    }
  }

  /// Button or tab click
  void playClick() {
    if (isHapticsEnabled) {
      HapticFeedback.selectionClick();
    }
    _playSfxAsset(
      'audio/sfx_button_click.wav',
      fallbackSound: SystemSoundType.click,
    );
  }

  /// Sword slash or attack against boss
  void playAttack() {
    if (isHapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
    _playSfxAsset(
      'audio/sfx_sword_slash.wav',
      fallbackSound: SystemSoundType.click,
    );
  }

  /// Alias for playAttack
  void playSwordSlash() => playAttack();

  /// Critical strike or heavy boss damage
  void playCriticalAttack() {
    if (isHapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    _playSfxAsset(
      'audio/sfx_critical_strike.wav',
      fallbackSound: SystemSoundType.alert,
    );
  }

  /// Hero took damage / boss counter-attack
  void playHurt() {
    if (isHapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    _playSfxAsset(
      'audio/sfx_hero_hurt.wav',
      fallbackSound: SystemSoundType.alert,
    );
  }

  /// Gained coins or completed habit
  void playCoin() {
    if (isHapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    _playSfxAsset(
      'audio/sfx_coin_collect.wav',
      fallbackSound: SystemSoundType.click,
    );
  }

  /// Hero Level Up fanfare
  void playLevelUp() {
    if (isHapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
    _playSfxAsset(
      'audio/sfx_level_up.wav',
      fallbackSound: SystemSoundType.alert,
    );
  }

  /// Chapter boss victory fanfare
  void playVictory() {
    if (isHapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    _playSfxAsset(
      'audio/sfx_boss_defeat.wav',
      fallbackSound: SystemSoundType.alert,
    );
  }

  /// Activated MP skill buff
  void playBuff() {
    if (isHapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    _playSfxAsset(
      'audio/sfx_buff_cast.wav',
      fallbackSound: SystemSoundType.click,
    );
  }
}
