import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/feature/hero_sanctuary/bloc/sanctuary_bloc.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'widgets/hero_card_widget.dart';
import 'widgets/settings_section.dart';
import 'widgets/skin_selection_widget.dart';
import 'widgets/stat_allocation_widget.dart';
import 'widgets/title_selection_widget.dart';

@RoutePage()
class HeroSanctuaryPage extends StatelessWidget {
  const HeroSanctuaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SanctuaryBloc>(
      create: (ctx) => locator<SanctuaryBloc>()..add(const LoadSanctuary()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'HERO SANCTUARY',
            style: PixelTypography.pixelHeader(
              fontSize: 14,
              color: PixelColors.coinGold,
            ),
          ),
          backgroundColor: PixelColors.backgroundDark,
        ),
        body: BlocBuilder<SanctuaryBloc, SanctuaryState>(
          builder: (context, state) {
            final hero = state is SanctuaryLoaded ? state.hero : null;
            final heroModel = state is SanctuaryLoaded ? state.heroModel : null;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Hero Summary Profile Card
                    HeroCardWidget(
                      hero: hero,
                      heroModel: heroModel,
                    ),
                    const SizedBox(height: 16),

                    // 2. Stat Attributes Allocation
                    StatAllocationWidget(
                      hero: hero,
                      heroModel: heroModel,
                      onAllocate: (attr) {
                        context
                            .read<SanctuaryBloc>()
                            .add(AllocateStatPoint(attr));
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3. Avatar Skin Selection
                    SkinSelectionWidget(
                      hero: hero,
                      heroModel: heroModel,
                      onSelectSkin: (skinId) {
                        context
                            .read<SanctuaryBloc>()
                            .add(EquipSkinEvent(skinId));
                      },
                    ),
                    const SizedBox(height: 16),

                    // 4. Earned Title Selection
                    TitleSelectionWidget(
                      hero: hero,
                      heroModel: heroModel,
                      onSelectTitle: (title) {
                        context
                            .read<SanctuaryBloc>()
                            .add(EquipTitleEvent(title));
                      },
                    ),
                    const SizedBox(height: 16),

                    // 5. Settings & Local Storage Backup
                    const SettingsSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
