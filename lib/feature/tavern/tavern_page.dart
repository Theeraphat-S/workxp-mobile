import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/feature/battle_hub/bloc/hero_bloc.dart';
import 'package:workxp/feature/tavern/bloc/tavern_bloc.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';
import 'widgets/consumables_tab.dart';
import 'widgets/cosmetics_tab.dart';
import 'widgets/custom_rewards_tab.dart';
import 'widgets/inventory_dialog.dart';

@RoutePage()
class TavernPage extends StatefulWidget {
  const TavernPage({super.key});

  @override
  State<TavernPage> createState() => _TavernPageState();
}

class _TavernPageState extends State<TavernPage> {
  int _activeTabIndex = 0; // 0 = Consumables, 1 = Cosmetics, 2 = Custom Rewards

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      appBar: AppBar(
          title: Text(
            'THE TAVERN',
            style: PixelTypography.pixelHeader(
              fontSize: 14,
              color: PixelColors.coinGold,
            ),
          ),
          backgroundColor: PixelColors.backgroundDark,
          actions: [
            BlocBuilder<TavernBloc, TavernState>(
              builder: (context, state) {
                final inventory =
                    state is TavernLoaded ? state.inventory : <TavernItem>[];
                return IconButton(
                  icon: const Icon(Icons.backpack, color: PixelColors.coinGold),
                  tooltip: 'Inventory',
                  onPressed: () {
                    SensoryService.instance.playClick();
                    showDialog(
                      context: context,
                      builder: (ctx) => InventoryDialog(
                        driftInventory: inventory,
                        onUseItem: (id) {
                          context
                              .read<TavernBloc>()
                              .add(UseConsumableItem(id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<TavernBloc, TavernState>(
          builder: (context, state) {
            final hero = state is TavernLoaded ? state.hero : null;
            final consumables =
                state is TavernLoaded ? state.consumables : <TavernItem>[];
            final cosmetics =
                state is TavernLoaded ? state.cosmetics : <TavernItem>[];
            final customRewards =
                state is TavernLoaded ? state.customRewards : <TavernItem>[];

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Tavern Header & Coin Purse
                    PixelCard(
                      borderColor: PixelColors.borderGold,
                      backgroundColor: PixelColors.backgroundCard,
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
                                '${hero?.coins ?? 0} COINS',
                                style: PixelTypography.pixelHeader(
                                  fontSize: 14,
                                  color: PixelColors.coinGold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PixelButton(
                            text: 'INVENTORY',
                            fontSize: 9,
                            backgroundColor: PixelColors.backgroundSurface,
                            textColor: PixelColors.coinGold,
                            onPressed: () {
                              SensoryService.instance.playClick();
                              final inv = state is TavernLoaded
                                  ? state.inventory
                                  : <TavernItem>[];
                              showDialog(
                                context: context,
                                builder: (ctx) => InventoryDialog(
                                  driftInventory: inv,
                                  onUseItem: (id) {
                                    context
                                        .read<TavernBloc>()
                                        .add(UseConsumableItem(id));
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Marketplace Category Selector
                    Container(
                      decoration: BoxDecoration(
                        color: PixelColors.backgroundDark,
                        border: Border.all(color: PixelColors.borderHighlight),
                      ),
                      child: Row(
                        children: [
                          _buildTabItem(0, 'POTIONS', Icons.science),
                          _buildTabItem(1, 'COSMETICS', Icons.palette),
                          _buildTabItem(2, 'REWARDS', Icons.card_giftcard),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Active Tab Content
                    if (_activeTabIndex == 0)
                      ConsumablesTab(
                        driftItems: consumables,
                        hero: hero,
                        onBuy: (id) {
                          context.read<TavernBloc>().add(PurchaseItem(id));
                        },
                      )
                    else if (_activeTabIndex == 1)
                      CosmeticsTab(
                        driftItems: cosmetics,
                        hero: hero,
                        onBuy: (id) {
                          context.read<TavernBloc>().add(PurchaseItem(id));
                        },
                        onEquip: (skinId) {
                          context
                              .read<HeroBloc>()
                              .add(EquipSkin(skinId));
                        },
                      )
                    else if (_activeTabIndex == 2)
                      CustomRewardsTab(
                        driftRewards: customRewards,
                        hero: hero,
                        onRedeem: (id) {
                          context
                              .read<TavernBloc>()
                              .add(RedeemCustomRewardEvent(id));
                          return true;
                        },
                        onAdd: (newReward) {
                          context
                              .read<TavernBloc>()
                              .add(CreateCustomRewardEvent(
                                name: newReward.title,
                                cost: newReward.coinCost,
                                description: newReward.description,
                                iconAsset: newReward.iconName,
                                id: newReward.id,
                              ));
                        },
                        onDelete: (id) {
                          context
                              .read<TavernBloc>()
                              .add(DeleteCustomRewardEvent(id));
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );

    try {
      context.read<TavernBloc>();
    } catch (_) {
      content = MultiBlocProvider(
        providers: [
          BlocProvider<TavernBloc>(
            create: (ctx) => locator<TavernBloc>()..add(const LoadTavern()),
          ),
          BlocProvider<HeroBloc>(
            create: (ctx) => locator<HeroBloc>()..add(const LoadHero()),
          ),
        ],
        child: content,
      );
    }
    return content;
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _activeTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          SensoryService.instance.playClick();
          setState(() => _activeTabIndex = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? PixelColors.backgroundSurface
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? PixelColors.coinGold : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color:
                    isSelected ? PixelColors.coinGold : PixelColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: isSelected
                      ? PixelColors.coinGold
                      : PixelColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
