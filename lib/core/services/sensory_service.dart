import 'package:flutter/services.dart';

/// Sensory Service managing 8-bit sound triggers and device tactile haptics
class SensoryService {
  SensoryService._();
  static final SensoryService instance = SensoryService._();

  bool isSfxEnabled = true;
  bool isHapticsEnabled = true;

  void toggleSfx(bool enabled) {
    isSfxEnabled = enabled;
  }

  void toggleHaptics(bool enabled) {
    isHapticsEnabled = enabled;
  }

  /// Button or tab click
  void playClick() {
    if (isHapticsEnabled) {
      HapticFeedback.selectionClick();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  /// Sword slash or attack against boss
  void playAttack() {
    if (isHapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  /// Alias for playAttack
  void playSwordSlash() => playAttack();

  /// Critical strike or heavy boss damage
  void playCriticalAttack() {
    if (isHapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Hero took damage / boss counter-attack
  void playHurt() {
    if (isHapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Gained coins or completed habit
  void playCoin() {
    if (isHapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  /// Hero Level Up fanfare
  void playLevelUp() {
    if (isHapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Chapter boss victory fanfare
  void playVictory() {
    if (isHapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Activated MP skill buff
  void playBuff() {
    if (isHapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    if (isSfxEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }
}
