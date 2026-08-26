import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';
import '../theme/pixel_typography.dart';
import '../services/sensory_service.dart';

/// 16-bit Tactile Pixel Button with press depression effect
class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = PixelColors.coinGold,
    this.textColor = PixelColors.textDark,
    this.borderColor = PixelColors.borderDark,
    this.icon,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.isFullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool isFullWidth;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isEnabled
        ? widget.backgroundColor
        : PixelColors.borderHighlight.withAlpha(100);
    final txtColor = _isEnabled ? widget.textColor : PixelColors.textMuted;

    Widget content = GestureDetector(
      onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: _isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              SensoryService.instance.playClick();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () {
        if (_isPressed) setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        transform: Matrix4.translationValues(
          _isPressed ? 2.0 : 0.0,
          _isPressed ? 2.0 : 0.0,
          0.0,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: widget.borderColor, width: 2.0),
          boxShadow: _isPressed || !_isEnabled
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(160),
                    offset: const Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: widget.padding,
        child: Row(
          mainAxisSize: widget.isFullWidth
              ? MainAxisSize.max
              : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: widget.fontSize + 4, color: txtColor),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: PixelTypography.pixelSubheader(
                  fontSize: widget.fontSize,
                  color: txtColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }
}
