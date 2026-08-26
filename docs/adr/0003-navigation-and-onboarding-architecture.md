# 0003. Five-Screen Hub Navigation & Starter Kit Onboarding Architecture

## Status
Accepted

## Context
WorkXP needs a navigation structure that balances high-intensity RPG combat feedback with standard productivity workflows (To-dos, Dailies, Habits, Statistics, Shop, and Profile management) while providing immediate instant gratification upon first install.

## Decision
1. We established a **5-Screen Bottom Navigation Bar**:
   - **Battle Hub (Home)**: Active Boss encounter, Floating Damage Combat Text, Quests / Dailies / Habits lists.
   - **World Map (Dungeons)**: Chapter progression map (Slime Forest -> Goblin Keep -> Shadow Crypt -> Volcano Peak).
   - **The Tavern (Shop)**: Consumables, Pixel Skins & Themes, and Custom Real-Life Rewards.
   - **Hall of Fame & Stats**: FL Chart Analytics (EXP line, Damage bar, Habit heatmap, Attribute radar) and simulated leaderboards.
   - **Hero Sanctuary (Profile)**: Stat point allocation, cosmetic skin equips, titles, settings, and JSON backup.
2. We provide a **Pre-loaded Starter Kit** on first launch with Novice Hero, King Slime Boss, sample Quests/Habits, and sample Tavern items.

## Consequences
- Immediate zero-friction onboarding: Users can tap a quest on their first launch and immediately see damage animations and level progression.
- Clean separation of concerns across state providers.
