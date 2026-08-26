import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/analytics_model.dart';

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key, required this.achievements});

  final List<AchievementModel> achievements;

  @override
  Widget build(BuildContext context) {
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return PixelCard(
      borderColor: PixelColors.coinGold,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIFETIME ACHIEVEMENTS',
                style: PixelTypography.pixelHeader(
                  fontSize: 11,
                  color: PixelColors.coinGold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: PixelColors.coinAmber.withAlpha(40),
                child: Text(
                  '$unlockedCount / ${achievements.length} UNLOCKED',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 8,
                    color: PixelColors.coinGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...achievements.map((ach) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ach.isUnlocked
                    ? PixelColors.coinAmber.withAlpha(25)
                    : PixelColors.backgroundSurface,
                border: Border.all(
                  color: ach.isUnlocked
                      ? PixelColors.coinGold
                      : PixelColors.borderDark,
                ),
              ),
              child: Row(
                children: [
                  Opacity(
                    opacity: ach.isUnlocked ? 1.0 : 0.3,
                    child: const PixelSprite(spriteType: 'trophy', size: 32),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ach.title.toUpperCase(),
                          style: PixelTypography.pixelSubheader(
                            fontSize: 10,
                            color: ach.isUnlocked
                                ? PixelColors.coinGold
                                : PixelColors.textMuted,
                          ),
                        ),
                        Text(
                          ach.description,
                          style: PixelTypography.standardBody(
                            fontSize: 10,
                            color: PixelColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (ach.isUnlocked)
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: PixelColors.hpGreen,
                    )
                  else
                    const Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: PixelColors.textMuted,
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
