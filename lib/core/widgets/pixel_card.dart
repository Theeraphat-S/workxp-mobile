import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

/// A 16-bit retro card widget with stepped pixel borders and optional corner notches.
class PixelCard extends StatelessWidget {
  const PixelCard({
    super.key,
    required this.child,
    this.backgroundColor = PixelColors.backgroundCard,
    this.borderColor = PixelColors.borderHighlight,
    this.outerBorderColor = PixelColors.borderDark,
    this.padding = const EdgeInsets.all(12),
    this.margin,
    this.borderWidth = 2.0,
    this.onTap,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final Color outerBorderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: outerBorderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            offset: const Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        splashColor: borderColor.withAlpha(50),
        highlightColor: borderColor.withAlpha(25),
        child: card,
      );
    }

    return card;
  }
}
