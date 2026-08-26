# WorkXP (Pocket Quest)

WorkXP is a 16-bit retro pixel fantasy RPG gamified productivity mobile app where real-world tasks and daily habits power dungeon expeditions, boss battles, and character progression.

## Language

### Core Entities

**Hero**:
The player's 16-bit pixel RPG persona, featuring Level, HP, MP, Core Attributes (STR, INT, AGI, VIT, WIS), equipped avatar skins, and earned titles.
_Avoid_: User profile, player account, character sheet

**Ghost State**:
A temporary penalty state triggered when Hero HP reaches 0 from missed Daily Quests, suspending EXP/Coin gains until a Revival Quest or Elixir is used.
_Avoid_: Dead, game over, account lock

**Revival Quest**:
A designated emergency real-world action (e.g. drink water, take a walk, finish 1 quick task) that restores the Hero from Ghost State back to life.
_Avoid_: Penalty task, punishment chore

**Boss (Dungeon Boss)**:
A chapter-specific monster with a massive HP pool that the Hero attacks by completing Quests and Daily Quests.
_Avoid_: Enemy, monster, target

**Dungeon**:
A thematic chapter stage on the World Map (e.g. Slime Forest, Goblin Keep, Shadow Crypt, Volcano Peak) guarded by a Boss.
_Avoid_: Level, world, zone, stage

### Activity System

**Quest**:
A discrete, one-off task ranked E, D, C, B, A, or S that deals direct damage to the Boss and awards EXP.
_Avoid_: To-do, task, chore, ticket

**Daily Quest**:
A recurring 24-hour scheduled task that maintains Streaks and shields the Hero from Boss counter-damage at midnight reset.
_Avoid_: Daily to-do, recurring task, routine

**Habit**:
A repeatable positive or negative behavioral action tracking frequency and granting or deducting Coins and MP.
_Avoid_: Habit tracker, routine item

**Streak**:
The count of consecutive days a Hero has fulfilled their Daily Quests without taking Boss damage.
_Avoid_: Chain, consecutive days

### Economy & Vitals

**HP (Health Points)**:
The Hero's vitality pool. Incomplete Daily Quests at day reset cause Boss counter-attacks, draining HP.
_Avoid_: Life, energy, stamina

**MP (Mana Points)**:
The Hero's magical resource accumulated through positive habits, used to cast skill buffs (e.g. Double EXP, Boss Stun).
_Avoid_: Energy, power, magic points

**EXP (Experience Points)**:
The non-spendable progression metric that drives Hero Leveling and unlocks new skills, tiers, and avatar equipment.
_Avoid_: Score, points, XP

**Coin**:
The spendable in-game currency earned from completing Quests and Habits, spent at the Tavern.
_Avoid_: Gold, credits, money, gems

**Tavern**:
The in-game marketplace containing Game Consumables (Potions, Scrolls), Pixel Cosmetics (Avatars, CRT Themes), and User-Created Custom Real-Life Rewards.
_Avoid_: Store, shop, marketplace

**Custom Reward**:
A real-life reward defined and priced in Coins by the user (e.g. 50 Coins for Boba Tea, 40 Coins for Gaming time) redeemable at the Tavern.
_Avoid_: Real prize, voucher, coupon

**Achievement**:
A permanent milestone trophy awarded for specific lifetime feats (e.g. Defeating first Dragon, 30-Day Streak).
_Avoid_: Badge, award, medal
