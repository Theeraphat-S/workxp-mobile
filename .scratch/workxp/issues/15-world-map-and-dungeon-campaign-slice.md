# 15: World Map & Dungeon Campaign Feature Slice

**What to build:** Implement the World Map & Dungeon Campaign feature so that players can view chapter progression, inspect upcoming bosses across dungeons, and unlock new stages upon boss defeat.

**Blocked by:** 14: Battle Hub Feature Vertical Slice (Hero, Boss & Quest Combat)

**Status:** completed

- [x] Create `feature/dungeon/bloc/` with `DungeonBloc` handling chapter progression, dungeon exploration, and stage unlocks.
- [x] Connect `DungeonBloc` to `BossRepository` and `DungeonRepository`.
- [x] Implement `DungeonMapPage` with `@RoutePage` annotation in `feature/dungeon/pages/`.
- [x] Implement Dungeon widgets in `feature/dungeon/widgets/` (`DungeonChapterCard`, `DungeonBossPreviewModal`, `StageUnlockFanfareDialog`).
- [x] Add localization strings under `lib/i18n/locals/dungeon/` for Thai and English.
- [x] Add unit tests for `DungeonBloc` and widget tests for `DungeonMapPage`.
