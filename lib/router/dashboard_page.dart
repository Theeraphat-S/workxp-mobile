import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/services/sensory_service.dart';
import '../i18n/i18n.dart';
import '../shared/bloc/language/language_bloc.dart';
import '../shared/theme/pixel_colors.dart';
import '../shared/theme/pixel_typography.dart';
import '../shared/widgets/crt_scanline_overlay.dart';
import 'router.gr.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrtScanlineOverlay(
      enabled: true,
      child: AutoTabsScaffold(
        routes: const [
          BattleHubRoute(),
          DungeonMapRoute(),
          TavernRoute(),
          AnalyticsRoute(),
          HeroSanctuaryRoute(),
        ],
        bottomNavigationBuilder: (navContext, tabsRouter) {
          final bloc = BlocProvider.of<LanguageBloc>(navContext);
          final i18n = I18n(bloc.state.locale);
          return Container(
            decoration: const BoxDecoration(
              color: PixelColors.backgroundDark,
              border: Border(
                top: BorderSide(
                  color: PixelColors.borderHighlight,
                  width: 2.0,
                ),
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
                      i18n: i18n,
                      key: const Key('nav_battle'),
                      index: 0,
                      tabsRouter: tabsRouter,
                      icon: Icons.sports_martial_arts,
                    ),
                    _buildNavItem(
                      i18n: i18n,
                      key: const Key('nav_dungeon'),
                      index: 1,
                      tabsRouter: tabsRouter,
                      icon: Icons.map,
                    ),
                    _buildNavItem(
                      i18n: i18n,
                      key: const Key('nav_tavern'),
                      index: 2,
                      tabsRouter: tabsRouter,
                      icon: Icons.storefront,
                    ),
                    _buildNavItem(
                      i18n: i18n,
                      key: const Key('nav_analytics'),
                      index: 3,
                      tabsRouter: tabsRouter,
                      icon: Icons.bar_chart,
                    ),
                    _buildNavItem(
                      i18n: i18n,
                      key: const Key('nav_sanctuary'),
                      index: 4,
                      tabsRouter: tabsRouter,
                      icon: Icons.shield,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required I18n i18n,
    required Key key,
    required int index,
    required TabsRouter tabsRouter,
    required IconData icon,
  }) {
    final isSelected = tabsRouter.activeIndex == index;
    final color = isSelected ? PixelColors.coinGold : PixelColors.textMuted;
    final navLabel = switch (index) {
      0 => i18n.shared.navBattle,
      1 => i18n.shared.navDungeon,
      2 => i18n.shared.navTavern,
      3 => i18n.shared.navAnalytics,
      _ => i18n.shared.navSanctuary,
    };

    return Expanded(
      child: InkWell(
        key: key,
        onTap: () {
          if (!isSelected) {
            SensoryService.instance.playClick();
            tabsRouter.setActiveIndex(index);
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
              navLabel.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PixelTypography.pixelSubheader(
                fontSize: 8,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
