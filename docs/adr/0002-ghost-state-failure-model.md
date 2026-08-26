# 0002. Ghost State Failure Mechanic over Permadeath or Level Loss

## Status
Accepted

## Context
When users fail to complete Daily Quests, the RPG Boss counter-attacks and drains Hero HP. In traditional RPGs, 0 HP results in death or progress wipe. In a productivity app, harsh punishment (losing levels or wiping streaks) often causes burnout and app abandonment.

## Decision
We adopted the **Ghost State and Revival Quest mechanic**. When Hero HP drops to 0:
1. Hero enters "Ghost State" (visual spirit sprite).
2. EXP and Coin progression is paused.
3. Hero is revived either by finishing a prompt "Revival Quest" (immediate self-care or quick task) or by purchasing an *Elixir of Life* from the Tavern.

## Consequences
- Protects user retention while preserving game stakes and immersion.
- Turns failure into an immediate actionable recovery loop rather than a demotivating punishment.
