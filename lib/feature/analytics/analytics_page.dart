import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/domain/models/analytics_model.dart';
import 'package:workxp/feature/analytics/bloc/analytics_bloc.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'widgets/achievements_card.dart';
import 'widgets/attribute_radar_card.dart';
import 'widgets/damage_bar_chart_card.dart';
import 'widgets/exp_line_chart_card.dart';
import 'widgets/habit_heatmap_card.dart';
import 'widgets/leaderboard_card.dart';

@RoutePage()
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final AnalyticsBloc _analyticsBloc;

  @override
  void initState() {
    super.initState();
    _analyticsBloc = locator<AnalyticsBloc>()..add(const LoadAnalytics());
  }

  @override
  void dispose() {
    _analyticsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalyticsBloc>.value(
      value: _analyticsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'HALL OF FAME',
            style: PixelTypography.pixelHeader(
              fontSize: 14,
              color: PixelColors.coinGold,
            ),
          ),
          backgroundColor: PixelColors.backgroundDark,
        ),
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            final dailyLogs =
                state is AnalyticsLoaded ? state.dailyLogs : <DailyActivityLog>[];
            final achievements =
                state is AnalyticsLoaded ? state.achievements : <AchievementModel>[];
            final leaderboard =
                state is AnalyticsLoaded ? state.leaderboard : <LeaderboardEntryModel>[];
            final hero = state is AnalyticsLoaded ? state.hero : null;
            final heroModel = state is AnalyticsLoaded ? state.heroModel : null;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. EXP Growth Line Chart
                    ExpLineChartCard(logs: dailyLogs),
                    const SizedBox(height: 16),

                    // 2. Boss Damage Bar Chart
                    DamageBarChartCard(logs: dailyLogs),
                    const SizedBox(height: 16),

                    // 3. 16-Bit Habit Heatmap Matrix
                    HabitHeatmapCard(logs: dailyLogs),
                    const SizedBox(height: 16),

                    // 4. Attribute Balance Radar Chart
                    AttributeRadarCard(
                      hero: hero,
                      heroModel: heroModel,
                    ),
                    const SizedBox(height: 16),

                    // 5. Lifetime Achievements System
                    AchievementsCard(achievements: achievements),
                    const SizedBox(height: 16),

                    // 6. Simulated Guild Leaderboard
                    LeaderboardCard(entries: leaderboard),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
