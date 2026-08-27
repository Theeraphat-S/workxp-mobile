import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class SkillBuffBar extends StatelessWidget {
  const SkillBuffBar({
    super.key,
    required this.buffs,
    this.heroModel,
    this.hero,
    required this.onCastBuff,
  });

  final List<SkillBuffModel> buffs;
  final HeroModel? heroModel;
  final Hero? hero;
  final void Function(String buffId) onCastBuff;

  @override
  Widget build(BuildContext context) {
    final currentMp = hero?.mp ?? heroModel?.currentMp ?? 50;
    final maxMp = hero?.maxMp ?? heroModel?.maxMp ?? 100;

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
                'HERO MP: $currentMp/$maxMp',
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
            final canAfford = currentMp >= buff.mpCost;

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
