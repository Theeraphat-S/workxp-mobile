import 'package:flutter/material.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class VictoryFanfareDialog extends StatelessWidget {
  const VictoryFanfareDialog({
    super.key,
    this.bossModel,
    this.boss,
    required this.onContinue,
  });

  final BossModel? bossModel;
  final Boss? boss;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final name = boss?.name ?? bossModel?.name ?? 'Boss';
    final coinReward = bossModel?.coinReward ?? 100;
    final expReward = bossModel?.expReward ?? 150;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelCard(
        borderColor: PixelColors.coinGold,
        backgroundColor: const Color(0xFF1E170A),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: PixelSprite(spriteType: 'trophy', size: 64)),
            const SizedBox(height: 12),
            Text(
              'VICTORY FANFARE!',
              style: PixelTypography.pixelHeader(
                fontSize: 16,
                color: PixelColors.coinGold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              '${name.toUpperCase()} HAS BEEN VANQUISHED!',
              style: PixelTypography.pixelSubheader(
                fontSize: 10,
                color: PixelColors.textBright,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PixelColors.backgroundDark,
                border: Border.all(color: PixelColors.borderGold),
              ),
              child: Column(
                children: [
                  Text(
                    'CHAPTER REWARDS LOOT',
                    style: PixelTypography.pixelHeader(
                      fontSize: 10,
                      color: PixelColors.coinAmber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const PixelSprite(spriteType: 'coin', size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '+$coinReward COINS',
                            style: PixelTypography.pixelHeader(
                              fontSize: 11,
                              color: PixelColors.coinGold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+$expReward EXP',
                        style: PixelTypography.pixelHeader(
                          fontSize: 11,
                          color: PixelColors.expPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PixelButton(
              text: 'CLAIM REWARDS & PROCEED',
              backgroundColor: PixelColors.coinGold,
              textColor: Colors.black,
              isFullWidth: true,
              onPressed: () {
                Navigator.of(context).pop();
                onContinue();
              },
            ),
          ],
        ),
      ),
    );
  }
}
