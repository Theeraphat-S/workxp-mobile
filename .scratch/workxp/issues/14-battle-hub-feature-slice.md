# 14: Battle Hub Feature Vertical Slice (Hero, Boss & Quest Combat)

**What to build:** Implement the Battle Hub feature with BLoCs, pages, and widgets so that players can complete Quests, check Daily Quests, log Habits, see floating combat damage at 60fps against the Boss, and recover from Ghost State.

**Blocked by:** 12: Drift SQLite Relational Persistence & Starter Kit Seeding, 13: AutoRoute Navigation Shell & 16-Bit Shared Design System

**Status:** completed

- [x] Create `feature/battle_hub/bloc/` containing `HeroBloc`, `BossBloc`, `QuestBloc`, `DailyQuestBloc`, and `HabitBloc` with clear Events and States.
- [x] Connect BLoCs to reactive streams from `HeroRepository`, `BossRepository`, `QuestRepository`, `DailyQuestRepository`, and `HabitRepository`.
- [x] Implement `BattleHubPage` with `@RoutePage` annotation in `feature/battle_hub/pages/`.
- [x] Implement Battle Hub widgets in `feature/battle_hub/widgets/` (`BossEncounterCard`, `FloatingCombatOverlay`, `DailyQuestTabView`, `HabitTabView`, `CreateQuestDialog`, `CreateDailyQuestDialog`, `CreateHabitDialog`, `RevivalQuestDialog`).
- [x] Integrate localization strings via `i18n.battleHub` for both Thai and English.
- [x] Add unit tests for `HeroBloc`, `BossBloc`, `QuestBloc`, `DailyQuestBloc`, `HabitBloc` and widget tests for `BattleHubPage`.
