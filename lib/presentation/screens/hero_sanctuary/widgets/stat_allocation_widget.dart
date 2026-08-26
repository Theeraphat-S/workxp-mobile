import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_badge.dart';
import 'package:workxp/core/widgets/pixel_button.dart';
import 'package:workxp/domain/models/hero_model.dart';

class StatAllocationWidget extends StatelessWidget {
  const StatAllocationWidget({
    super.key,
    required this.hero,
    required this.onAllocate,
  });

  final HeroModel hero;
  final void Function(String attribute) onAllocate;

  @override
  Widget build(BuildContext context) {
    return PixelCard(
      borderColor: PixelColors.borderHighlight,
      backgroundColor: PixelColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ATTRIBUTES',
                style: PixelTypography.pixelHeader(
                  fontSize: 12,
                  color: PixelColors.coinGold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hero.unallocatedPoints > 0
                      ? PixelColors.attrWis.withAlpha(80)
                      : PixelColors.backgroundSurface,
                  border: Border.all(
                    color: hero.unallocatedPoints > 0
                        ? PixelColors.attrWis
                        : PixelColors.borderHighlight,
                  ),
                ),
                child: Text(
                  'POINTS: ${hero.unallocatedPoints}',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 10,
                    color: hero.unallocatedPoints > 0
                        ? PixelColors.coinGold
                        : PixelColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            'STR',
            'Strength (Combat Attack Bonus)',
            hero.str,
            PixelColors.attrStr,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'INT',
            'Intelligence (EXP Boost & Wisdom)',
            hero.intel,
            PixelColors.attrInt,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'AGI',
            'Agility (Speed & Critical Strike)',
            hero.agi,
            PixelColors.attrAgi,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'VIT',
            'Vitality (Resilience & Max HP)',
            hero.vit,
            PixelColors.attrVit,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'WIS',
            'Wisdom (MP Generation & Focus)',
            hero.wis,
            PixelColors.attrWis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    String attr,
    String description,
    int value,
    Color color,
  ) {
    final canAdd = hero.unallocatedPoints > 0;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: PixelColors.backgroundSurface,
        border: Border.all(color: PixelColors.borderDark),
      ),
      child: Row(
        children: [
          PixelBadge.attribute(attr),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: PixelTypography.pixelBody(
                    fontSize: 12,
                    color: PixelColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$value',
            style: PixelTypography.pixelHeader(fontSize: 13, color: color),
          ),
          const SizedBox(width: 10),
          if (canAdd)
            PixelButton(
              text: '+',
              fontSize: 11,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              backgroundColor: PixelColors.coinGold,
              onPressed: () => onAllocate(attr),
            )
          else
            const SizedBox(width: 28),
        ],
      ),
    );
  }
}
