import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1 Unit Test: Hero Progression & Leveling Math', () {
    test(
      '1. EXP target progression formula calculates exact exponential thresholds',
      () {
        // Level 1 target = 100
        expect(HeroModel.expTargetForLevel(0), 100);
        expect(HeroModel.expTargetForLevel(1), 100);
        // Level 2 target = floor(100 * 1.25^1) = 125
        expect(HeroModel.expTargetForLevel(2), 125);
        // Level 3 target = floor(100 * 1.25^2) = 156
        expect(HeroModel.expTargetForLevel(3), 156);
        // Level 4 target = floor(100 * 1.25^3) = 195
        expect(HeroModel.expTargetForLevel(4), 195);
        // Level 5 target = floor(100 * 1.25^4) = 244
        expect(HeroModel.expTargetForLevel(5), 244);
      },
    );

    test(
      '2. Single Level Up increases level, grants +3 unallocated points, and fully refills HP/MP',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            name: 'Arthur',
            level: 1,
            currentExp: 0,
            currentHp: 40,
            maxHp: 100,
            currentMp: 20,
            maxMp: 100,
            unallocatedPoints: 0,
          ),
        );

        // Gain 100 EXP (exactly hits Level 1 target)
        heroNotifier.gainExp(100);

        final state = heroNotifier.state;
        expect(state.level, 2);
        expect(state.currentExp, 0);
        expect(state.unallocatedPoints, 3);
        expect(state.currentHp, 100);
        expect(state.currentMp, 100);
      },
    );

    test(
      '3. Level up with remainder EXP correctly carries over excess points',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(level: 1, currentExp: 20, unallocatedPoints: 1),
        );

        // 20 + 130 = 150 EXP -> 100 consumed for level 2, 50 left over
        heroNotifier.gainExp(130);

        expect(heroNotifier.state.level, 2);
        expect(heroNotifier.state.currentExp, 50);
        expect(heroNotifier.state.unallocatedPoints, 4); // 1 + 3
      },
    );

    test(
      '4. Stat point allocation increases chosen attribute and decrements unallocated points',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            str: 5,
            intel: 5,
            agi: 5,
            vit: 5,
            wis: 5,
            unallocatedPoints: 5,
          ),
        );

        expect(heroNotifier.allocateStatPoint('STR'), isTrue);
        expect(heroNotifier.allocateStatPoint('INT'), isTrue);
        expect(heroNotifier.allocateStatPoint('AGI'), isTrue);
        expect(heroNotifier.allocateStatPoint('VIT'), isTrue);
        expect(heroNotifier.allocateStatPoint('WIS'), isTrue);

        final state = heroNotifier.state;
        expect(state.str, 6);
        expect(state.intel, 6);
        expect(state.agi, 6);
        expect(state.vit, 6);
        expect(state.wis, 6);
        expect(state.unallocatedPoints, 0);

        // Attempt allocation when points are exhausted
        expect(heroNotifier.allocateStatPoint('STR'), isFalse);
        expect(heroNotifier.state.str, 6);
      },
    );

    test('5. Dynamic Title milestones unlock upon stat and level thresholds', () {
      final heroNotifier = HeroNotifier(
        const HeroModel(
          level: 1,
          str: 9,
          intel: 19,
          unallocatedPoints: 5,
          unlockedTitles: ['Novice Adventurer'],
        ),
      );

      // Allocating STR from 9 -> 10 unlocks Iron Knight
      heroNotifier.allocateStatPoint('STR');
      expect(heroNotifier.state.unlockedTitles.contains('Iron Knight'), isTrue);

      // Allocating INT from 19 -> 20 unlocks Archmage Scholar
      heroNotifier.allocateStatPoint('INT');
      expect(
        heroNotifier.state.unlockedTitles.contains('Archmage Scholar'),
        isTrue,
      );

      // Gaining EXP to hit Level 5 unlocks Seasoned Veteran
      // Lvl 1->2 (100), Lvl 2->3 (125), Lvl 3->4 (156), Lvl 4->5 (195) = 576 total
      heroNotifier.gainExp(600);
      expect(heroNotifier.state.level >= 5, isTrue);
      expect(
        heroNotifier.state.unlockedTitles.contains('Seasoned Veteran'),
        isTrue,
      );
    });

    test(
      '6. Avatar skin and Title equipping updates active cosmetic identifiers',
      () {
        final heroNotifier = HeroNotifier(
          const HeroModel(
            activeSkinId: 'hero_novice',
            activeTitleId: 'Novice Adventurer',
            unlockedSkins: ['hero_novice', 'paladin', 'dark_knight'],
            unlockedTitles: ['Novice Adventurer', 'Iron Knight'],
          ),
        );

        expect(heroNotifier.setActiveSkin('paladin'), isTrue);
        expect(heroNotifier.state.activeSkinId, 'paladin');

        expect(heroNotifier.setActiveTitle('Iron Knight'), isTrue);
        expect(heroNotifier.state.activeTitleId, 'Iron Knight');

        // Attempt to equip locked skin or title
        expect(heroNotifier.setActiveSkin('archmage'), isFalse);
        expect(heroNotifier.state.activeSkinId, 'paladin');

        expect(heroNotifier.setActiveTitle('Titan Berserker'), isFalse);
        expect(heroNotifier.state.activeTitleId, 'Iron Knight');
      },
    );

    test(
      '7. Combat damage bonus scaling formula matches (STR * 2) + (AGI * 1)',
      () {
        const heroA = HeroModel(str: 5, agi: 5);
        expect(heroA.combatDamageBonus, 15); // (5 * 2) + (5 * 1)

        const heroB = HeroModel(str: 14, agi: 8);
        expect(heroB.combatDamageBonus, 36); // (14 * 2) + (8 * 1)

        const heroC = HeroModel(str: 25, agi: 12);
        expect(heroC.combatDamageBonus, 62); // (25 * 2) + (12 * 1)
      },
    );
  });
}
