import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';
import '../theme/pixel_typography.dart';

/// 16-bit Retro Progress Bar with pixel frame and label overlay
class PixelProgressBar extends StatelessWidget {
  const PixelProgressBar({
    super.key,
    required this.current,
    required this.max,
    this.label,
    this.fillColor = PixelColors.hpGreen,
    this.backgroundColor = PixelColors.hpBackground,
    this.borderColor = PixelColors.borderDark,
    this.height = 20,
    this.showValues = true,
  });

  final num current;
  final num max;
  final String? label;
  final Color fillColor;
  final Color backgroundColor;
  final Color borderColor;
  final double height;
  final bool showValues;

  @override
  Widget build(BuildContext context) {
    final ratio = max <= 0 ? 0.0 : (current / max).clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValues)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: PixelTypography.pixelSubheader(
                      fontSize: 10,
                      color: PixelColors.textBright,
                    ),
                  ),
                if (showValues)
                  Text(
                    '${current.toInt()} / ${max.toInt()}',
                    style: PixelTypography.pixelSubheader(
                      fontSize: 10,
                      color: PixelColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2.0),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: ratio,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    border: Border(
                      right: ratio > 0 && ratio < 1.0
                          ? BorderSide(
                              color: Colors.white.withAlpha(180),
                              width: 2.0,
                            )
                          : BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Top pixel gloss highlight
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height * 0.3,
                child: Container(color: Colors.white.withAlpha(35)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
