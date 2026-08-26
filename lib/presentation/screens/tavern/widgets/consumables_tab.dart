import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/domain/models/hero_model.dart';

class ConsumablesTab extends StatelessWidget {
  const ConsumablesTab({
    super.key,
    required this.items,
    required this.hero,
    required this.onBuy,
  });

  final List<ShopItemModel> items;
  final HeroModel hero;
  final void Function(String id) onBuy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final canAfford = hero.coins >= item.cost;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PixelCard(
            borderColor: PixelColors.borderHighlight,
            backgroundColor: PixelColors.backgroundCard,
            child: Row(
              children: [
                PixelSprite(spriteType: item.spriteType, size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: PixelTypography.pixelSubheader(
                          fontSize: 11,
                          color: PixelColors.textBright,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: PixelTypography.standardBody(
                          fontSize: 10,
                          color: PixelColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PixelButton(
                  text: '${item.cost}',
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
                  onPressed: canAfford ? () => onBuy(item.id) : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
