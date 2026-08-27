import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class CombatLogRepository {
  Stream<List<CombatLog>> watchCombatLogs({int limit = 50});
  Future<List<CombatLog>> getRecentLogs({int limit = 50});
  Future<CombatLog> addLog({
    required String text,
    int damage = 0,
    bool isCritical = false,
    DateTime? timestamp,
    String? id,
  });
  Future<void> clearLogs();
}

class CombatLogRepositoryImpl implements CombatLogRepository {
  CombatLogRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<CombatLog>> watchCombatLogs({int limit = 50}) {
    return (_db.select(_db.combatLogs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
          ..limit(limit))
        .watch();
  }

  @override
  Future<List<CombatLog>> getRecentLogs({int limit = 50}) async {
    return (_db.select(_db.combatLogs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
          ..limit(limit))
        .get();
  }

  @override
  Future<CombatLog> addLog({
    required String text,
    int damage = 0,
    bool isCritical = false,
    DateTime? timestamp,
    String? id,
  }) async {
    final logId = id ?? const Uuid().v4();
    final companion = CombatLogsCompanion.insert(
      id: logId,
      textContent: text,
      damage: Value(damage),
      isCritical: Value(isCritical),
      timestamp: Value(timestamp ?? DateTime.now()),
    );

    await _db.into(_db.combatLogs).insert(companion);
    return (await (_db.select(
      _db.combatLogs,
    )..where((tbl) => tbl.id.equals(logId))).getSingle());
  }

  @override
  Future<void> clearLogs() async {
    await _db.delete(_db.combatLogs).go();
  }
}
