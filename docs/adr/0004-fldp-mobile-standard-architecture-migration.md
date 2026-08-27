# 0004. Adoption of FLDP Mobile Standard Architecture (Feature-First, BLoC, Drift SQLite, AutoRoute, GetIt, and Multi-Folder i18n)

## Status
Accepted

## Context
WorkXP (Pocket Quest) was initially developed with a Layer-First Riverpod and Hive NoSQL stack. To conform with the organizational standard established in [fakduai-logistics-and-digital-platform/mobile-standard-app](https://github.com/fakduai-logistics-and-digital-platform/mobile-standard-app), the application architecture requires standardization across state management, dependency injection, routing, persistence, localization, and feature directory organization.

## Decisions

1. **State Management & Dependency Injection**:
   - Adopt **`flutter_bloc`** (^9.1.1) and **`equatable`** for state management.
   - Separate concerns into granular BLoCs (e.g. `HeroBloc`, `BossBloc`, `QuestBloc`, `TavernBloc`, `LanguageBloc`) that react to domain repository streams.
   - Adopt **`get_it`** (^8.0.3) registered centrally in `lib/locator.dart` for dependency injection.

2. **Persistence & Data Layer**:
   - Implement **`drift`** (^2.23.1) with SQLite as the primary relational database (`lib/domain/datasource/app_database.dart`) with `MigrationStrategy` handling Starter Kit seeding upon initial creation.
   - Retain **`hive`** (`lib/domain/datasource/hive_config.dart`) for lightweight local preferences and caching.
   - Wrap persistence behind clean Repository interfaces in `lib/domain/repositories/`.

3. **Navigation & Routing**:
   - Adopt **`auto_route`** (^10.1.0+1) with code-generation (`@AutoRouterConfig`, `@RoutePage`).
   - Implement `DashboardPage` using `AutoTabsScaffold` for the 5 core game hubs (Battle Hub, World Map / Dungeon, Tavern, Analytics, Hero Sanctuary) with nested sub-routes.

4. **Localization (i18n)**:
   - Adopt multi-folder ARB structure (`lib/i18n/locals/<feature>/en.arb`, `th.arb`).
   - Provide cross-platform Dart generation tool (`tool/generate_i18n.dart`) and `generate_all.sh` shell script updating `lib/i18n/i18n.dart`.

5. **Directory Organization**:
   - Reorganize from Layer-first to **Feature-First**:
     - `lib/config/`
     - `lib/domain/` (datasource, http_client, models, repositories)
     - `lib/feature/<feature_name>/` (bloc, pages, widgets)
     - `lib/i18n/` (locals/, i18n.dart)
     - `lib/router/`
     - `lib/shared/` (bloc, theme, widgets, utils)
     - `lib/locator.dart` & `lib/main.dart`

## Consequences
- Full alignment with corporate mobile engineering standards.
- Strong relational integrity, offline performance, type-safe navigation, and multi-language support (TH/EN).
- Requires updating all Riverpod notifiers and test suites to BLoC and Drift mocks.
