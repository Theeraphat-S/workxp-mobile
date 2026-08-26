import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/analytics_model.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({super.key, required this.entries});

  final List<LeaderboardEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.borderGold,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIMULATED GUILD LEADERBOARD',
                style: PixelTypography.pixelHeader(
                  fontSize: 10,
                  color: PixelColors.coinGold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: PixelColors.backgroundSurface,
                child: Text(
                  'WEEKLY RANK',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 8,
                    color: PixelColors.coinGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...entries.map((entry) {
            final isTop3 = entry.rank <= 3;
            Color rankColor;
            if (entry.rank == 1) {
              rankColor = PixelColors.coinGold;
            } else if (entry.rank == 2) {
              rankColor = PixelColors.borderSilver;
            } else if (entry.rank == 3) {
              rankColor = PixelColors.coinAmber;
            } else {
              rankColor = PixelColors.textMuted;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: entry.isHero
                    ? PixelColors.coinAmber.withAlpha(30)
                    : PixelColors.backgroundSurface,
                border: Border.all(
                  color: entry.isHero
                      ? PixelColors.coinGold
                      : PixelColors.borderDark,
                  width: entry.isHero ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '#${entry.rank}',
                      style: PixelTypography.pixelHeader(
                        fontSize: isTop3 ? 11 : 9,
                        color: rankColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PixelSprite(spriteType: entry.skinId, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style: PixelTypography.pixelSubheader(
                            fontSize: 10,
                            color: entry.isHero
                                ? PixelColors.coinGold
                                : PixelColors.textBright,
                          ),
                        ),
                        Text(
                          '« ${entry.title} »',
                          style: PixelTypography.pixelBody(
                            fontSize: 9,
                            color: PixelColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '⚔ ${entry.weeklyDamage}',
                        style: PixelTypography.pixelHeader(
                          fontSize: 9,
                          color: PixelColors.hpRed,
                        ),
                      ),
                      Text(
                        '🔥 ${entry.streak}d streak',
                        style: PixelTypography.pixelBody(
                          fontSize: 9,
                          color: PixelColors.coinAmber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
