# 11: Core Foundation, Dependencies & Build Infrastructure

**What to build:** Set up the standard dependencies, runtime environment configuration, cross-platform localization generator, and central service locator so that all features can run on the organization's standard Flutter foundation.

**Blocked by:** None (can start immediately)

**Status:** completed

- [x] Update `pubspec.yaml` with required packages (`flutter_bloc`, `drift`, `drift_flutter`, `auto_route`, `get_it`, `dio`, `flutter_dotenv`, `skeletonizer`, `toastification`, `equatable`, `hive`, `hive_flutter`, `build_runner`, `auto_route_generator`, `drift_dev`).
- [x] Create `.env` file and `lib/config/config.dart` to load runtime environment configurations.
- [x] Implement cross-platform Dart generator `tool/generate_i18n.dart` and `generate_all.sh` to compile multi-folder ARBs from `lib/i18n/locals/<feature>/` into `lib/i18n/i18n.dart`.
- [x] Create initial multi-folder ARBs for `general`, `battle_hub`, `dungeon`, `tavern`, `analytics`, and `hero_sanctuary` supporting both English (`en.arb`) and Thai (`th.arb`).
- [x] Configure `lib/locator.dart` with GetIt service locator registration entry point.
- [x] Run static analysis (`dart analyze`) to confirm 0 errors.
