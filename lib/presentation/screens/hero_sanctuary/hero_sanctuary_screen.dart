import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'widgets/hero_card_widget.dart';
import 'widgets/stat_allocation_widget.dart';
import 'widgets/title_selection_widget.dart';
import 'widgets/skin_selection_widget.dart';
import 'widgets/settings_section.dart';

class HeroSanctuaryScreen extends ConsumerWidget {
  const HeroSanctuaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hero = ref.watch(heroProvider);
    final heroNotifier = ref.read(heroProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HERO SANCTUARY',
          style: PixelTypography.pixelHeader(
            fontSize: 14,
            color: PixelColors.coinGold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeroCardWidget(hero: hero),
              const SizedBox(height: 16),
              StatAllocationWidget(
                hero: hero,
                onAllocate: (attr) => heroNotifier.allocateStatPoint(attr),
              ),
              const SizedBox(height: 16),
              TitleSelectionWidget(
                hero: hero,
                onSelectTitle: (title) => heroNotifier.setActiveTitle(title),
              ),
              const SizedBox(height: 16),
              SkinSelectionWidget(
                hero: hero,
                onSelectSkin: (skinId) => heroNotifier.setActiveSkin(skinId),
              ),
              const SizedBox(height: 16),
              const SettingsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
