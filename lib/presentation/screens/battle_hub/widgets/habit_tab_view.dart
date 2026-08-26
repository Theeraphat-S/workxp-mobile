import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'create_habit_dialog.dart';
import 'skill_buff_bar.dart';

class HabitTabView extends StatelessWidget {
  const HabitTabView({
    super.key,
    required this.habits,
    required this.buffs,
    required this.hero,
    required this.onLogPositive,
    required this.onLogNegative,
    required this.onCastBuff,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<HabitModel> habits;
  final List<SkillBuffModel> buffs;
  final HeroModel hero;
  final void Function(String id) onLogPositive;
  final void Function(String id) onLogNegative;
  final void Function(String buffId) onCastBuff;
  final void Function(HabitModel habit) onAdd;
  final void Function(HabitModel habit) onEdit;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // MP Skill Buff Bar
        SkillBuffBar(buffs: buffs, hero: hero, onCastBuff: onCastBuff),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HABITS (${habits.length})',
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
        if (habits.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No Habits registered. Forge a new Habit above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...habits.map((habit) => _buildHabitCard(context, habit)),
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
                    style: PixelTypography.pixelSubheader(
                      fontSize: 11,
                      color: PixelColors.textBright,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      PixelBadge.attribute(habit.attributeTag),
                      const SizedBox(width: 8),
                      Text(
                        '+${habit.positiveCountToday} | -${habit.negativeCountToday} Today',
                        style: PixelTypography.pixelBody(
                          fontSize: 11,
                          color: PixelColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // (-) Button
            if (habit.hasNegative)
              PixelButton(
                text: '-',
                fontSize: 13,
                backgroundColor: PixelColors.hpRed,
                textColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                onPressed: () => onLogNegative(habit.id),
              ),
            if (habit.hasNegative && habit.hasPositive)
              const SizedBox(width: 6),
            // (+) Button
            if (habit.hasPositive)
              PixelButton(
                text: '+',
                fontSize: 13,
                backgroundColor: PixelColors.hpGreen,
                textColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                onPressed: () => onLogPositive(habit.id),
              ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 16,
                color: PixelColors.textMuted,
              ),
              onPressed: () async {
                final edited = await showDialog<HabitModel>(
                  context: context,
                  builder: (ctx) => CreateHabitDialog(habitToEdit: habit),
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
              onPressed: () => onDelete(habit.id),
            ),
          ],
        ),
      ),
    );
  }
}
