import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class HeroCardWidget extends StatelessWidget {
  const HeroCardWidget({
    super.key,
    this.heroModel,
    this.hero,
  });

  final HeroModel? heroModel;
  final Hero? hero;

  HeroModel get _resolvedHero {
    if (heroModel != null) return heroModel!;
    return HeroModel(
      name: hero?.name ?? 'Arthur',
      level: hero?.level ?? 1,
      currentExp: hero?.currentExp ?? 0,
      currentHp: hero?.hp ?? 100,
      maxHp: hero?.maxHp ?? 100,
      currentMp: hero?.mp ?? 50,
      maxMp: hero?.maxMp ?? 100,
      coins: hero?.coins ?? 50,
      unallocatedPoints: hero?.unspentStatPoints ?? 0,
      str: hero?.str ?? 5,
      intel: hero?.intAttr ?? 5,
      agi: hero?.agi ?? 5,
      vit: hero?.vit ?? 5,
      wis: hero?.intAttr ?? 5,
      isGhost: hero?.isGhost ?? false,
      activeSkinId: hero?.avatarSkinId ?? 'hero_novice',
      activeTitleId: hero?.activeTitle ?? 'Novice Adventurer',
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = _resolvedHero;
    final expTarget = HeroModel.expTargetForLevel(h.level);

    return PixelCard(
      borderColor: h.isGhost
          ? PixelColors.ghostSpirit
          : PixelColors.coinGold,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PixelSprite(
                spriteType: h.activeSkinId,
                size: 56,
                isGhost: h.isGhost,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h.name.toUpperCase(),
                      style: PixelTypography.pixelHeader(
                        fontSize: 14,
                        color: PixelColors.coinGold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '« ${h.activeTitleId} »',
                      style: PixelTypography.pixelSubheader(
                        fontSize: 10,
                        color: h.isGhost
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
                          color: PixelColors.backgroundSurface,
                          child: Text(
                            'LVL ${h.level}',
                            style: PixelTypography.pixelHeader(
                              fontSize: 10,
                              color: PixelColors.coinGold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (h.isGhost)
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
                          '${h.coins}',
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
            current: h.currentExp,
            max: expTarget,
            fillColor: PixelColors.expPurple,
            backgroundColor: PixelColors.expBackground,
            height: 14,
          ),
          const SizedBox(height: 6),
          // HP Bar
          PixelProgressBar(
            label: 'HP',
            current: h.currentHp,
            max: h.maxHp,
            fillColor: h.isGhost
                ? PixelColors.ghostSpirit
                : PixelColors.hpGreen,
            backgroundColor: PixelColors.hpBackground,
            height: 14,
          ),
          const SizedBox(height: 6),
          // MP Bar
          PixelProgressBar(
            label: 'MP',
            current: h.currentMp,
            max: h.maxMp,
            fillColor: PixelColors.mpCyan,
            backgroundColor: PixelColors.mpBackground,
            height: 14,
          ),
        ],
      ),
    );
  }
}
