# 04: Daily Quest 24-Hour Cycle, Streak Protection & Ghost State Slice

**What to build:**
Daily Quests that recur every 24 hours to track vital daily habits. Completing all Daily Quests increments the Hero's consecutive Streak count. When the 24-hour cycle resets at midnight, any uncompleted Daily Quests cause the active Boss to counter-attack, draining 15 HP per missed daily. If Hero HP reaches 0, the Hero enters the "Ghost State" (pausing EXP and Coin gains). The Hero can be resurrected by completing an emergency "Revival Quest" or consuming an Elixir of Life.

**Blocked by:** 03: Quest System & Boss Combat Strike Slice

**Status:** ready-for-agent

- [ ] Users can create, edit, delete, and check off Daily Quests.
- [ ] Completing all Daily Quests for the day increments the Streak counter and awards bonus streak coins.
- [ ] `DayCycleService` detects date transitions and evaluates uncompleted Daily Quests.
- [ ] Incomplete Daily Quests at midnight inflict Boss counter-attacks (15 HP damage per incomplete daily).
- [ ] When Hero HP reaches 0, `isGhost` is activated, turning the Hero sprite into a translucent ghost and suspending EXP/Coin gains.
- [ ] Completing a prompt Revival Quest or using a revival item restores Hero HP to 50% and removes Ghost State.
- [ ] Tests verify the day-cycle evaluation, damage deduction, Ghost State trigger at 0 HP, and successful resurrection via Revival Quest.
