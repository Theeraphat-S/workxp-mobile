import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class CreateQuestDialog extends StatefulWidget {
  const CreateQuestDialog({super.key});

  @override
  State<CreateQuestDialog> createState() => _CreateQuestDialogState();
}

class _CreateQuestDialogState extends State<CreateQuestDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedRank = 'E';
  String _selectedAttribute = 'STR';
  DateTime? _selectedDueDate;

  static const List<String> _ranks = ['E', 'D', 'C', 'B', 'A', 'S'];
  static const List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseDmg = QuestModel.baseDamageForRank(_selectedRank);
    final expReward = QuestModel.expRewardForRank(_selectedRank);
    final coinReward = QuestModel.coinRewardForRank(_selectedRank);

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
                'NEW QUEST CONTRACT',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // Title Field
              Text(
                'QUEST TITLE',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('quest_title_input'),
                controller: _titleController,
                style: PixelTypography.standardBody(
                  fontSize: 13,
                  color: PixelColors.textBright,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Clean battle station & organize scrolls',
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
                key: const Key('quest_desc_input'),
                controller: _descController,
                maxLines: 2,
                style: PixelTypography.standardBody(
                  fontSize: 12,
                  color: PixelColors.textBright,
                ),
                decoration: InputDecoration(
                  hintText: 'Additional notes or requirements...',
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

              // Rank Tier Picker
              Text(
                'DIFFICULTY RANK',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.textBright,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _ranks.map((rank) {
                  final isSelected = rank == _selectedRank;
                  return InkWell(
                    onTap: () => setState(() => _selectedRank = rank),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PixelBadge.colorForRank(rank).withAlpha(50)
                            : PixelColors.backgroundSurface,
                        border: Border.all(
                          color: isSelected
                              ? PixelBadge.colorForRank(rank)
                              : PixelColors.borderDark,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        rank,
                        style: PixelTypography.pixelHeader(
                          fontSize: 11,
                          color: PixelBadge.colorForRank(rank),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Attribute Tag Picker
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

              // Rewards & Damage Preview
              Container(
                padding: const EdgeInsets.all(8),
                color: PixelColors.backgroundSurface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'DMG',
                          style: PixelTypography.pixelSubheader(
                            fontSize: 8,
                            color: PixelColors.textMuted,
                          ),
                        ),
                        Text(
                          '+$baseDmg',
                          style: PixelTypography.pixelHeader(
                            fontSize: 10,
                            color: PixelColors.bossHealth,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'EXP',
                          style: PixelTypography.pixelSubheader(
                            fontSize: 8,
                            color: PixelColors.textMuted,
                          ),
                        ),
                        Text(
                          '+$expReward',
                          style: PixelTypography.pixelHeader(
                            fontSize: 10,
                            color: PixelColors.expPink,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'COINS',
                          style: PixelTypography.pixelSubheader(
                            fontSize: 8,
                            color: PixelColors.textMuted,
                          ),
                        ),
                        Text(
                          '+$coinReward',
                          style: PixelTypography.pixelHeader(
                            fontSize: 10,
                            color: PixelColors.coinGold,
                          ),
                        ),
                      ],
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
                      key: const Key('submit_quest_btn'),
                      text: 'CREATE',
                      backgroundColor: PixelColors.coinGold,
                      textColor: Colors.black,
                      onPressed: () {
                        final title = _titleController.text.trim();
                        if (title.isEmpty) return;

                        final newQuest = QuestModel(
                          id: const Uuid().v4(),
                          title: title,
                          description: _descController.text.trim(),
                          rank: _selectedRank,
                          attributeTag: _selectedAttribute,
                          dueDate: _selectedDueDate,
                        );
                        Navigator.of(context).pop(newQuest);
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
