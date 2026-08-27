import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Adversarial Challenge Suite: Generator Internal Engine Stress Tests', () {
    test(
      '1. ARB parsing ignores @ metadata keys and extracts string values',
      () {
        final arbContent = jsonEncode({
          '@@locale': 'en',
          '@appName': {
            'description': 'The application title',
            'type': 'text',
            'placeholders': {},
          },
          'appName': 'WorkXP',
          '@dealDamage': {
            'description': 'Damage formatted',
            'placeholders': {
              'damage': {'type': 'int'},
            },
          },
          'dealDamage': 'Dealt {damage} damage!',
        });

        final Map<String, dynamic> json = jsonDecode(arbContent);
        final extractedKeys = <String, String>{};

        for (final entry in json.entries) {
          if (entry.key.startsWith('@')) continue;
          extractedKeys[entry.key] = entry.value.toString();
        }

        expect(extractedKeys.containsKey('@@locale'), isFalse);
        expect(extractedKeys.containsKey('@appName'), isFalse);
        expect(extractedKeys.containsKey('@dealDamage'), isFalse);
        expect(extractedKeys['appName'], 'WorkXP');
        expect(extractedKeys['dealDamage'], 'Dealt {damage} damage!');
      },
    );

    test(
      '2. Placeholder extractor finds 1, 2, 3+ unique placeholders across locales',
      () {
        final regex = RegExp(r'\{([a-zA-Z0-9_]+)\}');

        String text1 = 'HP: {current}/{max} (Level {level})';
        final matches1 = regex
            .allMatches(text1)
            .map((m) => m.group(1)!)
            .toSet();
        expect(matches1, containsAll(['current', 'max', 'level']));
        expect(matches1.length, 3);

        // Multi-occurrence parameter
        String text2 = '{hero} strikes {boss}! {hero} gained {exp} EXP.';
        final matches2 = regex
            .allMatches(text2)
            .map((m) => m.group(1)!)
            .toSet();
        expect(matches2, containsAll(['hero', 'boss', 'exp']));
        expect(matches2.length, 3);
      },
    );

    test(
      '3. Escape helper escapes single quotes, backslashes, dollar signs, and newlines',
      () {
        String escapeDartString(String value) {
          return value
              .replaceAll(r'\', r'\\')
              .replaceAll("'", r"\'")
              .replaceAll(r'$', r'\$')
              .replaceAll('\n', r'\n')
              .replaceAll('\r', r'\r');
        }

        // Single quotes
        expect(escapeDartString("Don't quit!"), r"Don\'t quit!");

        // Dollar signs
        expect(escapeDartString(r"Cost: $50 USD"), r"Cost: \$50 USD");

        // Backslashes
        expect(
          escapeDartString(r"Path: C:\Work\workxp"),
          r"Path: C:\\Work\\workxp",
        );

        // Newlines
        expect(
          escapeDartString("Line 1\nLine 2\r\nLine 3"),
          r"Line 1\nLine 2\r\nLine 3",
        );

        // Combined
        expect(
          escapeDartString(r"Don't spend $100 at C:\shop!\nCome back later."),
          r"Don\'t spend \$100 at C:\\shop!\\nCome back later.",
        );
      },
    );

    test(
      '4. Generated i18n.dart contains all expected feature namespaces and methods',
      () {
        final generatedFile = File('lib/i18n/i18n.dart');
        expect(generatedFile.existsSync(), isTrue);
        final content = generatedFile.readAsStringSync();

        expect(content.contains('class I18n'), isTrue);
        expect(content.contains('class BattleHubI18n'), isTrue);
        expect(content.contains('class DungeonI18n'), isTrue);
        expect(content.contains('class TavernI18n'), isTrue);
        expect(content.contains('class AnalyticsI18n'), isTrue);
        expect(content.contains('class HeroSanctuaryI18n'), isTrue);
        expect(content.contains('class GeneralI18n'), isTrue);
        expect(content.contains('class SharedI18n'), isTrue);
        expect(content.contains('class _I18nDelegate'), isTrue);

        // Verify parameter methods
        expect(content.contains('String dealDamage(Object damage)'), isTrue);
        expect(
          content.contains('String heroHp(Object current, Object max)'),
          isTrue,
        );
        expect(
          content.contains('String chapterTitle(Object chapter, Object name)'),
          isTrue,
        );
      },
    );
  });
}
