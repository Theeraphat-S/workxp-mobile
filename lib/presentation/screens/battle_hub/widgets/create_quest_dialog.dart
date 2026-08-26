import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/domain/models/quest_model.dart';

class CreateQuestDialog extends StatefulWidget {
  const CreateQuestDialog({super.key, this.questToEdit});

  final QuestModel? questToEdit;

  @override
  State<CreateQuestDialog> createState() => _CreateQuestDialogState();
}

class _CreateQuestDialogState extends State<CreateQuestDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String _selectedRank = 'E';
  String _selectedAttribute = 'STR';

  final List<String> _ranks = ['E', 'D', 'C', 'B', 'A', 'S'];
  final List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.questToEdit?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.questToEdit?.description ?? '',
    );
    if (widget.questToEdit != null) {
      _selectedRank = widget.questToEdit!.rank;
      _selectedAttribute = widget.questToEdit!.attributeTag;
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
        borderColor: PixelColors.coinGold,
        backgroundColor: PixelColors.backgroundCard,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.questToEdit == null ? 'NEW QUEST' : 'EDIT QUEST',
                style: PixelTypography.pixelHeader(
                  fontSize: 14,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              // Title Field
              Text(
                'QUEST TITLE',
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
                  hintText: 'e.g. Slay the Code Refactor',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.coinGold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Description Field
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
                  hintText: 'Quest details or notes',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.coinGold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Rank Selection
              Text(
                'RANK TIER',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _ranks.map((r) {
                  final isSelected = r == _selectedRank;
                  return InkWell(
                    onTap: () => setState(() => _selectedRank = r),
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
                              ? PixelColors.coinGold
                              : PixelColors.borderDark,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: PixelBadge.rank(r),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Attribute Tag
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
                              ? PixelColors.coinGold
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
                    text: widget.questToEdit == null ? 'ACCEPT' : 'SAVE',
                    backgroundColor: PixelColors.coinGold,
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isEmpty) return;

                      final quest = widget.questToEdit != null
                          ? widget.questToEdit!.copyWith(
                              title: title,
                              description: _descController.text.trim(),
                              rank: _selectedRank,
                              attributeTag: _selectedAttribute,
                            )
                          : QuestModel(
                              title: title,
                              description: _descController.text.trim(),
                              rank: _selectedRank,
                              attributeTag: _selectedAttribute,
                            );

                      Navigator.of(context).pop(quest);
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
