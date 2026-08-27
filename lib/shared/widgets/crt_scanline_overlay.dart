import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

/// 16-bit CRT Scanline Overlay widget providing retro arcade screen raster lines
class CrtScanlineOverlay extends StatelessWidget {
  const CrtScanlineOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.scanlineHeight = 3.0,
    this.opacity = 0.15,
  });

  final Widget child;
  final bool enabled;
  final double scanlineHeight;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _CrtScanlinePainter(
                scanlineHeight: scanlineHeight,
                opacity: opacity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CrtScanlinePainter extends CustomPainter {
  const _CrtScanlinePainter({
    required this.scanlineHeight,
    required this.opacity,
  });

  final double scanlineHeight;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double y = 0; y < size.height; y += scanlineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Subtle vignette around borders
    final rect = Offset.zero & size;
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Colors.transparent,
          PixelColors.borderDark.withValues(alpha: 0.35),
        ],
        stops: const [0.8, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant _CrtScanlinePainter oldDelegate) {
    return oldDelegate.scanlineHeight != scanlineHeight ||
        oldDelegate.opacity != opacity;
  }
}
