import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/tavern_model.dart';

class InventoryDialog extends StatelessWidget {
  const InventoryDialog({
    super.key,
    required this.inventory,
    required this.activeStreakShields,
    required this.onUseItem,
  });

  final List<InventoryItemModel> inventory;
  final int activeStreakShields;
  final void Function(String shopItemId) onUseItem;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelCard(
        borderColor: PixelColors.coinGold,
        backgroundColor: PixelColors.backgroundCard,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ADVENTURER INVENTORY',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              if (activeStreakShields > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  color: PixelColors.mpCyan.withAlpha(30),
                  child: Center(
                    child: Text(
                      '🛡 STREAK SHIELDS ACTIVE: $activeStreakShields',
                      style: PixelTypography.pixelHeader(
                        fontSize: 9,
                        color: PixelColors.mpCyan,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (inventory.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Inventory is empty. Purchase potions at the Tavern!',
                      style: TextStyle(color: PixelColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...inventory.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PixelColors.backgroundSurface,
                      border: Border.all(color: PixelColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        PixelSprite(spriteType: item.spriteType, size: 36),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.name} (x${item.quantity})',
                                style: PixelTypography.pixelSubheader(
                                  fontSize: 10,
                                  color: PixelColors.textBright,
                                ),
                              ),
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
                          text: 'USE',
                          fontSize: 9,
                          backgroundColor: PixelColors.hpGreen,
                          textColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          onPressed: () {
                            onUseItem(item.shopItemId);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 10),
              PixelButton(
                text: 'CLOSE INVENTORY',
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
