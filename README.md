<div align="center">

<img src="docs/assets/readme/medal.gif" width="72" alt="" />

# WorkXP (Pocket Quest)

**16-bit pixel RPG that turns your tasks into boss fights.**<br/>
แอปจัดการงานและสร้างนิสัยในรูปแบบเกม RPG พิกเซล 16-บิต

[![Flutter](https://img.shields.io/badge/Flutter-3.38%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/BLoC-flutter__bloc%209.1-9900FF?style=for-the-badge)](https://bloclibrary.dev)
[![Database](https://img.shields.io/badge/Drift-SQLite%202.31-00A98F?style=for-the-badge)](https://drift.simonbinder.eu)
[![Storage](https://img.shields.io/badge/Hive-2.2-FFC107?style=for-the-badge)](https://pub.dev/packages/hive)
[![Routing](https://img.shields.io/badge/AutoRoute-10.3-FF5722?style=for-the-badge)](https://pub.dev/packages/auto_route)
[![DI](https://img.shields.io/badge/GetIt-8.3-607D8B?style=for-the-badge)](https://pub.dev/packages/get_it)
[![Audio](https://img.shields.io/badge/Audioplayers-6.7-E040FB?style=for-the-badge)](https://pub.dev/packages/audioplayers)

[Overview](#overview) • [Features](#features) • [Architecture](#architecture) • [Getting Started](#getting-started)

</div>

---

## <img src="docs/assets/readme/book.gif" width="32" align="absmiddle" alt="" /> Overview

Finish real tasks to damage **Bosses**, log **Habits** for MP buffs, clear **Dungeon** chapters, and spend **Coins** at **The Tavern**. Fully offline, 60fps, Thai/English, with 16-bit chiptune audio.

> ทำงานจริงเพื่อโจมตีบอส สะสม MP จากนิสัยดี ตะลุยดันเจี้ยน แล้วนำเหรียญไปแลกรางวัล — ทำงานออฟไลน์ 100%

---

## <img src="docs/assets/readme/star.gif" width="32" align="absmiddle" alt="" /> Features

| | Feature | What it does |
| :-: | :-- | :-- |
| <img src="docs/assets/readme/battle.gif" width="36" alt="" /> | **Battle Hub** | Quests ranked **E–S** deal instant damage to the Boss. Collapsible boss bar, quick-add `+` sheet, live tab badges. |
| <img src="docs/assets/readme/music.gif" width="36" alt="" /> | **Chiptune Audio** | 8 SFX triggers + per-tab BGM. Separate toggles for BGM, SFX and haptics. |
| <img src="docs/assets/readme/habit.gif" width="36" alt="" /> | **Habits & MP Buffs** | `[+]` / `[-]` habit logging. Spend MP on *Double EXP*, *Boss Freeze*, *Focus Surge*. |
| <img src="docs/assets/readme/ghost.gif" width="36" alt="" /> | **Ghost State & Revival** | Missed Daily Quests hurt your Hero at midnight. HP 0 = Ghost State; revive via **Revival Quest** or *Elixir of Life*. |
| <img src="docs/assets/readme/map.gif" width="36" alt="" /> | **World Map** | 4 level-gated chapters, from *Slime Forest* to *Volcano Peak*, with a boss bestiary. |
| <img src="docs/assets/readme/tavern.gif" width="36" alt="" /> | **The Tavern** | Buy potions, shields and skins — or redeem your own **Custom Rewards** (e.g. "50 Coins = Boba Tea"). |
| <img src="docs/assets/readme/chart.gif" width="36" alt="" /> | **Hall of Fame** | EXP curve, weekly damage, habit heatmap, attribute radar, achievements. |
| <img src="docs/assets/readme/hero.gif" width="36" alt="" /> | **Hero Sanctuary** | Allocate **STR / INT / AGI / VIT / WIS**, JSON backup/restore, Thai–English switch. |

---

## <img src="docs/assets/readme/arch.gif" width="32" align="absmiddle" alt="" /> Architecture

Feature-first vertical slices on the **FLDP Mobile Standard**.

```
lib/
├── core/          # SensoryService (SFX/BGM/haptics), DayCycleService, theme
├── domain/        # Entities, combat math, Drift DB, repositories
├── feature/       # battle_hub · dungeon · tavern · analytics · hero_sanctuary
├── i18n/          # en.arb / th.arb per feature
├── router/        # AutoRoute, 5-tab dashboard
├── shared/        # 16-bit shared widgets
├── locator.dart   # GetIt DI
└── main.dart
```

```mermaid
graph LR
    UI[Pixel UI] -->|events| BLOC[BLoCs]
    BLOC -->|state| UI
    BLOC --> REPO[Repositories]
    REPO -->|streams| DB[(Drift SQLite)]
    REPO --> HIVE[(Hive)]
    LOC[GetIt] -.->|injects| BLOC & REPO
```

---

## <img src="docs/assets/readme/start.gif" width="32" align="absmiddle" alt="" /> Getting Started

**Requires** Flutter `>= 3.38.4` · Dart `>= 3.11.3`

```bash
git clone https://github.com/Theeraphat-S/workxp-mobile.git && cd workxp-mobile
flutter pub get
cp .env.example .env
```

```bash
dart run build_runner build --delete-conflicting-outputs   # Drift, routes, adapters
dart run tool/generate_i18n.dart                           # i18n from ARBs
dart run tool/generate_audio_assets.dart                   # 16-bit SFX/BGM
```

```bash
flutter analyze && flutter test
flutter run
```

---

<div align="center">

<img src="docs/assets/readme/heart.gif" width="28" align="absmiddle" alt="" /> Built with the **FLDP Mobile Standard**, for productive heroes.

<sub>Animated icons by <a href="https://lordicon.com/">Lordicon.com</a></sub>

</div>
