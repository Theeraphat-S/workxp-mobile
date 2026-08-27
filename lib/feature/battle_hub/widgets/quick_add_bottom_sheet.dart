import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';

enum QuickAddType { quest, daily, habit }

class QuickAddResult {
  const QuickAddResult({this.quest, this.daily, this.habit});

  final QuestModel? quest;
  final DailyQuestModel? daily;
  final HabitModel? habit;
}

class QuickAddBottomSheet extends StatefulWidget {
  const QuickAddBottomSheet({super.key, this.initialType = QuickAddType.quest});

  final QuickAddType initialType;

  static Future<QuickAddResult?> show(
    BuildContext context, {
    QuickAddType initialType = QuickAddType.quest,
  }) {
    return showModalBottomSheet<QuickAddResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QuickAddBottomSheet(initialType: initialType),
    );
  }

  @override
  State<QuickAddBottomSheet> createState() => _QuickAddBottomSheetState();
}

class _QuickAddBottomSheetState extends State<QuickAddBottomSheet> {
  late QuickAddType _selectedType;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  // Quest options
  String _selectedRank = 'D'; // Smart default: D (50 DMG / 25 EXP)
  String _selectedAttribute = 'STR';
  bool _isDueToday = true;
  bool _isAdvancedMode = false;

  // Habit options
  bool _habitHasPositive = true;
  bool _habitHasNegative = false;

  static const List<String> _ranks = ['E', 'D', 'C', 'B', 'A', 'S'];
  static const List<String> _attributes = ['STR', 'INT', 'AGI', 'VIT', 'WIS'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final id = const Uuid().v4();

    if (_selectedType == QuickAddType.quest) {
      final newQuest = QuestModel(
        id: id,
        title: title,
        description: _descController.text.trim(),
        rank: _selectedRank,
        attributeTag: _selectedAttribute,
        dueDate: _isDueToday ? DateTime.now() : null,
      );
      Navigator.of(context).pop(QuickAddResult(quest: newQuest));
    } else if (_selectedType == QuickAddType.daily) {
      final newDaily = DailyQuestModel(
        id: id,
        title: title,
        description: _descController.text.trim(),
        attributeTag: _selectedAttribute,
      );
      Navigator.of(context).pop(QuickAddResult(daily: newDaily));
    } else {
      final newHabit = HabitModel(
        id: id,
        title: title,
        hasPositive: _habitHasPositive,
        hasNegative: _habitHasNegative,
        attributeTag: _selectedAttribute,
      );
      Navigator.of(context).pop(QuickAddResult(habit: newHabit));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;

    final baseDmg = QuestModel.baseDamageForRank(_selectedRank);
    final expReward = QuestModel.expRewardForRank(_selectedRank);

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        decoration: const BoxDecoration(
          color: PixelColors.backgroundDark,
          border: Border(
            top: BorderSide(color: PixelColors.borderGold, width: 3),
            left: BorderSide(color: PixelColors.borderGold, width: 2),
            right: BorderSide(color: PixelColors.borderGold, width: 2),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top drag pill & Type selector
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: PixelColors.borderHighlight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Segmented Category Tabs
              Container(
                decoration: BoxDecoration(
                  color: PixelColors.backgroundSurface,
                  border: Border.all(color: PixelColors.borderDark),
                ),
                child: Row(
                  children: [
                    _buildCategoryButton(
                      QuickAddType.quest,
                      'QUEST',
                      PixelColors.coinGold,
                    ),
                    _buildCategoryButton(
                      QuickAddType.daily,
                      'DAILY',
                      PixelColors.hpGreen,
                    ),
                    _buildCategoryButton(
                      QuickAddType.habit,
                      'HABIT',
                      PixelColors.mpCyan,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Title Input Field
              Text(
                _selectedType == QuickAddType.quest
                    ? 'QUEST CONTRACT'
                    : _selectedType == QuickAddType.daily
                    ? 'DAILY ROUTINE'
                    : 'HABIT BEHAVIOR',
                style: PixelTypography.pixelHeader(
                  fontSize: 10,
                  color: _selectedType == QuickAddType.quest
                      ? PixelColors.coinGold
                      : _selectedType == QuickAddType.daily
                      ? PixelColors.hpGreen
                      : PixelColors.mpCyan,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('quick_add_title_input'),
                controller: _titleController,
                autofocus: true,
                style: PixelTypography.readableTitle(
                  fontSize: 14,
                  color: PixelColors.textBright,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: _selectedType == QuickAddType.quest
                      ? 'e.g. Finish Sprint Report or Clean Desk'
                      : _selectedType == QuickAddType.daily
                      ? 'e.g. Read 10 pages or Morning Workout'
                      : 'e.g. Drink Water (+), Midnight Snacking (-)',
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
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 1-Tap Attribute Selector Chips
              Text(
                'ATTRIBUTE FOCUS',
                style: PixelTypography.pixelSubheader(
                  fontSize: 8,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _attributes.map((attr) {
                    final isSelected = attr == _selectedAttribute;
                    final attrColor = PixelBadge.colorForAttribute(attr);
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => setState(() => _selectedAttribute = attr),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? attrColor.withAlpha(50)
                                : PixelColors.backgroundSurface,
                            border: Border.all(
                              color: isSelected
                                  ? attrColor
                                  : PixelColors.borderDark,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            attr,
                            style: PixelTypography.pixelSubheader(
                              fontSize: 9,
                              color: isSelected
                                  ? attrColor
                                  : PixelColors.textBright,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Type-specific quick controls
              if (_selectedType == QuickAddType.quest) ...[
                // Due Today Switch & Reward Preview
                Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isDueToday = !_isDueToday),
                      child: Row(
                        children: [
                          Icon(
                            _isDueToday
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: _isDueToday
                                ? PixelColors.coinGold
                                : PixelColors.textMuted,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Due Today',
                            style: PixelTypography.standardBody(
                              fontSize: 12,
                              color: PixelColors.textBright,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Smart Default Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      color: PixelBadge.colorForRank(
                        _selectedRank,
                      ).withAlpha(40),
                      child: Text(
                        'RANK $_selectedRank (+$baseDmg DMG / +$expReward EXP)',
                        style: PixelTypography.pixelHeader(
                          fontSize: 8,
                          color: PixelBadge.colorForRank(_selectedRank),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (_selectedType == QuickAddType.habit) ...[
                // Habit + and - toggles
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(
                          () => _habitHasPositive = !_habitHasPositive,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _habitHasPositive
                                ? PixelColors.hpGreen.withAlpha(40)
                                : PixelColors.backgroundSurface,
                            border: Border.all(
                              color: _habitHasPositive
                                  ? PixelColors.hpGreen
                                  : PixelColors.borderDark,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _habitHasPositive ? Icons.check : Icons.add,
                                color: PixelColors.hpGreen,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Positive (+)',
                                style: PixelTypography.pixelSubheader(
                                  fontSize: 8,
                                  color: PixelColors.hpGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(
                          () => _habitHasNegative = !_habitHasNegative,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _habitHasNegative
                                ? PixelColors.hpRed.withAlpha(40)
                                : PixelColors.backgroundSurface,
                            border: Border.all(
                              color: _habitHasNegative
                                  ? PixelColors.hpRed
                                  : PixelColors.borderDark,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _habitHasNegative ? Icons.check : Icons.remove,
                                color: PixelColors.hpRed,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Negative (-)',
                                style: PixelTypography.pixelSubheader(
                                  fontSize: 8,
                                  color: PixelColors.hpRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),

              // Expandable Advanced Options Toggle
              InkWell(
                onTap: () => setState(() => _isAdvancedMode = !_isAdvancedMode),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isAdvancedMode ? Icons.expand_less : Icons.tune,
                        size: 14,
                        color: PixelColors.coinAmber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isAdvancedMode
                            ? 'Hide Advanced Options'
                            : 'More Options (Rank, Notes)',
                        style: PixelTypography.pixelSubheader(
                          fontSize: 8,
                          color: PixelColors.coinAmber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Advanced Options Body
              if (_isAdvancedMode) ...[
                const SizedBox(height: 8),
                if (_selectedType == QuickAddType.quest) ...[
                  Text(
                    'DIFFICULTY RANK',
                    style: PixelTypography.pixelSubheader(
                      fontSize: 8,
                      color: PixelColors.textBright,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _ranks.map((rank) {
                      final isSelected = rank == _selectedRank;
                      return InkWell(
                        onTap: () => setState(() => _selectedRank = rank),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
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
                              fontSize: 10,
                              color: PixelBadge.colorForRank(rank),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  key: const Key('quick_add_desc_input'),
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
              ],
              const SizedBox(height: 14),

              // Action Buttons (Cancel / Quick Create)
              Row(
                children: [
                  Expanded(
                    child: PixelButton(
                      text: 'CANCEL',
                      backgroundColor: PixelColors.backgroundSurface,
                      textColor: PixelColors.textMuted,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: PixelButton(
                      key: const Key('quick_add_submit_btn'),
                      text: '⚡ QUICK CREATE',
                      backgroundColor: _selectedType == QuickAddType.quest
                          ? PixelColors.coinGold
                          : _selectedType == QuickAddType.daily
                          ? PixelColors.hpGreen
                          : PixelColors.mpCyan,
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: _submit,
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

  Widget _buildCategoryButton(
    QuickAddType type,
    String label,
    Color accentColor,
  ) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? accentColor.withAlpha(40) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? accentColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: PixelTypography.pixelSubheader(
                fontSize: 9,
                color: isSelected ? accentColor : PixelColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
