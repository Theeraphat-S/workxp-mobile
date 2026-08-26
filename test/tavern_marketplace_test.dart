import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';
import 'package:workxp/presentation/screens/tavern/tavern_screen.dart';

void main() {
  group(
    'Ticket 07: The Tavern Marketplace & Custom Real-Life Rewards Slice',
    () {
      test('Buying consumable deducts coins and adds item to inventory', () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 100, currentHp: 40),
        );

        final tavernNotifier = TavernNotifier(
          const TavernState(
            catalog: [
              ShopItemModel(
                id: 'item_potion_health',
                name: 'Health Potion',
                description: 'Restores 50 HP',
                cost: 25,
                type: 'consumable',
                spriteType: 'potion_health',
                effectValue: 50,
              ),
            ],
          ),
        );

        final success = tavernNotifier.buyItem(
          'item_potion_health',
          heroNotifier: heroNotifier,
        );

        expect(success, true);
        expect(heroNotifier.state.coins, 75); // 100 - 25
        expect(tavernNotifier.state.inventory.length, 1);
        expect(tavernNotifier.state.inventory.first.quantity, 1);

        // Consume potion
        final used = tavernNotifier.useConsumable(
          'item_potion_health',
          heroNotifier: heroNotifier,
        );
        expect(used, true);
        expect(heroNotifier.state.currentHp, 90); // 40 + 50
        expect(tavernNotifier.state.inventory.isEmpty, true);
      });

      test('Buying skin unlocks avatar in hero state', () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 200, unlockedSkins: ['hero_novice']),
        );

        final tavernNotifier = TavernNotifier(
          const TavernState(
            catalog: [
              ShopItemModel(
                id: 'paladin',
                name: 'Paladin',
                description: 'Holy Armor',
                cost: 150,
                type: 'skin',
                spriteType: 'paladin',
              ),
            ],
          ),
        );

        final success = tavernNotifier.buyItem(
          'paladin',
          heroNotifier: heroNotifier,
        );

        expect(success, true);
        expect(heroNotifier.state.coins, 50); // 200 - 150
        expect(heroNotifier.state.unlockedSkins.contains('paladin'), true);
      });

      test(
        'Redeeming custom real-life reward deducts coins and increments counter',
        () {
          final heroNotifier = HeroNotifier(const HeroModel(coins: 60));

          final reward = CustomRewardModel(
            id: 'r1',
            title: 'Bubble Tea',
            coinCost: 50,
          );

          final tavernNotifier = TavernNotifier(
            TavernState(customRewards: [reward]),
          );

          final success = tavernNotifier.redeemCustomReward(
            'r1',
            heroNotifier: heroNotifier,
          );

          expect(success, true);
          expect(heroNotifier.state.coins, 10); // 60 - 50
          expect(tavernNotifier.state.customRewards.first.timesRedeemed, 1);

          // Attempt to redeem again with insufficient coins (10 < 50)
          final fail = tavernNotifier.redeemCustomReward(
            'r1',
            heroNotifier: heroNotifier,
          );
          expect(fail, false);
          expect(heroNotifier.state.coins, 10);
        },
      );

      testWidgets(
        'Tavern UI renders shop tabs, shows coin balance, and allows purchase',
        (tester) async {
          final heroNotifier = HeroNotifier(
            const HeroModel(name: 'Arthur', coins: 50),
          );

          final tavernNotifier = TavernNotifier();

          final container = ProviderContainer(
            overrides: [
              heroProvider.overrideWith((ref) => heroNotifier),
              tavernProvider.overrideWith((ref) => tavernNotifier),
            ],
          );

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: const MaterialApp(home: TavernScreen()),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('THE TAVERN'), findsOneWidget);
          expect(find.text('50 COINS'), findsOneWidget);
          expect(find.text('Health Potion'), findsOneWidget);

          // Switch to SKINS tab
          await tester.tap(find.text('SKINS'));
          await tester.pumpAndSettle();

          expect(find.text('Holy Paladin Skin'), findsOneWidget);

          // Switch to REAL REWARDS tab
          await tester.tap(find.text('REAL REWARDS'));
          await tester.pumpAndSettle();

          expect(find.text('1 Delicious Boba Tea'), findsOneWidget);
          expect(find.text('+ REWARD'), findsOneWidget);
        },
      );
    },
  );
}
