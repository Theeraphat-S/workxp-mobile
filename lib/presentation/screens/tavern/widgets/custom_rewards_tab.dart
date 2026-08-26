import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'create_custom_reward_dialog.dart';
import 'reward_celebration_dialog.dart';

class CustomRewardsTab extends StatelessWidget {
  const CustomRewardsTab({
    super.key,
    required this.rewards,
    required this.hero,
    required this.onRedeem,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CustomRewardModel> rewards;
  final HeroModel hero;
  final bool Function(String id) onRedeem;
  final void Function(CustomRewardModel reward) onAdd;
  final void Function(CustomRewardModel reward) onEdit;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REAL-LIFE REWARDS (${rewards.length})',
              style: PixelTypography.pixelHeader(
                fontSize: 11,
                color: PixelColors.coinGold,
              ),
            ),
            PixelButton(
              text: '+ REWARD',
              fontSize: 9,
              backgroundColor: PixelColors.coinGold,
              textColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              onPressed: () async {
                final newReward = await showDialog<CustomRewardModel>(
                  context: context,
                  builder: (ctx) => const CreateCustomRewardDialog(),
                );
                if (newReward != null) onAdd(newReward);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (rewards.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No custom rewards created. Set your real-life treats above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...rewards.map((reward) {
          final canAfford = hero.coins >= reward.coinCost;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PixelCard(
              borderColor: PixelColors.borderGold,
              backgroundColor: PixelColors.backgroundCard,
              child: Row(
                children: [
                  const PixelSprite(spriteType: 'trophy', size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.title,
                          style: PixelTypography.pixelSubheader(
                            fontSize: 11,
                            color: PixelColors.coinGold,
                          ),
                        ),
                        if (reward.description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            reward.description,
                            style: PixelTypography.standardBody(
                              fontSize: 10,
                              color: PixelColors.textMuted,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          'Redeemed ${reward.timesRedeemed} times',
                          style: PixelTypography.pixelBody(
                            fontSize: 10,
                            color: PixelColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    text: '${reward.coinCost}',
                    icon: Icons.monetization_on,
                    fontSize: 9,
                    backgroundColor: canAfford
                        ? PixelColors.coinGold
                        : PixelColors.borderHighlight.withAlpha(80),
                    textColor: canAfford ? Colors.black : PixelColors.textMuted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    onPressed: canAfford
                        ? () {
                            final success = onRedeem(reward.id);
                            if (success) {
                              showDialog(
                                context: context,
                                builder: (ctx) =>
                                    RewardCelebrationDialog(reward: reward),
                              );
                            }
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                      color: PixelColors.textMuted,
                    ),
                    onPressed: () async {
                      final edited = await showDialog<CustomRewardModel>(
                        context: context,
                        builder: (ctx) =>
                            CreateCustomRewardDialog(rewardToEdit: reward),
                      );
                      if (edited != null) onEdit(edited);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: PixelColors.hpRed,
                    ),
                    onPressed: () => onDelete(reward.id),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
