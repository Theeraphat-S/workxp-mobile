import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/i18n/i18n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1 Unit Test: Feature-Divided Multi-Language Localization (i18n)', () {
    test('1. Supported Locales include English (en) and Thai (th)', () {
      expect(I18n.supportedLocales, contains(const Locale('en')));
      expect(I18n.supportedLocales, contains(const Locale('th')));
      expect(I18n.supportedLocales.length, 2);
    });

    test(
      '2. English dictionary resolves correct feature namespaces and keys',
      () {
        final i18n = I18n(const Locale('en'));

        expect(i18n.general.appName, 'WorkXP');
        expect(i18n.battleHub.title, 'Battle Hub');
        expect(i18n.battleHub.bossFight, 'Boss Encounter');
        expect(i18n.battleHub.ghostStateTitle, 'GHOST STATE');
        expect(i18n.dungeon.title, 'World Map');
        expect(i18n.tavern.title, 'The Tavern');
        expect(i18n.heroSanctuary.title, 'Hero Sanctuary');
        expect(i18n.analytics.title, 'Hall of Fame');
        expect(i18n.shared.navBattle, 'Battle');
      },
    );

    test(
      '3. Thai dictionary resolves accurate Thai translations for all game features',
      () {
        final i18n = I18n(const Locale('th'));

        expect(i18n.general.appName, 'WorkXP');
        expect(i18n.battleHub.title, 'ศูนย์กลางการต่อสู้');
        expect(i18n.battleHub.ghostStateTitle, 'สถานะวิญญาณ');
        expect(i18n.dungeon.title, 'แผนที่โลก');
        expect(i18n.dungeon.chapter1Name, 'ป่าสไลม์');
        expect(i18n.tavern.title, 'โรงเตี๊ยม');
        expect(i18n.heroSanctuary.title, 'วิหารฮีโร่');
        expect(i18n.analytics.title, 'หอเกียรติยศ');
        expect(i18n.shared.navBattle, 'การรบ');
      },
    );

    test(
      '4. Dynamic parameter interpolation replaces template variables correctly',
      () {
        final i18nEn = I18n(const Locale('en'));
        final i18nTh = I18n(const Locale('th'));

        // Parameterized damage string
        expect(i18nEn.battleHub.dealDamage(125), 'Dealt 125 damage!');
        expect(i18nTh.battleHub.dealDamage(125), 'สร้างความเสียหาย 125 แต้ม!');

        // Parameterized HP vitals
        expect(i18nEn.battleHub.heroHp(50, 100), 'HP: 50/100');
        expect(i18nTh.battleHub.heroHp(50, 100), 'พลังชีวิต: 50/100');

        // Parameterized Chapter Title
        expect(
          i18nEn.dungeon.chapterTitle(1, 'Slime Forest'),
          'Chapter 1: Slime Forest',
        );
        expect(i18nTh.dungeon.chapterTitle(1, 'ป่าสไลม์'), 'บทที่ 1: ป่าสไลม์');
      },
    );

    test(
      '5. Dynamic translate helper method resolves keys across feature namespaces',
      () {
        final i18n = I18n(const Locale('en'));

        expect(i18n.translate('battle_hub', 'title'), 'Battle Hub');
        expect(i18n.translate('dungeon', 'chapter2Name'), 'Goblin Keep');
        expect(
          i18n.translate('tavern', 'insufficientCoins'),
          'Not enough Coins!',
        );
        expect(
          i18n.translate('hero_sanctuary', 'soundEffects'),
          'Sound Effects',
        );
        expect(i18n.translate('general', 'level', {'level': 5}), 'Level 5');
      },
    );

    test(
      '6. Missing or fallback key lookup gracefully returns the default key name',
      () {
        final i18n = I18n(const Locale('en'));

        expect(
          i18n.translate('unknown_feature', 'non_existent_key'),
          'non_existent_key',
        );
        expect(i18n.general.lookup('untranslated_key'), 'untranslated_key');
      },
    );
  });
}
