import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/domain/models/analytics_model.dart';

class HabitHeatmapCard extends StatelessWidget {
  const HabitHeatmapCard({super.key, required this.logs});

  final List<DailyActivityLog> logs;

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.hpGreen,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '16-BIT HABIT HEATMAP',
                style: PixelTypography.pixelHeader(
                  fontSize: 11,
                  color: PixelColors.hpGreen,
                ),
              ),
              Text(
                '4-WEEK MATRIX',
                style: PixelTypography.pixelSubheader(
                  fontSize: 8,
                  color: PixelColors.hpGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 7 columns x 4 rows matrix (28 days of history)
          Center(
            child: SizedBox(
              height: 110,
              child: Builder(
                builder: (context) {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(7, (colIndex) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (rowIndex) {
                          // Map grid to chronological day offsets (0 = oldest, 27 = today)
                          final dayOffset = (colIndex * 4) + rowIndex;
                          final targetDate = today.subtract(
                            Duration(days: 27 - dayOffset),
                          );

                          final logMatch = logs.where(
                            (l) =>
                                l.date.year == targetDate.year &&
                                l.date.month == targetDate.month &&
                                l.date.day == targetDate.day,
                          );
                          final count = logMatch.isNotEmpty
                              ? logMatch.first.habitCompletions
                              : 0;

                          Color cellColor;
                          if (count >= 4) {
                            cellColor = PixelColors.coinGold;
                          } else if (count >= 3) {
                            cellColor = PixelColors.hpGreen;
                          } else if (count >= 1) {
                            cellColor = PixelColors.hpGreen.withAlpha(120);
                          } else {
                            cellColor = PixelColors.backgroundSurface;
                          }

                          return Container(
                            width: 18,
                            height: 18,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: cellColor,
                              border: Border.all(
                                color: PixelColors.borderDark,
                                width: 1.0,
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Less',
                style: PixelTypography.pixelBody(
                  fontSize: 9,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(width: 4),
              _buildLegendBox(PixelColors.backgroundSurface),
              _buildLegendBox(PixelColors.hpGreen.withAlpha(120)),
              _buildLegendBox(PixelColors.hpGreen),
              _buildLegendBox(PixelColors.coinGold),
              const SizedBox(width: 4),
              Text(
                'More',
                style: PixelTypography.pixelBody(
                  fontSize: 9,
                  color: PixelColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: PixelColors.borderDark),
      ),
    );
  }
}
