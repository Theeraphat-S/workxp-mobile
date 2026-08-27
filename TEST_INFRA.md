# WorkXP (Pocket Quest) Test Infrastructure & Strategy (`TEST_INFRA.md`)

## 1. Overview & Testing Philosophy

WorkXP (Pocket Quest) employs an **opaque-box, progressive, behavior-driven test architecture** that verifies all RPG game mechanics, domain mathematical formulas, reactive state loops, 16-bit UI design system components, and offline-first persistence without coupling tests to ephemeral internal implementation details.

### 1.1 Core Principles
- **Opaque-Box Testing**: Tests interact exclusively with public seams (Domain Models, Notifiers / BLoCs, Service Locators, UI widgets via `WidgetTester`).
- **Domain Language Alignment**: All test descriptors and assertions strictly adhere to canonical terminology defined in `CONTEXT.md` (`Hero`, `Boss`, `Dungeon`, `Quest`, `Daily Quest`, `Habit`, `Ghost State`, `Revival Quest`, `Tavern`, `Custom Reward`, `EXP`, `Coin`).
- **Deterministic Expected Output**: All expected test values are derived from mathematical formulas defined in `docs/SPEC.md` and `PROJECT.md`.
- **Self-Contained & Isolated**: Every test manages its own state and dependencies without order-dependent side effects.

---

## 2. Four-Tier Testing Methodology

The test suite is structured into four distinct, progressive tiers:

```
                  ┌─────────────────────────────────────┐
                  │ Tier 4: Real-World User Journeys    │
                  │ (Full E2E Scenario-Driven Flows)    │
                  └──────────────────┬──────────────────┘
                                     │
                  ┌──────────────────┴──────────────────┐
                  │ Tier 3: Cross-Feature Combinations  │
                  │ (Pairwise Integration & Synergies)  │
                  └──────────────────┬──────────────────┘
                                     │
                  ┌──────────────────┴──────────────────┐
                  │ Tier 2: Boundary & Corner Cases     │
                  │ (Edge, Overflow, Clamping, Clashing)│
                  └──────────────────┬──────────────────┘
                                     │
                  ┌──────────────────┴──────────────────┐
                  │ Tier 1: Feature Coverage (>=5 / feat)│
                  │ (Core Unit Math, Rules, & Contracts)│
                  └─────────────────────────────────────┘
```

---

### 2.1 Tier 1: Feature Coverage (>=5 Test Cases per Feature)

Tier 1 establishes high-density unit and component test coverage for each discrete feature area:

#### Feature 1: Hero Progression & Leveling Math
1. **EXP Progression Thresholds**: Verifies $\text{Target EXP}(L) = \lfloor 100 \times 1.25^{L-1} \rfloor$ for Levels 1, 2, 3, 4, and 5.
2. **Single Level Up Transition**: Gaining sufficient EXP increments `level`, grants `+3 unallocatedPoints`, and completely refills `hp` and `mp` to 100.
3. **Stat Point Allocation**: Allocating points to `STR`, `INT`, `AGI`, `VIT`, or `WIS` increments the target stat and decrements `unallocatedPoints`.
4. **Dynamic Title Milestone Evaluation**: Unlocks `'Iron Knight'` at STR 10, `'Seasoned Veteran'` at Level 5, and `'Archmage Scholar'` at INT 20.
5. **Cosmetic Skin Equipping**: Updates `activeSkinId` when selecting an unlocked avatar skin.

#### Feature 2: Quest System & Combat Math
1. **Base Rank Damage & Rewards**: Verifies Base Damage and EXP/Coin rewards for Ranks E, D, C, B, A, and S.
2. **Hero Combat Bonus Formula**: Verifies $\text{Hero Bonus} = (\text{STR} \times 2) + (\text{AGI} \times 1)$ applied to total damage.
3. **Focus Surge Multiplier**: Verifies $+50\%$ damage boost ($\lfloor \text{Damage} \times 1.5 \rfloor$) when `buff_focus_surge` is active.
4. **Double EXP Multiplier**: Verifies $2\times$ EXP reward when `buff_double_exp` is active.
5. **Critical Strike Detection**: Flags strikes $\ge 200$ damage as Critical Strikes.

#### Feature 3: Daily Quests & Midnight Day Cycle
1. **Daily Quest Completion**: Awards `+30 EXP` and `+15 Coins`, and increments individual `streak += 1`.
2. **All-Done Daily Bonus**: Completing all daily quests in a single day awards a bonus `+25 Coins` chest.
3. **Midnight Counter-Attack Calculation**: Evaluates incomplete dailies across calendar day change ($15\text{ HP}$ per missed daily).
4. **Streak Shield Immunity**: Consumes 1 shield charge to completely negate midnight counter-damage.
5. **Boss Stun Immunity**: Active `buff_boss_stun` prevents boss counter-attack damage.

#### Feature 4: Ghost State & Revival Mechanics
1. **Ghost State Trigger**: Hero HP dropping to 0 activates `isGhost = true`.
2. **EXP Gain Suspension**: `gainExp()` is completely blocked while `isGhost == true`.
3. **Coin Gain Suspension**: `gainCoins()` is completely blocked while `isGhost == true`.
4. **Revival Quest Resolution**: Emergency revival restores Hero HP to $50\%$ ($50\text{ HP}$) and clears `isGhost = false`.
5. **Elixir of Life Resurrection**: Using `item_elixir_life` restores Hero HP to $100\%$ ($100\text{ HP}$) and clears `isGhost = false`.

#### Feature 5: Habit Tracking & MP Economy
1. **Positive Habit Action (+)**: Awards `+10 Coins` and `+15 MP`, capped at `maxMp` (100).
2. **Negative Habit Action (-)**: Deducts `-10 Coins` and `-15 MP`, clamped at `0` (never negative).
3. **MP Buff Casting**: Spends MP to activate timed buffs (Double EXP, Boss Stun, Focus Surge).
4. **Insufficient MP Rejection**: Buff cast fails if `currentMp < cost`.
5. **Buff Duration Refresh**: Casting an already active buff extends or resets the expiration timer.

#### Feature 6: The Tavern Marketplace & Custom Rewards
1. **Consumable Item Purchase**: Deducts Coins and increments inventory quantity.
2. **Consumable Item Usage**: Consuming `potion_health` restores $+50\text{ HP}$; `potion_exp` grants $+100\text{ EXP}$.
3. **Cosmetic Skin Purchase**: Unlocks skin in `unlockedSkins` and deducts Coins.
4. **Custom Real-Life Reward Creation**: Adds custom user reward with custom title, cost, and icon.
5. **Custom Real-Life Reward Redemption**: Deducts Coins, increments `timesRedeemed`, and fails if Coins are insufficient.

#### Feature 7: Dungeon World Map & Boss Progression
1. **Boss Damage Infliction**: Strikes reduce Boss HP in real time.
2. **Boss Defeat & Victory Trigger**: Boss reaching 0 HP triggers Victory state and unlocks the next Chapter.
3. **Boss Loot Grant**: Awards Boss bonus Coins and EXP on defeat.
4. **Chapter Selection**: Allows navigation between unlocked chapters (1 through 4).
5. **Dungeon Bestiary**: Displays Boss statistics, lore, and loot drops.

#### Feature 8: Hall of Fame, Analytics & Persistence
1. **Combat & EXP Logging**: Records timestamped logs for chart analytics.
2. **Achievement Milestone Unlocks**: Evaluates achievements (`ach_first_blood`, `ach_slime_slayer`, `ach_coin_hoarder`, etc.).
3. **Simulated Guild Leaderboard**: Ranks Hero against 5 simulated rivals based on weekly damage.
4. **Starter Kit Seeding**: Initial run seeds default Hero, King Slime, starter Quests, Dailies, Habits, and Tavern items.
5. **JSON Save File Export & Import**: Exports and validates complete game state roundtrip.

---

### 2.2 Tier 2: Boundary & Corner Cases

Tier 2 exercises extreme input values, zero/negative clamping, and edge failure modes:
1. **Level Up Multi-Level Overflow**: Gaining `300 EXP` at Level 1 skips Level 2 to reach Level 3, awarding `+6 unallocatedPoints` and retaining `75 EXP` remainder.
2. **Stat Allocation at 0 Points**: Attempting to allocate points when `unallocatedPoints == 0` is safely rejected.
3. **Negative Habit Clamping at 0 Resources**: Logging negative habits when `coins == 5` and `mp == 10` clamps both to `0` without negative underflow.
4. **Massive Overkill Strike**: A 600-damage Rank S strike against a Boss with 10 HP clamps Boss HP to `0` and triggers victory cleanly.
5. **Catastrophic Midnight Damage**: Missed daily counter-damage of 120 HP against a Hero with 30 HP clamps HP to `0` and triggers Ghost State.
6. **Locked Chapter Navigation**: Attempting to select Chapter 3 when only Chapters 1 and 2 are unlocked is rejected.
7. **Empty Inventory Consumption**: Attempting to use a consumable not in inventory returns `false`.
8. **Corrupted / Incomplete JSON Save Import**: Safely rejects invalid JSON or schema mismatches without corrupting in-memory state.
9. **Daily Quest Streak Decrement on Uncheck**: Unchecking a completed daily decrements streak without dropping below 0.
10. **Custom Reward Redemption with Insufficient Coins**: Safely rejects redemption when Hero has fewer Coins than required.

---

### 2.3 Tier 3: Cross-Feature Combinations

Tier 3 tests deep interactions between disparate game systems:
1. **Combat Strike + Focus Surge + Multi-Level Overflow + Title Unlock + Analytics**:
   - Focus Surge buff multiplies Rank A damage from 350 to 525 (+ Hero Bonus).
   - EXP reward triggers a level up, granting stat points.
   - Allocating points unlocks the `'Iron Knight'` title.
   - Analytics automatically records the activity and unlocks `'First Blood'`.
2. **Midnight Reset Damage + Ghost State + Blocked Rewards + Revival Loop**:
   - Missed dailies drain Hero HP to 0 -> Ghost State activated.
   - Hero attempts to complete quests and habits: EXP and Coin rewards are blocked.
   - Hero completes emergency Revival Quest -> HP restored to 50, Ghost State cleared.
   - Subsequent Quest completions successfully award EXP and Coins.
3. **Habits Economy + Tavern Inventory + Consumable Buffing + Midnight Immunity**:
   - Positive habit logging builds Coins and MP.
   - Hero purchases `Streak Shield` and `Health Potion` in Tavern.
   - Hero casts `Boss Stun` buff using accumulated MP.
   - Midnight reset triggers: Boss Stun and Streak Shield prevent all counter-damage.
4. **Dungeon Boss Defeat + Victory Loot + Tavern Cosmetic Purchase + Sanctuary Equipping**:
   - Hero defeats King Slime Boss, gaining 100 Coins and 150 EXP.
   - Chapter 2 (Goblin Keep) unlocks.
   - Hero visits Tavern and buys `Holy Paladin Skin` for 150 Coins.
   - Hero opens Sanctuary and equips the newly unlocked skin.

---

### 2.4 Tier 4: Real-World Application Scenarios (E2E Journeys)

Tier 4 validates complete end-to-end user journeys:
1. **Journey 1: "Day 1 Adventurer Onboarding & First Boss Battle"**:
   - Clean launch -> Starter Kit loaded (Arthur, King Slime, 3 Quests, 3 Dailies, 3 Habits).
   - Allocate 2 starter stat points into STR and VIT.
   - Complete starter Quest 1 -> Strike King Slime, gain EXP/Coins.
   - Log positive water habit -> Gain Coins and MP.
   - Cast Focus Surge buff -> Verify active status.
2. **Journey 2: "The Midnight Crisis & Heroic Revival"**:
   - Adventurer misses daily tasks across calendar reset.
   - Boss counter-attacks for 30 HP -> Hero HP reaches 0 -> Ghost State.
   - Adventurer attempts to gain rewards (blocked).
   - Adventurer performs Revival Quest prompt -> Restores 50 HP.
   - Adventurer purchases and drinks a Health Potion -> HP reaches 100.
3. **Journey 3: "Dungeon Expedition & Custom Reward Celebration"**:
   - Complete all 3 daily quests -> Receive All-Done Streak Chest (+25 Coins).
   - Complete Rank S Quest -> Deal critical strike -> Defeat King Slime Boss.
   - Victory fanfare -> Chapter 2 (Goblin Keep) unlocked.
   - Visit Tavern -> Create custom real-life reward "Boba Tea" (50 Coins).
   - Redeem "Boba Tea" -> Verify coin deduction and redemption increment.
   - Export full JSON save backup file.
4. **Journey 4: "Hall of Fame Legend & Attribute Mastery"**:
   - Progress through multiple quest ranks (E to S).
   - Level up to Level 5 -> Unlock `'Seasoned Veteran'` title.
   - Raise STR to 15 -> Unlock `'Ascended Hero'` achievement.
   - Check Hall of Fame -> View EXP trajectory, Boss damage chart, and climb Simulated Guild Leaderboard.

---

## 3. Test Suite Directory Layout

```
test/
├── unit/
│   ├── hero_progression_unit_test.dart       # Tier 1: Leveling math, attributes, titles
│   ├── combat_math_unit_test.dart            # Tier 1: Damage formulas, ranks, buffs, criticals
│   ├── habit_economy_unit_test.dart          # Tier 1: Habit counts, coin/MP economy, skill buffs
│   ├── day_cycle_and_ghost_unit_test.dart    # Tier 1: Dailies, streaks, midnight reset, ghost state
│   ├── tavern_economy_unit_test.dart         # Tier 1: Shop items, consumables, custom rewards
│   └── localization_and_i18n_test.dart       # Tier 1: Localization dictionaries & language toggle
├── boundary/
│   └── tier2_boundary_corner_cases_test.dart # Tier 2: Boundary conditions, overflows, clamps
├── combinations/
│   └── tier3_cross_feature_combinations_test.dart # Tier 3: Pairwise system integrations
├── e2e/
│   └── tier4_real_world_user_journeys_test.dart   # Tier 4: Realistic E2E player journeys
├── daily_quest_and_ghost_state_test.dart     # Component & Widget tests
├── dungeon_world_map_test.dart               # Component & Widget tests
├── habit_and_mp_buffs_test.dart              # Component & Widget tests
├── hall_of_fame_analytics_test.dart          # Component & Widget tests
├── hero_progression_test.dart                # Component & Widget tests
├── navigation_smoke_test.dart                # Component & Widget tests
├── persistence_and_starter_kit_test.dart     # Component & Widget tests
├── quest_combat_strike_test.dart             # Component & Widget tests
└── tavern_marketplace_test.dart              # Component & Widget tests
```

---

## 4. Verification & Quality Commands

```bash
# Execute entire test suite
flutter test

# Execute specific tier test suites
flutter test test/unit/
flutter test test/boundary/
flutter test test/combinations/
flutter test test/e2e/

# Run static analysis
flutter analyze
```
