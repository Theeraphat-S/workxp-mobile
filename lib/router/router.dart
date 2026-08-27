import 'package:auto_route/auto_route.dart';
import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: DashboardRoute.page,
          initial: true,
          children: [
            AutoRoute(
              path: 'battle',
              page: BattleHubRoute.page,
              initial: true,
            ),
            AutoRoute(
              path: 'dungeon',
              page: DungeonMapRoute.page,
            ),
            AutoRoute(
              path: 'tavern',
              page: TavernRoute.page,
            ),
            AutoRoute(
              path: 'analytics',
              page: AnalyticsRoute.page,
            ),
            AutoRoute(
              path: 'sanctuary',
              page: HeroSanctuaryRoute.page,
            ),
          ],
        ),
      ];
}
