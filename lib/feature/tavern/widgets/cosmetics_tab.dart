import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class CosmeticsTab extends StatelessWidget {
  const CosmeticsTab({
    super.key,
    this.items = const [],
    this.driftItems = const [],
    this.heroModel,
    this.hero,
    required this.onBuy,
    required this.onEquip,
  });

  final List<TavernItemModel> items;
  final List<TavernItem> driftItems;
  final HeroModel? heroModel;
  final Hero? hero;
  final void Function(String id) onBuy;
  final void Function(String skinId) onEquip;

  int get heroCoins => hero?.coins ?? heroModel?.coins ?? 0;
  String get activeSkinId => hero?.avatarSkinId ?? heroModel?.activeSkinId ?? 'hero_novice';

  List<TavernItemModel> get _combinedItems {
    if (items.isNotEmpty) return items;
    return driftItems
        .map((item) => TavernItemModel(
              id: item.id,
              name: item.name,
              description: item.description,
              cost: item.cost,
              type: item.category,
              spriteType: item.iconAsset,
              effectValue: item.effectValue,
            ))
        .toList();
  }

  bool _isItemPurchased(String itemId) {
    if (heroModel?.unlockedSkins.contains(itemId) == true) return true;
    final item = driftItems.where((i) => i.id == itemId).firstOrNull;
    return item?.isPurchased ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final list = _combinedItems;

    return Column(
      children: list.map((item) {
        final isUnlocked = _isItemPurchased(item.id);
        final isEquipped = activeSkinId == item.id;
        final canAfford = heroCoins >= item.cost;

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
