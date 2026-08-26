import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/domain/models/hero_model.dart';

class SkillBuffBar extends StatelessWidget {
  const SkillBuffBar({
    super.key,
    required this.buffs,
    required this.hero,
    required this.onCastBuff,
  });

  final List<SkillBuffModel> buffs;
  final HeroModel hero;
  final void Function(String buffId) onCastBuff;

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.mpBlue,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MP SKILL BUFFS',
                style: PixelTypography.pixelHeader(
                  fontSize: 11,
                  color: PixelColors.mpCyan,
                ),
              ),
              Text(
                'HERO MP: ${hero.currentMp}/${hero.maxMp}',
                style: PixelTypography.pixelSubheader(
                  fontSize: 9,
                  color: PixelColors.mpCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...buffs.map((buff) {
            final isActive = buff.isActive;
            final canAfford = hero.currentMp >= buff.mpCost;

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive
                    ? PixelColors.mpBackground.withAlpha(100)
                    : PixelColors.backgroundSurface,
                border: Border.all(
                  color: isActive ? PixelColors.mpCyan : PixelColors.borderDark,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              buff.name,
                              style: PixelTypography.pixelSubheader(
                                fontSize: 10,
                                color: isActive
                                    ? PixelColors.coinGold
                                    : PixelColors.textBright,
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                color: PixelColors.hpGreen.withAlpha(50),
                                child: Text(
                                  'ACTIVE (${buff.remainingDuration.inMinutes}m)',
                                  style: PixelTypography.pixelHeader(
                                    fontSize: 7,
                                    color: PixelColors.hpGreen,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          buff.description,
                          style: PixelTypography.standardBody(
                            fontSize: 10,
                            color: PixelColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    text: '${buff.mpCost} MP',
                    fontSize: 8,
                    backgroundColor: canAfford && !isActive
                        ? PixelColors.mpCyan
                        : PixelColors.borderHighlight.withAlpha(60),
                    textColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    onPressed: canAfford && !isActive
                        ? () => onCastBuff(buff.id)
                        : null,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
