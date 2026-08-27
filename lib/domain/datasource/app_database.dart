import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// 1. Heroes Table
@DataClassName('Hero')
class Heroes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant('Arthur'))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get currentExp => integer().withDefault(const Constant(0))();
  IntColumn get hp => integer().withDefault(const Constant(100))();
  IntColumn get maxHp => integer().withDefault(const Constant(100))();
  IntColumn get mp => integer().withDefault(const Constant(50))();
  IntColumn get maxMp => integer().withDefault(const Constant(50))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  IntColumn get str => integer().withDefault(const Constant(5))();
  IntColumn get agi => integer().withDefault(const Constant(5))();
  IntColumn get intAttr => integer().withDefault(const Constant(5))();
  IntColumn get vit => integer().withDefault(const Constant(5))();
  IntColumn get unspentStatPoints => integer().withDefault(const Constant(0))();
  BoolColumn get isGhost => boolean().withDefault(const Constant(false))();
  TextColumn get activeTitle =>
      text().withDefault(const Constant('Novice Adventurer'))();
  TextColumn get avatarSkinId =>
      text().withDefault(const Constant('hero_novice'))();
  TextColumn get bannerId =>
      text().withDefault(const Constant('default_banner'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 2. Bosses Table
@DataClassName('Boss')
class Bosses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get chapter => integer()();
  IntColumn get maxHp => integer()();
  IntColumn get currentHp => integer()();
  TextColumn get iconAsset => text()();
  BoolColumn get isDefeated => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 3. Quests Table
class Quests extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get rank => text().withDefault(const Constant('E'))();
  IntColumn get baseDamage => integer().withDefault(const Constant(25))();
  IntColumn get expReward => integer().withDefault(const Constant(20))();
  IntColumn get coinReward => integer().withDefault(const Constant(10))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 4. DailyQuests Table
class DailyQuests extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCompletedDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 5. Habits Table
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isPositive => boolean().withDefault(const Constant(true))();
  BoolColumn get isNegative => boolean().withDefault(const Constant(false))();
  IntColumn get positiveCount => integer().withDefault(const Constant(0))();
  IntColumn get negativeCount => integer().withDefault(const Constant(0))();
  TextColumn get historyDatesJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 6. TavernItems Table
class TavernItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get category => text()(); // consumable, skin, theme, custom_reward
  IntColumn get cost => integer()();
  TextColumn get effectType => text().withDefault(const Constant(''))();
  IntColumn get effectValue => integer().withDefault(const Constant(0))();
  TextColumn get iconAsset => text()();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 7. CombatLogs Table
class CombatLogs extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get textContent => text().named('text')();
  IntColumn get damage => integer().withDefault(const Constant(0))();
  BoolColumn get isCritical => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Heroes,
    Bosses,
    Quests,
    DailyQuests,
    Habits,
    TavernItems,
    CombatLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await seedStarterKit();
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      try {
        final db = driftDatabase(name: 'workxp_db');
        final executor = await (db as dynamic).delegate.executor;
        return executor as QueryExecutor;
      } catch (_) {
        return NativeDatabase.memory();
      }
    });
  }

  /// Seeds all default entities for the Starter Kit upon initial database creation
  Future<void> seedStarterKit() async {
    // 1. Novice Hero ('Arthur')
    await into(heroes).insert(
      HeroesCompanion.insert(
        id: 'hero_player',
        name: const Value('Arthur'),
        level: const Value(1),
        currentExp: const Value(0),
        hp: const Value(100),
        maxHp: const Value(100),
        mp: const Value(50),
        maxMp: const Value(50),
        coins: const Value(0),
        str: const Value(5),
        agi: const Value(5),
        intAttr: const Value(5),
        vit: const Value(5),
        unspentStatPoints: const Value(0),
        isGhost: const Value(false),
        activeTitle: const Value('Novice Adventurer'),
        avatarSkinId: const Value('hero_novice'),
        bannerId: const Value('default_banner'),
      ),
      mode: InsertMode.insertOrReplace,
    );

    // 2. Bosses (Chapters 1 to 4)
    await batch((b) {
      b.insertAll(bosses, [
        BossesCompanion.insert(
          id: 'boss_slime',
          name: 'King Slime',
          chapter: 1,
          maxHp: 500,
          currentHp: 500,
          iconAsset: 'boss_slime',
          isDefeated: const Value(false),
          isActive: const Value(true),
        ),
        BossesCompanion.insert(
          id: 'boss_goblin',
          name: 'Goblin Shaman',
          chapter: 2,
          maxHp: 1000,
          currentHp: 1000,
          iconAsset: 'boss_goblin',
          isDefeated: const Value(false),
          isActive: const Value(false),
        ),
        BossesCompanion.insert(
          id: 'boss_necromancer',
          name: 'Dread Necromancer',
          chapter: 3,
          maxHp: 2000,
          currentHp: 2000,
          iconAsset: 'boss_necromancer',
          isDefeated: const Value(false),
          isActive: const Value(false),
        ),
        BossesCompanion.insert(
          id: 'boss_dragon',
          name: 'Red Dragon',
          chapter: 4,
          maxHp: 5000,
          currentHp: 5000,
          iconAsset: 'boss_dragon',
          isDefeated: const Value(false),
          isActive: const Value(false),
        ),
      ], mode: InsertMode.insertOrReplace);
    });

    // 3. Starter Quests (E/D/C rank)
    final now = DateTime.now();
    await batch((b) {
      b.insertAll(quests, [
        QuestsCompanion.insert(
          id: 'quest_starter_1',
          title: 'Explore Battle Hub & Strike King Slime',
          description: const Value(
            'Complete this quest to deal your first combat strike!',
          ),
          rank: const Value('D'),
          baseDamage: const Value(50),
          expReward: const Value(40),
          coinReward: const Value(20),
          isCompleted: const Value(false),
          createdAt: Value(now),
        ),
        QuestsCompanion.insert(
          id: 'quest_starter_2',
          title: 'Tidy Workspace & Prepare Battle Station',
          description: const Value(
            'Clear desk clutter to enhance real-life agility.',
          ),
          rank: const Value('E'),
          baseDamage: const Value(25),
          expReward: const Value(20),
          coinReward: const Value(10),
          isCompleted: const Value(false),
          createdAt: Value(now.add(const Duration(seconds: 1))),
        ),
        QuestsCompanion.insert(
          id: 'quest_starter_3',
          title: 'Read 10 Pages of Knowledge',
          description: const Value(
            'Sharpen your mental attributes and gain EXP.',
          ),
          rank: const Value('C'),
          baseDamage: const Value(100),
          expReward: const Value(80),
          coinReward: const Value(40),
          isCompleted: const Value(false),
          createdAt: Value(now.add(const Duration(seconds: 2))),
        ),
      ], mode: InsertMode.insertOrReplace);
    });

    // 4. Starter Daily Quests
    await batch((b) {
      b.insertAll(dailyQuests, [
        DailyQuestsCompanion.insert(
          id: 'daily_starter_1',
          title: 'Morning Physical Exercise (30 Mins)',
          description: const Value(
            'Boost endurance and protect HP from midnight attacks.',
          ),
          isCompleted: const Value(false),
          streak: const Value(1),
        ),
        DailyQuestsCompanion.insert(
          id: 'daily_starter_2',
          title: 'Daily Deep Work / Coding Session',
          description: const Value(
            'Advance key projects with concentrated focus.',
          ),
          isCompleted: const Value(false),
          streak: const Value(2),
        ),
        DailyQuestsCompanion.insert(
          id: 'daily_starter_3',
          title: 'Mindful Evening Review & Plan Tomorrow',
          description: const Value(
            'Reflect on accomplishments and restore wisdom.',
          ),
          isCompleted: const Value(false),
          streak: const Value(1),
        ),
      ], mode: InsertMode.insertOrReplace);
    });

    // 5. Starter Habits
    await batch((b) {
      b.insertAll(habits, [
        HabitsCompanion.insert(
          id: 'habit_starter_1',
          title: 'Drink 1 Glass of Fresh Water',
          isPositive: const Value(true),
          isNegative: const Value(false),
          positiveCount: const Value(0),
          negativeCount: const Value(0),
          historyDatesJson: const Value('[]'),
        ),
        HabitsCompanion.insert(
          id: 'habit_starter_2',
          title: 'Good Posture Check',
          isPositive: const Value(true),
          isNegative: const Value(false),
          positiveCount: const Value(0),
          negativeCount: const Value(0),
          historyDatesJson: const Value('[]'),
        ),
        HabitsCompanion.insert(
          id: 'habit_starter_3',
          title: 'Mindless Social Media Scrolling',
          isPositive: const Value(false),
          isNegative: const Value(true),
          positiveCount: const Value(0),
          negativeCount: const Value(0),
          historyDatesJson: const Value('[]'),
        ),
      ], mode: InsertMode.insertOrReplace);
    });

    // 6. Default Tavern Items (Consumables, Skins, Themes, Custom Rewards)
    await batch((b) {
      b.insertAll(tavernItems, [
        // Consumables
        TavernItemsCompanion.insert(
          id: 'item_potion_health',
          name: 'Health Potion',
          description: const Value('Restores 50 HP immediately.'),
          category: 'consumable',
          cost: 25,
          effectType: const Value('heal_hp'),
          effectValue: const Value(50),
          iconAsset: 'potion_health',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'item_streak_shield',
          name: 'Streak Shield',
          description: const Value(
            'Shields your HP and streak from 1 missed day.',
          ),
          category: 'consumable',
          cost: 40,
          effectType: const Value('streak_shield'),
          effectValue: const Value(1),
          iconAsset: 'shield',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'item_exp_tonic',
          name: 'EXP Tonic',
          description: const Value('Grants an instant +100 EXP boost.'),
          category: 'consumable',
          cost: 35,
          effectType: const Value('exp_boost'),
          effectValue: const Value(100),
          iconAsset: 'potion_exp',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'item_elixir_life',
          name: 'Elixir of Life',
          description: const Value(
            'Instantly resurrects Hero from Ghost State with 100% HP.',
          ),
          category: 'consumable',
          cost: 80,
          effectType: const Value('revive_full'),
          effectValue: const Value(100),
          iconAsset: 'elixir_life',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),

        // Skins (Cosmetic)
        TavernItemsCompanion.insert(
          id: 'paladin',
          name: 'Holy Paladin Skin',
          description: const Value(
            'Radiant armor forged from golden sunlight.',
          ),
          category: 'skin',
          cost: 150,
          effectType: const Value('skin'),
          effectValue: const Value(0),
          iconAsset: 'paladin',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'dark_knight',
          name: 'Dark Knight Skin',
          description: const Value(
            'Shadow-infused plate armor with violet aura.',
          ),
          category: 'skin',
          cost: 200,
          effectType: const Value('skin'),
          effectValue: const Value(0),
          iconAsset: 'dark_knight',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'archmage',
          name: 'Archmage Robes',
          description: const Value(
            'Mystic vestments glowing with ancient wisdom.',
          ),
          category: 'skin',
          cost: 250,
          effectType: const Value('skin'),
          effectValue: const Value(0),
          iconAsset: 'archmage',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'cyber_samurai',
          name: 'Cyber Samurai Skin',
          description: const Value('Neon-infused futuristic cyber armor.'),
          category: 'skin',
          cost: 350,
          effectType: const Value('skin'),
          effectValue: const Value(0),
          iconAsset: 'cyber_samurai',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),

        // Themes (Cosmetics)
        TavernItemsCompanion.insert(
          id: 'theme_amber_crt',
          name: 'Amber CRT Theme',
          description: const Value(
            'Retro monochrome amber terminal phosphorescent screen.',
          ),
          category: 'theme',
          cost: 100,
          effectType: const Value('theme'),
          effectValue: const Value(0),
          iconAsset: 'theme_amber',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'theme_green_crt',
          name: 'Matrix Green CRT Theme',
          description: const Value(
            'Cyberpunk green phosphorescent terminal display.',
          ),
          category: 'theme',
          cost: 100,
          effectType: const Value('theme'),
          effectValue: const Value(0),
          iconAsset: 'theme_green',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),

        // Starter Custom Rewards
        TavernItemsCompanion.insert(
          id: 'starter_boba',
          name: '1 Delicious Boba Tea',
          description: const Value('Treat yourself to a sweet bubble tea.'),
          category: 'custom_reward',
          cost: 50,
          effectType: const Value('custom'),
          effectValue: const Value(0),
          iconAsset: 'coffee',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
        TavernItemsCompanion.insert(
          id: 'starter_game',
          name: '1 Hour Video Game Session',
          description: const Value('Guilt-free gaming time.'),
          category: 'custom_reward',
          cost: 40,
          effectType: const Value('custom'),
          effectValue: const Value(0),
          iconAsset: 'sports_esports',
          isPurchased: const Value(false),
          quantity: const Value(0),
        ),
      ], mode: InsertMode.insertOrReplace);
    });
  }
}
