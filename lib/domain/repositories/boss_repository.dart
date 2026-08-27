import 'dart:math';
import 'package:drift/drift.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class BossRepository {
  Stream<Boss?> watchActiveBoss();
  Stream<List<Boss>> watchAllBosses();
  Future<Boss?> getActiveBoss();
  Future<Boss?> getBossByChapter(int chapter);
  Future<void> applyDamage(int damage, {String? bossId});
  Future<Boss?> advanceToNextBoss();
  Future<void> selectActiveChapter(int chapter);
  Future<void> resetBoss(String bossId);
}

class BossRepositoryImpl implements BossRepository {
  BossRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<Boss?> watchActiveBoss() {
    return (_db.select(
      _db.bosses,
    )..where((tbl) => tbl.isActive.equals(true))).watchSingleOrNull();
  }

  @override
  Stream<List<Boss>> watchAllBosses() {
    return (_db.select(
      _db.bosses,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.chapter)])).watch();
  }

  @override
  Future<Boss?> getActiveBoss() async {
    return (_db.select(
      _db.bosses,
    )..where((tbl) => tbl.isActive.equals(true))).getSingleOrNull();
  }

  @override
  Future<Boss?> getBossByChapter(int chapter) async {
    return (_db.select(
      _db.bosses,
    )..where((tbl) => tbl.chapter.equals(chapter))).getSingleOrNull();
  }

  @override
  Future<void> applyDamage(int damage, {String? bossId}) async {
    if (damage <= 0) return;
    final boss = bossId != null
        ? await (_db.select(
            _db.bosses,
          )..where((tbl) => tbl.id.equals(bossId))).getSingleOrNull()
        : await getActiveBoss();

    if (boss == null) return;

    final newHp = max(0, boss.currentHp - damage);
    final isDefeated = newHp == 0 ? true : boss.isDefeated;

    await (_db.update(
      _db.bosses,
    )..where((tbl) => tbl.id.equals(boss.id))).write(
      BossesCompanion(currentHp: Value(newHp), isDefeated: Value(isDefeated)),
    );
  }

  @override
  Future<Boss?> advanceToNextBoss() async {
    final currentBoss = await getActiveBoss();
    if (currentBoss == null) return null;

    final nextChapter = currentBoss.chapter + 1;
    final nextBoss = await getBossByChapter(nextChapter);
    if (nextBoss == null) return currentBoss;

    await _db.batch((b) {
      b.update(
        _db.bosses,
        const BossesCompanion(isActive: Value(false)),
        where: (tbl) => tbl.id.equals(currentBoss.id),
      );
      b.update(
        _db.bosses,
        const BossesCompanion(isActive: Value(true)),
        where: (tbl) => tbl.id.equals(nextBoss.id),
      );
    });

    return getBossByChapter(nextChapter);
  }

  @override
  Future<void> selectActiveChapter(int chapter) async {
    final targetBoss = await getBossByChapter(chapter);
    if (targetBoss == null) return;

    await _db.batch((b) {
      b.update(_db.bosses, const BossesCompanion(isActive: Value(false)));
      b.update(
        _db.bosses,
        const BossesCompanion(isActive: Value(true)),
        where: (tbl) => tbl.chapter.equals(chapter),
      );
    });
  }

  @override
  Future<void> resetBoss(String bossId) async {
    final boss = await (_db.select(
      _db.bosses,
    )..where((tbl) => tbl.id.equals(bossId))).getSingleOrNull();
    if (boss == null) return;

    await (_db.update(_db.bosses)..where((tbl) => tbl.id.equals(bossId))).write(
      BossesCompanion(
        currentHp: Value(boss.maxHp),
        isDefeated: const Value(false),
      ),
    );
  }
}
