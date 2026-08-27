import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/feature/battle_hub/bloc/boss_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/daily_quest_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/habit_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/hero_bloc.dart';
import 'package:workxp/feature/battle_hub/bloc/quest_bloc.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_progress_bar.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';
import 'widgets/boss_encounter_card.dart';
import 'widgets/daily_quest_tab_view.dart';
import 'widgets/floating_combat_overlay.dart';
import 'widgets/habit_tab_view.dart';
import 'widgets/quest_list_widget.dart';
import 'widgets/revival_quest_dialog.dart';

@RoutePage()
class BattleHubPage extends StatefulWidget {
  const BattleHubPage({super.key});

  @override
  State<BattleHubPage> createState() => _BattleHubPageState();
}

class _BattleHubPageState extends State<BattleHubPage> {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<HeroBloc>(
          create: (ctx) => locator<HeroBloc>()..add(const LoadHero()),
        ),
        BlocProvider<BossBloc>(
          create: (ctx) => locator<BossBloc>()..add(const LoadBoss()),
        ),
        BlocProvider<QuestBloc>(
          create: (ctx) => locator<QuestBloc>()..add(const LoadQuests()),
        ),
        BlocProvider<DailyQuestBloc>(
          create: (ctx) => locator<DailyQuestBloc>()..add(const LoadDailyQuests()),
        ),
        BlocProvider<HabitBloc>(
          create: (ctx) => locator<HabitBloc>()..add(const LoadHabits()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'BATTLE HUB',
            style: PixelTypography.pixelHeader(
              fontSize: 14,
              color: PixelColors.coinGold,
            ),
          ),
          backgroundColor: PixelColors.backgroundDark,
        ),
        body: BlocListener<QuestBloc, QuestState>(
          listener: (context, questState) {
            if (questState is QuestLoaded && questState.lastStrikeDamage > 0) {
              _triggerCombatSlash(questState.lastStrikeDamage);
            }
          },
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Vitals & Ghost Banner
                      BlocBuilder<HeroBloc, HeroState>(
                        builder: (context, heroState) {
                          if (heroState is! HeroLoaded) {
                            return const SizedBox.shrink();
                          }
                          final hero = heroState;

                          return Column(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'GHOST STATE ACTIVE',
                                              style: PixelTypography.pixelHeader(
                                                fontSize: 10,
                                                color: PixelColors.ghostSpirit,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'HP is 0! EXP and Coin rewards are suspended.',
                                              style: PixelTypography.standardBody(
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
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                RevivalQuestDialog(
                                              onRevive: () {
                                                context
                                                    .read<HeroBloc>()
                                                    .add(const ReviveHero());
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                              // Hero HUD Card
                              PixelCard(
                                borderColor: PixelColors.borderGold,
                                backgroundColor: PixelColors.backgroundCard,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        PixelSprite(
                                          spriteType: hero.avatarSkinId,
                                          size: 40,
                                          isGhost: hero.isGhost,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    hero.name,
                                                    style: PixelTypography.pixelHeader(
                                                      fontSize: 11,
                                                      color: PixelColors.textBright,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 1,
                                                    ),
                                                    color: PixelColors.expPurple,
                                                    child: Text(
                                                      'LVL ${hero.level}',
                                                      style: PixelTypography.pixelHeader(
                                                        fontSize: 8,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                hero.activeTitle,
                                                style: PixelTypography.pixelSubheader(
                                                  fontSize: 8,
                                                  color: PixelColors.coinGold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Coins Purse
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: PixelColors.backgroundSurface,
                                            border: Border.all(
                                              color: PixelColors.coinGold,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.monetization_on,
                                                color: PixelColors.coinGold,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${hero.coins}',
                                                style: PixelTypography.pixelHeader(
                                                  fontSize: 10,
                                                  color: PixelColors.coinGold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    PixelProgressBar(
                                      label: 'HP',
                                      current: hero.hp,
                                      max: hero.maxHp,
                                      fillColor: PixelColors.hpGreen,
                                      backgroundColor: PixelColors.hpBackground,
                                    ),
                                    const SizedBox(height: 6),
                                    PixelProgressBar(
                                      label: 'MP',
                                      current: hero.mp,
                                      max: hero.maxMp,
                                      fillColor: PixelColors.mpCyan,
                                      backgroundColor: PixelColors.mpBackground,
                                    ),
                                    const SizedBox(height: 6),
                                    PixelProgressBar(
                                      label: 'EXP',
                                      current: hero.currentExp,
                                      max: hero.nextLevelExp,
                                      fillColor: PixelColors.expPink,
                                      backgroundColor: PixelColors.expBackground,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),

                      // Boss Encounter Card
                      BlocBuilder<BossBloc, BossState>(
                        builder: (context, bossState) {
                          if (bossState is BossLoaded &&
                              bossState.activeBoss != null) {
                            return BossEncounterCard(
                              boss: bossState.activeBoss,
                              lastDamage: _floatingDamage,
                            );
                          }
                          return BossEncounterCard(
                            bossModel: BossModel.chapterBoss(1),
                            lastDamage: _floatingDamage,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Selector Bar (Quests | Daily Quests | Habits)
                      Container(
                        decoration: BoxDecoration(
                          color: PixelColors.backgroundDark,
                          border: Border.all(color: PixelColors.borderHighlight),
                        ),
                        child: Row(
                          children: [
                            _buildTabItem(0, 'QUESTS', Icons.assignment),
                            _buildTabItem(1, 'DAILIES', Icons.today),
                            _buildTabItem(2, 'HABITS', Icons.repeat),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tab Views
                      if (_activeCategoryIndex == 0)
                        BlocBuilder<QuestBloc, QuestState>(
                          builder: (context, questState) {
                            final quests = questState is QuestLoaded
                                ? questState.quests
                                : <Quest>[];
                            return QuestListWidget(
                              driftQuests: quests,
                              onComplete: (questId) {
                                context
                                    .read<QuestBloc>()
                                    .add(CompleteQuest(questId));
                              },
                              onAdd: (newQuest) {
                                context.read<QuestBloc>().add(CreateQuest(
                                      title: newQuest.title,
                                      description: newQuest.description,
                                      rank: newQuest.rank,
                                      baseDamage: newQuest.baseDamage,
                                      expReward: newQuest.expReward,
                                      coinReward: newQuest.coinReward,
                                      id: newQuest.id,
                                    ));
                              },
                              onDelete: (questId) {
                                context
                                    .read<QuestBloc>()
                                    .add(DeleteQuest(questId));
                              },
                            );
                          },
                        )
                      else if (_activeCategoryIndex == 1)
                        BlocBuilder<DailyQuestBloc, DailyQuestState>(
                          builder: (context, dailyState) {
                            final dailies = dailyState is DailyQuestLoaded
                                ? dailyState.dailies
                                : <DailyQuest>[];
                            return DailyQuestTabView(
                              driftDailies: dailies,
                              onToggle: (id) {
                                context
                                    .read<DailyQuestBloc>()
                                    .add(ToggleDailyQuest(id));
                              },
                              onAdd: (newDaily) {
                                context
                                    .read<DailyQuestBloc>()
                                    .add(CreateDailyQuest(
                                      title: newDaily.title,
                                      description: newDaily.description,
                                      streak: newDaily.streakCount,
                                      id: newDaily.id,
                                    ));
                              },
                              onDelete: (id) {
                                context
                                    .read<DailyQuestBloc>()
                                    .add(DeleteDailyQuest(id));
                              },
                            );
                          },
                        )
                      else if (_activeCategoryIndex == 2)
                        BlocBuilder<HabitBloc, HabitState>(
                          builder: (context, habitState) {
                            final habits = habitState is HabitLoaded
                                ? habitState.habits
                                : <Habit>[];
                            return BlocBuilder<HeroBloc, HeroState>(
                              builder: (context, heroState) {
                                final hero = heroState is HeroLoaded
                                    ? heroState.hero
                                    : null;
                                return HabitTabView(
                                  driftHabits: habits,
                                  hero: hero,
                                  buffs: const [
                                    SkillBuffModel(
                                      id: 'buff_double_exp',
                                      name: 'Double EXP Scroll',
                                      description:
                                          '2x EXP on all Quest completions (2h)',
                                      mpCost: 30,
                                      durationMinutes: 120,
                                    ),
                                    SkillBuffModel(
                                      id: 'buff_boss_stun',
                                      name: 'Boss Freeze / Stun',
                                      description:
                                          'Stuns Boss, preventing midnight penalty (12h)',
                                      mpCost: 40,
                                      durationMinutes: 720,
                                    ),
                                    SkillBuffModel(
                                      id: 'buff_focus_surge',
                                      name: 'Focus Surge',
                                      description:
                                          '+50% attack damage on Quest strikes (1h)',
                                      mpCost: 25,
                                      durationMinutes: 60,
                                    ),
                                  ],
                                  onLogPositive: (id) {
                                    context.read<HabitBloc>().add(LogHabit(
                                          id: id,
                                          isPositive: true,
                                        ));
                                  },
                                  onLogNegative: (id) {
                                    context.read<HabitBloc>().add(LogHabit(
                                          id: id,
                                          isPositive: false,
                                        ));
                                  },
                                  onCastBuff: (buffId) {
                                    if (buffId == 'buff_double_exp') {
                                      context
                                          .read<HeroBloc>()
                                          .add(const SpendMp(30));
                                    } else if (buffId == 'buff_boss_stun') {
                                      context
                                          .read<HeroBloc>()
                                          .add(const SpendMp(40));
                                    } else if (buffId == 'buff_focus_surge') {
                                      context
                                          .read<HeroBloc>()
                                          .add(const SpendMp(25));
                                    }
                                  },
                                  onAdd: (newHabit) {
                                    context.read<HabitBloc>().add(CreateHabit(
                                          title: newHabit.title,
                                          isPositive: newHabit.hasPositive,
                                          isNegative: newHabit.hasNegative,
                                          id: newHabit.id,
                                        ));
                                  },
                                  onDelete: (id) {
                                    context
                                        .read<HabitBloc>()
                                        .add(DeleteHabit(id));
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Floating Combat Strike Overlay
              if (_floatingDamage > 0)
                Positioned(
                  top: 200,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingCombatOverlay(
                      damage: _floatingDamage,
                      onComplete: () {
                        setState(() {
                          _floatingDamage = 0;
                        });
                        context
                            .read<QuestBloc>()
                            .add(const ClearCombatStrikeFeedback());
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _activeCategoryIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeCategoryIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? PixelColors.backgroundSurface
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color:
                    isSelected ? PixelColors.coinGold : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? PixelColors.coinGold
                    : PixelColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: isSelected
                      ? PixelColors.coinGold
                      : PixelColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
