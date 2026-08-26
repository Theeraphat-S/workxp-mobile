import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/pixel_colors.dart';
import '../../core/theme/pixel_typography.dart';
import '../../core/services/sensory_service.dart';
import '../providers/navigation_provider.dart';
import 'battle_hub/battle_hub_screen.dart';
import 'world_map/world_map_screen.dart';
import 'tavern/tavern_screen.dart';
import 'hall_of_fame/hall_of_fame_screen.dart';
import 'hero_sanctuary/hero_sanctuary_screen.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    BattleHubScreen(),
    WorldMapScreen(),
    TavernScreen(),
    HallOfFameScreen(),
    HeroSanctuaryScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: PixelColors.backgroundDark,
          border: Border(
            top: BorderSide(color: PixelColors.borderHighlight, width: 2.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  ref: ref,
                  index: 0,
                  currentIndex: currentIndex,
                  label: 'BATTLE',
                  icon: Icons.sports_martial_arts,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 1,
                  currentIndex: currentIndex,
                  label: 'MAP',
                  icon: Icons.map,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 2,
                  currentIndex: currentIndex,
                  label: 'TAVERN',
                  icon: Icons.storefront,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 3,
                  currentIndex: currentIndex,
                  label: 'STATS',
                  icon: Icons.bar_chart,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 4,
                  currentIndex: currentIndex,
                  label: 'HERO',
                  icon: Icons.shield,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required WidgetRef ref,
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
  }) {
    final isSelected = index == currentIndex;
    final color = isSelected ? PixelColors.coinGold : PixelColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            SensoryService.instance.playClick();
            ref.read(navigationProvider.notifier).setTab(index);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? PixelColors.backgroundSurface
                    : Colors.transparent,
                border: isSelected
                    ? Border.all(color: PixelColors.borderGold, width: 1.5)
                    : Border.all(color: Colors.transparent, width: 1.5),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: PixelTypography.pixelSubheader(fontSize: 8, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
