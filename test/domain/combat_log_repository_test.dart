import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';

void main() {
  late AppDatabase db;
  late CombatLogRepository logRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    logRepo = CombatLogRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('CombatLogRepository Tests', () {
    test(
      '1. addLog creates entries and watchCombatLogs emits in descending order',
      () async {
        final initialLogs = await logRepo.getRecentLogs();
        expect(initialLogs.length, equals(0));

        final log1 = await logRepo.addLog(
          text: 'Arthur struck King Slime for 50 damage!',
          damage: 50,
          isCritical: false,
          timestamp: DateTime.now().subtract(const Duration(seconds: 5)),
        );
        expect(
          log1.textContent,
          equals('Arthur struck King Slime for 50 damage!'),
        );

        final log2 = await logRepo.addLog(
          text: 'CRITICAL HIT! Arthur struck King Slime for 250 damage!',
          damage: 250,
          isCritical: true,
          timestamp: DateTime.now(),
        );
        expect(log2.isCritical, isTrue);

        final logs = await logRepo.watchCombatLogs().first;
        expect(logs.length, equals(2));
        expect(logs.first.id, equals(log2.id)); // Most recent first
      },
    );

    test('2. clearLogs deletes all entries', () async {
      await logRepo.addLog(text: 'Log 1');
      await logRepo.addLog(text: 'Log 2');
      var logs = await logRepo.getRecentLogs();
      expect(logs.length, equals(2));

      await logRepo.clearLogs();
      logs = await logRepo.getRecentLogs();
      expect(logs.length, equals(0));
    });
  });
}
