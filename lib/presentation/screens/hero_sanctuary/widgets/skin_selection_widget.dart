import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/hero_model.dart';

class SkinSelectionWidget extends StatelessWidget {
  const SkinSelectionWidget({
    super.key,
    required this.hero,
    required this.onSelectSkin,
  });

  final HeroModel hero;
  final void Function(String skinId) onSelectSkin;

  static const List<Map<String, String>> allSkins = [
    {'id': 'hero_novice', 'name': 'Novice Knight'},
    {'id': 'paladin', 'name': 'Holy Paladin'},
    {'id': 'dark_knight', 'name': 'Dark Knight'},
    {'id': 'archmage', 'name': 'Archmage'},
    {'id': 'cyber_samurai', 'name': 'Cyber Samurai'},
  ];

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.borderHighlight,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'AVATAR SKINS',
            style: PixelTypography.pixelHeader(
              fontSize: 12,
              color: PixelColors.coinGold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allSkins.map((skin) {
                final skinId = skin['id']!;
                final skinName = skin['name']!;
                final isUnlocked = hero.unlockedSkins.contains(skinId);
                final isEquipped = hero.activeSkinId == skinId;

                return InkWell(
                  onTap: isUnlocked ? () => onSelectSkin(skinId) : null,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isEquipped
                          ? PixelColors.attrStr.withAlpha(50)
                          : PixelColors.backgroundSurface,
                      border: Border.all(
                        color: isEquipped
                            ? PixelColors.coinGold
                            : (isUnlocked
                                  ? PixelColors.borderDark
                                  : PixelColors.borderDark.withAlpha(100)),
                        width: isEquipped ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: isUnlocked ? 1.0 : 0.35,
                          child: PixelSprite(spriteType: skinId, size: 44),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          skinName,
                          style: PixelTypography.pixelSubheader(
                            fontSize: 8,
                            color: isUnlocked
                                ? (isEquipped
                                      ? PixelColors.coinGold
                                      : PixelColors.textBright)
                                : PixelColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEquipped
                              ? 'EQUIPPED'
                              : (isUnlocked ? 'SELECT' : 'LOCKED'),
                          style: PixelTypography.pixelHeader(
                            fontSize: 7,
                            color: isEquipped
                                ? PixelColors.hpGreen
                                : (isUnlocked
                                      ? PixelColors.mpCyan
                                      : PixelColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
