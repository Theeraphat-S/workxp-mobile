import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';
import 'create_custom_reward_dialog.dart';
import 'reward_celebration_dialog.dart';

class CustomRewardsTab extends StatelessWidget {
  const CustomRewardsTab({
    super.key,
    this.rewards = const [],
    this.driftRewards = const [],
    this.heroModel,
    this.hero,
    required this.onRedeem,
    required this.onAdd,
    this.onEdit,
    required this.onDelete,
  });

  final List<CustomRewardModel> rewards;
  final List<TavernItem> driftRewards;
  final HeroModel? heroModel;
  final Hero? hero;
  final bool Function(String id) onRedeem;
  final void Function(CustomRewardModel reward) onAdd;
  final void Function(CustomRewardModel reward)? onEdit;
  final void Function(String id) onDelete;

  int get heroCoins => hero?.coins ?? heroModel?.coins ?? 0;

  List<CustomRewardModel> get _combinedRewards {
    if (rewards.isNotEmpty) return rewards;
    return driftRewards
        .map((r) => CustomRewardModel(
              id: r.id,
              title: r.name,
              description: r.description,
              coinCost: r.cost,
              iconName: r.iconAsset,
              timesRedeemed: r.quantity,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _combinedRewards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REAL-LIFE REWARDS (${list.length})',
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
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No custom rewards created. Set your real-life treats above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...list.map((reward) {
          final canAfford = heroCoins >= reward.coinCost;

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
                          'Redeemed: ${reward.timesRedeemed} times',
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
                    text: '${reward.coinCost}c',
                    fontSize: 9,
                    backgroundColor: canAfford
                        ? PixelColors.coinGold
                        : PixelColors.borderHighlight.withAlpha(80),
                    textColor: canAfford ? Colors.black : PixelColors.textMuted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
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
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      size: 16,
                      color: PixelColors.textMuted,
                    ),
                    color: PixelColors.backgroundSurface,
                    onSelected: (val) {
                      if (val == 'delete') {
                        onDelete(reward.id);
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Reward',
                          style: PixelTypography.pixelSubheader(
                            fontSize: 9,
                            color: PixelColors.hpRed,
                          ),
                        ),
                      ),
                    ],
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
