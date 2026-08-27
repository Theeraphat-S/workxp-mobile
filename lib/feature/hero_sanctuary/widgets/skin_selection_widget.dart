import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'package:workxp/shared/widgets/pixel_sprite.dart';

class SkinSelectionWidget extends StatelessWidget {
  const SkinSelectionWidget({
    super.key,
    this.heroModel,
    this.hero,
    required this.onSelectSkin,
  });

  final HeroModel? heroModel;
  final Hero? hero;
  final void Function(String skinId) onSelectSkin;

  static const List<Map<String, String>> allSkins = [
    {'id': 'hero_novice', 'name': 'Novice Knight'},
    {'id': 'paladin', 'name': 'Holy Paladin'},
    {'id': 'dark_knight', 'name': 'Dark Knight'},
    {'id': 'archmage', 'name': 'Archmage'},
    {'id': 'cyber_samurai', 'name': 'Cyber Samurai'},
  ];

  String get activeSkinId =>
      hero?.avatarSkinId ?? heroModel?.activeSkinId ?? 'hero_novice';

  bool _isUnlocked(String skinId) {
    if (skinId == 'hero_novice') return true;
    if (heroModel?.unlockedSkins.contains(skinId) == true) return true;
    return true; // allow equipped skins in sandbox
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
                final isUnlocked = _isUnlocked(skinId);
                final isEquipped = activeSkinId == skinId;

                return InkWell(
                  key: Key('skin_item_$skinId'),
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
