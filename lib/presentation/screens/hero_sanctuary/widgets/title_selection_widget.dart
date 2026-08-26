import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/domain/models/hero_model.dart';

class TitleSelectionWidget extends StatelessWidget {
  const TitleSelectionWidget({
    super.key,
    required this.hero,
    required this.onSelectTitle,
  });

  final HeroModel hero;
  final void Function(String titleId) onSelectTitle;

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.borderHighlight,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'EARNED TITLES',
            style: PixelTypography.pixelHeader(
              fontSize: 12,
              color: PixelColors.coinGold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hero.unlockedTitles.map((title) {
              final isEquipped = title == hero.activeTitleId;
              return InkWell(
                onTap: () => onSelectTitle(title),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isEquipped
                        ? PixelColors.attrWis.withAlpha(90)
                        : PixelColors.backgroundSurface,
                    border: Border.all(
                      color: isEquipped
                          ? PixelColors.coinGold
                          : PixelColors.borderDark,
                      width: isEquipped ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isEquipped) ...[
                        const Icon(
                          Icons.check,
                          size: 12,
                          color: PixelColors.coinGold,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        title,
                        style: PixelTypography.pixelSubheader(
                          fontSize: 9,
                          color: isEquipped
                              ? PixelColors.coinGold
                              : PixelColors.textBright,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
