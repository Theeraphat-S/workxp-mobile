import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/feature/dungeon/bloc/dungeon_bloc.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'widgets/bestiary_dialog.dart';
import 'widgets/dungeon_node_widget.dart';

@RoutePage()
class DungeonMapPage extends StatelessWidget {
  const DungeonMapPage({super.key});

  static const List<Map<String, dynamic>> _chapterMetadata = [
    {
      'chapter': 1,
      'name': 'Slime Forest',
      'bossId': 'boss_slime',
      'sprite': 'boss_slime',
    },
    {
      'chapter': 2,
      'name': 'Goblin Keep',
      'bossId': 'boss_goblin',
      'sprite': 'boss_goblin',
    },
    {
      'chapter': 3,
      'name': 'Shadow Crypt',
      'bossId': 'boss_necromancer',
      'sprite': 'boss_necromancer',
    },
    {
      'chapter': 4,
      'name': 'Volcano Peak',
      'bossId': 'boss_dragon',
      'sprite': 'boss_dragon',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DungeonBloc>(
      create: (ctx) => locator<DungeonBloc>()..add(const LoadDungeon()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'WORLD MAP',
            style: PixelTypography.pixelHeader(
              fontSize: 14,
              color: PixelColors.coinGold,
            ),
          ),
          backgroundColor: PixelColors.backgroundDark,
        ),
        body: BlocBuilder<DungeonBloc, DungeonState>(
          builder: (context, state) {
            final bosses = state is DungeonLoaded ? state.bosses : <Boss>[];
            final activeBoss = state is DungeonLoaded ? state.activeBoss : null;
            final maxUnlocked = state is DungeonLoaded
                ? state.unlockedChapterMax
                : 1;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // World Map Header Card
                    PixelCard(
                      borderColor: PixelColors.borderGold,
                      backgroundColor: PixelColors.backgroundCard,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: PixelColors.backgroundSurface,
                            child: const Icon(
                              Icons.explore,
                              color: PixelColors.coinGold,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CAMPAIGN PROGRESSION',
                                  style: PixelTypography.pixelHeader(
                                    fontSize: 11,
                                    color: PixelColors.coinGold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Defeat each Dungeon Boss to unlock the next Chapter.',
                                  style: PixelTypography.pixelBody(
                                    fontSize: 12,
                                    color: PixelColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PixelButton(
                            text: 'BESTIARY',
                            fontSize: 9,
                            backgroundColor: PixelColors.attrWis,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            onPressed: () {
                              SensoryService.instance.playClick();
                              showDialog(
                                context: context,
                                builder: (ctx) =>
                                    BestiaryDialog(driftDefeatedBosses: bosses),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chapter Nodes 1 to 4
                    ..._chapterMetadata.map((meta) {
                      final chapterNum = meta['chapter'] as int;
                      final chapterName = meta['name'] as String;
                      final boss = bosses
                          .where((b) => b.chapter == chapterNum)
                          .firstOrNull;

                      final isUnlocked = chapterNum <= maxUnlocked;
                      final isCurrent = activeBoss?.chapter == chapterNum;
                      final isDefeated = boss?.isDefeated ?? false;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DungeonNodeWidget(
                          chapterNumber: chapterNum,
                          chapterName: chapterName,
                          boss: boss,
                          isUnlocked: isUnlocked,
                          isCurrent: isCurrent,
                          isDefeated: isDefeated,
                          onSelect: () {
                            SensoryService.instance.playClick();
                            context.read<DungeonBloc>().add(
                              SelectChapter(chapterNum),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
