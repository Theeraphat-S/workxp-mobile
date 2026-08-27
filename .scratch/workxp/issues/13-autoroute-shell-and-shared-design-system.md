# 13: AutoRoute Navigation Shell & 16-Bit Shared Design System

**What to build:** Set up the declarative AutoRoute navigation structure with a 5-tab shell and consolidate the 16-bit retro pixel design system so that all screens can navigate seamlessly with consistent retro visuals.

**Blocked by:** 11: Core Foundation, Dependencies & Build Infrastructure

**Status:** completed

- [x] Move and organize retro theme and typography (`PixelColors`, `PixelTypography`, `PixelTheme`) into `lib/shared/theme/`.
- [x] Move and organize 16-bit retro pixel widgets (`PixelButton`, `PixelCard`, `PixelProgressBar`, `PixelSprite`, `PixelBadge`) into `lib/shared/widgets/`.
- [x] Move and organize `SensoryService` and `DayCycleService` into `lib/shared/utils/`.
- [x] Configure `lib/router/router.dart` with `@AutoRouterConfig` and `DashboardPage` using `AutoTabsScaffold` for the 5 core game hubs.
- [x] Generate AutoRoute code (`lib/router/router.gr.dart`) using `dart run build_runner build`.
- [x] Implement `LanguageBloc` in `lib/shared/bloc/language/` to manage dynamic language switching (TH/EN).
- [x] Register `AppRouter`, `LanguageBloc`, `SensoryService`, and `DayCycleService` in `lib/locator.dart`.
- [x] Add widget tests for `DashboardPage` navigation and pixel widgets.
