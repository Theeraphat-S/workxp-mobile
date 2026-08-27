import 'package:flutter/material.dart' hide Hero;
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/models/hero_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_badge.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class StatAllocationWidget extends StatelessWidget {
  const StatAllocationWidget({
    super.key,
    this.heroModel,
    this.hero,
    required this.onAllocate,
  });

  final HeroModel? heroModel;
  final Hero? hero;
  final void Function(String attribute) onAllocate;

  HeroModel get _resolvedHero {
    if (heroModel != null) return heroModel!;
    return HeroModel(
      str: hero?.str ?? 5,
      intel: hero?.intAttr ?? 5,
      agi: hero?.agi ?? 5,
      vit: hero?.vit ?? 5,
      wis: hero?.intAttr ?? 5,
      unallocatedPoints: hero?.unspentStatPoints ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = _resolvedHero;

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
                  color: h.unallocatedPoints > 0
                      ? PixelColors.attrWis.withAlpha(80)
                      : PixelColors.backgroundSurface,
                  border: Border.all(
                    color: h.unallocatedPoints > 0
                        ? PixelColors.attrWis
                        : PixelColors.borderHighlight,
                  ),
                ),
                child: Text(
                  'POINTS: ${h.unallocatedPoints}',
                  style: PixelTypography.pixelSubheader(
                    fontSize: 10,
                    color: h.unallocatedPoints > 0
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
            h.str,
            PixelColors.attrStr,
            h.unallocatedPoints,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'INT',
            'Intelligence (EXP Boost & Wisdom)',
            h.intel,
            PixelColors.attrInt,
            h.unallocatedPoints,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'AGI',
            'Agility (Speed & Critical Strike)',
            h.agi,
            PixelColors.attrAgi,
            h.unallocatedPoints,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'VIT',
            'Vitality (Resilience & Max HP)',
            h.vit,
            PixelColors.attrVit,
            h.unallocatedPoints,
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'WIS',
            'Wisdom (MP Generation & Focus)',
            h.wis,
            PixelColors.attrWis,
            h.unallocatedPoints,
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
    int unallocatedPoints,
  ) {
    final canAdd = unallocatedPoints > 0;

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
              key: Key('allocate_stat_${attr.toLowerCase()}'),
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
