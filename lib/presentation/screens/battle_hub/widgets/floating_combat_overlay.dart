import 'package:flutter/material.dart';
import 'package:workxp/core/theme/pixel_colors.dart';
import 'package:workxp/core/theme/pixel_typography.dart';

class FloatingCombatOverlay extends StatefulWidget {
  const FloatingCombatOverlay({
    super.key,
    required this.damage,
    required this.onComplete,
  });

  final int damage;
  final VoidCallback onComplete;

  @override
  State<FloatingCombatOverlay> createState() => _FloatingCombatOverlayState();
}

class _FloatingCombatOverlayState extends State<FloatingCombatOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.4), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 70),
    ]).animate(_controller);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, -0.6),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward().then((_) {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCrit = widget.damage >= 200;

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(
          scale: _scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slash line
              Container(
                height: 3,
                width: isCrit ? 100 : 60,
                color: isCrit ? PixelColors.hpRed : PixelColors.coinGold,
              ),
              const SizedBox(height: 2),
              Text(
                isCrit ? 'CRITICAL -${widget.damage}!' : '-${widget.damage}',
                style: PixelTypography.pixelHeader(
                  fontSize: isCrit ? 20 : 16,
                  color: isCrit ? PixelColors.hpRed : PixelColors.coinGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
