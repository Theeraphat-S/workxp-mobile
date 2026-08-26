import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'create_daily_quest_dialog.dart';

class DailyQuestTabView extends StatelessWidget {
  const DailyQuestTabView({
    super.key,
    required this.dailies,
    required this.onToggle,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<DailyQuestModel> dailies;
  final void Function(String id) onToggle;
  final void Function(DailyQuestModel daily) onAdd;
  final void Function(DailyQuestModel daily) onEdit;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    final totalCompletedToday = dailies.where((d) => d.isCompletedToday).length;
    final allDone = dailies.isNotEmpty && totalCompletedToday == dailies.length;

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
                      '$totalCompletedToday / ${dailies.length} completed today. Protects HP at midnight!',
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
        if (dailies.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No Daily Quests set. Add your daily habits above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...dailies.map((daily) => _buildDailyCard(context, daily)),
      ],
    );
  }

  Widget _buildDailyCard(BuildContext context, DailyQuestModel daily) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PixelCard(
        borderColor: daily.isCompletedToday
            ? PixelColors.hpGreen
            : PixelColors.borderHighlight,
        backgroundColor: daily.isCompletedToday
            ? PixelColors.backgroundSurface.withAlpha(120)
            : PixelColors.backgroundCard,
        child: Row(
          children: [
            InkWell(
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
                        : PixelColors.coinGold,
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
                        fontSize: 11,
                        color: PixelColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      PixelBadge.attribute(daily.attributeTag),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.local_fire_department,
                        size: 14,
                        color: PixelColors.coinAmber,
                      ),
                      Text(
                        '${daily.streak} STREAK',
                        style: PixelTypography.pixelHeader(
                          fontSize: 8,
                          color: PixelColors.coinAmber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 16,
                color: PixelColors.textMuted,
              ),
              onPressed: () async {
                final edited = await showDialog<DailyQuestModel>(
                  context: context,
                  builder: (ctx) => CreateDailyQuestDialog(dailyToEdit: daily),
                );
                if (edited != null) onEdit(edited);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 16,
                color: PixelColors.hpRed,
              ),
              onPressed: () => onDelete(daily.id),
            ),
          ],
        ),
      ),
    );
  }
}
