import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/domain/models/boss_model.dart';
import 'package:workxp/presentation/providers/dungeon_notifier.dart';
import 'widgets/dungeon_node_widget.dart';
import 'widgets/bestiary_dialog.dart';
import 'widgets/victory_fanfare_dialog.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dungeon = ref.watch(dungeonProvider);
    final dungeonNotifier = ref.read(dungeonProvider.notifier);

    // If victory is triggered, show fanfare modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dungeon.isVictory) {
        showDialog(
          context: context,
          builder: (ctx) => VictoryFanfareDialog(
            boss: dungeon.activeBoss,
            onContinue: () => dungeonNotifier.dismissVictoryDialog(),
          ),
        );
      }
    });

    final chapters = [
      {'number': 1, 'name': 'Slime Forest', 'boss': BossModel.chapterBoss(1)},
      {'number': 2, 'name': 'Goblin Keep', 'boss': BossModel.chapterBoss(2)},
      {'number': 3, 'name': 'Shadow Crypt', 'boss': BossModel.chapterBoss(3)},
      {'number': 4, 'name': 'Volcano Peak', 'boss': BossModel.chapterBoss(4)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WORLD MAP',
          style: PixelTypography.pixelHeader(
            fontSize: 14,
            color: PixelColors.coinGold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book, color: PixelColors.coinGold),
            tooltip: 'Bestiary',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) =>
                    BestiaryDialog(defeatedBosses: dungeon.defeatedBosses),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DUNGEON EXPEDITION',
                        style: PixelTypography.pixelHeader(
                          fontSize: 12,
                          color: PixelColors.coinGold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Conquer Dungeon Bosses with your daily quests!',
                        style: PixelTypography.pixelBody(
                          fontSize: 12,
                          color: PixelColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  PixelButton(
                    text: 'BESTIARY',
                    fontSize: 8,
                    backgroundColor: PixelColors.backgroundSurface,
                    textColor: PixelColors.coinGold,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => BestiaryDialog(
                          defeatedBosses: dungeon.defeatedBosses,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...chapters.map((ch) {
                final num = ch['number'] as int;
                final name = ch['name'] as String;
                final boss = ch['boss'] as BossModel;

                final isUnlocked = dungeon.unlockedChapters.contains(num);
                final isCurrent = dungeon.currentChapter == num;
                final isDefeated = dungeon.defeatedBosses.any(
                  (b) => b.chapter == num,
                );

                return Column(
                  children: [
                    DungeonNodeWidget(
                      chapterNumber: num,
                      chapterName: name,
                      boss: isCurrent ? dungeon.activeBoss : boss,
                      isUnlocked: isUnlocked,
                      isCurrent: isCurrent,
                      isDefeated: isDefeated,
                      onSelect: () => dungeonNotifier.selectChapter(num),
                    ),
                    if (num < 4) ...[
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          '▼  ▼  ▼',
                          style: PixelTypography.pixelHeader(
                            fontSize: 8,
                            color: isUnlocked
                                ? PixelColors.borderHighlight
                                : PixelColors.borderDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
