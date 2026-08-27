# Project: WorkXP (FLDP Mobile Standard Architecture Standardization)

## Architecture
WorkXP is a 16-bit retro pixel fantasy RPG gamified productivity mobile application.
This standardization migrates the architecture to the FLDP Mobile Standard (`fakduai-logistics-and-digital-platform/mobile-standard-app`):
- **State Management**: `flutter_bloc` (^9.1.1) with `Equatable` events/states.
- **Persistence**: `drift` (^2.23.1) SQLite relational database with reactive Dart stream watchers (`select().watch()`) for zero-latency 60fps UI updates. Local preferences/cache in Hive (`hive_flutter` ^1.1.0).
- **Navigation**: `auto_route` (^10.1.0+1) declarative routing with `DashboardPage` (`AutoTabsScaffold`) hosting 5 primary destinations (Battle Hub, World Map / Dungeon, Tavern, Analytics, Hero Sanctuary) and type-safe sub-routes.
- **Dependency Injection**: `get_it` (^8.0.3) centralized service locator in `lib/locator.dart`.
- **Localization (i18n)**: Feature-divided multi-folder ARB structure (`lib/i18n/locals/<feature>/en.arb` & `th.arb`) compiled via `tool/generate_i18n.dart` into `lib/i18n/i18n.dart`, dynamically switched via `LanguageBloc`.
- **UI/UX Design System**: 16-bit retro pixel tokens (`PixelColors`, `PixelTypography`), custom widgets (`PixelButton`, `PixelCard`, `PixelProgressBar`, `PixelSprite`, `PixelBadge`), CRT scanlines, and 60fps floating combat overlays.

## Code Layout
```
lib/
├── config/                  # Environment and application configurations (.env loader)
│   └── config.dart
├── domain/                  # Pure domain entities, database tables & repository interfaces
│   ├── datasource/          # Drift SQLite database (app_database.dart) & Hive storage
│   │   ├── app_database.dart
│   │   └── hive_config.dart
│   ├── models/              # Pure domain entities and game math logic
│   └── repositories/        # Repository contracts & Drift reactive implementations
│       ├── hero_repository.dart
│       ├── boss_repository.dart
│       ├── quest_repository.dart
│       ├── daily_quest_repository.dart
│       ├── habit_repository.dart
│       ├── tavern_repository.dart
│       └── combat_log_repository.dart
├── feature/                 # Feature-first vertical slices
│   ├── battle_hub/          # Hero, Boss, Quests, Dailies, Habits, Ghost State, Revival
│   ├── dungeon/             # World map, chapter campaign progression
│   ├── tavern/              # Marketplace, item purchases, custom real-world rewards
│   ├── analytics/           # Charts (EXP, Damage, Heatmap, Radar), Leaderboard
│   └── hero_sanctuary/      # Attributes, cosmetics, audio/haptic settings, JSON backup
├── i18n/                    # Feature-divided multi-language localization
│   ├── i18n.dart            # Compiled string translations
│   └── locals/              # Modular ARB dictionaries per feature (en.arb, th.arb)
├── router/                  # AutoRoute configuration and route generation
│   ├── router.dart
│   ├── router.gr.dart
│   └── dashboard_page.dart
├── shared/                  # Cross-cutting design system, theme tokens, common BLoCs
│   ├── bloc/                # Shared BLoCs (LanguageBloc)
│   ├── theme/               # 16-bit pixel theme, typography, color constants
│   └── widgets/             # Reusable retro pixel UI components
├── locator.dart             # Centralized GetIt service locator setup
└── main.dart                # Application entrypoint
```

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Standard Dependencies Stack | Configure pubspec.yaml with flutter_bloc, drift, auto_route, get_it, dio, dotenv, etc. | M1 | ORIGINAL_REQUEST §R1 |
| 2 | Environment Configuration | Load .env in lib/config/config.dart | M1 | ORIGINAL_REQUEST §R1 |
| 3 | Service Locator Infrastructure | lib/locator.dart registering DB, repos, services, and BLoCs via GetIt | M1 | ORIGINAL_REQUEST §R1 |
| 4 | i18n Compilation Tool | tool/generate_i18n.dart compiling multi-folder ARBs to lib/i18n/i18n.dart | M1 | ORIGINAL_REQUEST §R5 |
| 5 | Drift SQLite Schema (7 Tables) | Heroes, Bosses, Quests, DailyQuests, Habits, TavernItems, CombatLogs | M2 | ORIGINAL_REQUEST §R2 |
| 6 | Starter Kit Auto-Seeding | MigrationStrategy.onCreate seeding Novice Hero, King Slime, Quests, Habits, Items | M2 | ORIGINAL_REQUEST §R2 |
| 7 | Reactive Stream Repositories | Repositories in lib/domain/repositories/ exposing Drift watch queries | M2 | ORIGINAL_REQUEST §R2 |
| 8 | Local Storage / Cache Config | lib/domain/datasource/hive_config.dart for local preferences/cache | M2 | ORIGINAL_REQUEST §R2 |
| 9 | AutoRoute 5-Tab Navigation Shell | DashboardPage (AutoTabsScaffold) managing Battle Hub, Dungeon, Tavern, Analytics, Sanctuary | M3 | ORIGINAL_REQUEST §R3 |
| 10 | 16-Bit Shared Retro Theme Tokens | PixelColors, PixelTypography, CRT scanlines in lib/shared/theme/ | M3 | ORIGINAL_REQUEST §R3 |
| 11 | Shared 16-Bit Retro UI Components | PixelButton, PixelCard, PixelProgressBar, PixelSprite, PixelBadge in lib/shared/widgets/ | M3 | ORIGINAL_REQUEST §R3 |
| 12 | Language Switching BLoC | LanguageBloc in lib/shared/bloc/language/ for real-time TH/EN toggle | M3 | ORIGINAL_REQUEST §R3 |
| 13 | Battle Hub: Hero & Boss State | HeroBloc, BossBloc managing stats, HP/MP pools, leveling, and Boss encounters | M4A | ORIGINAL_REQUEST §R4 |
| 14 | Battle Hub: Quest Combat Strike | QuestBloc executing damage strikes, EXP gains, Coin rewards, and Level Up triggers | M4A | ORIGINAL_REQUEST §R4 |
| 15 | Battle Hub: Daily Quests & Midnight Penalty | DailyQuestBloc managing daily habits, midnight counter-attack damage, and streak tracking | M4A | ORIGINAL_REQUEST §R4 |
| 16 | Battle Hub: Ghost State & Revival | Hero HP <= 0 triggers Ghost State (-50% rewards), completed via Revival Quest | M4A | ORIGINAL_REQUEST §R4 |
| 17 | Battle Hub: Habits & MP Buffs | HabitBloc logging positive/negative habits, modifying Coin balance and MP pool | M4A | ORIGINAL_REQUEST §R4 |
| 18 | Battle Hub: 60fps Floating Combat UI | BattleHubPage with animated damage floating numbers and sprite shake | M4A | ORIGINAL_REQUEST §R4 |
| 19 | Dungeon: Campaign Progression | DungeonBloc, DungeonMapPage managing chapters, stages, unlocks, and boss progression | M4B | ORIGINAL_REQUEST §R4 |
| 20 | Tavern: Marketplace Economy | TavernBloc, TavernPage handling consumable/cosmetic purchases and inventory | M4C | ORIGINAL_REQUEST §R4 |
| 21 | Tavern: Custom Real-Life Rewards | Creation, editing, and redemption of user-defined custom rewards with Coin cost | M4C | ORIGINAL_REQUEST §R4 |
| 22 | Analytics: Visual Charts & Metrics | AnalyticsBloc, AnalyticsPage with FL Chart views (EXP, Damage, Habit Heatmap, Radar) | M4D | ORIGINAL_REQUEST §R4 |
| 23 | Analytics: Simulated Leaderboard | Leaderboard view comparing Hero score against simulated adventurers | M4D | ORIGINAL_REQUEST §R4 |
| 24 | Sanctuary: Attribute Point Allocation | SanctuaryBloc, HeroSanctuaryPage distributing unspent attribute points (STR/AGI/INT/VIT) | M4E | ORIGINAL_REQUEST §R4 |
| 25 | Sanctuary: Cosmetics & Customization | Equipping unlocked avatar skins, banners, and character titles | M4E | ORIGINAL_REQUEST §R4 |
| 26 | Sanctuary: Audio & Haptic Settings | Sensory settings toggles persisting to Hive | M4E | ORIGINAL_REQUEST §R4 |
| 27 | Sanctuary: JSON Backup Export/Import | Full state backup export to JSON file and import restoration | M4E | ORIGINAL_REQUEST §R4 |
| 28 | Multi-Feature Localization Dictionaries | ARB files for all features (battle_hub, dungeon, tavern, analytics, sanctuary, shared) | M5 | ORIGINAL_REQUEST §R5 |
| 29 | Comprehensive E2E Testing Suite | Multi-tier test suite verifying 100% of features, edge cases, and combat scenarios | M6 | ORIGINAL_REQUEST §R6 |
| 30 | Quality Gates & Static Analysis Clean | 0 errors and 0 warnings on dart analyze; 100% pass on flutter test | M6 | ORIGINAL_REQUEST §R6 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Core Foundation & Dependencies | pubspec.yaml, .env, config.dart, locator.dart skeleton, tool/generate_i18n.dart | none | DONE |
| M2 | Drift SQLite Persistence & Repositories | app_database.dart (7 tables, starter kit seed), domain repositories (reactive streams), hive_config.dart | M1 | DONE |
| M3 | AutoRoute Shell & Shared Design System | router.dart, DashboardPage (5 tabs), lib/shared/theme, lib/shared/widgets, LanguageBloc | M1 | DONE |
| M4A | Feature: Battle Hub | HeroBloc, BossBloc, QuestBloc, DailyQuestBloc, HabitBloc, BattleHubPage, combat overlay, Ghost State | M2, M3 | DONE |
| M4B | Feature: Dungeon / World Map | DungeonBloc, DungeonMapPage, chapter progression | M2, M3 | DONE |
| M4C | Feature: Tavern Marketplace | TavernBloc, TavernPage, items, custom rewards | M2, M3 | DONE |
| M4D | Feature: Analytics & Hall of Fame | AnalyticsBloc, AnalyticsPage, charts, simulated leaderboard | M2, M3 | DONE |
| M4E | Feature: Hero Sanctuary | SanctuaryBloc, HeroSanctuaryPage, attributes, cosmetics, audio/haptic, JSON backup | M2, M3 | DONE |
| M5 | Localization Dictionaries & Compilation | All feature ARB files compiled to lib/i18n/i18n.dart, TH/EN dynamic switching verified | M1, M4A-M4E | DONE |
| M6 | E2E Testing & Quality Gate DoD | Complete unit/widget/e2e test suite pass, 0 errors/warnings on dart analyze, full DoD verified | M1-M5 | DONE |

## Interface Contracts

### Domain Repositories ↔ BLoCs
- `HeroRepository`: `Stream<HeroModel> watchHero()`, `Future<void> updateHero(HeroModel hero)`, `Future<void> awardExp(int exp)`, `Future<void> allocateAttributes(...)`.
- `BossRepository`: `Stream<BossModel> watchActiveBoss()`, `Future<void> applyDamage(int damage)`, `Future<void> advanceToNextBoss()`.
- `QuestRepository`: `Stream<List<QuestModel>> watchQuests()`, `Future<void> createQuest(...)`, `Future<void> completeQuest(String id)`.
- `DailyQuestRepository`: `Stream<List<DailyQuestModel>> watchDailyQuests()`, `Future<void> toggleDailyQuest(String id)`, `Future<void> processMidnightReset()`.
- `HabitRepository`: `Stream<List<HabitModel>> watchHabits()`, `Future<void> logHabit(String id, bool isPositive)`.
- `TavernRepository`: `Stream<List<TavernItemModel>> watchCatalog()`, `Stream<List<CustomRewardModel>> watchCustomRewards()`, `Future<void> purchaseItem(String id)`, `Future<void> redeemCustomReward(String id)`.
- `CombatLogRepository`: `Stream<List<CombatLogModel>> watchCombatLogs()`, `Future<void> addLog(CombatLogModel log)`.

### Router ↔ Feature Pages
- `AppRouter` defines `@AutoRouterConfig(replaceInRouteName: 'Page,Route')` with routes:
  - `DashboardRoute` -> `DashboardPage` (`AutoTabsScaffold`)
    - Children: `BattleHubRoute`, `DungeonMapRoute`, `TavernRoute`, `AnalyticsRoute`, `HeroSanctuaryRoute`
  - Sub-routes: `QuestDetailRoute`, `CreateQuestRoute`, `CreateCustomRewardRoute`, etc.

### Service Locator (`lib/locator.dart`)
- `setupLocator()` initializes:
  - Singleton `AppDatabase` (Drift SQLite)
  - Singleton `HiveConfig` / storage
  - LazySingletons for all Domain Repositories
  - Factory or Singleton registrations for BLoCs
  - Singleton `AppRouter`
