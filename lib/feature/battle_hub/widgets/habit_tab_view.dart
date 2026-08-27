import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'create_habit_dialog.dart';
import 'skill_buff_bar.dart';

class HabitTabView extends StatelessWidget {
  const HabitTabView({
    super.key,
    this.habits = const [],
    this.driftHabits = const [],
    this.buffs = const [],
    this.heroModel,
    this.hero,
    required this.onLogPositive,
    required this.onLogNegative,
    required this.onCastBuff,
    required this.onAdd,
    this.onEdit,
    required this.onDelete,
  });

  final List<HabitModel> habits;
  final List<Habit> driftHabits;
  final List<SkillBuffModel> buffs;
  final HeroModel? heroModel;
  final Hero? hero;
  final void Function(String id) onLogPositive;
  final void Function(String id) onLogNegative;
  final void Function(String buffId) onCastBuff;
  final void Function(HabitModel habit) onAdd;
  final void Function(HabitModel habit)? onEdit;
  final void Function(String id) onDelete;

  List<HabitModel> get _combinedHabits {
    if (habits.isNotEmpty) return habits;
    return driftHabits
        .map(
          (h) => HabitModel(
            id: h.id,
            title: h.title,
            hasPositive: h.isPositive,
            hasNegative: h.isNegative,
            positiveCountToday: h.positiveCount,
            negativeCountToday: h.negativeCount,
            totalPositiveCount: h.positiveCount,
            totalNegativeCount: h.negativeCount,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _combinedHabits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // MP Skill Buff Bar
        SkillBuffBar(
          buffs: buffs,
          heroModel: heroModel,
          hero: hero,
          onCastBuff: onCastBuff,
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HABITS (${list.length})',
              style: PixelTypography.pixelHeader(
                fontSize: 12,
                color: PixelColors.mpCyan,
              ),
            ),
            PixelButton(
              text: '+ HABIT',
              fontSize: 9,
              backgroundColor: PixelColors.mpCyan,
              textColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              onPressed: () async {
                final newHabit = await showDialog<HabitModel>(
                  context: context,
                  builder: (ctx) => const CreateHabitDialog(),
                );
                if (newHabit != null) onAdd(newHabit);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No Habits registered. Forge a new Habit above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...list.map((habit) => _buildHabitCard(context, habit)),
      ],
    );
  }

  Widget _buildHabitCard(BuildContext context, HabitModel habit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PixelCard(
        borderColor: PixelColors.borderHighlight,
        backgroundColor: PixelColors.backgroundCard,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: PixelTypography.readableTitle(
                      fontSize: 13,
                      color: PixelColors.textBright,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Row(
                    children: [
                      PixelBadge.attribute(habit.attributeTag),
                      const SizedBox(width: 8),
                      Text(
                        '+${habit.positiveCountToday} / -${habit.negativeCountToday} today',
                        style: PixelTypography.standardBody(
                          fontSize: 10,
                          color: PixelColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Positive Button
            if (habit.hasPositive) ...[
              PixelButton(
                key: Key('habit_pos_${habit.id}'),
                text: '+',
                fontSize: 12,
                backgroundColor: PixelColors.hpGreen,
                textColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                onPressed: () => onLogPositive(habit.id),
              ),
              const SizedBox(width: 6),
            ],
            // Negative Button
            if (habit.hasNegative) ...[
              PixelButton(
                key: Key('habit_neg_${habit.id}'),
                text: '-',
                fontSize: 12,
                backgroundColor: PixelColors.hpRed,
                textColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                onPressed: () => onLogNegative(habit.id),
              ),
              const SizedBox(width: 6),
            ],
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 16,
                color: PixelColors.textMuted,
              ),
              color: PixelColors.backgroundSurface,
              onSelected: (val) {
                if (val == 'delete') onDelete(habit.id);
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete Habit',
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
