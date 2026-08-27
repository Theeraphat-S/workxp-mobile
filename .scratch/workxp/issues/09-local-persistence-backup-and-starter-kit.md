# 09: Local Storage Persistence, JSON Backup & Starter Kit Onboarding Slice

**What to build:**
Robust 100% offline-first local storage persistence using Hive across all application domains (Hero, Quests, Dailies, Habits, Dungeons, Inventory, Analytics). Injects a rich Starter Kit upon first launch (Novice Hero, King Slime, sample Quests/Habits, starter potions) to ensure immediate engagement. Provides a Settings section for exporting the entire game state into a JSON backup file and importing/restoring it with validation.

**Blocked by:** 06: Dungeon World Map & Boss Chapter Progression Slice, 07: The Tavern Marketplace & Custom Real-Life Rewards Slice, 08: Hall of Fame, FL Chart Analytics & Simulated Leaderboards Slice

**Status:** completed

- [x] Hive adapters and storage boxes persist and reload Hero, Activity, Dungeon, Shop, and Stat states across app restarts.
- [x] On first app launch, checks if database is empty and automatically loads pre-seeded Starter Kit data.
- [x] Settings screen provides "Export Save File (JSON)" button allowing the user to copy/save full JSON state.
- [x] Settings screen provides "Import Save File (JSON)" button with schema validation and state reload.
- [x] Audio and Haptic toggles persist their user preferences.
- [x] Integration tests verify full state preservation on reload and successful JSON export/import cycles.
