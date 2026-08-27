import 'package:flutter/material.dart';

/// 16-bit Retro Pixel Fantasy Color Palette
class PixelColors {
  PixelColors._();

  // Primary Backgrounds
  static const Color backgroundDark = Color(0xFF0D0D18);
  static const Color backgroundCard = Color(0xFF19192E);
  static const Color backgroundSurface = Color(0xFF242442);
  static const Color backgroundElevated = Color(0xFF303058);

  // Border & Frame Colors
  static const Color borderDark = Color(0xFF07070D);
  static const Color borderHighlight = Color(0xFF4A4A7A);
  static const Color borderGold = Color(0xFFFFD166);
  static const Color borderSilver = Color(0xFFCBD5E1);

  // RPG Stat & Economy Accents
  static const Color hpGreen = Color(0xFF06D6A0);
  static const Color hpRed = Color(0xFFEF476F);
  static const Color hpBackground = Color(0xFF4A1020);

  static const Color mpBlue = Color(0xFF118AB2);
  static const Color mpCyan = Color(0xFF4CC9F0);
  static const Color mpBackground = Color(0xFF0C3852);

  static const Color expPurple = Color(0xFF7209B7);
  static const Color expPink = Color(0xFFF72585);
  static const Color expBackground = Color(0xFF2D0747);

  static const Color coinGold = Color(0xFFFFB703);
  static const Color coinAmber = Color(0xFFFB8500);

  // Rank Colors
  static const Color rankE = Color(0xFF9E9E9E);
  static const Color rankD = Color(0xFF4CAF50);
  static const Color rankC = Color(0xFF2196F3);
  static const Color rankB = Color(0xFF9C27B0);
  static const Color rankA = Color(0xFFFF9800);
  static const Color rankS = Color(0xFFE91E63);

  // Attribute Colors
  static const Color attrStr = Color(0xFFE63946); // Red (Strength)
  static const Color attrInt = Color(0xFF457B9D); // Blue (Intelligence)
  static const Color attrAgi = Color(0xFF2A9D8F); // Teal/Green (Agility)
  static const Color attrVit = Color(0xFFE76F51); // Orange (Vitality)
  static const Color attrWis = Color(0xFF9D4EDD); // Violet (Wisdom)

  // Text Colors
  static const Color textBright = Color(0xFFF8F9FA);
  static const Color textMuted = Color(0xFFA0A0C0);
  static const Color textDark = Color(0xFF101018);

  // Special States
  static const Color ghostSpirit = Color(0xFF80CED6);
  static const Color bossHealth = Color(0xFFD62828);

  // CRT Scanline Overlay Colors
  static const Color crtScanlineDark = Color(0x33000000);
  static const Color crtGlowAmber = Color(0x15FFB703);
  static const Color crtGlowGreen = Color(0x1506D6A0);
}
