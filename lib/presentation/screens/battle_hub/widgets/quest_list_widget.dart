import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'create_quest_dialog.dart';

class QuestListWidget extends StatefulWidget {
  const QuestListWidget({
    super.key,
    required this.quests,
    required this.onComplete,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<QuestModel> quests;
  final void Function(String questId) onComplete;
  final void Function(QuestModel quest) onAdd;
  final void Function(QuestModel quest) onEdit;
  final void Function(String questId) onDelete;

  @override
  State<QuestListWidget> createState() => _QuestListWidgetState();
}

class _QuestListWidgetState extends State<QuestListWidget> {
  String _selectedFilter = 'ALL';

  List<QuestModel> get _filteredQuests {
    if (_selectedFilter == 'ALL') return widget.quests;
    return widget.quests
        .where(
          (q) => q.rank == _selectedFilter || q.attributeTag == _selectedFilter,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeQuests = _filteredQuests.where((q) => !q.isCompleted).toList();
    final completedQuests = _filteredQuests
        .where((q) => q.isCompleted)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'QUEST BOARD (${activeQuests.length})',
              style: PixelTypography.pixelHeader(
                fontSize: 12,
                color: PixelColors.coinGold,
              ),
            ),
            PixelButton(
              text: '+ NEW QUEST',
              fontSize: 9,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              onPressed: () async {
                final newQuest = await showDialog<QuestModel>(
                  context: context,
                  builder: (ctx) => const CreateQuestDialog(),
                );
                if (newQuest != null) {
                  widget.onAdd(newQuest);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Filter bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                  'ALL',
                  'E',
                  'D',
                  'C',
                  'B',
                  'A',
                  'S',
                  'STR',
                  'INT',
                  'AGI',
                  'VIT',
                  'WIS',
                ].map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? PixelColors.coinGold
                              : PixelColors.backgroundSurface,
                          border: Border.all(
                            color: isSelected
                                ? PixelColors.coinAmber
                                : PixelColors.borderDark,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: PixelTypography.pixelSubheader(
                            fontSize: 9,
                            color: isSelected
                                ? PixelColors.textDark
                                : PixelColors.textBright,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (activeQuests.isEmpty && completedQuests.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No Quests found. Forge a new Quest above!',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        // Active Quests
        ...activeQuests.map((quest) => _buildQuestCard(quest)),
        // Completed Section
        if (completedQuests.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'COMPLETED (${completedQuests.length})',
            style: PixelTypography.pixelHeader(
              fontSize: 10,
              color: PixelColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          ...completedQuests.map((quest) => _buildQuestCard(quest)),
        ],
      ],
    );
  }

  Widget _buildQuestCard(QuestModel quest) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PixelCard(
        borderColor: quest.isCompleted
            ? PixelColors.borderDark
            : PixelColors.borderHighlight,
        backgroundColor: quest.isCompleted
            ? PixelColors.backgroundSurface.withAlpha(120)
            : PixelColors.backgroundCard,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Complete Checkbox Button
            InkWell(
              onTap: quest.isCompleted
                  ? null
                  : () => widget.onComplete(quest.id),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: quest.isCompleted
                      ? PixelColors.hpGreen
                      : PixelColors.backgroundSurface,
                  border: Border.all(
                    color: quest.isCompleted
                        ? PixelColors.hpGreen
                        : PixelColors.coinGold,
                    width: 2,
                  ),
                ),
                child: quest.isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.black)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Quest Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: PixelTypography.pixelSubheader(
                      fontSize: 11,
                      color: quest.isCompleted
                          ? PixelColors.textMuted
                          : PixelColors.textBright,
                    ),
                  ),
                  if (quest.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      quest.description,
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
                      PixelBadge.rank(quest.rank),
                      const SizedBox(width: 6),
                      PixelBadge.attribute(quest.attributeTag),
                      const SizedBox(width: 8),
                      Text(
                        '⚔ ${QuestModel.baseDamageForRank(quest.rank)} DMG',
                        style: PixelTypography.pixelBody(
                          fontSize: 12,
                          color: PixelColors.hpRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            if (!quest.isCompleted) ...[
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                  color: PixelColors.textMuted,
                ),
                onPressed: () async {
                  final edited = await showDialog<QuestModel>(
                    context: context,
                    builder: (ctx) => CreateQuestDialog(questToEdit: quest),
                  );
                  if (edited != null) widget.onEdit(edited);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: PixelColors.hpRed,
                ),
                onPressed: () => widget.onDelete(quest.id),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
