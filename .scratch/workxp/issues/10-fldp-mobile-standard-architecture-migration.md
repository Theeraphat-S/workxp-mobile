# Issue #10: Architecture Standardization (FLDP Mobile Standard)

Triage Label: `completed`

## Description
Refactor WorkXP into the FLDP Mobile Standard architecture (`fakduai-logistics-and-digital-platform/mobile-standard-app`).

## Acceptance Criteria
- [x] 1. **Dependencies**: `pubspec.yaml` updated with `flutter_bloc`, `drift`, `auto_route`, `get_it`, `dio`, `flutter_dotenv`, `skeletonizer`, `toastification`, etc.
- [x] 2. **Configuration & Locator**: `lib/config/config.dart`, `.env`, and `lib/locator.dart` configured with GetIt.
- [x] 3. **Database (Drift)**: `lib/domain/datasource/app_database.dart` created with Drift SQLite tables and Starter Kit seeding in `MigrationStrategy.onCreate`.
- [x] 4. **Localization (i18n)**: `lib/i18n/locals/*/` created with English and Thai ARB files, and cross-platform `tool/generate_i18n.dart` + `generate_all.sh` generating `lib/i18n/i18n.dart`.
- [x] 5. **Feature-First Structure**: Features organized into `lib/feature/<feature_name>/` (`battle_hub`, `dungeon`, `tavern`, `analytics`, `hero_sanctuary`) with BLoCs, Pages, and Widgets.
- [x] 6. **AutoRoute**: `lib/router/router.dart` configured with `AutoTabsScaffold` for the 5-screen navigation and generated `router.gr.dart`.
- [x] 7. **Shared Layer**: 16-bit retro theme and pixel widgets consolidated under `lib/shared/theme/` and `lib/shared/widgets/`.
- [x] 8. **Static Analysis & Tests**: `dart analyze` reports 0 errors / 0 warnings and all tests pass with `flutter test`.
