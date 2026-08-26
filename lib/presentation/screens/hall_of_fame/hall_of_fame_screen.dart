import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'widgets/exp_line_chart_card.dart';
import 'widgets/damage_bar_chart_card.dart';
import 'widgets/habit_heatmap_card.dart';
import 'widgets/attribute_radar_card.dart';
import 'widgets/achievements_card.dart';
import 'widgets/leaderboard_card.dart';

class HallOfFameScreen extends ConsumerStatefulWidget {
  const HallOfFameScreen({super.key});

  @override
  ConsumerState<HallOfFameScreen> createState() => _HallOfFameScreenState();
}

class _HallOfFameScreenState extends ConsumerState<HallOfFameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hero = ref.read(heroProvider);
      final dungeon = ref.read(dungeonProvider);
      final quests = ref.read(questProvider);
      final dailies = ref.read(dailyQuestProvider);

      ref
          .read(analyticsProvider.notifier)
          .evaluateAchievements(
            hero: hero,
            dungeon: dungeon,
            quests: quests,
            dailies: dailies,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hero = ref.watch(heroProvider);
    final analytics = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HALL OF FAME',
          style: PixelTypography.pixelHeader(
            fontSize: 14,
            color: PixelColors.coinGold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'STATS & ANALYTICS ARCHIVES',
                style: PixelTypography.pixelHeader(
                  fontSize: 12,
                  color: PixelColors.coinGold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Review your lifetime productivity trajectory and guild ranking.',
                style: PixelTypography.pixelBody(
                  fontSize: 12,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              // 1. EXP Growth Line Chart
              ExpLineChartCard(logs: analytics.dailyLogs),
              const SizedBox(height: 16),
              // 2. Boss Damage Dealt Bar Chart
              DamageBarChartCard(logs: analytics.dailyLogs),
              const SizedBox(height: 16),
              // 3. 16-Bit Habit Consistency Heatmap
              HabitHeatmapCard(logs: analytics.dailyLogs),
              const SizedBox(height: 16),
              // 4. Attribute Radar Chart
              AttributeRadarCard(hero: hero),
              const SizedBox(height: 16),
              // 5. Permanent Achievements
              AchievementsCard(achievements: analytics.achievements),
              const SizedBox(height: 16),
              // 6. Simulated Guild Leaderboard
              LeaderboardCard(entries: analytics.leaderboard),
            ],
          ),
        ),
      ),
    );
  }
}
