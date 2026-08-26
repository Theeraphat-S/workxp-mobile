import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';

class RevivalQuestDialog extends StatefulWidget {
  const RevivalQuestDialog({super.key, required this.onRevive});

  final VoidCallback onRevive;

  @override
  State<RevivalQuestDialog> createState() => _RevivalQuestDialogState();
}

class _RevivalQuestDialogState extends State<RevivalQuestDialog> {
  int _selectedActionIndex = 0;

  static const List<Map<String, String>> _revivalTasks = [
    {
      'title': 'Hydrate the Soul',
      'desc': 'Drink 1 full glass of clean water right now.',
    },
    {
      'title': 'Warrior Stretch',
      'desc': 'Stand up and stretch arms and back for 60 seconds.',
    },
    {
      'title': 'Tidy the Sanctuary',
      'desc': 'Clear 1 item off your desk or wash 1 dish.',
    },
    {
      'title': 'Mindful Reset',
      'desc': 'Take 5 deep breaths and close eyes for 30 seconds.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelCard(
        borderColor: PixelColors.ghostSpirit,
        backgroundColor: const Color(0xFF0F1B24),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: PixelSprite(
                spriteType: 'hero_novice',
                size: 64,
                isGhost: true,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'GHOST STATE RESURRECTION',
              style: PixelTypography.pixelHeader(
                fontSize: 12,
                color: PixelColors.ghostSpirit,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Your HP dropped to 0 from missed Dailies. Complete 1 emergency Revival Quest to resurrect with 50% HP and restore EXP/Coin gain!',
              style: PixelTypography.pixelBody(
                fontSize: 13,
                color: PixelColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ...List.generate(_revivalTasks.length, (index) {
              final task = _revivalTasks[index];
              final isSelected = _selectedActionIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedActionIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PixelColors.ghostSpirit.withAlpha(40)
                          : PixelColors.backgroundSurface,
                      border: Border.all(
                        color: isSelected
                            ? PixelColors.ghostSpirit
                            : PixelColors.borderDark,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: isSelected
                              ? PixelColors.ghostSpirit
                              : PixelColors.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title']!,
                                style: PixelTypography.pixelSubheader(
                                  fontSize: 10,
                                  color: isSelected
                                      ? PixelColors.ghostSpirit
                                      : PixelColors.textBright,
                                ),
                              ),
                              Text(
                                task['desc']!,
                                style: PixelTypography.standardBody(
                                  fontSize: 10,
                                  color: PixelColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),
            PixelButton(
              text: 'COMPLETE REVIVAL ACTION',
              backgroundColor: PixelColors.ghostSpirit,
              textColor: Colors.black,
              isFullWidth: true,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onRevive();
              },
            ),
          ],
        ),
      ),
    );
  }
}
