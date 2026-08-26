import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/tavern_model.dart';

class RewardCelebrationDialog extends StatelessWidget {
  const RewardCelebrationDialog({super.key, required this.reward});

  final CustomRewardModel reward;

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
            const Center(child: PixelSprite(spriteType: 'trophy', size: 56)),
            const SizedBox(height: 12),
            Text(
              'REWARD REDEEMED!',
              style: PixelTypography.pixelHeader(
                fontSize: 14,
                color: PixelColors.coinGold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your well-earned real-life reward:',
              style: PixelTypography.pixelBody(
                fontSize: 12,
                color: PixelColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PixelColors.backgroundDark,
                border: Border.all(color: PixelColors.borderGold),
              ),
              child: Column(
                children: [
                  Text(
                    reward.title.toUpperCase(),
                    style: PixelTypography.pixelHeader(
                      fontSize: 12,
                      color: PixelColors.coinAmber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (reward.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      reward.description,
                      style: PixelTypography.standardBody(
                        fontSize: 11,
                        color: PixelColors.textBright,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Paid: ${reward.coinCost} Coins • Total Redeemed: ${reward.timesRedeemed + 1}x',
                    style: PixelTypography.pixelBody(
                      fontSize: 10,
                      color: PixelColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PixelButton(
              text: 'ENJOY REWARD',
              backgroundColor: PixelColors.coinGold,
              textColor: Colors.black,
              isFullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
