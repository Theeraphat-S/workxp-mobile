# Specification: WorkXP Architecture Standardization (FLDP Mobile Standard)

Triage Label: `ready-for-agent`

## Problem Statement

WorkXP (Pocket Quest) was initially developed with a layer-first directory layout, Riverpod 2.x state notifiers, and Hive NoSQL storage. While the retro pixel gameplay mechanics and offline-first capabilities are fully operational, the application structure diverges from the organization's standardized enterprise blueprint defined in [fakduai-logistics-and-digital-platform/mobile-standard-app](https://github.com/fakduai-logistics-and-digital-platform/mobile-standard-app). 

This divergence introduces several engineering challenges:
1. State management and dependency injection do not align with the standard `flutter_bloc` and `get_it` pattern.
2. Local data persistence lacks relational indexing and SQL querying capabilities provided by `drift` (SQLite ORM).
3. Screen navigation relies on manual state switching rather than declarative, type-safe `auto_route` routing.
4. Text strings are hardcoded or mixed, lacking the multi-folder per-feature internationalization architecture (`lib/i18n/locals/<feature>/`) that supports seamless Thai (TH) and English (EN) localization.
5. Directory structures are layer-first (`presentation/`, `domain/`, `data/`) rather than feature-first (`lib/feature/<name>/`, `lib/domain/`, `lib/shared/`), hindering modular scalability.

## Solution

Standardize WorkXP's entire technical architecture to match the FLDP Mobile Standard template while strictly preserving all 16-bit retro pixel fantasy RPG mechanics, 60fps animations, floating combat numbers, domain entities, combat logic, and 100% offline-first reliability.

The restructured application will feature:
- **Feature-First Organization**: Modularized folders under `lib/feature/<name>/` (`battle_hub`, `dungeon`, `tavern`, `analytics`, `hero_sanctuary`).
- **Reactive State Management**: Fine-grained BLoCs and Cubits (`flutter_bloc` ^9.1.1 + `equatable`) reacting to Drift database streams.
- **Service Locator**: Centralized dependency injection via `get_it` (^8.0.3) in `lib/locator.dart`.
- **Relational Persistence**: `drift` (^2.23.1) SQLite ORM with automatic schema migrations and Starter Kit seeding on initial database creation, paired with `hive` (^2.2.3) for lightweight user preferences and cache.
- **Declarative Navigation**: `auto_route` (^10.1.0+1) with `AutoTabsScaffold` for the 5-screen game hub and nested type-safe sub-routes.
- **Multi-Folder i18n**: Feature-divided ARB localization (`lib/i18n/locals/*/en.arb`, `th.arb`) with a cross-platform Dart generator (`tool/generate_i18n.dart`) and `generate_all.sh` shell script.
- **Shared Design System**: 16-bit retro pixel colors, typography, and widgets consolidated under `lib/shared/theme/` and `lib/shared/widgets/`.

---

## User Stories

### Gameplay & RPG Progression
1. As an Adventurer opening the app for the first time, I want the Drift database to automatically seed a Novice Hero, King Slime Boss, starter Quests, starter Habits, and Tavern items, so that I can immediately start playing without manual setup.
2. As an Adventurer, I want to switch between Thai and English languages in the Hero Sanctuary settings, so that all screens, quests, tabs, and game dialogs display in my preferred language.
3. As an Adventurer, I want to create a Quest with a Title, Description, Due Date, Rank (E, D, C, B, A, S), and Attribute tag, so that I can track real-world tasks of varying difficulty.
4. As an Adventurer, I want completing a Quest to trigger floating critical damage numbers and deal real-time damage to the active Boss through reactive Drift streams, so that I experience instant 60fps feedback.
5. As an Adventurer, I want to earn EXP from Quests and level up automatically when reaching the EXP threshold, granting Attribute Points to allocate to STR, INT, AGI, VIT, and WIS.
6. As an Adventurer, I want to create Daily Quests that reset every 24 hours, so that I can maintain my daily routines and build consecutive day Streaks.
7. As an Adventurer, I want incomplete Daily Quests at midnight reset to trigger a Boss counter-attack, deducting HP from my Hero.
8. As an Adventurer whose HP reaches 0, I want my Hero to enter a Ghost State (with EXP/Coin gains paused) until I complete a Revival Quest or consume an Elixir of Life, so that failure is an actionable challenge rather than a permanent loss.
9. As an Adventurer, I want to log positive (+) and negative (-) Habits, earning or losing Coins and MP with instantaneous updates across the UI.
10. As an Adventurer, I want to spend MP to cast skill buffs (e.g. Double EXP Scroll, Boss Stun), so that positive habits provide strategic gameplay advantages.
11. As an Adventurer, I want to defeat a Dungeon Boss when its HP hits 0, receiving victory rewards and unlocking the next Chapter on the World Map.
12. As an Adventurer, I want to navigate the World Map across Chapters (Slime Forest, Goblin Keep, Shadow Crypt, Volcano Peak), viewing active boss stats and stage requirements.
13. As an Adventurer, I want to visit The Tavern to purchase consumable items (Health Potion, Streak Shield, EXP Tonic, Elixir of Life) using earned Coins.
14. As an Adventurer, I want to create, manage, and redeem Custom Real-Life Rewards (e.g. "1 Boba Tea = 50 Coins") in The Tavern, celebrating real-world self-care with in-game currency.
15. As an Adventurer, I want to allocate earned Attribute Points in the Hero Sanctuary, equip cosmetic avatar skins, and display earned Titles.
16. As an Adventurer, I want to view detailed FL Chart analytics in the Hall of Fame (EXP line chart, Boss damage bar chart, 16-bit habit consistency heatmap, and attribute radar chart) to track my lifetime productivity momentum.
17. As an Adventurer, I want to view a Simulated Leaderboard in the Hall of Fame to compete against fictional guild members even while offline.
18. As an Adventurer, I want to export my entire save file to a JSON backup and import it on any device, so that my data is completely secure and portable.

### Engineering & Architecture Standards
19. As a Developer, I want all state management to use `flutter_bloc` with clear Events and States, so that state transitions are predictable, unidirectional, and easily testable.
20. As a Developer, I want all dependencies registered in `lib/locator.dart` via `get_it`, so that services, database instances, and repositories are decoupled from UI widgets.
21. As a Developer, I want relational data stored in Drift SQLite tables (`Heroes`, `Bosses`, `Quests`, `DailyQuests`, `Habits`, `TavernItems`, `CombatLogs`), so that complex queries and stats calculations run with optimal performance.
22. As a Developer, I want Drift database watch queries to emit reactive Dart Streams, so that BLoCs automatically update when records change without manual polling.
23. As a Developer, I want routing managed by `auto_route` with `AutoTabsScaffold` and `@RoutePage` annotations, so that page navigation and deep-linking are compile-time type-safe.
24. As a Developer, I want localization strings organized by feature in `lib/i18n/locals/<feature_name>/` (`en.arb`, `th.arb`), so that text is co-located with feature modules.
25. As a Developer on Windows or macOS, I want to run `dart run tool/generate_i18n.dart` (or `./generate_all.sh`), so that ARB files are automatically compiled into `lib/i18n/i18n.dart` across all operating systems.
26. As a Developer, I want environment configuration loaded from `.env` via `flutter_dotenv` in `lib/config/config.dart`, so that API endpoints and feature flags can be adjusted per environment.
27. As a Developer, I want shared 16-bit retro UI components (`PixelButton`, `PixelCard`, `PixelProgressBar`, `PixelSprite`, `PixelBadge`) isolated under `lib/shared/`, so that they can be reused across all features without circular dependencies.
28. As a Developer, I want `dart analyze` to report 0 errors and 0 warnings, ensuring pristine code quality across the entire codebase.
29. As a Developer, I want all unit and widget tests to pass via `flutter test`, ensuring zero functional regressions after the architectural migration.

---

## Implementation Decisions

### 1. Directory Structure & Module Layout

```
lib/
├── config/
│   └── config.dart                     # Environment variables & runtime constants
├── domain/
│   ├── datasource/
│   │   ├── app_database.dart           # Drift SQLite database, tables, and migration logic
│   │   ├── app_database.g.dart         # Auto-generated Drift code
│   │   └── hive_config.dart            # Hive setup for local preferences & cache
│   ├── http_client/
│   │   ├── ip.dart                     # Dio HTTP client wrapper with error interceptors
│   │   └── websocket.dart              # WebSocket channel wrapper
│   ├── models/                         # Domain value objects, enums, pure data contracts
│   └── repositories/                   # Abstract & concrete repositories exposing reactive streams
│       ├── hero_repository.dart
│       ├── boss_repository.dart
│       ├── quest_repository.dart
│       ├── habit_repository.dart
│       └── tavern_repository.dart
├── feature/
│   ├── battle_hub/
│   │   ├── bloc/                       # HeroBloc, BossBloc, QuestBloc, HabitBloc
│   │   ├── pages/                      # BattleHubPage (@RoutePage)
│   │   └── widgets/                    # BossEncounterCard, FloatingCombatOverlay, Dialogs
│   ├── dungeon/
│   │   ├── bloc/                       # DungeonBloc
│   │   ├── pages/                      # DungeonMapPage (@RoutePage)
│   │   └── widgets/                    # DungeonCard, StageUnlockModal
│   ├── tavern/
│   │   ├── bloc/                       # TavernBloc
│   │   ├── pages/                      # TavernPage (@RoutePage)
│   │   └── widgets/                    # RewardCard, CustomRewardDialog, ShopTabs
│   ├── analytics/
│   │   ├── bloc/                       # AnalyticsBloc
│   │   ├── pages/                      # AnalyticsPage (@RoutePage)
│   │   └── widgets/                    # ExpChart, DamageBarChart, HeatmapPainter
│   └── hero_sanctuary/
│       ├── bloc/                       # SanctuaryBloc, ProfileBloc
│       ├── pages/                      # HeroSanctuaryPage (@RoutePage)
│       └── widgets/                    # StatAllocator, AvatarEquipper, BackupDialog
├── i18n/
│   ├── i18n.dart                       # Generated localization delegates & getters
│   └── locals/                         # Multi-folder ARBs
│       ├── general/ (en.arb, th.arb)
│       ├── battle_hub/ (en.arb, th.arb)
│       ├── dungeon/ (en.arb, th.arb)
│       ├── tavern/ (en.arb, th.arb)
│       ├── analytics/ (en.arb, th.arb)
│       └── hero_sanctuary/ (en.arb, th.arb)
├── router/
│   ├── router.dart                     # AutoRoute configuration & Dashboard shell
│   └── router.gr.dart                  # AutoRoute generated code
├── shared/
│   ├── bloc/                           # Shared BLoCs (LanguageBloc, ThemeBloc)
│   ├── theme/                          # PixelColors, PixelTypography, PixelTheme
│   ├── widgets/                        # PixelButton, PixelCard, PixelProgressBar, PixelSprite, etc.
│   └── utils/                          # SensoryService (Audio/Haptics), DayCycleService, Helpers
├── locator.dart                        # Central GetIt dependency registration
└── main.dart                           # Entrypoint initializing Hive, Drift, GetIt, DotEnv
```

### 2. Database Schema (Drift SQLite)

- **`Heroes` Table**: `id`, `name`, `level`, `currentExp`, `hp`, `maxHp`, `mp`, `maxMp`, `str`, `intAttr`, `agi`, `vit`, `wis`, `unallocatedPoints`, `isGhost`, `activeSkinId`, `activeTitleId`, `createdAt`, `updatedAt`.
- **`Bosses` Table**: `id`, `chapter`, `name`, `maxHp`, `currentHp`, `spriteAsset`, `isDefeated`, `unlockedAt`.
- **`Quests` Table**: `id`, `title`, `description`, `rank`, `attributeTag`, `dueDate`, `isCompleted`, `completedAt`, `createdAt`.
- **`DailyQuests` Table**: `id`, `title`, `streakCount`, `isCompletedToday`, `lastCompletedDate`, `attributeTag`, `createdAt`.
- **`Habits` Table**: `id`, `title`, `isPositive`, `countToday`, `totalCount`, `attributeTag`, `lastLoggedDate`, `createdAt`.
- **`TavernItems` Table**: `id`, `title`, `description`, `coinCost`, `itemType`, `iconAsset`, `quantityOwned`, `isCustom`, `createdAt`.
- **`CombatLogs` Table**: `id`, `entityType`, `damageDealt`, `expEarned`, `coinsEarned`, `timestamp`.
- **Seeding Strategy**: Starter kit is inserted in `MigrationStrategy.onCreate` within `AppDatabase`.

### 3. State Management & Event Contracts

- Fine-grained BLoCs communicate via Domain Repositories:
  - `HeroBloc`: Subscribes to `HeroRepository.watchHero()`. Emits `HeroLoaded(HeroEntity)`. Handles `AllocateStatEvent`, `ReviveHeroEvent`, `EquipSkinEvent`.
  - `BossBloc`: Subscribes to `BossRepository.watchActiveBoss()`. Emits `BossLoaded(BossEntity)`. Handles `DealDamageEvent`, `AdvanceDungeonEvent`.
  - `QuestBloc`: Subscribes to `QuestRepository.watchQuests()`. Handles `CreateQuestEvent`, `CompleteQuestEvent`, `DeleteQuestEvent`.
  - `DailyQuestBloc`: Subscribes to `DailyQuestRepository.watchDailyQuests()`. Handles `ToggleDailyQuestEvent`, `MidnightResetEvent`.
  - `HabitBloc`: Subscribes to `HabitRepository.watchHabits()`. Handles `LogHabitEvent`, `CreateHabitEvent`.
  - `TavernBloc`: Subscribes to `TavernRepository.watchItems()` and `watchCoins()`. Handles `PurchaseItemEvent`, `RedeemCustomRewardEvent`.
  - `LanguageBloc`: Manages `Locale` state (`'en'` or `'th'`), persisting selection in Hive preferences.

---

## Testing Decisions

- **Primary Seam**: Domain Repositories and BLoCs (`HeroBloc`, `BossBloc`, `QuestBloc`, `DailyQuestBloc`, `HabitBloc`, `TavernBloc`, `LanguageBloc`).
- **Testing Approach**:
  - Unit tests will instantiate BLoCs with in-memory Drift databases (`NativeDatabase.memory()`) or mock repositories, dispatch events, and verify resulting state transitions.
  - Widget tests will pump feature pages (`BattleHubPage`, `DungeonMapPage`, `TavernPage`, `AnalyticsPage`, `HeroSanctuaryPage`) wrapped in `MultiBlocProvider` and `MaterialApp.router` to verify 60fps rendering, floating damage text, and dialog interactions.
  - Test suites will verify:
    1. Complete quest action decreases Boss HP in Drift, increments EXP in Hero table, and triggers Level Up when EXP threshold is crossed.
    2. Midnight cycle calculates missed daily penalties, drains HP, and triggers Ghost State when HP <= 0.
    3. Revival Quest restores Hero HP and clears Ghost State.
    4. Habit logs modify Coin balance and MP pools accurately.
    5. Tavern purchases deduct Coins and update Inventory/Custom Rewards.
    6. Language switching updates localized strings dynamically.

---

## Out of Scope

- Remote cloud backend server deployment (the app remains 100% offline-first with simulated leaderboards).
- Real-money payment gateway integration (all items are acquired with earned productivity Coins).
- Real-time multiplayer co-op raids over network.

---

## Further Notes

- All domain terminology strictly complies with [CONTEXT.md](file:///c:/Work/workxp/CONTEXT.md).
- Architectural trade-offs and decisions are formally recorded in [docs/adr/0004-fldp-mobile-standard-architecture-migration.md](file:///c:/Work/workxp/docs/adr/0004-fldp-mobile-standard-architecture-migration.md).
