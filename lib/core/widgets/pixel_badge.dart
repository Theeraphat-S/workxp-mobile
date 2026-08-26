import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';
import '../theme/pixel_typography.dart';

/// 16-bit Pixel Badge for Quest Ranks (E to S) and Attributes (STR, INT, AGI, VIT, WIS)
class PixelBadge extends StatelessWidget {
  const PixelBadge({
    super.key,
    required this.label,
    this.backgroundColor = PixelColors.backgroundSurface,
    this.textColor = PixelColors.textBright,
    this.borderColor = PixelColors.borderHighlight,
    this.fontSize = 9,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  /// Factory for Quest Rank tier badge
  factory PixelBadge.rank(String rank) {
    Color bg;
    Color text = Colors.white;
    switch (rank.toUpperCase()) {
      case 'S':
        bg = PixelColors.rankS;
        break;
      case 'A':
        bg = PixelColors.rankA;
        break;
      case 'B':
        bg = PixelColors.rankB;
        break;
      case 'C':
        bg = PixelColors.rankC;
        break;
      case 'D':
        bg = PixelColors.rankD;
        break;
      case 'E':
      default:
        bg = PixelColors.rankE;
        break;
    }

    return PixelBadge(
      label: 'RANK $rank',
      backgroundColor: bg,
      textColor: text,
      borderColor: PixelColors.borderDark,
    );
  }

  /// Factory for RPG Attribute badge
  factory PixelBadge.attribute(String attr) {
    Color bg;
    switch (attr.toUpperCase()) {
      case 'STR':
        bg = PixelColors.attrStr;
        break;
      case 'INT':
        bg = PixelColors.attrInt;
        break;
      case 'AGI':
        bg = PixelColors.attrAgi;
        break;
      case 'VIT':
        bg = PixelColors.attrVit;
        break;
      case 'WIS':
        bg = PixelColors.attrWis;
        break;
      default:
        bg = PixelColors.backgroundSurface;
    }

    return PixelBadge(
      label: attr.toUpperCase(),
      backgroundColor: bg,
      textColor: Colors.white,
      borderColor: PixelColors.borderDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      padding: padding,
      child: Text(
        label,
        style: PixelTypography.pixelSubheader(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
