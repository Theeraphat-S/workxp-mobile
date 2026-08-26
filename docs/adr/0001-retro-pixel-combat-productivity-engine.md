# 0001. 16-Bit Retro Pixel Combat Engine with Offline-First Flutter Architecture

## Status
Accepted

## Context
WorkXP requires a gamified mobile app combining task management (To-dos, Dailies, Habits) with rich RPG mechanics, 60fps animations, local persistence, and retro gaming aesthetics.

## Decision
We chose **Flutter with Riverpod and Hive (Local NoSQL)** as the foundation, driven by a **16-bit retro pixel fantasy theme with an active Dungeon Boss combat engine**. All data is saved offline-first locally, with simulated leaderboards and JSON export. Completing Quests deals damage to Dungeon Bosses, while missed Daily Quests inflict HP counter-damage at day reset.

## Consequences
- Requires high-fidelity custom pixel UI components, pixel-perfect borders/shaders, and retro typography.
- Offline-first ensures zero-latency task logging, instant damage animations, and zero server hosting overhead for V1.
- Introduces HP/Death mechanics into a productivity app, requiring fair penalty buffers (e.g. revival potions, rest days) to maintain user motivation.
