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
    return PixelBadge(
      label: 'RANK $rank',
      backgroundColor: colorForRank(rank),
      textColor: Colors.white,
      borderColor: PixelColors.borderDark,
    );
  }

  static Color colorForRank(String rank) {
    switch (rank.toUpperCase()) {
      case 'S':
        return PixelColors.rankS;
      case 'A':
        return PixelColors.rankA;
      case 'B':
        return PixelColors.rankB;
      case 'C':
        return PixelColors.rankC;
      case 'D':
        return PixelColors.rankD;
      case 'E':
      default:
        return PixelColors.rankE;
    }
  }

  /// Factory for RPG Attribute badge
  factory PixelBadge.attribute(String attr) {
    return PixelBadge(
      label: attr.toUpperCase(),
      backgroundColor: colorForAttribute(attr),
      textColor: Colors.white,
      borderColor: PixelColors.borderDark,
    );
  }

  static Color colorForAttribute(String attr) {
    switch (attr.toUpperCase()) {
      case 'STR':
        return PixelColors.attrStr;
      case 'INT':
        return PixelColors.attrInt;
      case 'AGI':
        return PixelColors.attrAgi;
      case 'VIT':
        return PixelColors.attrVit;
      case 'WIS':
        return PixelColors.attrWis;
      default:
        return PixelColors.backgroundSurface;
    }
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
