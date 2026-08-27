import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/i18n/i18n.dart';

void main() {
  group('M1: i18n Localization Unit Tests', () {
    test('1. English localization returns correct values and placeholders', () {
      final i18n = I18n(const Locale('en'));

      expect(i18n.general.appName, 'WorkXP');
      expect(i18n.general.level(5), 'Level 5');
      expect(i18n.general.coins(100), '100 Coins');
      expect(i18n.general.exp(50, 100), '50/100 EXP');

      expect(i18n.battleHub.title, 'Battle Hub');
      expect(i18n.battleHub.dealDamage(42), 'Dealt 42 damage!');
      expect(i18n.battleHub.heroHp(80, 100), 'HP: 80/100');

      expect(i18n.dungeon.title, 'World Map');
      expect(
        i18n.dungeon.chapterTitle(1, 'Slime Forest'),
        'Chapter 1: Slime Forest',
      );

      expect(i18n.tavern.title, 'The Tavern');
      expect(i18n.tavern.buyItem(50), 'Buy for 50 Coins');

      expect(i18n.analytics.title, 'Hall of Fame');
      expect(i18n.heroSanctuary.title, 'Hero Sanctuary');
      expect(i18n.heroSanctuary.unallocatedPoints(3), 'Unspent Points: 3');

      expect(i18n.shared.navBattle, 'Battle');
    });

    test(
      '2. Thai localization returns accurate Thai translations and formatted placeholders',
      () {
        final i18n = I18n(const Locale('th'));

        expect(i18n.general.appName, 'WorkXP');
        expect(i18n.general.level(5), 'เลเวล 5');
        expect(i18n.general.coins(100), '100 เหรียญ');

        expect(i18n.battleHub.title, 'ศูนย์กลางการต่อสู้');
        expect(i18n.battleHub.dealDamage(42), 'สร้างความเสียหาย 42 แต้ม!');

        expect(i18n.dungeon.title, 'แผนที่โลก');
        expect(
          i18n.dungeon.chapterTitle(2, 'ป้อมก๊อบลิน'),
          'บทที่ 2: ป้อมก๊อบลิน',
        );

        expect(i18n.tavern.title, 'โรงเตี๊ยม');
        expect(i18n.tavern.buyItem(50), 'ซื้อด้วย 50 เหรียญ');

        expect(i18n.analytics.title, 'หอเกียรติยศ');
        expect(i18n.heroSanctuary.title, 'วิหารฮีโร่');
        expect(i18n.heroSanctuary.unallocatedPoints(3), 'แต้มคงเหลือ: 3');

        expect(i18n.shared.navBattle, 'การรบ');
      },
    );

    test('3. Dynamic translate lookup works across namespaces', () {
      final i18n = I18n(const Locale('en'));

      expect(i18n.translate('battle_hub', 'title'), 'Battle Hub');
      expect(
        i18n.translate('battle_hub', 'dealDamage', {'damage': 99}),
        'Dealt 99 damage!',
      );
      expect(i18n.translate('dungeon', 'chapter1Name'), 'Slime Forest');
      expect(
        i18n.translate('tavern', 'insufficientCoins'),
        'Not enough Coins!',
      );
      expect(i18n.translate('unknown_feature', 'some_key'), 'some_key');
    });

    test('4. I18nDelegate supports en and th', () {
      const delegate = I18n.delegate;

      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('th')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isFalse);
    });
  });
}
