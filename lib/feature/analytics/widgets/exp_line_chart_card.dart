import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workxp/domain/models/analytics_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class ExpLineChartCard extends StatefulWidget {
  const ExpLineChartCard({super.key, required this.logs});

  final List<DailyActivityLog> logs;

  @override
  State<ExpLineChartCard> createState() => _ExpLineChartCardState();
}

class _ExpLineChartCardState extends State<ExpLineChartCard> {
  bool _is30Days = false;

  @override
  Widget build(BuildContext context) {
    final range = _is30Days ? 30 : 7;
    final recentLogs = widget.logs.length > range
        ? widget.logs.sublist(widget.logs.length - range)
        : widget.logs;
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
                  fontSize: 10,
                  color: PixelColors.expPink,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _is30Days = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      color: !_is30Days
                          ? PixelColors.expPink
                          : PixelColors.backgroundSurface,
                      child: Text(
                        '7D',
                        style: PixelTypography.pixelSubheader(
                          fontSize: 8,
                          color: !_is30Days
                              ? Colors.black
                              : PixelColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => setState(() => _is30Days = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      color: _is30Days
                          ? PixelColors.expPink
                          : PixelColors.backgroundSurface,
                      child: Text(
                        '30D',
                        style: PixelTypography.pixelSubheader(
                          fontSize: 8,
                          color: _is30Days
                              ? Colors.black
                              : PixelColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: LineChart(
              duration: Duration.zero,
              LineChartData(
                minX: 0,
                maxX: (recentLogs.length - 1).toDouble() > 0
                    ? (recentLogs.length - 1).toDouble()
                    : 1,
                minY: 0,
                maxY: maxY > 0 ? maxY * 1.25 : 100,
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
                      interval: _is30Days ? 5 : 1,
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
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false, // Stepped 16-bit aesthetic
                    color: PixelColors.expPink,
                    barWidth: 2.5,
                    isStrokeCapRound: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotSquarePainter(
                            size: 6,
                            color: PixelColors.expPink,
                            strokeColor: PixelColors.borderDark,
                            strokeWidth: 1.5,
                          ),
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
