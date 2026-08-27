import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/tavern_repository.dart';
import 'package:workxp/feature/tavern/bloc/tavern_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late TavernRepository tavernRepo;
  late HeroRepository heroRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedStarterKit();
    tavernRepo = TavernRepositoryImpl(db);
    heroRepo = HeroRepositoryImpl(db);

    // Give hero 200 coins for testing purchases
    await heroRepo.gainCoins(200);
  });

  tearDown(() async {
    await db.close();
  });

  group('Tavern Feature Slice BLoC Unit Tests', () {
    test('1. Purchases consumable potion and uses it to restore HP', () async {
      final bloc = TavernBloc(
        tavernRepository: tavernRepo,
        heroRepository: heroRepo,
      );
      bloc.add(const LoadTavern());

      await expectLater(
        bloc.stream,
        emitsThrough(isA<TavernLoaded>().having(
          (s) => s.catalog.isNotEmpty,
          'hasCatalog',
          true,
        )),
      );

      // Hero takes damage
      await heroRepo.takeDamage(40);
      var hero = await heroRepo.getHero();
      expect(hero?.hp, 60);

      // Buy Health Potion (item_potion_health)
      bloc.add(const PurchaseItem('item_potion_health'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<TavernLoaded>().having(
          (s) => s.inventory.any((i) => i.id == 'item_potion_health' && i.quantity > 0),
          'inInventory',
          true,
        )),
      );

      // Use Health Potion
      bloc.add(const UseConsumableItem('item_potion_health'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<TavernLoaded>()),
      );

      hero = await heroRepo.getHero();
      expect(hero?.hp, greaterThan(60));

      await bloc.close();
    });

    test('2. Creates custom real-life reward and redeems it with coins', () async {
      final bloc = TavernBloc(
        tavernRepository: tavernRepo,
        heroRepository: heroRepo,
      );
      bloc.add(const LoadTavern());

      await expectLater(
        bloc.stream,
        emitsThrough(isA<TavernLoaded>()),
      );

      // Create custom reward
      bloc.add(const CreateCustomRewardEvent(
        name: '30 Mins Gaming',
        description: 'Take a guilt-free break',
        cost: 50,
      ));

      await expectLater(
        bloc.stream,
        emitsThrough(isA<TavernLoaded>().having(
          (s) => s.customRewards.any((r) => r.name == '30 Mins Gaming'),
          'rewardCreated',
          true,
        )),
      );

      final reward = (bloc.state as TavernLoaded)
          .customRewards
          .firstWhere((r) => r.name == '30 Mins Gaming');

      // Redeem custom reward
      bloc.add(RedeemCustomRewardEvent(reward.id));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<TavernLoaded>()),
      );

      final updatedHero = await heroRepo.getHero();
      expect(updatedHero?.coins, lessThan(200));

      await bloc.close();
    });
  });
}
