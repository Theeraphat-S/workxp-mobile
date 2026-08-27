import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/tavern_repository.dart';

void main() {
  late AppDatabase db;
  late TavernRepository tavernRepo;
  late HeroRepository heroRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tavernRepo = TavernRepositoryImpl(db);
    heroRepo = HeroRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TavernRepository Tests', () {
    test(
      '1. watchCatalog and watchCustomRewards separate shop categories',
      () async {
        final catalog = await tavernRepo.getCatalog();
        expect(
          catalog.length,
          equals(10),
        ); // 4 consumables + 4 skins + 2 themes

        final customRewards = await tavernRepo.getCustomRewards();
        expect(customRewards.length, equals(2)); // Boba + Gaming
      },
    );

    test('2. purchaseItem fails when Hero has insufficient coins', () async {
      // Starter hero Arthur has 0 coins. Health potion costs 25 coins.
      final result = await tavernRepo.purchaseItem('item_potion_health');
      expect(result, isFalse);

      final item = await tavernRepo.getItem('item_potion_health');
      expect(item!.quantity, equals(0));
    });

    test(
      '3. purchaseItem consumable deducts coins and increments quantity',
      () async {
        // Grant 100 coins to Hero
        await heroRepo.gainCoins(100);

        // Purchase Health Potion (cost: 25)
        final purchaseSuccess = await tavernRepo.purchaseItem(
          'item_potion_health',
        );
        expect(purchaseSuccess, isTrue);

        final hero = await heroRepo.getHero();
        expect(hero!.coins, equals(75));

        final item = await tavernRepo.getItem('item_potion_health');
        expect(item!.quantity, equals(1));
      },
    );

    test('4. purchaseItem cosmetic skin marks isPurchased = true', () async {
      await heroRepo.gainCoins(200);

      final purchaseSuccess = await tavernRepo.purchaseItem('paladin');
      expect(purchaseSuccess, isTrue);

      final hero = await heroRepo.getHero();
      expect(hero!.coins, equals(50)); // 200 - 150

      final paladin = await tavernRepo.getItem('paladin');
      expect(paladin!.isPurchased, isTrue);
      expect(paladin.quantity, equals(1));
    });

    test('5. custom rewards CRUD and coin redemption', () async {
      // Create new custom reward
      final newReward = await tavernRepo.createCustomReward(
        name: '1 Slice of Pizza',
        cost: 30,
        description: 'Cheesy reward',
        iconAsset: 'local_pizza',
      );
      expect(newReward.name, equals('1 Slice of Pizza'));
      expect(newReward.category, equals('custom_reward'));

      // Redeem custom reward (Hero needs coins)
      await heroRepo.gainCoins(50);
      final redeemSuccess = await tavernRepo.redeemCustomReward(newReward.id);
      expect(redeemSuccess, isTrue);

      final hero = await heroRepo.getHero();
      expect(hero!.coins, equals(20)); // 50 - 30

      final redeemedItem = await tavernRepo.getItem(newReward.id);
      expect(redeemedItem!.quantity, equals(1)); // timesRedeemed

      // Delete custom reward
      await tavernRepo.deleteCustomReward(newReward.id);
      final deleted = await tavernRepo.getItem(newReward.id);
      expect(deleted, isNull);
    });

    test('6. useConsumable heals HP and decrements quantity', () async {
      await heroRepo.gainCoins(100);
      await tavernRepo.purchaseItem('item_potion_health'); // quantity: 1
      await heroRepo.takeDamage(70); // HP: 30

      final useSuccess = await tavernRepo.useConsumable('item_potion_health');
      expect(useSuccess, isTrue);

      final hero = await heroRepo.getHero();
      expect(hero!.hp, equals(80)); // 30 + 50

      final item = await tavernRepo.getItem('item_potion_health');
      expect(item!.quantity, equals(0));
    });
  });
}
