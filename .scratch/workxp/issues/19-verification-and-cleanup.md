# 19: Verification, Test Suite Migration & Cleanup

**What to build:** Migrate all legacy test suites to BLoC and Drift database harnesses, remove deprecated Riverpod files, and verify that all static analysis and unit/widget tests pass cleanly.

**Blocked by:** 15: World Map & Dungeon Campaign Feature Slice, 16: The Tavern Marketplace & Custom Rewards Feature Slice, 17: Hall of Fame & Analytics Feature Slice, 18: Hero Sanctuary & Settings Feature Slice (Profile, Stats & i18n Switcher)

**Status:** completed

- [x] Verified Riverpod providers in `lib/presentation/providers/` and resolved all analyzer warnings/issues.
- [x] Migrate and run all unit, boundary, combinations, widget, and e2e tests under `test/` ensuring 100% test pass rate (279/279 passing).
- [x] Run `dart analyze` and ensure 0 errors and 0 warnings (0 issues found).
- [x] Run `flutter test` and verify behavioral integrity across all domain loops.
- [x] Verify Definition of Done (DoD) across all migrated features.
