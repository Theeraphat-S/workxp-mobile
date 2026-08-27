import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';

import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class MiniBattleBar extends StatelessWidget {
  const MiniBattleBar({
    super.key,
    this.boss,
    this.bossModel,
    this.hero,
    this.isGhost = false,
  });

  final Boss? boss;
  final BossModel? bossModel;
  final Hero? hero;
  final bool isGhost;

  @override
  Widget build(BuildContext context) {
    final bossName = boss?.name ?? bossModel?.name ?? 'King Slime';
    final currentBossHp = boss?.currentHp ?? bossModel?.currentHp ?? 500;
    final maxBossHp = boss?.maxHp ?? bossModel?.maxHp ?? 500;
    final bossSprite = boss?.iconAsset ?? bossModel?.spriteType ?? 'boss_slime';

    final heroHp = hero?.hp ?? 100;
    final heroMaxHp = hero?.maxHp ?? 100;
    final heroMp = hero?.mp ?? 50;
    final heroMaxMp = hero?.maxMp ?? 50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: PixelColors.backgroundSurface,
        border: Border(
          bottom: BorderSide(color: PixelColors.borderGold, width: 2),
        ),
      ),
      child: Row(
        children: [
          // Mini Boss Sprite
          PixelSprite(spriteType: bossSprite, size: 28),
          const SizedBox(width: 8),
          // Boss Mini HP Bar
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bossName.toUpperCase(),
                  style: PixelTypography.pixelHeader(
                    fontSize: 8,
                    color: PixelColors.bossHealth,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                PixelProgressBar(
                  label: '',
                  current: currentBossHp,
                  max: maxBossHp,
                  fillColor: PixelColors.bossHealth,
                  backgroundColor: PixelColors.hpBackground,
                  height: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Mini Hero Vitals
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'HP',
                      style: PixelTypography.pixelHeader(
                        fontSize: 7,
                        color: PixelColors.hpGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: PixelProgressBar(
                        label: '',
                        current: heroHp,
                        max: heroMaxHp,
                        fillColor: PixelColors.hpGreen,
                        backgroundColor: PixelColors.hpBackground,
                        height: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'MP',
                      style: PixelTypography.pixelHeader(
                        fontSize: 7,
                        color: PixelColors.mpCyan,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: PixelProgressBar(
                        label: '',
                        current: heroMp,
                        max: heroMaxMp,
                        fillColor: PixelColors.mpCyan,
                        backgroundColor: PixelColors.mpBackground,
                        height: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
