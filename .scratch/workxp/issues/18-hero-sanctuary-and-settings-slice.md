# 18: Hero Sanctuary & Settings Feature Slice (Profile, Stats & i18n Switcher)

**What to build:** Implement the Hero Sanctuary feature so that players can allocate attribute points, equip unlocked avatar skins and titles, toggle audio/haptics, switch between Thai and English languages, and backup/restore data via JSON.

**Blocked by:** 14: Battle Hub Feature Vertical Slice (Hero, Boss & Quest Combat)

**Status:** completed

- [x] Create `feature/hero_sanctuary/bloc/` with `SanctuaryBloc` and `BackupBloc`.
- [x] Implement `HeroSanctuaryPage` with `@RoutePage` annotation in `feature/hero_sanctuary/pages/`.
- [x] Implement Sanctuary widgets in `feature/hero_sanctuary/widgets/` (`AttributePointAllocator`, `SkinEquipSelector`, `TitleEquipSelector`, `LanguageSelectorTile`, `SettingsToggleTile`, `JsonBackupDialog`).
- [x] Add localization strings under `lib/i18n/locals/hero_sanctuary/` for Thai and English.
- [x] Add unit tests for `SanctuaryBloc` and widget tests for `HeroSanctuaryPage`.
