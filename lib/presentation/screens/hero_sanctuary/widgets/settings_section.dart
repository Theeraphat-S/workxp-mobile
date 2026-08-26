import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/data/storage/hive_storage_service.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/quest_model.dart';
import 'package:workxp/domain/models/daily_quest_model.dart';
import 'package:workxp/domain/models/habit_model.dart';
import 'package:workxp/presentation/providers/hero_notifier.dart';
import 'package:workxp/presentation/providers/quest_notifier.dart';
import 'package:workxp/presentation/providers/daily_quest_notifier.dart';
import 'package:workxp/presentation/providers/habit_notifier.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'package:workxp/presentation/providers/tavern_notifier.dart';
import 'package:workxp/presentation/providers/analytics_notifier.dart';
import 'json_backup_dialog.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool _sfx = SensoryService.instance.isSfxEnabled;
  bool _haptics = SensoryService.instance.isHapticsEnabled;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final hero = ref.watch(heroProvider);
        final quests = ref.watch(questProvider);
        final dailies = ref.watch(dailyQuestProvider);
        final habits = ref.watch(habitProvider);
        final dungeon = ref.watch(dungeonProvider);
        final tavern = ref.watch(tavernProvider);
        final analytics = ref.watch(analyticsProvider);

        final heroNotifier = ref.read(heroProvider.notifier);
        final questNotifier = ref.read(questProvider.notifier);
        final dailyNotifier = ref.read(dailyQuestProvider.notifier);
        final habitNotifier = ref.read(habitProvider.notifier);
        final dungeonNotifier = ref.read(dungeonProvider.notifier);
        final tavernNotifier = ref.read(tavernProvider.notifier);
        final analyticsNotifier = ref.read(analyticsProvider.notifier);

        return PixelCard(
          borderColor: PixelColors.borderHighlight,
          backgroundColor: PixelColors.backgroundCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SETTINGS & STORAGE BACKUP',
                style: PixelTypography.pixelHeader(
                  fontSize: 12,
                  color: PixelColors.coinGold,
                ),
              ),
              const SizedBox(height: 12),
              // SFX Switch
              SwitchListTile(
                title: Text(
                  '8-BIT SOUND EFFECTS (SFX)',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 10,
                    color: PixelColors.textBright,
                  ),
                ),
                subtitle: Text(
                  'Chiptune sword swings, victory fanfares, and chimes',
                  style: PixelTypography.pixelBody(
                    fontSize: 10,
                    color: PixelColors.textMuted,
                  ),
                ),
                value: _sfx,
                activeThumbColor: PixelColors.coinGold,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() => _sfx = val);
                  SensoryService.instance.toggleSfx(val);
                },
              ),
              const Divider(color: PixelColors.borderHighlight),
              // Haptics Switch
              SwitchListTile(
                title: Text(
                  'TACTILE HAPTIC FEEDBACK',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 10,
                    color: PixelColors.textBright,
                  ),
                ),
                subtitle: Text(
                  'Vibrations on button taps, combat strikes, and level-ups',
                  style: PixelTypography.pixelBody(
                    fontSize: 10,
                    color: PixelColors.textMuted,
                  ),
                ),
                value: _haptics,
                activeThumbColor: PixelColors.coinGold,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() => _haptics = val);
                  SensoryService.instance.toggleHaptics(val);
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: PixelButton(
                      text: 'EXPORT JSON',
                      icon: Icons.upload,
                      fontSize: 9,
                      backgroundColor: PixelColors.backgroundSurface,
                      textColor: PixelColors.coinGold,
                      onPressed: () {
                        final json = HiveStorageService.instance
                            .exportSaveFileJson(
                              hero: hero,
                              quests: quests,
                              dailies: dailies,
                              habits: habits,
                              dungeon: dungeon,
                              tavern: tavern,
                              analytics: analytics,
                            );
                        showDialog(
                          context: context,
                          builder: (ctx) => JsonBackupDialog(
                            isExport: true,
                            exportedJson: json,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PixelButton(
                      text: 'IMPORT JSON',
                      icon: Icons.download,
                      fontSize: 9,
                      backgroundColor: PixelColors.backgroundSurface,
                      textColor: PixelColors.mpCyan,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => JsonBackupDialog(
                            isExport: false,
                            onImport: (jsonString) {
                              final map = HiveStorageService.instance
                                  .parseAndValidateSaveJson(jsonString);
                              if (map != null) {
                                if (map.containsKey('hero')) {
                                  heroNotifier.setHero(
                                    HeroModel.fromJson(
                                      map['hero'] as Map<String, dynamic>,
                                    ),
                                  );
                                }
                                if (map.containsKey('quests')) {
                                  final qList = (map['quests'] as List<dynamic>)
                                      .map(
                                        (e) => QuestModel.fromJson(
                                          e as Map<String, dynamic>,
                                        ),
                                      )
                                      .toList();
                                  questNotifier.setQuests(qList);
                                }
                                if (map.containsKey('dailies')) {
                                  final dList =
                                      (map['dailies'] as List<dynamic>)
                                          .map(
                                            (e) => DailyQuestModel.fromJson(
                                              e as Map<String, dynamic>,
                                            ),
                                          )
                                          .toList();
                                  dailyNotifier.setDailyQuests(dList);
                                }
                                if (map.containsKey('habits')) {
                                  final hList = (map['habits'] as List<dynamic>)
                                      .map(
                                        (e) => HabitModel.fromJson(
                                          e as Map<String, dynamic>,
                                        ),
                                      )
                                      .toList();
                                  habitNotifier.setHabits(hList);
                                }
                                if (map.containsKey('dungeon')) {
                                  dungeonNotifier.setDungeonState(
                                    DungeonState.fromJson(
                                      map['dungeon'] as Map<String, dynamic>,
                                    ),
                                  );
                                }
                                if (map.containsKey('tavern')) {
                                  tavernNotifier.setTavernState(
                                    TavernState.fromJson(
                                      map['tavern'] as Map<String, dynamic>,
                                    ),
                                  );
                                }
                                if (map.containsKey('analytics')) {
                                  analyticsNotifier.setAnalyticsState(
                                    AnalyticsState.fromJson(
                                      map['analytics'] as Map<String, dynamic>,
                                    ),
                                  );
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Save file imported successfully!',
                                    ),
                                    backgroundColor: PixelColors.hpGreen,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PixelButton(
                text: 'SAVE GAME PROGRESS NOW',
                icon: Icons.save,
                fontSize: 9,
                backgroundColor: PixelColors.coinGold,
                textColor: Colors.black,
                isFullWidth: true,
                onPressed: () async {
                  await HiveStorageService.instance.saveGameState(
                    hero: hero,
                    quests: quests,
                    dailies: dailies,
                    habits: habits,
                    dungeon: dungeon,
                    tavern: tavern,
                    analytics: analytics,
                    isSfxEnabled: _sfx,
                    isHapticsEnabled: _haptics,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Game progress saved locally!'),
                        backgroundColor: PixelColors.coinGold,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
