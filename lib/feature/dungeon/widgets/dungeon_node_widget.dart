import 'package:flutter/material.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class DungeonNodeWidget extends StatelessWidget {
  const DungeonNodeWidget({
    super.key,
    required this.chapterNumber,
    required this.chapterName,
    this.bossModel,
    this.boss,
    required this.isUnlocked,
    required this.isCurrent,
    required this.isDefeated,
    required this.onSelect,
  });

  final int chapterNumber;
  final String chapterName;
  final BossModel? bossModel;
  final Boss? boss;
  final bool isUnlocked;
  final bool isCurrent;
  final bool isDefeated;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;

    if (isCurrent) {
      borderColor = PixelColors.coinGold;
      bgColor = PixelColors.backgroundSurface;
    } else if (isDefeated) {
      borderColor = PixelColors.hpGreen;
      bgColor = PixelColors.backgroundCard;
    } else if (isUnlocked) {
      borderColor = PixelColors.borderHighlight;
      bgColor = PixelColors.backgroundCard;
    } else {
      borderColor = PixelColors.borderDark;
      bgColor = PixelColors.backgroundDark;
    }

    final spriteType = boss?.iconAsset ?? bossModel?.spriteType ?? 'boss_slime';
    final name = boss?.name ?? bossModel?.name ?? 'Boss';
    final currentHp = boss?.currentHp ?? bossModel?.currentHp ?? 100;
    final maxHp = boss?.maxHp ?? bossModel?.maxHp ?? 100;

    return InkWell(
      onTap: isUnlocked ? onSelect : null,
      child: PixelCard(
        borderColor: borderColor,
        backgroundColor: bgColor,
        child: Row(
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.35,
              child: PixelSprite(spriteType: spriteType, size: 54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'CHAPTER $chapterNumber',
                        style: PixelTypography.pixelHeader(
                          fontSize: 9,
                          color: isUnlocked
                              ? PixelColors.coinGold
                              : PixelColors.textMuted,
                        ),
                      ),
                      const Spacer(),
                      if (!isUnlocked)
                        const Icon(
                          Icons.lock,
                          size: 14,
                          color: PixelColors.textMuted,
                        )
                      else if (isDefeated)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: PixelColors.hpGreen.withAlpha(40),
                          child: Text(
                            'CONQUERED',
                            style: PixelTypography.pixelHeader(
                              fontSize: 8,
                              color: PixelColors.hpGreen,
                            ),
                          ),
                        )
                      else if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: PixelColors.coinGold.withAlpha(40),
                          child: Text(
                            'ACTIVE BATTLE',
                            style: PixelTypography.pixelHeader(
                              fontSize: 8,
                              color: PixelColors.coinGold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chapterName.toUpperCase(),
                    style: PixelTypography.pixelSubheader(
                      fontSize: 12,
                      color: isUnlocked
                          ? PixelColors.textBright
                          : PixelColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'BOSS: $name',
                    style: PixelTypography.pixelBody(
                      fontSize: 11,
                      color: isUnlocked
                          ? PixelColors.bossHealth
                          : PixelColors.textMuted,
                    ),
                  ),
                  if (isUnlocked && !isDefeated) ...[
                    const SizedBox(height: 6),
                    PixelProgressBar(
                      current: currentHp,
                      max: maxHp,
                      fillColor: PixelColors.bossHealth,
                      height: 10,
                      showValues: false,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
