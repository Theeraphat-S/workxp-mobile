# 02: Hero Vitals, Attribute Stats & Leveling Progression Slice

**What to build:**
Hero state management and UI showcasing the adventurer's Level, EXP progression bar, HP, MP, and the 5 Core Attributes (STR, INT, AGI, VIT, WIS). When EXP hits the threshold ($\text{floor}(100 \times 1.25^{\text{level}-1})$), a Level-Up fanfare animation triggers, increasing maximum vitals and awarding attribute points that can be allocated in the Hero Profile screen to unlock new Titles.

**Blocked by:** 01: Flutter Foundation, 16-Bit Design System & 5-Screen Navigation Shell

**Status:** completed

- [x] `HeroModel` and `HeroNotifier` maintain Level, current/max EXP, HP (0-100), MP (0-100), available stat points, and allocated attributes (STR, INT, AGI, VIT, WIS).
- [x] Gaining EXP triggers smooth animated progress bar updates and evaluates level thresholds.
- [x] Level Up event triggers visual fanfare, plays level-up chiptune SFX, restores HP/MP, and grants stat points.
- [x] Hero Profile screen allows the user to allocate stat points into STR, INT, AGI, VIT, and WIS, updating stats in real-time.
- [x] Titles unlock dynamically based on highest attributes and completed milestones.
- [x] Unit tests verify EXP progression formula, level up transitions, and stat point allocation limits.
