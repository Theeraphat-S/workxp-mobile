import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';

class CreateDailyQuestDialog extends StatefulWidget {
  const CreateDailyQuestDialog({super.key, this.dailyToEdit});

  final DailyQuestModel? dailyToEdit;

  @override
  State<CreateDailyQuestDialog> createState() => _CreateDailyQuestDialogState();
}

class _CreateDailyQuestDialogState extends State<CreateDailyQuestDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String _selectedAttribute = 'VIT';

  final List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.dailyToEdit?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.dailyToEdit?.description ?? '',
    );
    if (widget.dailyToEdit != null) {
      _selectedAttribute = widget.dailyToEdit!.attributeTag;
    }
  }

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
      child: PixelCard(
        borderColor: PixelColors.hpGreen,
        backgroundColor: PixelColors.backgroundCard,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.dailyToEdit == null ? 'NEW DAILY QUEST' : 'EDIT DAILY',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.hpGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'DAILY ROUTINE TITLE',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _titleController,
                style: PixelTypography.standardBody(
                  color: PixelColors.textBright,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: PixelColors.backgroundSurface,
                  hintText: 'e.g. 30 Mins Workout or Read 10 Pages',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.hpGreen),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'DESCRIPTION',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _descController,
                maxLines: 2,
                style: PixelTypography.standardBody(
                  color: PixelColors.textBright,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: PixelColors.backgroundSurface,
                  hintText: 'Routine details',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.hpGreen),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ATTRIBUTE FOCUS',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
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
                            ? PixelColors.backgroundElevated
                            : PixelColors.backgroundSurface,
                        border: Border.all(
                          color: isSelected
                              ? PixelColors.hpGreen
                              : PixelColors.borderDark,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: PixelBadge.attribute(attr),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    text: 'CANCEL',
                    backgroundColor: PixelColors.backgroundSurface,
                    textColor: PixelColors.textMuted,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    text: widget.dailyToEdit == null ? 'CREATE' : 'SAVE',
                    backgroundColor: PixelColors.hpGreen,
                    textColor: Colors.black,
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isEmpty) return;

                      final daily = widget.dailyToEdit != null
                          ? widget.dailyToEdit!.copyWith(
                              title: title,
                              description: _descController.text.trim(),
                              attributeTag: _selectedAttribute,
                            )
                          : DailyQuestModel(
                              title: title,
                              description: _descController.text.trim(),
                              attributeTag: _selectedAttribute,
                            );

                      Navigator.of(context).pop(daily);
                    },
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
