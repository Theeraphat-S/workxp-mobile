import 'dart:math';
import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/domain/models/hero_model.dart';

class AttributeRadarCard extends StatelessWidget {
  const AttributeRadarCard({super.key, required this.hero});

  final HeroModel hero;

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.attrWis,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ATTRIBUTE BALANCE RADAR',
                style: PixelTypography.pixelHeader(
                  fontSize: 11,
                  color: PixelColors.attrWis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: PixelColors.backgroundSurface,
                child: Text(
                  '5 CORE STATS',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 8,
                    color: PixelColors.coinGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 220,
              height: 200,
              child: CustomPaint(painter: _RadarChartPainter(hero: hero)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  _RadarChartPainter({required this.hero});

  final HeroModel hero;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final stats = [
      {'name': 'STR', 'val': hero.str, 'color': PixelColors.attrStr},
      {'name': 'INT', 'val': hero.intel, 'color': PixelColors.attrInt},
      {'name': 'AGI', 'val': hero.agi, 'color': PixelColors.attrAgi},
      {'name': 'VIT', 'val': hero.vit, 'color': PixelColors.attrVit},
      {'name': 'WIS', 'val': hero.wis, 'color': PixelColors.attrWis},
    ];

    const maxStat = 25.0;

    // Draw pentagon rings
    final gridPaint = Paint()
      ..color = PixelColors.borderHighlight.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int ring = 1; ring <= 4; ring++) {
      final ringRadius = (radius / 4) * ring;
      final path = Path();
      for (int i = 0; i < 5; i++) {
        final angle = (i * 2 * pi / 5) - (pi / 2);
        final x = center.dx + ringRadius * cos(angle);
        final y = center.dy + ringRadius * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axis lines and labels
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);

      // Label
      final labelX = center.dx + (radius + 18) * cos(angle);
      final labelY = center.dy + (radius + 14) * sin(angle);
      final stat = stats[i];

      final textSpan = TextSpan(
        text: '${stat['name']}\n${stat['val']}',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: stat['color'] as Color,
          fontFamily: 'monospace',
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(
          labelX - (textPainter.width / 2),
          labelY - (textPainter.height / 2),
        ),
      );
    }

    // Draw Hero Stat Polygon
    final polyPath = Path();
    final fillPaint = Paint()
      ..color = PixelColors.attrWis.withAlpha(90)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = PixelColors.coinGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 5; i++) {
      final val = ((stats[i]['val'] as int).toDouble()).clamp(1.0, maxStat);
      final ratio = val / maxStat;
      final angle = (i * 2 * pi / 5) - (pi / 2);
      final x = center.dx + (radius * ratio) * cos(angle);
      final y = center.dy + (radius * ratio) * sin(angle);

      if (i == 0) {
        polyPath.moveTo(x, y);
      } else {
        polyPath.lineTo(x, y);
      }
    }
    polyPath.close();

    canvas.drawPath(polyPath, fillPaint);
    canvas.drawPath(polyPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.hero.str != hero.str ||
        oldDelegate.hero.intel != hero.intel ||
        oldDelegate.hero.agi != hero.agi ||
        oldDelegate.hero.vit != hero.vit ||
        oldDelegate.hero.wis != hero.wis;
  }
}
