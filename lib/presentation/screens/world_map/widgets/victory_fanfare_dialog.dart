import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/boss_model.dart';

class VictoryFanfareDialog extends StatelessWidget {
  const VictoryFanfareDialog({
    super.key,
    required this.boss,
    required this.onContinue,
  });

  final BossModel boss;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
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
              '${boss.name.toUpperCase()} HAS BEEN VANQUISHED!',
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
                            '+${boss.coinReward} COINS',
                            style: PixelTypography.pixelHeader(
                              fontSize: 11,
                              color: PixelColors.coinGold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+${boss.expReward} EXP',
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
