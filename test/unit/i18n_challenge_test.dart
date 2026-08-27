import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/i18n/i18n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Adversarial Challenge Suite: i18n & Generator Stress Testing', () {
    // =========================================================================
    // 1. ARB Key Extraction & Multi-Argument Parameter Interpolation
    // =========================================================================
    group('1. Parameter Interpolation Stress & Edge Cases', () {
      test(
        '1.1 Multi-argument interpolation with 2 parameters (chapter, name)',
        () {
          final en = I18n(const Locale('en'));
          final th = I18n(const Locale('th'));

          expect(
            en.dungeon.chapterTitle(1, 'Slime Forest'),
            'Chapter 1: Slime Forest',
          );
          expect(th.dungeon.chapterTitle(1, 'ป่าสไลม์'), 'บทที่ 1: ป่าสไลม์');

          expect(
            en.dungeon.chapterTitle(99, 'Volcano Peak'),
            'Chapter 99: Volcano Peak',
          );
          expect(
            th.dungeon.chapterTitle(99, 'ยอดเขาเปลวเพลิง'),
            'บทที่ 99: ยอดเขาเปลวเพลิง',
          );
        },
      );

      test(
        '1.2 Multi-argument interpolation with 2 parameters (current, max)',
        () {
          final en = I18n(const Locale('en'));
          final th = I18n(const Locale('th'));

          expect(en.general.exp(0, 100), '0/100 EXP');
          expect(th.general.exp(9999, 9999), '9999/9999 EXP');

          expect(en.battleHub.heroHp(1, 100), 'HP: 1/100');
          expect(th.battleHub.heroHp(0, 100), 'พลังชีวิต: 0/100');

          expect(en.battleHub.heroMp(50, 50), 'MP: 50/50');
          expect(th.battleHub.heroMp(0, 50), 'พลังมานา: 0/50');
        },
      );

      test(
        '1.3 Argument with numeric boundary values (0, negative, large numbers, decimals)',
        () {
          final en = I18n(const Locale('en'));
          final th = I18n(const Locale('th'));

          expect(en.battleHub.dealDamage(0), 'Dealt 0 damage!');
          expect(en.battleHub.dealDamage(-50), 'Dealt -50 damage!');
          expect(en.battleHub.dealDamage(999999999), 'Dealt 999999999 damage!');
          expect(en.battleHub.dealDamage(12.345), 'Dealt 12.345 damage!');

          expect(th.battleHub.dealDamage(0), 'สร้างความเสียหาย 0 แต้ม!');
          expect(th.battleHub.dealDamage(-100), 'สร้างความเสียหาย -100 แต้ม!');
        },
      );

      test(
        '1.4 Argument containing special characters and symbols (\$, {}, <>, Thai, emojis)',
        () {
          final en = I18n(const Locale('en'));
          final th = I18n(const Locale('th'));

          expect(
            en.dungeon.chapterTitle(1, '\$pecial & <Tag>'),
            'Chapter 1: \$pecial & <Tag>',
          );
          expect(
            en.dungeon.chapterTitle('X', '⚔️ Dragon\'s Lair 🔥'),
            'Chapter X: ⚔️ Dragon\'s Lair 🔥',
          );
          expect(
            th.dungeon.chapterTitle('๑', 'ป่ามังกร 🐉'),
            'บทที่ ๑: ป่ามังกร 🐉',
          );
          expect(
            en.heroSanctuary.activeSkin('{nested_fake}'),
            'Equipped Skin: {nested_fake}',
          );
        },
      );

      test('1.5 Dynamic translate with parameter map', () {
        final en = I18n(const Locale('en'));
        final th = I18n(const Locale('th'));

        expect(
          en.translate('battle_hub', 'dealDamage', {'damage': 500}),
          'Dealt 500 damage!',
        );
        expect(
          th.translate('battle_hub', 'dealDamage', {'damage': 500}),
          'สร้างความเสียหาย 500 แต้ม!',
        );
        expect(
          en.translate('tavern', 'ownedQuantity', {'count': 10}),
          'Owned: 10',
        );
        expect(
          th.translate('tavern', 'ownedQuantity', {'count': 10}),
          'มีอยู่: 10',
        );
      });

      test(
        '1.6 Extra/unused parameters in parameter map are ignored without error',
        () {
          final en = I18n(const Locale('en'));
          expect(
            en.translate('battle_hub', 'dealDamage', {
              'damage': 100,
              'unused_arg_1': 'ignored',
              'unused_arg_2': 999,
            }),
            'Dealt 100 damage!',
          );
        },
      );
    });

    // =========================================================================
    // 2. Missing Keys & Fallback Mechanics
    // =========================================================================
    group('2. Missing Keys and Fallback Resolution', () {
      test(
        '2.1 Non-existent key in known feature namespace returns raw key name',
        () {
          final en = I18n(const Locale('en'));
          final th = I18n(const Locale('th'));

          expect(
            en.general.lookup('completely_bogus_key'),
            'completely_bogus_key',
          );
          expect(
            th.general.lookup('completely_bogus_key'),
            'completely_bogus_key',
          );
          expect(
            en.battleHub.lookup('missing_strike_key'),
            'missing_strike_key',
          );
          expect(th.tavern.lookup('missing_item_key'), 'missing_item_key');
        },
      );

      test('2.2 Non-existent feature in translate() returns raw key name', () {
        final en = I18n(const Locale('en'));
        expect(en.translate('invalid_feature_name', 'any_key'), 'any_key');
        expect(
          en.translate('unknown_feature', 'some_random_key', {'arg': 123}),
          'some_random_key',
        );
      });

      test(
        '2.3 Lookup with unsupported/unregistered locale falls back to English',
        () {
          final fr = I18n(const Locale('fr'));
          final ja = I18n(const Locale('ja'));
          final de = I18n(const Locale('de'));

          expect(fr.general.appName, 'WorkXP');
          expect(ja.battleHub.title, 'Battle Hub');
          expect(de.tavern.title, 'The Tavern');
          expect(fr.battleHub.dealDamage(77), 'Dealt 77 damage!');
        },
      );

      test('2.4 Lookup with language code only vs language+country code', () {
        final enUS = I18n(const Locale('en', 'US'));
        final enGB = I18n(const Locale('en', 'GB'));
        final thTH = I18n(const Locale('th', 'TH'));

        expect(enUS.general.appName, 'WorkXP');
        expect(enGB.battleHub.title, 'Battle Hub');
        expect(thTH.battleHub.title, 'ศูนย์กลางการต่อสู้');
        expect(thTH.tavern.buyItem(20), 'ซื้อด้วย 20 เหรียญ');
      });
    });

    // =========================================================================
    // 3. Special Characters & Unicode Stress
    // =========================================================================
    group('3. Special Characters & Unicode Stress', () {
      test('3.1 Preserves Thai script diacritics and vowels accurately', () {
        final th = I18n(const Locale('th'));

        expect(
          th.battleHub.ghostStateWarning,
          'ฮีโร่ของคุณพ่ายแพ้ในการรบ! รางวัลลดลง 50% จนกว่าจะฟื้นคืนชีพ',
        );
        expect(
          th.analytics.emptyLogs,
          'ยังไม่มีบันทึกการรบ ทำเควสต์เพื่อดูสถิติวิเคราะห์!',
        );
        expect(th.heroSanctuary.strengthLabel, 'STR (พลังโจมตี)');
        expect(th.heroSanctuary.intelligenceLabel, 'INT (เวทมนตร์และความจำ)');
      });

      test(
        '3.2 Punctuation, brackets, parentheses, colons, and percentages',
        () {
          final en = I18n(const Locale('en'));
          final th = I18n(const Locale('th'));

          expect(
            en.battleHub.ghostStateWarning,
            'Your Hero fell in battle! Gain 50% less rewards until revived.',
          );
          expect(en.heroSanctuary.strengthLabel, 'STR (Physical Attack)');
          expect(en.tavern.redeemReward(100), 'Redeem (100 Coins)');
          expect(th.tavern.redeemReward(100), 'แลกรับ (100 เหรียญ)');
        },
      );
    });

    // =========================================================================
    // 4. Widget Integration, `I18n.of(context)`, and Dynamic Switching
    // =========================================================================
    group('4. Widget Context & Language Switching Delegation', () {
      testWidgets(
        '4.1 I18n.of(context) retrieves correct translations in widget tree',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              locale: const Locale('en'),
              supportedLocales: I18n.supportedLocales,
              localizationsDelegates: const [
                I18n.delegate,
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              home: Builder(
                builder: (context) {
                  final i18n = I18n.of(context);
                  return Scaffold(
                    body: Column(
                      children: [
                        Text(i18n.general.appName),
                        Text(i18n.battleHub.title),
                        Text(i18n.dungeon.chapterTitle(1, 'Slime Forest')),
                      ],
                    ),
                  );
                },
              ),
            ),
          );

          expect(find.text('WorkXP'), findsOneWidget);
          expect(find.text('Battle Hub'), findsOneWidget);
          expect(find.text('Chapter 1: Slime Forest'), findsOneWidget);
        },
      );

      testWidgets(
        '4.2 Dynamic language switching from English to Thai in widget tree',
        (WidgetTester tester) async {
          Locale currentLocale = const Locale('en');

          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                return WidgetsApp(
                  color: const Color(0xFF000000),
                  locale: currentLocale,
                  supportedLocales: I18n.supportedLocales,
                  localizationsDelegates: const [
                    I18n.delegate,
                    DefaultWidgetsLocalizations.delegate,
                  ],
                  pageRouteBuilder: <T>(settings, builder) =>
                      PageRouteBuilder<T>(
                        settings: settings,
                        pageBuilder: (ctx, _, __) => builder(ctx),
                      ),
                  home: Builder(
                    builder: (innerContext) {
                      final i18n = I18n.of(innerContext);
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: [
                            Text('Title: ${i18n.battleHub.title}'),
                            Text('Damage: ${i18n.battleHub.dealDamage(99)}'),
                            GestureDetector(
                              key: const ValueKey('switch_btn'),
                              onTap: () {
                                setState(() {
                                  currentLocale = const Locale('th');
                                });
                              },
                              child: const Text('Switch to Thai'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );

          // English initial state
          expect(find.text('Title: Battle Hub'), findsOneWidget);
          expect(find.text('Damage: Dealt 99 damage!'), findsOneWidget);

          // Tap switch button
          await tester.tap(find.byKey(const ValueKey('switch_btn')));
          await tester.pumpAndSettle();

          // Thai updated state
          expect(find.text('Title: ศูนย์กลางการต่อสู้'), findsOneWidget);
          expect(
            find.text('Damage: สร้างความเสียหาย 99 แต้ม!'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        '4.3 I18n.of(context) fallback when Localizations widget is missing',
        (WidgetTester tester) async {
          late I18n capturedI18n;

          // Build widget WITHOUT Localizations widget in tree
          await tester.pumpWidget(
            Builder(
              builder: (context) {
                capturedI18n = I18n.of(context);
                return const SizedBox();
              },
            ),
          );

          // Must safely fallback to default 'en' instance without crashing
          expect(capturedI18n, isNotNull);
          expect(capturedI18n.locale.languageCode, 'en');
          expect(capturedI18n.general.appName, 'WorkXP');
        },
      );

      testWidgets(
        '4.4 I18n.maybeOf(context) returns null when Localizations is missing',
        (WidgetTester tester) async {
          I18n? capturedI18n;

          await tester.pumpWidget(
            Builder(
              builder: (context) {
                capturedI18n = I18n.maybeOf(context);
                return const SizedBox();
              },
            ),
          );

          expect(capturedI18n, isNull);
        },
      );

      test('4.5 _I18nDelegate lifecycle and contracts', () async {
        const delegate = I18n.delegate;

        expect(delegate.isSupported(const Locale('en')), isTrue);
        expect(delegate.isSupported(const Locale('th')), isTrue);
        expect(delegate.isSupported(const Locale('es')), isFalse);
        expect(delegate.isSupported(const Locale('zh')), isFalse);

        final loadedEn = await delegate.load(const Locale('en'));
        expect(loadedEn.locale.languageCode, 'en');
        expect(loadedEn.general.appName, 'WorkXP');

        final loadedTh = await delegate.load(const Locale('th'));
        expect(loadedTh.locale.languageCode, 'th');
        expect(loadedTh.battleHub.title, 'ศูนย์กลางการต่อสู้');

        expect(delegate.shouldReload(delegate), isFalse);
      });
    });
  });
}
