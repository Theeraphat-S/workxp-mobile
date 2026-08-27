# 12: Drift SQLite Relational Persistence & Starter Kit Seeding

**What to build:** Create the SQLite relational persistence layer using Drift and local cache using Hive so that Hero, Boss, Quest, Daily Quest, Habit, Tavern, and Combat Log states persist offline and emit reactive streams.

**Blocked by:** 11: Core Foundation, Dependencies & Build Infrastructure

**Status:** completed

- [x] Define Drift tables in `lib/domain/datasource/app_database.dart` (`Heroes`, `Bosses`, `Quests`, `DailyQuests`, `Habits`, `TavernItems`, `CombatLogs`).
- [x] Configure `MigrationStrategy.onCreate` to seed the default Starter Kit (Novice Hero, King Slime Boss, starter Quests, starter Habits, Tavern consumable/cosmetic items).
- [x] Configure `lib/domain/datasource/hive_config.dart` for local preferences and cache.
- [x] Run `dart run build_runner build` to generate `app_database.g.dart`.
- [x] Implement Domain Repositories (`HeroRepository`, `BossRepository`, `QuestRepository`, `DailyQuestRepository`, `HabitRepository`, `TavernRepository`) exposing reactive Dart streams from Drift watch queries.
- [x] Register `AppDatabase` and all Repositories in `lib/locator.dart`.
- [x] Add unit tests verifying database creation, starter kit seeding, and repository reactive streams.
