import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';
import 'widgets/consumables_tab.dart';
import 'widgets/cosmetics_tab.dart';
import 'widgets/custom_rewards_tab.dart';
import 'widgets/inventory_dialog.dart';

class TavernScreen extends ConsumerStatefulWidget {
  const TavernScreen({super.key});

  @override
  ConsumerState<TavernScreen> createState() => _TavernScreenState();
}

class _TavernScreenState extends ConsumerState<TavernScreen> {
  int _activeTabIndex = 0; // 0 = Consumables, 1 = Cosmetics, 2 = Custom Rewards

  @override
  Widget build(BuildContext context) {
    final hero = ref.watch(heroProvider);
    final tavern = ref.watch(tavernProvider);

    final heroNotifier = ref.read(heroProvider.notifier);
    final tavernNotifier = ref.read(tavernProvider.notifier);

    final consumables = tavern.catalog
        .where((i) => i.type == 'consumable')
        .toList();
    final cosmetics = tavern.catalog
        .where((i) => i.type == 'skin' || i.type == 'theme')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'THE TAVERN',
          style: PixelTypography.pixelHeader(
            fontSize: 14,
            color: PixelColors.coinGold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.backpack, color: PixelColors.coinGold),
            tooltip: 'Inventory',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => InventoryDialog(
                  inventory: tavern.inventory,
                  activeStreakShields: tavern.activeStreakShields,
                  onUseItem: (id) => tavernNotifier.useConsumable(
                    id,
                    heroNotifier: heroNotifier,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Tavern Header & Coin Purse
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PixelColors.backgroundCard,
                  border: Border.all(color: PixelColors.borderGold, width: 1.5),
                ),
                child: Row(
                  children: [
                    const PixelSprite(spriteType: 'coin', size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HERO PURSE',
                          style: PixelTypography.pixelSubheader(
                            fontSize: 9,
                            color: PixelColors.textMuted,
                          ),
                        ),
                        Text(
                          '${hero.coins} COINS',
                          style: PixelTypography.pixelHeader(
                            fontSize: 14,
                            color: PixelColors.coinGold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    PixelButton(
                      text:
                          'INVENTORY (${tavern.inventory.fold<int>(0, (sum, i) => sum + i.quantity)})',
                      fontSize: 8,
                      backgroundColor: PixelColors.backgroundSurface,
                      textColor: PixelColors.coinGold,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => InventoryDialog(
                            inventory: tavern.inventory,
                            activeStreakShields: tavern.activeStreakShields,
                            onUseItem: (id) => tavernNotifier.useConsumable(
                              id,
                              heroNotifier: heroNotifier,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Tavern Tabs
              Row(
                children: [
                  _buildTavernTab(0, 'POTIONS'),
                  const SizedBox(width: 8),
                  _buildTavernTab(1, 'SKINS'),
                  const SizedBox(width: 8),
                  _buildTavernTab(2, 'REAL REWARDS'),
                ],
              ),
              const SizedBox(height: 14),
              if (_activeTabIndex == 0)
                ConsumablesTab(
                  items: consumables,
                  hero: hero,
                  onBuy: (id) =>
                      tavernNotifier.buyItem(id, heroNotifier: heroNotifier),
                )
              else if (_activeTabIndex == 1)
                CosmeticsTab(
                  items: cosmetics,
                  hero: hero,
                  onBuy: (id) =>
                      tavernNotifier.buyItem(id, heroNotifier: heroNotifier),
                  onEquip: (skinId) => heroNotifier.setActiveSkin(skinId),
                )
              else
                CustomRewardsTab(
                  rewards: tavern.customRewards,
                  hero: hero,
                  onRedeem: (id) => tavernNotifier.redeemCustomReward(
                    id,
                    heroNotifier: heroNotifier,
                  ),
                  onAdd: (r) => tavernNotifier.addCustomReward(r),
                  onEdit: (r) => tavernNotifier.editCustomReward(r),
                  onDelete: (id) => tavernNotifier.deleteCustomReward(id),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTavernTab(int index, String label) {
    final isSelected = _activeTabIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? PixelColors.coinGold
                : PixelColors.backgroundSurface,
            border: Border.all(
              color: isSelected
                  ? PixelColors.coinAmber
                  : PixelColors.borderDark,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: PixelTypography.pixelSubheader(
                fontSize: 8,
                color: isSelected ? Colors.black : PixelColors.textBright,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
