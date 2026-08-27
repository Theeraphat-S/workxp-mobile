# 05: Habit Tracker, Coin Economy & MP Skill Buffs Slice

**What to build:**
A Habit tracker allowing heroes to log positive (+) and negative (-) actions throughout the day. Positive taps grant Coins and fill the Hero's MP gauge, while negative taps deduct Coins and drain MP. Accumulated MP can be spent on active Skill Buffs (e.g. Double EXP Scroll for 2 hours, Boss Freeze to prevent counter-attacks for one night).

**Blocked by:** 02: Hero Vitals, Attribute Stats & Leveling Progression Slice

**Status:** completed

- [x] Users can create Habits with title, positive (+) and/or negative (-) actions, and Attribute tags.
- [x] Tapping (+) increases daily counter, awards Coins (+10), and adds MP (+15) with animated sound & haptic feedback.
- [x] Tapping (-) increments penalty counter, deducts Coins (-10), and drains MP (-15).
- [x] Skill Buffs UI allows spending MP to cast temporary buffs (Double EXP, Boss Stun).
- [x] Active buffs display remaining duration countdown on the Battle hub.
- [x] Tests verify habit counter updates, Coin/MP math boundaries, and MP buff activation logic.
