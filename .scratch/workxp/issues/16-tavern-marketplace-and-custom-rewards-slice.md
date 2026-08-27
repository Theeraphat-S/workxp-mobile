# 16: The Tavern Marketplace & Custom Rewards Feature Slice

**What to build:** Implement The Tavern marketplace so that players can spend earned Coins on consumable potions, cosmetic avatar skins, CRT themes, and custom real-life rewards.

**Blocked by:** 14: Battle Hub Feature Vertical Slice (Hero, Boss & Quest Combat)

**Status:** completed

- [x] Create `feature/tavern/bloc/` with `TavernBloc` handling item purchasing, custom reward creation, and redemption.
- [x] Connect `TavernBloc` to `TavernRepository` and `HeroRepository`.
- [x] Implement `TavernPage` with `@RoutePage` annotation in `feature/tavern/pages/`.
- [x] Implement Tavern widgets in `feature/tavern/widgets/` (`TavernItemCard`, `CustomRewardCard`, `CreateCustomRewardDialog`, `RedeemCelebrationDialog`, `TavernTabBarView`).
- [x] Add localization strings under `lib/i18n/locals/tavern/` for Thai and English.
- [x] Add unit tests for `TavernBloc` and widget tests for `TavernPage`.
