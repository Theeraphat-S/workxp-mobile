import 'package:flutter/material.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'create_quest_dialog.dart';

class QuestListWidget extends StatefulWidget {
  const QuestListWidget({
    super.key,
    this.quests = const [],
    this.driftQuests = const [],
    required this.onComplete,
    required this.onAdd,
    this.onEdit,
    required this.onDelete,
  });

  final List<QuestModel> quests;
  final List<Quest> driftQuests;
  final void Function(String questId) onComplete;
  final void Function(QuestModel quest) onAdd;
  final void Function(QuestModel quest)? onEdit;
  final void Function(String questId) onDelete;

  @override
  State<QuestListWidget> createState() => _QuestListWidgetState();
}

class _QuestListWidgetState extends State<QuestListWidget> {
  String _selectedFilter = 'ALL';

  List<QuestModel> get _combinedQuests {
    if (widget.quests.isNotEmpty) return widget.quests;
    return widget.driftQuests
        .map((q) => QuestModel(
              id: q.id,
              title: q.title,
              description: q.description,
              rank: q.rank,
              isCompleted: q.isCompleted,
            ))
        .toList();
  }

  List<QuestModel> get _filteredQuests {
    final list = _combinedQuests;
    if (_selectedFilter == 'ALL') return list;
    return list
        .where(
          (q) => q.rank == _selectedFilter || q.attributeTag == _selectedFilter,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeQuests = _filteredQuests.where((q) => !q.isCompleted).toList();
    final completedQuests =
        _filteredQuests.where((q) => q.isCompleted).toList();

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
            children: [
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
                            ? PixelColors.borderGold
                            : PixelColors.borderDark,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: PixelTypography.pixelSubheader(
                        fontSize: 9,
                        color: isSelected
                            ? Colors.black
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

        // Active Quests
        if (activeQuests.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No active Quests in this category.',
                style: TextStyle(color: PixelColors.textMuted),
              ),
            ),
          ),
        ...activeQuests.map((quest) => _buildQuestCard(quest, false)),

        // Completed Section
        if (completedQuests.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'COMPLETED QUESTS (${completedQuests.length})',
            style: PixelTypography.pixelHeader(
              fontSize: 10,
              color: PixelColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          ...completedQuests.map((quest) => _buildQuestCard(quest, true)),
        ],
      ],
    );
  }

  Widget _buildQuestCard(QuestModel quest, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PixelCard(
        borderColor: isCompleted
            ? PixelColors.borderHighlight.withAlpha(80)
            : PixelBadge.colorForRank(quest.rank),
        backgroundColor: isCompleted
            ? PixelColors.backgroundDark
            : PixelColors.backgroundCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PixelBadge.rank(quest.rank),
                const SizedBox(width: 6),
                PixelBadge.attribute(quest.attributeTag),
                const Spacer(),
                if (!isCompleted) ...[
                  Text(
                    'DMG: ${quest.baseDamage}',
                    style: PixelTypography.pixelSubheader(
                      fontSize: 9,
                      color: PixelColors.bossHealth,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'EXP: +${quest.expReward}',
                    style: PixelTypography.pixelSubheader(
                      fontSize: 9,
                      color: PixelColors.expPink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${quest.coinReward}c',
                    style: PixelTypography.pixelSubheader(
                      fontSize: 9,
                      color: PixelColors.coinGold,
                    ),
                  ),
                ],
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: PixelColors.textMuted,
                  ),
                  color: PixelColors.backgroundSurface,
                  onSelected: (val) {
                    if (val == 'delete') {
                      widget.onDelete(quest.id);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete Quest',
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
            const SizedBox(height: 8),
            Text(
              quest.title,
              style: PixelTypography.pixelSubheader(
                fontSize: 11,
                color: isCompleted
                    ? PixelColors.textMuted
                    : PixelColors.textBright,
              ),
            ),
            if (quest.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                quest.description,
                style: PixelTypography.standardBody(
                  fontSize: 11,
                  color: PixelColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (!isCompleted)
              PixelButton(
                key: Key('complete_quest_${quest.id}'),
                text: 'COMPLETE STRIKE (Deal ${quest.baseDamage} DMG)',
                backgroundColor: PixelBadge.colorForRank(quest.rank),
                textColor: Colors.black,
                isFullWidth: true,
                fontSize: 9,
                padding: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () => widget.onComplete(quest.id),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: PixelColors.hpGreen.withAlpha(30),
                child: Center(
                  child: Text(
                    'COMPLETED',
                    style: PixelTypography.pixelHeader(
                      fontSize: 8,
                      color: PixelColors.hpGreen,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
