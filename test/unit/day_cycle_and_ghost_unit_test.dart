import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/core/services/day_cycle_service.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1 Unit Test: Daily Quests, Midnight Reset & Ghost State', () {
    test(
      '1. Completing a Daily Quest awards +30 EXP, +15 Coins, and increments streak counter',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 10, currentExp: 0),
        );

        final daily = DailyQuestModel(
          id: 'd_stretch',
          title: 'Morning Stretch',
          streak: 3,
        );
        final dailyNotifier = DailyQuestNotifier([daily]);

        dailyNotifier.toggleDailyQuest('d_stretch', heroNotifier: heroNotifier);

        expect(dailyNotifier.state.first.isCompletedToday, isTrue);
        expect(dailyNotifier.state.first.streak, 4);
        expect(heroNotifier.state.currentExp, 30);
        expect(
          heroNotifier.state.coins,
          50,
        ); // 10 + 15 + 25 (only 1 daily in list, so allDone triggered!)
      },
    );

    test(
      '2. All-Done Daily Bonus grants +25 Coins bonus chest when all active dailies are fulfilled',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(coins: 10, currentExp: 0),
        );

        final daily1 = DailyQuestModel(id: 'd1', title: 'Daily 1', streak: 1);
        final daily2 = DailyQuestModel(id: 'd2', title: 'Daily 2', streak: 2);
        final dailyNotifier = DailyQuestNotifier([daily1, daily2]);

        // Complete Daily 1 (not all done yet)
        dailyNotifier.toggleDailyQuest('d1', heroNotifier: heroNotifier);
        expect(heroNotifier.state.coins, 25); // 10 + 15

        // Complete Daily 2 (all done -> +15 + 25 bonus chest)
        dailyNotifier.toggleDailyQuest('d2', heroNotifier: heroNotifier);
        expect(heroNotifier.state.coins, 65); // 25 + 15 + 25
        expect(heroNotifier.state.currentExp, 60); // 30 + 30
      },
    );

    test(
      '3. Unchecking a completed Daily Quest decrements streak without going below 0',
      () {
        final heroNotifier = HeroNotifier(const HeroModel());

        final daily = DailyQuestModel(
          id: 'd_test',
          title: 'Exercise',
          streak: 5,
          isCompletedToday: true,
        );

        final dailyNotifier = DailyQuestNotifier([daily]);

        // Toggle off
        dailyNotifier.toggleDailyQuest('d_test', heroNotifier: heroNotifier);

        expect(dailyNotifier.state.first.isCompletedToday, isFalse);
        expect(dailyNotifier.state.first.streak, 4);

        // Multiple unchecks with 0 streak
        final dailyZero = DailyQuestModel(
          id: 'd_zero',
          title: 'Zero',
          streak: 0,
          isCompletedToday: true,
        );
        final dailyNotifierZero = DailyQuestNotifier([dailyZero]);
        dailyNotifierZero.toggleDailyQuest(
          'd_zero',
          heroNotifier: heroNotifier,
        );
        expect(dailyNotifierZero.state.first.streak, 0);
      },
    );

    test(
      '4. DayCycleService calculates 15 HP counter-damage per missed daily across day boundary',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(currentHp: 100));

        final daily1 = DailyQuestModel(
          id: 'd1',
          title: 'Task 1',
          isCompletedToday: false,
        );
        final daily2 = DailyQuestModel(
          id: 'd2',
          title: 'Task 2',
          isCompletedToday: true,
        );
        final daily3 = DailyQuestModel(
          id: 'd3',
          title: 'Task 3',
          isCompletedToday: false,
        );

        final yesterday = DateTime(2026, 8, 25);
        final today = DateTime(2026, 8, 26);

        final result = DayCycleService.instance.processDayReset(
          lastActiveDate: yesterday,
          currentDate: today,
          dailies: [daily1, daily2, daily3],
          heroNotifier: heroNotifier,
        );

        expect(result.dayChanged, isTrue);
        expect(result.incompleteDailiesCount, 2);
        expect(result.counterDamageDealt, 30); // 2 * 15
        expect(result.isGhostStateTriggered, isFalse);
        expect(heroNotifier.state.currentHp, 70); // 100 - 30
      },
    );

    test(
      '5. DayCycleService does not trigger reset or damage on same calendar day',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(currentHp: 100));
        final daily = DailyQuestModel(
          id: 'd1',
          title: 'Task',
          isCompletedToday: false,
        );

        final timeA = DateTime(2026, 8, 26, 10, 0);
        final timeB = DateTime(2026, 8, 26, 18, 30);

        final result = DayCycleService.instance.processDayReset(
          lastActiveDate: timeA,
          currentDate: timeB,
          dailies: [daily],
          heroNotifier: heroNotifier,
        );

        expect(result.dayChanged, isFalse);
        expect(result.counterDamageDealt, 0);
        expect(heroNotifier.state.currentHp, 100);
      },
    );

    test(
      '6. Streak Shield and Boss Stun immunities negate all midnight counter-damage',
      () {
        final heroNotifier = HeroNotifier(const HeroModel(currentHp: 80));
        final daily = DailyQuestModel(
          id: 'd1',
          title: 'Task',
          isCompletedToday: false,
        );

        final yesterday = DateTime(2026, 8, 25);
        final today = DateTime(2026, 8, 26);

        // Streak shield active
        final shieldResult = DayCycleService.instance.processDayReset(
          lastActiveDate: yesterday,
          currentDate: today,
          dailies: [daily],
          heroNotifier: heroNotifier,
          isStreakShieldActive: true,
        );
        expect(shieldResult.counterDamageDealt, 0);
        expect(heroNotifier.state.currentHp, 80);

        // Boss Stun active
        final stunResult = DayCycleService.instance.processDayReset(
          lastActiveDate: yesterday,
          currentDate: today,
          dailies: [daily],
          heroNotifier: heroNotifier,
          isBossStunActive: true,
        );
        expect(stunResult.counterDamageDealt, 0);
        expect(heroNotifier.state.currentHp, 80);
      },
    );

    test(
      '7. Hero entering Ghost State (0 HP) suspends all EXP and Coin gains',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(currentHp: 15, currentExp: 20, coins: 50),
        );

        // Take 15 damage -> HP drops to 0 -> Ghost State
        heroNotifier.takeDamage(15);
        expect(heroNotifier.state.currentHp, 0);
        expect(heroNotifier.state.isGhost, isTrue);

        // Attempt gaining EXP and Coins while in Ghost State
        heroNotifier.gainExp(100);
        heroNotifier.gainCoins(100);

        expect(heroNotifier.state.currentExp, 20); // Unchanged
        expect(heroNotifier.state.coins, 50); // Unchanged
      },
    );

    test(
      '8. Revival Quest emergency action restores 50% HP (50 HP) and clears Ghost State',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            currentHp: 0,
            isGhost: true,
            currentExp: 0,
            coins: 10,
          ),
        );

        heroNotifier.reviveHero();

        expect(heroNotifier.state.isGhost, isFalse);
        expect(heroNotifier.state.currentHp, 50); // 50% of 100

        // Progression is restored
        heroNotifier.gainExp(50);
        heroNotifier.gainCoins(20);
        expect(heroNotifier.state.currentExp, 50);
        expect(heroNotifier.state.coins, 30);
      },
    );

    test(
      '9. Elixir of Life item consumption resurrects Hero with 100% HP (100 HP)',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(currentHp: 0, isGhost: true),
        );

        final tavernNotifier = TavernNotifier(
          const TavernState(
            inventory: [
              InventoryItemModel(
                tavernItemId: 'item_elixir_life',
                name: 'Elixir of Life',
                description: 'Resurrects with 100% HP',
                spriteType: 'elixir_life',
                quantity: 1,
              ),
            ],
          ),
        );

        final used = tavernNotifier.useConsumable(
          'item_elixir_life',
          heroNotifier: heroNotifier,
        );

        expect(used, isTrue);
        expect(heroNotifier.state.isGhost, isFalse);
        expect(heroNotifier.state.currentHp, 100);
        expect(tavernNotifier.state.inventory.isEmpty, isTrue);
      },
    );
  });
}
