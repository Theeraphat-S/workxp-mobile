import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/analytics_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/repositories/combat_log_repository.dart';
import 'package:workxp/domain/repositories/daily_quest_repository.dart';
import 'package:workxp/domain/repositories/habit_repository.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

export 'analytics_event.dart';
export 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({
    required CombatLogRepository combatLogRepository,
    required HeroRepository heroRepository,
    required DailyQuestRepository dailyQuestRepository,
    required HabitRepository habitRepository,
  })  : _combatLogRepository = combatLogRepository,
        _heroRepository = heroRepository,
        _dailyQuestRepository = dailyQuestRepository,
        _habitRepository = habitRepository,
        super(const AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<AnalyticsUpdated>(_onAnalyticsUpdated);
    on<RefreshAnalytics>(_onRefreshAnalytics);
  }

  final CombatLogRepository _combatLogRepository;
  final HeroRepository _heroRepository;
  final DailyQuestRepository _dailyQuestRepository;
  final HabitRepository _habitRepository;

  StreamSubscription? _logsSub;
  StreamSubscription? _heroSub;
  StreamSubscription? _dailiesSub;
  StreamSubscription? _habitsSub;

  List<CombatLog> _cachedLogs = [];
  Hero? _cachedHero;
  List<DailyQuest> _cachedDailies = [];
  List<Habit> _cachedHabits = [];

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    await _cancelSubscriptions();

    try {
      _cachedLogs = await _combatLogRepository.getRecentLogs(limit: 100);
      _cachedHero = await _heroRepository.getHero();
      _cachedDailies = await _dailyQuestRepository.getDailyQuests();
      _cachedHabits = await _habitRepository.getHabits();
      _dispatchUpdated();
    } catch (_) {}

    _logsSub = _combatLogRepository.watchCombatLogs(limit: 100).listen((logs) {
      _cachedLogs = logs;
      _dispatchUpdated();
    });

    _heroSub = _heroRepository.watchHero().listen((hero) {
      _cachedHero = hero;
      _dispatchUpdated();
    });

    _dailiesSub = _dailyQuestRepository.watchDailyQuests().listen((dailies) {
      _cachedDailies = dailies;
      _dispatchUpdated();
    });

    _habitsSub = _habitRepository.watchHabits().listen((habits) {
      _cachedHabits = habits;
      _dispatchUpdated();
    });
  }

  void _dispatchUpdated() {
    if (isClosed) return;
    add(AnalyticsUpdated(
      combatLogs: _cachedLogs,
      hero: _cachedHero,
      dailies: _cachedDailies,
      habits: _cachedHabits,
    ));
  }

  void _onAnalyticsUpdated(
    AnalyticsUpdated event,
    Emitter<AnalyticsState> emit,
  ) {
    final hero = event.hero;
    final heroModel = HeroModel(
      name: hero?.name ?? 'Hero',
      level: hero?.level ?? 1,
      currentExp: hero?.currentExp ?? 0,
      currentHp: hero?.hp ?? 100,
      maxHp: hero?.maxHp ?? 100,
      currentMp: hero?.mp ?? 50,
      maxMp: hero?.maxMp ?? 100,
      coins: hero?.coins ?? 50,
      unallocatedPoints: hero?.unspentStatPoints ?? 0,
      str: hero?.str ?? 5,
      intel: hero?.intAttr ?? 5,
      agi: hero?.agi ?? 5,
      vit: hero?.vit ?? 5,
      wis: hero?.intAttr ?? 5,
      isGhost: hero?.isGhost ?? false,
      activeSkinId: hero?.avatarSkinId ?? 'hero_novice',
      activeTitleId: hero?.activeTitle ?? 'Novice Adventurer',
    );

    final dailyLogs = _buildDailyLogs(event.combatLogs);
    final achievements = _buildAchievements(event.combatLogs, hero, event.dailies);
    final leaderboard = _buildLeaderboard(hero, event.combatLogs, event.dailies);

    emit(AnalyticsLoaded(
      combatLogs: event.combatLogs,
      hero: hero,
      heroModel: heroModel,
      dailies: event.dailies,
      habits: event.habits,
      dailyLogs: dailyLogs,
      achievements: achievements,
      leaderboard: leaderboard,
    ));
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    _dispatchUpdated();
  }

  List<DailyActivityLog> _buildDailyLogs(List<CombatLog> logs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list = <DailyActivityLog>[];

    for (int i = 29; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      int exp = 0;
      int damage = 0;

      for (final log in logs) {
        if (log.timestamp.year == date.year &&
            log.timestamp.month == date.month &&
            log.timestamp.day == date.day) {
          damage += log.damage;
          if (log.damage > 0) exp += (log.damage * 0.4).round();
        }
      }

      list.add(DailyActivityLog(
        date: date,
        expEarned: exp,
        damageDealt: damage,
        habitCompletions: 0,
      ));
    }

    return list;
  }

  List<AchievementModel> _buildAchievements(
    List<CombatLog> logs,
    Hero? hero,
    List<DailyQuest> dailies,
  ) {
    final hasStrike = logs.any((l) => l.damage > 0);
    final maxStreak = dailies.fold<int>(
      0,
      (maxS, d) => d.streak > maxS ? d.streak : maxS,
    );
    final coins = hero?.coins ?? 0;
    final maxStat = [
      hero?.str ?? 5,
      hero?.agi ?? 5,
      hero?.intAttr ?? 5,
      hero?.vit ?? 5,
    ].reduce((a, b) => a > b ? a : b);

    return [
      AchievementModel(
        id: 'ach_first_blood',
        title: 'First Blood',
        description: 'Complete your first Quest strike against a Boss.',
        isUnlocked: hasStrike,
        unlockedAt: hasStrike ? DateTime.now() : null,
      ),
      AchievementModel(
        id: 'ach_slime_slayer',
        title: 'Slime Slayer',
        description: 'Conquer Chapter 1 and defeat King Slime.',
        isUnlocked: logs.any((l) => l.textContent.contains('Slime') || l.damage >= 200),
      ),
      AchievementModel(
        id: 'ach_dragon_slayer',
        title: 'Dragon Slayer',
        description: 'Conquer Chapter 4 and defeat the Red Dragon.',
        isUnlocked: logs.any((l) => l.textContent.contains('Dragon')),
      ),
      AchievementModel(
        id: 'ach_streak_master',
        title: 'Iron Discipline',
        description: 'Maintain an unbroken Daily Quest Streak for 7 days.',
        isUnlocked: maxStreak >= 7,
      ),
      AchievementModel(
        id: 'ach_coin_hoarder',
        title: 'Dragon Treasury',
        description: 'Accumulate over 200 spendable Coins in purse.',
        isUnlocked: coins >= 200,
      ),
      AchievementModel(
        id: 'ach_attribute_master',
        title: 'Ascended Hero',
        description: 'Raise any single Attribute to 15 or higher.',
        isUnlocked: maxStat >= 15,
      ),
    ];
  }

  List<LeaderboardEntryModel> _buildLeaderboard(
    Hero? hero,
    List<CombatLog> logs,
    List<DailyQuest> dailies,
  ) {
    final weeklyHeroDamage = logs.fold<int>(0, (sum, l) => sum + l.damage);
    final maxStreak = dailies.fold<int>(0, (m, d) => d.streak > m ? d.streak : m);

    final heroEntry = LeaderboardEntryModel(
      rank: 0,
      name: hero?.name ?? 'Arthur',
      title: hero?.activeTitle ?? 'Novice Adventurer',
      skinId: hero?.avatarSkinId ?? 'hero_novice',
      weeklyDamage: weeklyHeroDamage,
      streak: maxStreak,
      isHero: true,
    );

    final allEntries = <LeaderboardEntryModel>[
      ...LeaderboardEntryModel.simulatedRivals(),
      heroEntry,
    ];

    allEntries.sort((a, b) => b.weeklyDamage.compareTo(a.weeklyDamage));

    final ranked = <LeaderboardEntryModel>[];
    for (int i = 0; i < allEntries.length; i++) {
      final entry = allEntries[i];
      ranked.add(LeaderboardEntryModel(
        rank: i + 1,
        name: entry.name,
        title: entry.title,
        skinId: entry.skinId,
        weeklyDamage: entry.weeklyDamage,
        streak: entry.streak,
        isHero: entry.isHero,
      ));
    }

    return ranked;
  }

  Future<void> _cancelSubscriptions() async {
    await _logsSub?.cancel();
    await _heroSub?.cancel();
    await _dailiesSub?.cancel();
    await _habitsSub?.cancel();
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
