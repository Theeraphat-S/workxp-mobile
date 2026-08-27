# 17: Hall of Fame & Analytics Feature Slice

**What to build:** Implement the Hall of Fame analytics dashboard so that players can view EXP growth, damage output, habit consistency heatmaps, attribute radar charts, and simulated leaderboard rankings.

**Blocked by:** 14: Battle Hub Feature Vertical Slice (Hero, Boss & Quest Combat)

**Status:** completed

- [x] Create `feature/analytics/bloc/` with `AnalyticsBloc` aggregating statistics from Drift `CombatLogs`, `Quests`, and `Habits`.
- [x] Implement `AnalyticsPage` with `@RoutePage` annotation in `feature/analytics/pages/`.
- [x] Implement Analytics widgets in `feature/analytics/widgets/` (`ExpGrowthLineChart`, `BossDamageBarChart`, `HabitHeatmapGrid`, `AttributeRadarChart`, `SimulatedLeaderboardCard`).
- [x] Add localization strings under `lib/i18n/locals/analytics/` for Thai and English.
- [x] Add unit tests for `AnalyticsBloc` and widget tests for `AnalyticsPage`.
