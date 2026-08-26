import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/skill_buff_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'widgets/boss_encounter_card.dart';
import 'widgets/floating_combat_overlay.dart';
import 'widgets/quest_list_widget.dart';
import 'widgets/daily_quest_tab_view.dart';
import 'widgets/habit_tab_view.dart';
import 'widgets/revival_quest_dialog.dart';

class BattleHubScreen extends ConsumerStatefulWidget {
  const BattleHubScreen({super.key});

  @override
  ConsumerState<BattleHubScreen> createState() => _BattleHubScreenState();
}

class _BattleHubScreenState extends ConsumerState<BattleHubScreen> {
  int _activeCategoryIndex = 0; // 0 = Quests, 1 = Daily Quests, 2 = Habits
  int _floatingDamage = 0;

  void _triggerCombatSlash(int damage) {
    if (damage > 0) {
      setState(() {
        _floatingDamage = damage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hero = ref.watch(heroProvider);
    final dungeon = ref.watch(dungeonProvider);
    final quests = ref.watch(questProvider);
    final dailies = ref.watch(dailyQuestProvider);
    final habits = ref.watch(habitProvider);
    final buffs = ref.watch(skillBuffProvider);

    final heroNotifier = ref.read(heroProvider.notifier);
    final dungeonNotifier = ref.read(dungeonProvider.notifier);
    final questNotifier = ref.read(questProvider.notifier);
    final dailyNotifier = ref.read(dailyQuestProvider.notifier);
    final habitNotifier = ref.read(habitProvider.notifier);
    final buffNotifier = ref.read(skillBuffProvider.notifier);
    final analyticsNotifier = ref.read(analyticsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BATTLE HUB',
          style: PixelTypography.pixelHeader(
            fontSize: 14,
            color: PixelColors.coinGold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ghost State Warning Banner
                  if (hero.isGhost)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E242B),
                        border: Border.all(
                          color: PixelColors.ghostSpirit,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          const PixelSprite(
                            spriteType: 'hero_novice',
                            size: 32,
                            isGhost: true,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GHOST STATE ACTIVE',
                                  style: PixelTypography.pixelHeader(
                                    fontSize: 10,
                                    color: PixelColors.ghostSpirit,
                                  ),
                                ),
                                Text(
                                  'EXP & Coins paused until revived.',
                                  style: PixelTypography.pixelBody(
                                    fontSize: 11,
                                    color: PixelColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PixelButton(
                            text: 'REVIVE',
                            fontSize: 9,
                            backgroundColor: PixelColors.ghostSpirit,
                            textColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => RevivalQuestDialog(
                                  onRevive: () => heroNotifier.reviveHero(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                  // Top Hero Quick HUD
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PixelColors.backgroundCard,
                      border: Border.all(
                        color: hero.isGhost
                            ? PixelColors.ghostSpirit
                            : PixelColors.borderHighlight,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        PixelSprite(
                          spriteType: hero.activeSkinId,
                          size: 32,
                          isGhost: hero.isGhost,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LVL ${hero.level} ${hero.name}',
                              style: PixelTypography.pixelSubheader(
                                fontSize: 9,
                                color: PixelColors.coinGold,
                              ),
                            ),
                            Text(
                              'HP: ${hero.currentHp}/${hero.maxHp} | MP: ${hero.currentMp}/${hero.maxMp}',
                              style: PixelTypography.pixelBody(
                                fontSize: 11,
                                color: hero.isGhost
                                    ? PixelColors.ghostSpirit
                                    : PixelColors.hpGreen,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const PixelSprite(spriteType: 'coin', size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${hero.coins}',
                          style: PixelTypography.pixelHeader(
                            fontSize: 11,
                            color: PixelColors.coinGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Active Boss Card
                  BossEncounterCard(
                    boss: dungeon.activeBoss,
                    lastDamage: dungeon.lastDamageDealt,
                  ),
                  const SizedBox(height: 16),
                  // Category Tabs (Quests / Dailies / Habits)
                  Row(
                    children: [
                      _buildCategoryTab(
                        0,
                        'QUESTS (${quests.where((q) => !q.isCompleted).length})',
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryTab(
                        1,
                        'DAILIES (${dailies.where((d) => d.isCompletedToday).length}/${dailies.length})',
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryTab(2, 'HABITS (${habits.length})'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_activeCategoryIndex == 0)
                    QuestListWidget(
                      quests: quests,
                      onComplete: (id) {
                        final dmg = questNotifier.completeQuest(
                          id,
                          heroNotifier: heroNotifier,
                          dungeonNotifier: dungeonNotifier,
                          skillBuffNotifier: buffNotifier,
                          analyticsNotifier: analyticsNotifier,
                        );
                        _triggerCombatSlash(dmg);
                      },
                      onAdd: (q) => questNotifier.addQuest(q),
                      onEdit: (q) => questNotifier.editQuest(q),
                      onDelete: (id) => questNotifier.deleteQuest(id),
                    )
                  else if (_activeCategoryIndex == 1)
                    DailyQuestTabView(
                      dailies: dailies,
                      onToggle: (id) => dailyNotifier.toggleDailyQuest(
                        id,
                        heroNotifier: heroNotifier,
                        analyticsNotifier: analyticsNotifier,
                      ),
                      onAdd: (d) => dailyNotifier.addDailyQuest(d),
                      onEdit: (d) => dailyNotifier.editDailyQuest(d),
                      onDelete: (id) => dailyNotifier.deleteDailyQuest(id),
                    )
                  else
                    HabitTabView(
                      habits: habits,
                      buffs: buffs,
                      hero: hero,
                      onLogPositive: (id) => habitNotifier.logPositive(
                        id,
                        heroNotifier: heroNotifier,
                        analyticsNotifier: analyticsNotifier,
                      ),
                      onLogNegative: (id) => habitNotifier.logNegative(
                        id,
                        heroNotifier: heroNotifier,
                        analyticsNotifier: analyticsNotifier,
                      ),
                      onCastBuff: (buffId) => buffNotifier.castBuff(
                        buffId,
                        heroNotifier: heroNotifier,
                      ),
                      onAdd: (h) => habitNotifier.addHabit(h),
                      onEdit: (h) => habitNotifier.editHabit(h),
                      onDelete: (id) => habitNotifier.deleteHabit(id),
                    ),
                ],
              ),
            ),
          ),
          // Floating Combat Damage Overlay
          if (_floatingDamage > 0)
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingCombatOverlay(
                  damage: _floatingDamage,
                  onComplete: () {
                    setState(() => _floatingDamage = 0);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(int index, String label) {
    final isSelected = _activeCategoryIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeCategoryIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
          child: Center(
            child: Text(
              label,
              style: PixelTypography.pixelSubheader(
                fontSize: 8,
                color: isSelected ? Colors.black : PixelColors.textBright,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
