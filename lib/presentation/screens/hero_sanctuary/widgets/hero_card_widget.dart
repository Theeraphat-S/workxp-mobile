import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/core/widgets/pixel_progress_bar.dart';
import 'package:workxp/domain/models/hero_model.dart';

class HeroCardWidget extends StatelessWidget {
  const HeroCardWidget({super.key, required this.hero});

  final HeroModel hero;

  @override
  Widget build(BuildContext context) {
    final expTarget = HeroModel.expTargetForLevel(hero.level);

    return PixelCard(
      borderColor: hero.isGhost
          ? PixelColors.ghostSpirit
          : PixelColors.coinGold,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PixelSprite(
                spriteType: hero.activeSkinId,
                size: 56,
                isGhost: hero.isGhost,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name.toUpperCase(),
                      style: PixelTypography.pixelHeader(
                        fontSize: 14,
                        color: PixelColors.coinGold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '« ${hero.activeTitleId} »',
                      style: PixelTypography.pixelSubheader(
                        fontSize: 10,
                        color: hero.isGhost
                            ? PixelColors.ghostSpirit
                            : PixelColors.attrWis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: PixelColors.backgroundElevated,
                          child: Text(
                            'LVL ${hero.level}',
                            style: PixelTypography.pixelHeader(
                              fontSize: 10,
                              color: PixelColors.coinGold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (hero.isGhost)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            color: PixelColors.hpRed.withAlpha(50),
                            child: Text(
                              'GHOST STATE',
                              style: PixelTypography.pixelHeader(
                                fontSize: 9,
                                color: PixelColors.ghostSpirit,
                              ),
                            ),
                          ),
                        const Spacer(),
                        const PixelSprite(spriteType: 'coin', size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${hero.coins}',
                          style: PixelTypography.pixelHeader(
                            fontSize: 11,
                            color: PixelColors.coinGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // EXP Bar
          PixelProgressBar(
            label: 'EXP',
            current: hero.currentExp,
            max: expTarget,
            fillColor: PixelColors.expPurple,
            backgroundColor: PixelColors.expBackground,
            height: 14,
          ),
          const SizedBox(height: 6),
          // HP Bar
          PixelProgressBar(
            label: 'HP',
            current: hero.currentHp,
            max: hero.maxHp,
            fillColor: hero.isGhost
                ? PixelColors.ghostSpirit
                : PixelColors.hpGreen,
            backgroundColor: PixelColors.hpBackground,
            height: 14,
          ),
          const SizedBox(height: 6),
          // MP Bar
          PixelProgressBar(
            label: 'MP',
            current: hero.currentMp,
            max: hero.maxMp,
            fillColor: PixelColors.mpCyan,
            backgroundColor: PixelColors.mpBackground,
            height: 14,
          ),
        ],
      ),
    );
  }
}
