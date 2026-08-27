# 06: Dungeon World Map & Boss Chapter Progression Slice

**What to build:**
A 16-bit retro World Map showing 4 Dungeon Chapter nodes: Chapter 1: *Slime Forest (King Slime)*, Chapter 2: *Goblin Keep (Goblin Shaman)*, Chapter 3: *Shadow Crypt (Dread Necromancer)*, and Chapter 4: *Volcano Peak (Red Dragon)*. When a Boss's HP reaches 0, the app triggers a Victory Fanfare sequence, awards massive bonus Coins and Chapter completion trophies, and unlocks the next Chapter on the World Map.

**Blocked by:** 03: Quest System & Boss Combat Strike Slice

**Status:** completed

- [x] World Map screen visualizes 4 Chapters with pixelated node paths, lock/unlock status, and completion progress.
- [x] Depleting a Boss's HP to 0 triggers a victory overlay modal with fanfare SFX, celebratory particles, and bonus loot.
- [x] Chapter unlocks sequentially as previous Bosses are defeated.
- [x] Users can review previously conquered Bosses in a Dungeon Bestiary.
- [x] Tests verify Boss death transition, reward distribution, and Chapter progression state persistence.
