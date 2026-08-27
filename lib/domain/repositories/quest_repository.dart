import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/quest_model.dart';

abstract class QuestRepository {
  Stream<List<Quest>> watchQuests();
  Stream<List<Quest>> watchActiveQuests();
  Stream<List<Quest>> watchCompletedQuests();
  Future<List<Quest>> getQuests();
  Future<Quest?> getQuest(String id);
  Future<Quest> createQuest({
    required String title,
    String description = '',
    String rank = 'E',
    int? baseDamage,
    int? expReward,
    int? coinReward,
    String? id,
  });
  Future<void> completeQuest(String id);
  Future<void> deleteQuest(String id);
}

class QuestRepositoryImpl implements QuestRepository {
  QuestRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Quest>> watchQuests() {
    return (_db.select(
      _db.quests,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).watch();
  }

  @override
  Stream<List<Quest>> watchActiveQuests() {
    return (_db.select(_db.quests)
          ..where((tbl) => tbl.isCompleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  @override
  Stream<List<Quest>> watchCompletedQuests() {
    return (_db.select(_db.quests)
          ..where((tbl) => tbl.isCompleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)]))
        .watch();
  }

  @override
  Future<List<Quest>> getQuests() async {
    return (_db.select(
      _db.quests,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
  }

  @override
  Future<Quest?> getQuest(String id) async {
    return (_db.select(
      _db.quests,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<Quest> createQuest({
    required String title,
    String description = '',
    String rank = 'E',
    int? baseDamage,
    int? expReward,
    int? coinReward,
    String? id,
  }) async {
    final questId = id ?? const Uuid().v4();
    final dmg = baseDamage ?? QuestModel.baseDamageForRank(rank);
    final exp = expReward ?? QuestModel.expRewardForRank(rank);
    final coins = coinReward ?? QuestModel.coinRewardForRank(rank);

    final companion = QuestsCompanion.insert(
      id: questId,
      title: title,
      description: Value(description),
      rank: Value(rank),
      baseDamage: Value(dmg),
      expReward: Value(exp),
      coinReward: Value(coins),
      isCompleted: const Value(false),
      createdAt: Value(DateTime.now()),
    );

    await _db.into(_db.quests).insert(companion);
    return (await getQuest(questId))!;
  }

  @override
  Future<void> completeQuest(String id) async {
    await (_db.update(_db.quests)..where((tbl) => tbl.id.equals(id))).write(
      QuestsCompanion(
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteQuest(String id) async {
    await (_db.delete(_db.quests)..where((tbl) => tbl.id.equals(id))).go();
  }
}
