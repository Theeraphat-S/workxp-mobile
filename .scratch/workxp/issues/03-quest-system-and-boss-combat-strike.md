# 03: Quest System & Boss Combat Strike Slice

**What to build:**
A full Quest (one-off tasks) management system where completing tasks delivers real combat strikes against the active Dungeon Boss. Quests have titles, descriptions, due dates, Rank tiers (E to S), and Attribute tags. Checking off a Quest plays a 16-bit sword slash animation, displays floating critical combat damage text, depletes the active Boss's HP bar, and awards the Hero EXP and Coins.

**Blocked by:** 02: Hero Vitals, Attribute Stats & Leveling Progression Slice

**Status:** ready-for-agent

- [ ] Users can create, edit, delete, and filter Quests by Rank (E, D, C, B, A, S) and Attribute tag.
- [ ] Completing a Quest triggers a retro combat animation on the Battle screen with a slashing effect and floating damage numbers.
- [ ] Damage is calculated based on Quest Rank (Rank E: 25, D: 50, C: 100, B: 200, A: 350, S: 600) plus Hero attribute bonuses.
- [ ] Active Boss HP decreases in real-time, accompanied by hit animations and audio SFX.
- [ ] Completing a Quest awards proportional EXP and Coins to the Hero state.
- [ ] Tests verify that completing a Quest correctly dispatches damage to the Boss, awards EXP/Coins, and marks the task as completed.
