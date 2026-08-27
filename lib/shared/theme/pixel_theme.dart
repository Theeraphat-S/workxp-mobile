import 'package:flutter/material.dart';
import 'pixel_colors.dart';
import 'pixel_typography.dart';

class PixelTheme {
  PixelTheme._();

  static ThemeData darkTheme({bool crtMode = false, String themeName = 'default'}) {
    Color primaryColor = PixelColors.coinGold;
    if (themeName == 'theme_amber') {
      primaryColor = PixelColors.coinAmber;
    } else if (themeName == 'theme_green') {
      primaryColor = PixelColors.hpGreen;
    }

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PixelColors.backgroundDark,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: PixelColors.mpCyan,
        surface: PixelColors.backgroundCard,
        error: PixelColors.hpRed,
        onPrimary: PixelColors.textDark,
        onSecondary: PixelColors.textBright,
        onSurface: PixelColors.textBright,
        onError: PixelColors.textBright,
      ),
      cardTheme: const CardThemeData(
        color: PixelColors.backgroundCard,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: PixelColors.backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: PixelTypography.pixelHeader(
          fontSize: 14,
          color: primaryColor,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PixelColors.backgroundDark,
        selectedItemColor: primaryColor,
        unselectedItemColor: PixelColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: PixelColors.borderHighlight,
        thickness: 2,
        space: 16,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: PixelColors.backgroundCard,
        elevation: 8,
      ),
    );
  }
}
