import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/domain/models/hero_model.dart';

class CosmeticsTab extends StatelessWidget {
  const CosmeticsTab({
    super.key,
    required this.items,
    required this.hero,
    required this.onBuy,
    required this.onEquip,
  });

  final List<TavernItemModel> items;
  final HeroModel hero;
  final void Function(String id) onBuy;
  final void Function(String skinId) onEquip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final isUnlocked = hero.unlockedSkins.contains(item.id);
        final isEquipped = hero.activeSkinId == item.id;
        final canAfford = hero.coins >= item.cost;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PixelCard(
            borderColor: isEquipped
                ? PixelColors.coinGold
                : PixelColors.borderHighlight,
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
                          color: isEquipped
                              ? PixelColors.coinGold
                              : PixelColors.textBright,
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
                if (isEquipped)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: PixelColors.hpGreen.withAlpha(40),
                    child: Text(
                      'EQUIPPED',
                      style: PixelTypography.pixelHeader(
                        fontSize: 8,
                        color: PixelColors.hpGreen,
                      ),
                    ),
                  )
                else if (isUnlocked)
                  PixelButton(
                    text: 'EQUIP',
                    fontSize: 9,
                    backgroundColor: PixelColors.attrWis,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    onPressed: () => onEquip(item.id),
                  )
                else
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
