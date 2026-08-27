import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1 Unit Test: Tavern Marketplace & Custom Real-Life Rewards', () {
    test(
      '1. Buying consumable item deducts coins and adds item with quantity 1 to inventory',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(coins: 100));
        final tavernNotifier = TavernNotifier();

        // Health Potion costs 25 Coins
        final success = tavernNotifier.buyItem(
          'item_potion_health',
          heroNotifier: heroNotifier,
        );

        expect(success, isTrue);
        expect(heroNotifier.state.coins, 75); // 100 - 25
        expect(tavernNotifier.state.inventory.length, 1);
        expect(
          tavernNotifier.state.inventory.first.tavernItemId,
          'item_potion_health',
        );
        expect(tavernNotifier.state.inventory.first.quantity, 1);
      },
    );

    test(
      '2. Buying multiple instances of the same consumable stacks inventory quantity',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(coins: 150));
        final tavernNotifier = TavernNotifier();

        // Buy 3 Health Potions (25 * 3 = 75 Coins)
        expect(
          tavernNotifier.buyItem(
            'item_potion_health',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(
          tavernNotifier.buyItem(
            'item_potion_health',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );
        expect(
          tavernNotifier.buyItem(
            'item_potion_health',
            heroNotifier: heroNotifier,
          ),
          isTrue,
        );

        expect(heroNotifier.state.coins, 75); // 150 - 75
        expect(tavernNotifier.state.inventory.length, 1);
        expect(tavernNotifier.state.inventory.first.quantity, 3);
      },
    );

    test(
      '3. Using consumables applies correct vital buffs and decrements quantity',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 200, currentHp: 30, currentExp: 0),
        );
        final tavernNotifier = TavernNotifier();

        // Buy 1 Health Potion (25) and 1 EXP Tonic (35)
        tavernNotifier.buyItem(
          'item_potion_health',
          heroNotifier: heroNotifier,
        );
        tavernNotifier.buyItem('item_exp_tonic', heroNotifier: heroNotifier);

        // Consume Health Potion (+50 HP)
        final usedHp = tavernNotifier.useConsumable(
          'item_potion_health',
          heroNotifier: heroNotifier,
        );
        expect(usedHp, isTrue);
        expect(heroNotifier.state.currentHp, 80); // 30 + 50
        expect(
          tavernNotifier.state.inventory.any(
            (i) => i.tavernItemId == 'item_potion_health',
          ),
          isFalse,
        );

        // Consume EXP Tonic (+100 EXP -> levels up to 2 with 0 remainder)
        final usedExp = tavernNotifier.useConsumable(
          'item_exp_tonic',
          heroNotifier: heroNotifier,
        );
        expect(usedExp, isTrue);
        expect(heroNotifier.state.level, 2);
        expect(heroNotifier.state.currentExp, 0);
        expect(tavernNotifier.state.inventory.isEmpty, isTrue);
      },
    );

    test(
      '4. Using Streak Shield consumable increments activeStreakShields in state',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(coins: 100));
        final tavernNotifier = TavernNotifier();

        // Buy Streak Shield (40 Coins)
        tavernNotifier.buyItem(
          'item_streak_shield',
          heroNotifier: heroNotifier,
        );
        expect(heroNotifier.state.coins, 60);

        // Use Streak Shield
        final used = tavernNotifier.useConsumable(
          'item_streak_shield',
          heroNotifier: heroNotifier,
        );
        expect(used, isTrue);
        expect(tavernNotifier.state.activeStreakShields, 1);
      },
    );

    test(
      '5. Purchasing Cosmetic Skin unlocks avatar in HeroModel.unlockedSkins',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 300, unlockedSkins: ['hero_novice']),
        );
        final tavernNotifier = TavernNotifier();

        // Paladin skin costs 150 Coins
        final boughtPaladin = tavernNotifier.buyItem(
          'paladin',
          heroNotifier: heroNotifier,
        );
        expect(boughtPaladin, isTrue);
        expect(heroNotifier.state.coins, 150); // 300 - 150
        expect(heroNotifier.state.unlockedSkins.contains('paladin'), isTrue);

        // Equip newly bought skin
        final equipped = heroNotifier.setActiveSkin('paladin');
        expect(equipped, isTrue);
        expect(heroNotifier.state.activeSkinId, 'paladin');
      },
    );

    test(
      '6. Custom Real-Life Reward creation, editing, and coin redemption',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(coins: 80));
        final tavernNotifier = TavernNotifier();

        final customReward = CustomRewardModel(
          id: 'rew_coffee',
          title: 'Specialty Espresso',
          coinCost: 35,
          iconName: 'coffee',
        );

        tavernNotifier.addCustomReward(customReward);
        expect(
          tavernNotifier.state.customRewards.any((r) => r.id == 'rew_coffee'),
          isTrue,
        );

        // Redeem reward (35 Coins)
        final redeemed = tavernNotifier.redeemCustomReward(
          'rew_coffee',
          heroNotifier: heroNotifier,
        );
        expect(redeemed, isTrue);
        expect(heroNotifier.state.coins, 45); // 80 - 35
        final updated = tavernNotifier.state.customRewards.firstWhere(
          (r) => r.id == 'rew_coffee',
        );
        expect(updated.timesRedeemed, 1);

        // Edit reward cost to 50
        tavernNotifier.editCustomReward(updated.copyWith(coinCost: 50));
        expect(
          tavernNotifier.state.customRewards
              .firstWhere((r) => r.id == 'rew_coffee')
              .coinCost,
          50,
        );

        // Attempt second redemption with 45 coins (needs 50) -> Rejected
        final fail = tavernNotifier.redeemCustomReward(
          'rew_coffee',
          heroNotifier: heroNotifier,
        );
        expect(fail, isFalse);
        expect(heroNotifier.state.coins, 45);
      },
    );
  });
}
