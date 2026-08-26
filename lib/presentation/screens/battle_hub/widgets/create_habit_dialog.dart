import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/domain/models/habit_model.dart';

class CreateHabitDialog extends StatefulWidget {
  const CreateHabitDialog({super.key, this.habitToEdit});

  final HabitModel? habitToEdit;

  @override
  State<CreateHabitDialog> createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  late TextEditingController _titleController;
  bool _hasPositive = true;
  bool _hasNegative = false;
  String _selectedAttribute = 'WIS';

  final List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.habitToEdit?.title ?? '',
    );
    if (widget.habitToEdit != null) {
      _hasPositive = widget.habitToEdit!.hasPositive;
      _hasNegative = widget.habitToEdit!.hasNegative;
      _selectedAttribute = widget.habitToEdit!.attributeTag;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelCard(
        borderColor: PixelColors.mpCyan,
        backgroundColor: PixelColors.backgroundCard,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.habitToEdit == null ? 'NEW HABIT' : 'EDIT HABIT',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.mpCyan,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'HABIT TITLE',
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
                  hintText: 'e.g. Meditate, Avoid Junk Food',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.mpCyan),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'TRACKING ACTIONS',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        '(+) Positive',
                        style: PixelTypography.pixelSubheader(
                          fontSize: 10,
                          color: PixelColors.hpGreen,
                        ),
                      ),
                      value: _hasPositive,
                      activeColor: PixelColors.hpGreen,
                      onChanged: (val) =>
                          setState(() => _hasPositive = val ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        '(-) Negative',
                        style: PixelTypography.pixelSubheader(
                          fontSize: 10,
                          color: PixelColors.hpRed,
                        ),
                      ),
                      value: _hasNegative,
                      activeColor: PixelColors.hpRed,
                      onChanged: (val) =>
                          setState(() => _hasNegative = val ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
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
                              ? PixelColors.mpCyan
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
                    text: widget.habitToEdit == null ? 'CREATE' : 'SAVE',
                    backgroundColor: PixelColors.mpCyan,
                    textColor: Colors.black,
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isEmpty || (!_hasPositive && !_hasNegative)) {
                        return;
                      }

                      final habit = widget.habitToEdit != null
                          ? widget.habitToEdit!.copyWith(
                              title: title,
                              hasPositive: _hasPositive,
                              hasNegative: _hasNegative,
                              attributeTag: _selectedAttribute,
                            )
                          : HabitModel(
                              title: title,
                              hasPositive: _hasPositive,
                              hasNegative: _hasNegative,
                              attributeTag: _selectedAttribute,
                            );

                      Navigator.of(context).pop(habit);
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
