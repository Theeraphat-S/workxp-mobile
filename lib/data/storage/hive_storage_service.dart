import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/domain/models/analytics_model.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';

class HiveStorageService {
  HiveStorageService._();
  static final HiveStorageService instance = HiveStorageService._();

  static const String boxName = 'workxp_save_data';
  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  bool get isInitialized => _box != null && _box!.isOpen;

  /// Check if database has saved game state
  bool hasSaveData() {
    if (!isInitialized) return false;
    return _box!.containsKey('hero');
  }

  /// Saves the complete game state into local storage
  Future<void> saveGameState({
    required HeroModel hero,
    required List<QuestModel> quests,
    required List<DailyQuestModel> dailies,
    required List<HabitModel> habits,
    required DungeonState dungeon,
    required TavernState tavern,
    required AnalyticsState analytics,
    required bool isSfxEnabled,
    required bool isHapticsEnabled,
  }) async {
    if (!isInitialized) return;

    await _box!.put('hero', jsonEncode(hero.toJson()));
    await _box!.put(
      'quests',
      jsonEncode(quests.map((q) => q.toJson()).toList()),
    );
    await _box!.put(
      'dailies',
      jsonEncode(dailies.map((d) => d.toJson()).toList()),
    );
    await _box!.put(
      'habits',
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
    await _box!.put('dungeon', jsonEncode(dungeon.toJson()));
    await _box!.put('tavern', jsonEncode(tavern.toJson()));
    await _box!.put('analytics', jsonEncode(analytics.toJson()));
    await _box!.put(
      'settings',
      jsonEncode({
        'isSfxEnabled': isSfxEnabled,
        'isHapticsEnabled': isHapticsEnabled,
        'lastSavedAt': DateTime.now().toIso8601String(),
      }),
    );
  }

  /// Exports the entire game state as a formatted JSON backup string
  String exportSaveFileJson({
    required HeroModel hero,
    required List<QuestModel> quests,
    required List<DailyQuestModel> dailies,
    required List<HabitModel> habits,
    required DungeonState dungeon,
    required TavernState tavern,
    required AnalyticsState analytics,
  }) {
    final saveMap = {
      'version': '1.0.0',
      'app': 'WorkXP (Pocket Quest)',
      'exportedAt': DateTime.now().toIso8601String(),
      'hero': hero.toJson(),
      'quests': quests.map((q) => q.toJson()).toList(),
      'dailies': dailies.map((d) => d.toJson()).toList(),
      'habits': habits.map((h) => h.toJson()).toList(),
      'dungeon': dungeon.toJson(),
      'tavern': tavern.toJson(),
      'analytics': analytics.toJson(),
    };

    return const JsonEncoder.withIndent('  ').convert(saveMap);
  }

  /// Validates and parses a JSON save file string
  Map<String, dynamic>? parseAndValidateSaveJson(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic> &&
          decoded.containsKey('hero') &&
          decoded.containsKey('quests')) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  /// Loads existing saved game state from Hive box
  Map<String, dynamic>? loadSavedGameState() {
    if (!hasSaveData()) return null;
    try {
      final heroJson =
          jsonDecode(_box!.get('hero') as String) as Map<String, dynamic>;
      final questsRaw =
          jsonDecode(_box!.get('quests') as String) as List<dynamic>;
      final dailiesRaw =
          jsonDecode(_box!.get('dailies') as String) as List<dynamic>;
      final habitsRaw =
          jsonDecode(_box!.get('habits') as String) as List<dynamic>;
      final dungeonJson =
          jsonDecode(_box!.get('dungeon') as String) as Map<String, dynamic>;
      final tavernJson =
          jsonDecode(_box!.get('tavern') as String) as Map<String, dynamic>;
      final analyticsJson =
          jsonDecode(_box!.get('analytics') as String) as Map<String, dynamic>;

      DateTime? lastSavedAt;
      if (_box!.containsKey('settings')) {
        final settingsJson =
            jsonDecode(_box!.get('settings') as String) as Map<String, dynamic>;
        if (settingsJson.containsKey('lastSavedAt')) {
          lastSavedAt = DateTime.tryParse(
            settingsJson['lastSavedAt'] as String,
          );
        }
      }

      return {
        'hero': HeroModel.fromJson(heroJson),
        'quests': questsRaw
            .map((e) => QuestModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        'dailies': dailiesRaw
            .map((e) => DailyQuestModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        'habits': habitsRaw
            .map((e) => HabitModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        'dungeon': DungeonState.fromJson(dungeonJson),
        'tavern': TavernState.fromJson(tavernJson),
        'analytics': AnalyticsState.fromJson(analyticsJson),
        'lastSavedAt': lastSavedAt,
      };
    } catch (_) {
      return null;
    }
  }

  /// Loads starter kit data for fresh installs
  Map<String, dynamic> generateStarterKit() {
    final starterHero = const HeroModel(
      name: 'Arthur',
      level: 1,
      currentExp: 0,
      currentHp: 100,
      maxHp: 100,
      currentMp: 50,
      maxMp: 100,
      coins: 50,
      unallocatedPoints: 2,
      str: 6,
      intel: 5,
      agi: 5,
      vit: 6,
      wis: 5,
      activeSkinId: 'hero_novice',
      activeTitleId: 'Novice Adventurer',
    );

    final starterQuests = [
      QuestModel(
        title: 'Explore Battle Hub & Strike King Slime',
        description: 'Complete this quest to deal your first combat strike!',
        rank: 'D',
        attributeTag: 'STR',
      ),
      QuestModel(
        title: 'Tidy Workspace & Prepare Battle Station',
        description: 'Clear desk clutter to enhance real-life agility.',
        rank: 'E',
        attributeTag: 'AGI',
      ),
      QuestModel(
        title: 'Read 10 Pages of Knowledge',
        description: 'Sharpen your mental attributes and gain EXP.',
        rank: 'C',
        attributeTag: 'INT',
      ),
    ];

    final starterDailies = [
      DailyQuestModel(
        title: 'Morning Physical Exercise (30 Mins)',
        description: 'Boost endurance and protect HP from midnight attacks.',
        streak: 1,
        attributeTag: 'VIT',
      ),
      DailyQuestModel(
        title: 'Daily Deep Work / Coding Session',
        description: 'Advance key projects with concentrated focus.',
        streak: 2,
        attributeTag: 'INT',
      ),
      DailyQuestModel(
        title: 'Mindful Evening Review & Plan Tomorrow',
        description: 'Reflect on accomplishments and restore wisdom.',
        streak: 1,
        attributeTag: 'WIS',
      ),
    ];

    final starterHabits = [
      HabitModel(
        title: 'Drink 1 Glass of Fresh Water',
        hasPositive: true,
        hasNegative: false,
        attributeTag: 'WIS',
      ),
      HabitModel(
        title: 'Good Posture Check',
        hasPositive: true,
        hasNegative: false,
        attributeTag: 'VIT',
      ),
      HabitModel(
        title: 'Mindless Social Media Scrolling',
        hasPositive: false,
        hasNegative: true,
        attributeTag: 'INT',
      ),
    ];

    final starterDungeon = DungeonState(
      activeBoss: BossModel.chapterBoss(1),
      currentChapter: 1,
      unlockedChapters: const [1],
    );

    final starterTavern = TavernState(
      catalog: TavernItemModel.defaultCatalog(),
      customRewards: [
        CustomRewardModel(
          id: 'starter_boba',
          title: '1 Delicious Boba Tea',
          description: 'A sweet real-life treat for great productivity.',
          coinCost: 50,
        ),
        CustomRewardModel(
          id: 'starter_game',
          title: '1 Hour Video Game Session',
          description: 'Guilt-free gaming time earned via completed quests.',
          coinCost: 40,
        ),
      ],
    );

    final starterAnalytics = AnalyticsState(
      achievements: AchievementModel.defaultAchievements(),
      leaderboard: LeaderboardEntryModel.simulatedRivals(),
    );

    return {
      'hero': starterHero,
      'quests': starterQuests,
      'dailies': starterDailies,
      'habits': starterHabits,
      'dungeon': starterDungeon,
      'tavern': starterTavern,
      'analytics': starterAnalytics,
    };
  }
}
