import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pixel_colors.dart';

/// Retro typography using 16-bit pixel styles (Press Start 2P, VT323, Silkscreen)
class PixelTypography {
  PixelTypography._();

  /// Press Start 2P - for main retro titles, level numbers, headers
  static TextStyle pixelHeader({
    double fontSize = 16,
    Color color = PixelColors.textBright,
    FontWeight fontWeight = FontWeight.bold,
    double letterSpacing = 1.0,
  }) {
    try {
      return GoogleFonts.pressStart2p(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'monospace',
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
    }
  }

  /// Silkscreen - for buttons, tabs, badges, combat stats
  static TextStyle pixelSubheader({
    double fontSize = 14,
    Color color = PixelColors.textBright,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = 0.5,
  }) {
    try {
      return GoogleFonts.silkscreen(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'monospace',
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
    }
  }

  /// VT323 - for terminal logs, flavor text, high-density stats
  static TextStyle pixelBody({
    double fontSize = 16,
    Color color = PixelColors.textBright,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    try {
      return GoogleFonts.vt323(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'monospace',
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );
    }
  }

  /// Clean readable sans-serif for long quest descriptions and form inputs
  static TextStyle standardBody({
    double fontSize = 13,
    Color color = PixelColors.textBright,
    FontWeight fontWeight = FontWeight.normal,
    double height = 1.3,
  }) {
    try {
      return GoogleFonts.prompt(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );
    } catch (_) {
      return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );
    }
  }

  /// Clean readable sans-serif header for Quest titles in both Thai and English
  static TextStyle readableTitle({
    double fontSize = 14,
    Color color = PixelColors.textBright,
    FontWeight fontWeight = FontWeight.w600,
    double height = 1.2,
  }) {
    try {
      return GoogleFonts.prompt(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );
    } catch (_) {
      return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );
    }
  }
}
