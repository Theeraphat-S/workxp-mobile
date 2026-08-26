import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/domain/models/analytics_model.dart';

class DamageBarChartCard extends StatelessWidget {
  const DamageBarChartCard({super.key, required this.logs});

  final List<DailyActivityLog> logs;

  @override
  Widget build(BuildContext context) {
    final recentLogs = logs.length > 7 ? logs.sublist(logs.length - 7) : logs;
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < recentLogs.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: recentLogs[i].damageDealt.toDouble(),
              color: PixelColors.bossHealth,
              width: 14,
              borderRadius: BorderRadius.zero, // Retro squared bars
              borderSide: const BorderSide(
                color: PixelColors.borderDark,
                width: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    final maxVal = recentLogs.isEmpty
        ? 100.0
        : recentLogs
              .map((l) => l.damageDealt.toDouble())
              .reduce((a, b) => a > b ? a : b);

    return PixelCard(
      borderColor: PixelColors.bossHealth,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BOSS DAMAGE DEALT',
                style: PixelTypography.pixelHeader(
                  fontSize: 11,
                  color: PixelColors.bossHealth,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: PixelColors.hpBackground,
                child: Text(
                  'WEEKLY COMBAT',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 8,
                    color: PixelColors.hpRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: maxVal > 0 ? maxVal * 1.25 : 100,
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: PixelColors.borderHighlight.withAlpha(40),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: PixelColors.borderDark, width: 1.5),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
