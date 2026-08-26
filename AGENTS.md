# WorkXP — Agent Engineering Guide (`AGENTS.md`)

This repository is **WorkXP (Pocket Quest)**, a 16-bit retro pixel fantasy RPG gamified productivity mobile application built with **Flutter (Dart)**, **Riverpod**, and **Hive**.

---

## 1. Project Standards & Essential Rules

- **Domain Language First**: Use canonical domain terminology defined in [CONTEXT.md](file:///c:/Work/workxp/CONTEXT.md) (`Hero`, `Boss`, `Dungeon`, `Quest`, `Daily Quest`, `Habit`, `Ghost State`, `Revival Quest`, `Tavern`, `Custom Reward`, `EXP`, `Coin`). Avoid generic terms.
- **Architectural Integrity**: Respect decisions recorded in [docs/adr/](file:///c:/Work/workxp/docs/adr/) and specifications in [docs/SPEC.md](file:///c:/Work/workxp/docs/SPEC.md).
- **Ticket-Driven Flow**: Implement features slice-by-slice following tickets in [`.scratch/workxp/issues/`](file:///c:/Work/workxp/.scratch/workxp/issues/) in dependency order.
- **Offline-First & Zero Latency**: All domain state must persist locally via Hive. State mutations must feel instantaneous (60fps).

---

## 2. Definition of Done (DoD) for Every Ticket

Before marking any ticket or feature complete, the following three criteria **must** pass:

1. **Static Analysis Clean**: Run `dart analyze` — must report 0 errors and 0 warnings.
2. **Behavioral Test Coverage**: Add unit/widget tests for the new slice and run `flutter test` — all tests must pass.
3. **Spec & Ticket Verification**: All acceptance criteria listed in the target ticket file and [docs/SPEC.md](file:///c:/Work/workxp/docs/SPEC.md) are met.

---

## 3. Skill Trigger Map (Context Pointers)

Agents must consult the relevant skill (`SKILL.md`) **before** starting work in that phase.

| Phase & Workflow | When to Read / Trigger Condition | Skill Pointer |
| :--- | :--- | :--- |
| **1. Architecture & Setup** | Structuring folders, data/logic/UI layers, Riverpod providers | [`flutter-apply-architecture-best-practices`](file:///c:/Work/workxp/.agents/skills/flutter-apply-architecture-best-practices/SKILL.md) |
| | Designing deep modules, minimal seams, clean interfaces | [`codebase-design`](file:///c:/Work/workxp/.agents/skills/codebase-design/SKILL.md) |
| | Introducing new domain terms or recording architectural trade-offs | [`domain-modeling`](file:///c:/Work/workxp/.agents/skills/domain-modeling/SKILL.md) |
| **2. UI/UX & 16-Bit Crafting** | Building screens, custom widgets, 60fps animations & transitions | [`flutter-ui-ux`](file:///c:/Work/workxp/.agents/skills/flutter-ui-ux/SKILL.md) |
| | Designing retro color palettes, typography, micro-interactions, HUDs | [`ui-ux-pro-max`](file:///c:/Work/workxp/.agents/skills/ui-ux-pro-max/SKILL.md) |
| | Enforcing premium visual standards (avoiding cheap/generic AI looks) | [`high-end-visual-design`](file:///c:/Work/workxp/.agents/skills/high-end-visual-design/SKILL.md) |
| | Handling multi-device responsive sizing and safe areas | [`flutter-build-responsive-layout`](file:///c:/Work/workxp/.agents/skills/flutter-build-responsive-layout/SKILL.md) |
| **3. Domain Logic & State** | Writing JSON serialization (`fromJson` / `toJson`) for models | [`flutter-implement-json-serialization`](file:///c:/Work/workxp/.agents/skills/flutter-implement-json-serialization/SKILL.md) |
| | Writing surgical, non-overcomplicated code changes | [`karpathy-guidelines`](file:///c:/Work/workxp/.agents/skills/karpathy-guidelines/SKILL.md) |
| | Writing test-first logic (Red-Green-Refactor) | [`tdd`](file:///c:/Work/workxp/.agents/skills/tdd/SKILL.md) |
| **4. Bug Fixing & Diagnostics** | Investigating unexpected bugs, regressions, or state glitches | [`diagnosing-bugs`](file:///c:/Work/workxp/.agents/skills/diagnosing-bugs/SKILL.md) |
| | Fixing layout errors (`RenderFlex overflowed`, `unbounded height`) | [`flutter-fix-layout-issues`](file:///c:/Work/workxp/.agents/skills/flutter-fix-layout-issues/SKILL.md) |
| | Debugging Dart runtime exceptions and stack traces | [`dart-fix-runtime-errors`](file:///c:/Work/workxp/.agents/skills/dart-fix-runtime-errors/SKILL.md) |
| **5. Testing & Code Review** | Writing unit tests for state notifiers, combat math, leveling logic | [`dart-add-unit-test`](file:///c:/Work/workxp/.agents/skills/dart-add-unit-test/SKILL.md) |
| | Writing component widget tests for UI interactions and dialogs | [`flutter-add-widget-test`](file:///c:/Work/workxp/.agents/skills/flutter-add-widget-test/SKILL.md) |
| | Running static analysis and applying auto-fixes (`dart analyze`) | [`dart-run-static-analysis`](file:///c:/Work/workxp/.agents/skills/dart-run-static-analysis/SKILL.md) |
| | Reviewing completed code against standards and spec | [`code-review`](file:///c:/Work/workxp/.agents/skills/code-review/SKILL.md) |

---

## 4. Key Commands Reference

```bash
# Analyze code for errors, warnings, and linter rules
flutter analyze

# Run all unit and widget tests
flutter test

# Run tests with coverage output
flutter test --coverage

# Format code according to Dart conventions
dart format .

# Build / Run development
flutter run
```
