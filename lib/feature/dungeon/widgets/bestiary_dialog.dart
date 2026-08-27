import 'package:flutter/material.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class BestiaryDialog extends StatelessWidget {
  const BestiaryDialog({
    super.key,
    this.defeatedBosses = const [],
    this.driftDefeatedBosses = const [],
  });

  final List<BossModel> defeatedBosses;
  final List<Boss> driftDefeatedBosses;

  static final List<BossModel> allChapterBosses = [
    BossModel.chapterBoss(1),
    BossModel.chapterBoss(2),
    BossModel.chapterBoss(3),
    BossModel.chapterBoss(4),
  ];

  bool _isBossConquered(String bossId) {
    if (defeatedBosses.any((b) => b.id == bossId)) return true;
    if (driftDefeatedBosses.any((b) => b.id == bossId && b.isDefeated)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelCard(
        borderColor: PixelColors.attrWis,
        backgroundColor: PixelColors.backgroundCard,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'DUNGEON BESTIARY',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Archives of defeated Chapter Bosses',
                style: PixelTypography.pixelBody(
                  fontSize: 12,
                  color: PixelColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ...allChapterBosses.map((boss) {
                final isConquered = _isBossConquered(boss.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: PixelColors.backgroundSurface,
                    border: Border.all(
                      color: isConquered
                          ? PixelColors.coinGold
                          : PixelColors.borderDark,
                    ),
                  ),
                  child: Row(
                    children: [
                      Opacity(
                        opacity: isConquered ? 1.0 : 0.25,
                        child: PixelSprite(
                          spriteType: boss.spriteType,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              boss.name.toUpperCase(),
                              style: PixelTypography.pixelSubheader(
                                fontSize: 10,
                                color: isConquered
                                    ? PixelColors.coinGold
                                    : PixelColors.textMuted,
                              ),
                            ),
                            Text(
                              'CH.${boss.chapter} ${boss.chapterName} • ${boss.maxHp} HP',
                              style: PixelTypography.pixelBody(
                                fontSize: 11,
                                color: PixelColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        color: isConquered
                            ? PixelColors.hpGreen.withAlpha(40)
                            : PixelColors.backgroundDark,
                        child: Text(
                          isConquered ? 'CONQUERED' : 'UNEXPLORED',
                          style: PixelTypography.pixelHeader(
                            fontSize: 7,
                            color: isConquered
                                ? PixelColors.hpGreen
                                : PixelColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              PixelButton(
                text: 'CLOSE BESTIARY',
                backgroundColor: PixelColors.backgroundSurface,
                textColor: PixelColors.textBright,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
