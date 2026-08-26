import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/domain/models/analytics_model.dart';

class ExpLineChartCard extends StatelessWidget {
  const ExpLineChartCard({super.key, required this.logs});

  final List<DailyActivityLog> logs;

  @override
  Widget build(BuildContext context) {
    final recentLogs = logs.length > 7 ? logs.sublist(logs.length - 7) : logs;
    final spots = <FlSpot>[];

    for (int i = 0; i < recentLogs.length; i++) {
      spots.add(FlSpot(i.toDouble(), recentLogs[i].expEarned.toDouble()));
    }

    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 0));
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return PixelCard(
      borderColor: PixelColors.expPurple,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXP GROWTH TRAJECTORY',
                style: PixelTypography.pixelHeader(
                  fontSize: 11,
                  color: PixelColors.expPink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: PixelColors.expBackground,
                child: Text(
                  'LAST 7 DAYS',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 8,
                    color: PixelColors.expPink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: PixelColors.borderHighlight.withAlpha(40),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < recentLogs.length) {
                          final day = recentLogs[idx].date.day;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '$day',
                              style: PixelTypography.pixelBody(
                                fontSize: 10,
                                color: PixelColors.textMuted,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: PixelColors.borderDark, width: 1.5),
                ),
                minX: 0,
                maxX: (recentLogs.length - 1).toDouble() > 0
                    ? (recentLogs.length - 1).toDouble()
                    : 1,
                minY: 0,
                maxY: maxY > 0 ? maxY * 1.25 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false, // Stepped retro look
                    color: PixelColors.expPink,
                    barWidth: 3,
                    isStrokeCapRound: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotSquarePainter(
                          size: 6,
                          color: PixelColors.coinGold,
                          strokeColor: PixelColors.borderDark,
                          strokeWidth: 1.5,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: PixelColors.expPurple.withAlpha(50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
