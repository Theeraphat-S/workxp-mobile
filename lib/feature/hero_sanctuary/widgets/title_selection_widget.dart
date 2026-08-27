import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class TitleSelectionWidget extends StatelessWidget {
  const TitleSelectionWidget({
    super.key,
    this.heroModel,
    this.hero,
    required this.onSelectTitle,
  });

  final HeroModel? heroModel;
  final Hero? hero;
  final void Function(String titleId) onSelectTitle;

  static const List<String> defaultTitles = [
    'Novice Adventurer',
    'Goblin Slayer',
    'Shadow Walker',
    'Dragon Champion',
    'Legendary Hero',
  ];

  String get activeTitle => hero?.activeTitle ?? heroModel?.activeTitleId ?? 'Novice Adventurer';

  List<String> get unlockedTitles {
    if (heroModel != null && heroModel!.unlockedTitles.isNotEmpty) {
      return heroModel!.unlockedTitles;
    }
    return defaultTitles;
  }

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
            children: unlockedTitles.map((title) {
              final isEquipped = title == activeTitle;
              return InkWell(
                key: Key('title_item_$title'),
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
