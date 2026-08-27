import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class CreateDailyQuestDialog extends StatefulWidget {
  const CreateDailyQuestDialog({super.key});

  @override
  State<CreateDailyQuestDialog> createState() => _CreateDailyQuestDialogState();
}

class _CreateDailyQuestDialogState extends State<CreateDailyQuestDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedAttribute = 'VIT';

  static const List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
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
                'NEW DAILY ROUTINE',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // Title Field
              Text(
                'ROUTINE TITLE',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('daily_title_input'),
                controller: _titleController,
                style: PixelTypography.standardBody(
                  fontSize: 13,
                  color: PixelColors.textBright,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 30 Minutes Morning Workout',
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
              const SizedBox(height: 12),

              // Description Field
              Text(
                'DESCRIPTION (OPTIONAL)',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('daily_desc_input'),
                controller: _descController,
                maxLines: 2,
                style: PixelTypography.standardBody(
                  fontSize: 12,
                  color: PixelColors.textBright,
                ),
                decoration: InputDecoration(
                  hintText: 'Notes on streak target and routine...',
                  hintStyle: PixelTypography.standardBody(
                    fontSize: 11,
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
              const SizedBox(height: 12),

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
              const SizedBox(height: 14),

              // Midnight Penalty Warning
              Container(
                padding: const EdgeInsets.all(8),
                color: PixelColors.hpBackground.withAlpha(50),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: PixelColors.hpRed,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Failing to complete before midnight deals -15 HP Boss Counter-Damage!',
                        style: PixelTypography.standardBody(
                          fontSize: 10,
                          color: PixelColors.hpRed,
                        ),
                      ),
                    ),
                  ],
                ),
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
                      key: const Key('submit_daily_btn'),
                      text: 'CREATE',
                      backgroundColor: PixelColors.coinGold,
                      textColor: Colors.black,
                      onPressed: () {
                        final title = _titleController.text.trim();
                        if (title.isEmpty) return;

                        final newDaily = DailyQuestModel(
                          id: const Uuid().v4(),
                          title: title,
                          description: _descController.text.trim(),
                          attributeTag: _selectedAttribute,
                        );
                        Navigator.of(context).pop(newDaily);
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
