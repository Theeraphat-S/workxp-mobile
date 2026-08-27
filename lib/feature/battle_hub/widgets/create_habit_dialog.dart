import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class CreateHabitDialog extends StatefulWidget {
  const CreateHabitDialog({super.key});

  @override
  State<CreateHabitDialog> createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  final _titleController = TextEditingController();
  bool _hasPositive = true;
  bool _hasNegative = false;
  String _selectedAttribute = 'WIS';

  static const List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: PixelCard(
        borderColor: PixelColors.borderGold,
        backgroundColor: PixelColors.backgroundDark,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'NEW HABIT TRIGGER',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // Title Field
              Text(
                'HABIT NAME',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('habit_title_input'),
                controller: _titleController,
                style: PixelTypography.standardBody(
                  fontSize: 13,
                  color: PixelColors.textBright,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Drink 1 Glass of Fresh Water',
                  hintStyle: PixelTypography.standardBody(
                    fontSize: 12,
                    color: PixelColors.textMuted,
                  ),
                  filled: true,
                  fillColor: PixelColors.backgroundSurface,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: PixelColors.borderHighlight,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Direction Toggles (+ and/or -)
              Text(
                'HABIT TYPE / DIRECTION',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          setState(() => _hasPositive = !_hasPositive),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _hasPositive
                              ? PixelColors.hpGreen.withAlpha(40)
                              : PixelColors.backgroundSurface,
                          border: Border.all(
                            color: _hasPositive
                                ? PixelColors.hpGreen
                                : PixelColors.borderDark,
                            width: _hasPositive ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _hasPositive
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 16,
                              color: _hasPositive
                                  ? PixelColors.hpGreen
                                  : PixelColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '+ POSITIVE\n(+10c, +15 MP)',
                              style: PixelTypography.pixelSubheader(
                                fontSize: 8,
                                color: _hasPositive
                                    ? PixelColors.hpGreen
                                    : PixelColors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          setState(() => _hasNegative = !_hasNegative),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _hasNegative
                              ? PixelColors.hpRed.withAlpha(40)
                              : PixelColors.backgroundSurface,
                          border: Border.all(
                            color: _hasNegative
                                ? PixelColors.hpRed
                                : PixelColors.borderDark,
                            width: _hasNegative ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _hasNegative
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 16,
                              color: _hasNegative
                                  ? PixelColors.hpRed
                                  : PixelColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '- NEGATIVE\n(-10c, -15 MP)',
                              style: PixelTypography.pixelSubheader(
                                fontSize: 8,
                                color: _hasNegative
                                    ? PixelColors.hpRed
                                    : PixelColors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Attribute Focus
              Text(
                'ATTRIBUTE FOCUS',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _attributes.map((attr) {
                  final isSelected = attr == _selectedAttribute;
                  return InkWell(
                    onTap: () => setState(() => _selectedAttribute = attr),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PixelBadge.colorForAttribute(attr).withAlpha(50)
                            : PixelColors.backgroundSurface,
                        border: Border.all(
                          color: isSelected
                              ? PixelBadge.colorForAttribute(attr)
                              : PixelColors.borderDark,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        attr,
                        style: PixelTypography.pixelSubheader(
                          fontSize: 9,
                          color: PixelBadge.colorForAttribute(attr),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: PixelButton(
                      text: 'CANCEL',
                      backgroundColor: PixelColors.backgroundSurface,
                      textColor: PixelColors.textMuted,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PixelButton(
                      key: const Key('submit_habit_btn'),
                      text: 'CREATE',
                      backgroundColor: PixelColors.coinGold,
                      textColor: Colors.black,
                      onPressed: () {
                        final title = _titleController.text.trim();
                        if (title.isEmpty || (!_hasPositive && !_hasNegative)) {
                          return;
                        }

                        final newHabit = HabitModel(
                          id: const Uuid().v4(),
                          title: title,
                          hasPositive: _hasPositive,
                          hasNegative: _hasNegative,
                          attributeTag: _selectedAttribute,
                        );
                        Navigator.of(context).pop(newHabit);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
