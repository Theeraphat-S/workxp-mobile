import 'dart:math';
import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';
import 'package:workxp/core/widgets/pixel_card.dart';
import 'package:workxp/core/widgets/pixel_progress_bar.dart';
import 'package:workxp/core/widgets/pixel_sprite.dart';
import 'package:workxp/domain/models/boss_model.dart';

class BossEncounterCard extends StatefulWidget {
  const BossEncounterCard({super.key, required this.boss, this.lastDamage = 0});

  final BossModel boss;
  final int lastDamage;

  @override
  State<BossEncounterCard> createState() => _BossEncounterCardState();
}

class _BossEncounterCardState extends State<BossEncounterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant BossEncounterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lastDamage > 0 && widget.lastDamage != oldWidget.lastDamage) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shake = (sin(_shakeController.value * pi * 4) * 6.0);

        return Transform.translate(offset: Offset(shake, 0), child: child);
      },
      child: PixelCard(
        borderColor: PixelColors.bossHealth,
        backgroundColor: PixelColors.backgroundCard,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: PixelColors.bossHealth.withAlpha(40),
                  child: Text(
                    'CH.${widget.boss.chapter} ${widget.boss.chapterName.toUpperCase()}',
                    style: PixelTypography.pixelHeader(
                      fontSize: 9,
                      color: PixelColors.bossHealth,
                    ),
                  ),
                ),
                const Spacer(),
                if (widget.boss.isDefeated)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    color: PixelColors.coinGold.withAlpha(50),
                    child: Text(
                      'DEFEATED!',
                      style: PixelTypography.pixelHeader(
                        fontSize: 9,
                        color: PixelColors.coinGold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: PixelSprite(spriteType: widget.boss.spriteType, size: 80),
            ),
            const SizedBox(height: 8),
            Text(
              widget.boss.name.toUpperCase(),
              style: PixelTypography.pixelHeader(
                fontSize: 14,
                color: PixelColors.textBright,
              ),
            ),
            const SizedBox(height: 10),
            PixelProgressBar(
              label: 'BOSS HP',
              current: widget.boss.currentHp,
              max: widget.boss.maxHp,
              fillColor: PixelColors.bossHealth,
              backgroundColor: PixelColors.hpBackground,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
