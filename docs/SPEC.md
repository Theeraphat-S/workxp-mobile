# Specification: WorkXP (Pocket Quest)

Triage Label: `ready-for-agent`

## Problem Statement

Traditional to-do and habit tracker apps suffer from rapid user abandonment due to a lack of immediate positive feedback loops, repetitive and dry check-in routines, and demotivating guilt mechanics when daily streaks are broken. Users who want to build consistent productivity habits lack an engaging, rewarding system that connects their daily real-world effort to exciting milestones, visual progression, and meaningful self-rewards.

## Solution

**WorkXP (Pocket Quest)** is a 16-bit retro pixel fantasy RPG gamified mobile application built with Flutter. Real-world tasks (Quests) function as critical strikes against Dungeon Bosses; daily routines (Daily Quests) protect the Hero's HP from midnight counter-attacks and build Streaks; and micro-habits (Habits) earn spendable Coins and MP. 

The application features high-impact 60fps animations, floating combat numbers, an active chapter-based dungeon campaign, a rich Tavern shop supporting custom real-life rewards, full FL Chart statistics (EXP growth, damage output, habit heatmap, attribute radar), 8-bit chiptune sound effects, and 100% offline-first local persistence.

---

## User Stories

1. As an Adventurer opening the app for the first time, I want a pre-loaded starter kit with a Novice Hero, initial quests, and the first Boss (King Slime), so that I can immediately experience the combat and quest loop without manual setup.
2. As an Adventurer, I want to create a one-off Quest with a title, description, due date, Rank (E, D, C, B, A, S), and Attribute tag (STR, INT, AGI, VIT, WIS), so that I can capture real-world tasks of varying importance.
3. As an Adventurer, I want completing a Quest to trigger a 16-bit attack animation and floating critical damage text against the active Boss, so that I feel an immediate visceral reward for completing my work.
4. As an Adventurer, I want to earn EXP proportional to the Quest's Rank upon completion, so that more difficult real-world projects grant greater progression.
5. As an Adventurer, I want to create Daily Quests that recur every 24 hours, so that I can track essential daily routines (e.g., exercise, meditation, reading).
6. As an Adventurer, I want to check off Daily Quests to build my consecutive day Streak, so that I stay motivated to maintain daily consistency.
7. As an Adventurer, I want uncompleted Daily Quests at midnight to trigger a Boss counter-attack that reduces my Hero HP, so that there are real, exciting in-game stakes for my daily habits.
8. As an Adventurer whose HP reaches 0, I want my Hero to enter a "Ghost State" where EXP and Coin gains are paused instead of deleting my account or wiping my level, so that I am motivated to recover without feeling punished.
9. As a Ghost Hero, I want to complete an emergency Revival Quest (e.g., drink water, stretch, do 1 quick chore) or drink an Elixir of Life to resurrect, so that I can immediately resume normal progression.
10. As an Adventurer, I want to create positive (+) and negative (-) Habits that can be logged multiple times throughout the day, so that I can reinforce good behaviors and penalize bad ones.
11. As an Adventurer, I want positive Habit logs to award Coins and MP, and negative Habit logs to deduct Coins and MP, so that micro-habits directly impact my resource economy.
12. As an Adventurer, I want to spend MP to activate temporary skill buffs (e.g., Double EXP Scroll, Boss Stun to prevent damage tonight), so that my positive habits give me strategic in-game advantages.
13. As an Adventurer, I want to defeat a Dungeon Boss when its HP reaches 0, triggering a victory fanfare animation, bonus Coin/EXP loot, and advancing to the next Chapter on the World Map.
14. As an Adventurer, I want to view the World Map to see my progress across Chapters (Slime Forest, Goblin Keep, Shadow Crypt, Volcano Peak) and inspect upcoming Bosses, so that I have a clear long-term goal.
15. As an Adventurer, I want to visit The Tavern (Shop) to buy consumable potions (Health Potion, Streak Shield, EXP Tonic) using earned Coins, so that I can manage my vitals and protect my streaks.
16. As an Adventurer, I want to purchase pixel cosmetic avatar skins (Paladin, Dark Knight, Archmage, Cyber Samurai) and retro CRT screen themes, so that I can customize my visual identity as I accumulate wealth.
17. As an Adventurer, I want to create Custom Real-Life Rewards in the Tavern with custom Coin prices (e.g., "1 Bubble Tea = 50 Coins", "1 Hour Video Game = 40 Coins"), so that I can reward myself in real life using hard-earned in-game currency.
18. As an Adventurer, I want to redeem a Custom Real-Life Reward to deduct the required Coins and display a celebration dialog, so that I can enjoy guilt-free real-world rewards.
19. As an Adventurer, I want to level up when my EXP bar fills up, triggering a Level Up fanfare animation and granting me Attribute Points to allocate, so that I can customize my Hero's build.
20. As an Adventurer, I want to allocate Attribute Points into STR, INT, AGI, VIT, and WIS in the Hero Sanctuary (Profile), so that my character reflects my personal life development.
21. As an Adventurer, I want to unlock and equip unique Titles (e.g., "Code Wizard", "Iron Knight", "Disciplined Monk") based on my highest attributes and completed milestones, so that I can show off my accomplishments.
22. As an Adventurer, I want to view an EXP & Level Growth Line Chart on the Stats page, so that I can visualize my productivity momentum over the last 7 and 30 days.
23. As an Adventurer, I want to view a Boss Damage Dealt Bar Chart, so that I can see how much productive output I delivered on each day of the week.
24. As an Adventurer, I want to view a 16-bit Habit Consistency Heatmap Grid, so that I can track my daily habit adherence in a GitHub-style matrix.
25. As an Adventurer, I want to view a Hero Attribute Hexagon Radar Chart, so that I can see my balance across STR, INT, AGI, VIT, and WIS.
26. As an Adventurer, I want to view a Simulated Guild Leaderboard that ranks me against fictional adventurers based on weekly damage and streak, so that I feel healthy social competition even while offline.
27. As an Adventurer, I want to unlock permanent Achievements (e.g., "First Blood", "Dragon Slayer", "30-Day Unbroken Streak") that grant bonus trophies and titles, so that my lifetime milestones are commemorated.
28. As an Adventurer, I want chiptune 8-bit sound effects (sword swings, coin chimes, victory jingles) and tactile haptic feedback on every action, with the option to toggle them in Settings, so that the app feels deeply satisfying to use.
29. As an Adventurer, I want all my data saved locally on my device (100% offline-first) with zero internet requirement, so that the app opens instantly and respects my privacy.
30. As an Adventurer, I want to export my entire save file to a JSON backup and import it on any device, so that I never lose my progress.

---

## Implementation Decisions

### Module Boundaries & State Architecture

1. **State Management & Dependency Injection**:
   - Driven entirely by Riverpod 2.x `Notifier` and `AsyncNotifier` providers.
   - Clean unidirectional data flow: UI Dispatches Actions -> Notifiers Compute Domain Logic -> Mutate Immutable State -> Persist via Repository -> Emit State to UI.

2. **Core Domain Modules**:
   - `HeroModule`:
     - Tracks Level, current EXP, target EXP formula: $\text{EXP}_{\text{next}} = \lfloor 100 \times 1.25^{(\text{level}-1)} \rfloor$.
     - Tracks HP ($\max 100$), MP ($\max 100$), and Attribute Points (STR, INT, AGI, VIT, WIS).
     - Manages `isGhost` state flag, active cosmetic skin ID, and active title ID.
   - `CombatDungeonModule`:
     - Tracks active Chapter (1 to 4+), active Boss entity (ID, name, sprite asset, max HP, current HP).
     - Damage calculations:
       - Rank E: 25 base damage
       - Rank D: 50 base damage
       - Rank C: 100 base damage
       - Rank B: 200 base damage
       - Rank A: 350 base damage
       - Rank S: 600 critical damage
       - Extra scaling bonus from Hero STR / AGI attributes.
     - Handles Boss death transition, reward granting (Coins + Chapter completion trophy), and advancing to the next Dungeon stage.
   - `ActivityModule`:
     - `Quest`: ID, title, description, rank (E-S), attribute tag, due date, isCompleted, completedAt.
     - `DailyQuest`: ID, title, streak count, isCompletedToday, lastCompletedDate, attribute tag.
     - `Habit`: ID, title, positive/negative toggle, countToday, totalCount, attribute tag.
     - `DayCycleService`: Detects date changes, evaluates uncompleted Daily Quests, calculates Boss counter-damage ($15 \text{ HP per missed daily}$), updates Ghost state if $\text{HP} \le 0$, and resets `isCompletedToday` flags.
   - `EconomyTavernModule`:
     - Balance of spendable Coins.
     - Catalog of system items: Consumables (Health Potion, Streak Shield, EXP Tonic, Elixir of Life) and Cosmetics (Avatars, CRT Theme).
     - User-defined Custom Rewards: ID, title, coinCost, icon, timesRedeemed.
     - Inventory: Purchased consumables with remaining quantity.
   - `AnalyticsModule`:
     - Stores historical snapshots of daily EXP earned, daily damage dealt, and habit check-ins.
     - Feeds FL Chart view models for Line Chart, Bar Chart, Radar Chart, and the custom 16-bit Heatmap Painter.
   - `SensoryModule`:
     - Manages synthesized 8-bit chiptune sound playback and device haptics via settings flags (`isSfxEnabled`, `isHapticsEnabled`).
   - `StorageModule`:
     - Hive/Isar NoSQL persistence abstraction with separate boxes for Hero, Activities, Dungeon, Shop, and Analytics.
     - Provides JSON serializable export/import services.

3. **User Interface & Design System**:
   - 16-Bit Retro Pixel Fantasy aesthetic.
   - Google Fonts (`Press Start 2P`, `VT323`, `Silkscreen`) for retro headers, numbers, and stats, paired with crisp legible sans-serif for long text descriptions.
   - Custom Pixel borders, 9-slice styled frames, and neon pixel glow accents.
   - Bottom Navigation Bar with 5 destinations:
     1. `Battle Hub` (Home)
     2. `World Map` (Dungeons)
     3. `The Tavern` (Shop & Custom Rewards)
     4. `Hall of Fame` (Stats & Leaderboard)
     5. `Hero Sanctuary` (Profile, Stats Allocation, Settings)

---

## Testing Decisions

- **Primary Seam**: Riverpod State Notifiers and Service Repositories (`HeroNotifier`, `CombatNotifier`, `ActivityNotifier`, `TavernNotifier`, `DayCycleService`).
- **Testing Approach**:
  - Unit tests will exercise external methods and verify that domain states mutate correctly without mocking internal implementation details.
  - Tests will cover:
    - Quest completion applying exact damage to Boss HP, granting EXP, and triggering Level Up when threshold is reached.
    - Daily Quest midnight cycle dealing counter-damage and transitioning Hero to `isGhost = true` when HP reaches 0.
    - Revival Quest or Elixir purchase restoring Hero from Ghost State.
    - Habit (+) and (-) logging correctly modifying Coins, MP, and analytics history.
    - Tavern purchase deducting Coins and adding items to Inventory or activating Custom Rewards.
    - JSON Export/Import preserving exact state without corruption.

---

## Out of Scope

- Real-time online multi-player WebSocket co-op raids (a simulated offline leaderboard is implemented for V1).
- Real-money in-app purchases (all items are earned strictly via productivity Coins).
- Cloud backend sync / account authentication (100% offline-first local storage for V1).

---

## Further Notes

- Pre-loaded starter seed data is injected on initial database initialization to guarantee immediate high-engagement onboarding.
- All code and domain vocabulary strictly conform to [CONTEXT.md](file:///c:/Work/workxp/CONTEXT.md) and Architecture Decision Records ([0001](file:///c:/Work/workxp/docs/adr/0001-retro-pixel-combat-productivity-engine.md), [0002](file:///c:/Work/workxp/docs/adr/0002-ghost-state-failure-model.md), [0003](file:///c:/Work/workxp/docs/adr/0003-navigation-and-onboarding-architecture.md)).
