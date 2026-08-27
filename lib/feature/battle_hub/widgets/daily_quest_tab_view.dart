import 'package:flutter/material.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'create_daily_quest_dialog.dart';

class DailyQuestTabView extends StatelessWidget {
  const DailyQuestTabView({
    super.key,
    this.dailies = const [],
    this.driftDailies = const [],
    required this.onToggle,
    required this.onAdd,
    this.onEdit,
    required this.onDelete,
  });

  final List<DailyQuestModel> dailies;
  final List<DailyQuest> driftDailies;
  final void Function(String id) onToggle;
  final void Function(DailyQuestModel daily) onAdd;
  final void Function(DailyQuestModel daily)? onEdit;
  final void Function(String id) onDelete;

  List<DailyQuestModel> get _combinedDailies {
    if (dailies.isNotEmpty) return dailies;
    return driftDailies
        .map((d) => DailyQuestModel(
              id: d.id,
              title: d.title,
              description: d.description,
              isCompletedToday: d.isCompleted,
              streak: d.streak,
              lastCompletedDate: d.lastCompletedDate,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _combinedDailies;
    final totalCompletedToday = list.where((d) => d.isCompletedToday).length;
    final allDone = list.isNotEmpty && totalCompletedToday == list.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Streak Summary Banner
        PixelCard(
          borderColor: allDone
              ? PixelColors.hpGreen
              : PixelColors.borderHighlight,
          backgroundColor: allDone
              ? PixelColors.hpGreen.withAlpha(20)
              : PixelColors.backgroundCard,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: PixelColors.backgroundSurface,
                child: const Icon(
                  Icons.local_fire_department,
                  color: PixelColors.coinAmber,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allDone ? 'ALL DAILIES FULFILLED!' : 'DAILY QUESTS',
                      style: PixelTypography.pixelHeader(
                        fontSize: 11,
                        color: allDone
                            ? PixelColors.hpGreen
                            : PixelColors.coinGold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalCompletedToday / ${list.length} completed today. Protects HP at midnight!',
                      style: PixelTypography.pixelBody(
                        fontSize: 12,
                        color: PixelColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              PixelButton(
                text: '+ DAILY',
                fontSize: 9,
                backgroundColor: PixelColors.hpGreen,
                textColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                onPressed: () async {
                  final newDaily = await showDialog<DailyQuestModel>(
                    context: context,
                    builder: (ctx) => const CreateDailyQuestDialog(),
                  );
                  if (newDaily != null) onAdd(newDaily);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No Daily Quests set. Add your first daily habit above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...list.map((daily) => _buildDailyCard(context, daily)),
      ],
    );
  }

  Widget _buildDailyCard(BuildContext context, DailyQuestModel daily) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PixelCard(
        borderColor: daily.isCompletedToday
            ? PixelColors.hpGreen
            : PixelColors.borderDark,
        backgroundColor: daily.isCompletedToday
            ? PixelColors.hpGreen.withAlpha(15)
            : PixelColors.backgroundCard,
        child: Row(
          children: [
            // Checkbox
            InkWell(
              key: Key('toggle_daily_${daily.id}'),
              onTap: () => onToggle(daily.id),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: daily.isCompletedToday
                      ? PixelColors.hpGreen
                      : PixelColors.backgroundSurface,
                  border: Border.all(
                    color: daily.isCompletedToday
                        ? PixelColors.hpGreen
                        : PixelColors.borderHighlight,
                    width: 2,
                  ),
                ),
                child: daily.isCompletedToday
                    ? const Icon(Icons.check, size: 18, color: Colors.black)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PixelBadge.attribute(daily.attributeTag),
                      const SizedBox(width: 6),
                      // Streak Flame Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        color: PixelColors.coinAmber.withAlpha(40),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              size: 11,
                              color: PixelColors.coinAmber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${daily.streakCount}d',
                              style: PixelTypography.pixelHeader(
                                fontSize: 8,
                                color: PixelColors.coinAmber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    daily.title,
                    style: PixelTypography.pixelSubheader(
                      fontSize: 11,
                      color: daily.isCompletedToday
                          ? PixelColors.textMuted
                          : PixelColors.textBright,
                    ),
                  ),
                  if (daily.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      daily.description,
                      style: PixelTypography.standardBody(
                        fontSize: 10,
                        color: PixelColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 16,
                color: PixelColors.textMuted,
              ),
              color: PixelColors.backgroundSurface,
              onSelected: (val) {
                if (val == 'delete') onDelete(daily.id);
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete Daily',
                    style: PixelTypography.pixelSubheader(
                      fontSize: 9,
                      color: PixelColors.hpRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
