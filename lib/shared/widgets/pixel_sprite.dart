import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

/// Renders 16-bit retro pixel icons & sprites
class PixelSprite extends StatelessWidget {
  const PixelSprite({
    super.key,
    required this.spriteType,
    this.size = 48,
    this.isGhost = false,
  });

  final String spriteType;
  final double size;
  final bool isGhost;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelSpritePainter(spriteType: spriteType, isGhost: isGhost),
      ),
    );
  }
}

class _PixelSpritePainter extends CustomPainter {
  _PixelSpritePainter({required this.spriteType, required this.isGhost});

  final String spriteType;
  final bool isGhost;

  @override
  void paint(Canvas canvas, Size size) {
    final double pixelSize = size.width / 16.0;

    // Helper to draw a pixel block
    void drawPixel(int x, int y, Color color) {
      final paint = Paint()
        ..color = isGhost ? color.withAlpha(120) : color
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint,
      );
    }

    void drawGhostAura() {
      final glowPaint = Paint()
        ..color = PixelColors.ghostSpirit.withAlpha(60)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width * 0.45,
        glowPaint,
      );
    }

    if (isGhost) {
      drawGhostAura();
    }

    switch (spriteType.toLowerCase()) {
      case 'hero_novice':
      case 'hero_warrior':
      case 'paladin':
        _drawKnight(drawPixel);
        break;
      case 'dark_knight':
        _drawDarkKnight(drawPixel);
        break;
      case 'archmage':
        _drawMage(drawPixel);
        break;
      case 'cyber_samurai':
        _drawSamurai(drawPixel);
        break;
      case 'boss_slime':
      case 'king_slime':
        _drawKingSlime(drawPixel);
        break;
      case 'boss_goblin':
      case 'goblin_shaman':
        _drawGoblinShaman(drawPixel);
        break;
      case 'boss_necromancer':
      case 'shadow_crypt':
      case 'dread_necromancer':
        _drawNecromancer(drawPixel);
        break;
      case 'boss_dragon':
      case 'volcano_peak':
      case 'red_dragon':
        _drawRedDragon(drawPixel);
        break;
      case 'potion_health':
        _drawPotion(drawPixel, PixelColors.hpRed);
        break;
      case 'potion_mana':
        _drawPotion(drawPixel, PixelColors.mpBlue);
        break;
      case 'potion_exp':
        _drawPotion(drawPixel, PixelColors.expPurple);
        break;
      case 'elixir_life':
        _drawPotion(drawPixel, PixelColors.coinGold);
        break;
      case 'coin':
        _drawCoin(drawPixel);
        break;
      case 'shield':
        _drawShield(drawPixel);
        break;
      case 'sword':
        _drawSword(drawPixel);
        break;
      case 'trophy':
        _drawTrophy(drawPixel);
        break;
      default:
        _drawKnight(drawPixel);
        break;
    }
  }

  void _drawKnight(void Function(int, int, Color) draw) {
    // 16x16 Knight sprite
    const helm = Color(0xFFB0BEC5);
    const plume = PixelColors.attrStr;
    const armor = Color(0xFF78909C);
    const skin = Color(0xFFFFCC80);
    const eye = Color(0xFF263238);

    // Plume
    for (int x = 6; x <= 9; x++) {
      draw(x, 1, plume);
      draw(x, 2, plume);
    }
    // Helmet
    for (int y = 3; y <= 6; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, helm);
      }
    }
    // Face slot / eyes
    draw(6, 5, skin);
    draw(7, 5, eye);
    draw(8, 5, skin);
    draw(9, 5, eye);

    // Body armor
    for (int y = 7; y <= 11; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, armor);
      }
    }
    // Belt / Gold Trim
    for (int x = 4; x <= 11; x++) {
      draw(x, 11, PixelColors.coinGold);
    }
    // Legs
    for (int y = 12; y <= 14; y++) {
      draw(5, y, helm);
      draw(6, y, helm);
      draw(9, y, helm);
      draw(10, y, helm);
    }
  }

  void _drawDarkKnight(void Function(int, int, Color) draw) {
    const helm = Color(0xFF212121);
    const plume = PixelColors.expPurple;
    const armor = Color(0xFF424242);
    const eye = PixelColors.hpRed;

    for (int x = 6; x <= 9; x++) {
      draw(x, 1, plume);
      draw(x, 2, plume);
    }
    for (int y = 3; y <= 6; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, helm);
      }
    }
    draw(6, 5, eye);
    draw(9, 5, eye);
    for (int y = 7; y <= 11; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, armor);
      }
    }
    for (int x = 4; x <= 11; x++) {
      draw(x, 11, PixelColors.expPurple);
    }
    for (int y = 12; y <= 14; y++) {
      draw(5, y, helm);
      draw(6, y, helm);
      draw(9, y, helm);
      draw(10, y, helm);
    }
  }

  void _drawMage(void Function(int, int, Color) draw) {
    const hat = PixelColors.attrInt;
    const brim = PixelColors.coinGold;
    const robe = PixelColors.mpBlue;
    const skin = Color(0xFFFFCC80);
    const eye = PixelColors.mpCyan;

    // Wizard Hat
    draw(7, 1, hat);
    draw(8, 1, hat);
    for (int x = 6; x <= 9; x++) {
      draw(x, 2, hat);
      draw(x, 3, hat);
    }
    for (int x = 3; x <= 12; x++) {
      draw(x, 4, brim);
    }
    // Face
    for (int y = 5; y <= 7; y++) {
      for (int x = 5; x <= 10; x++) {
        draw(x, y, skin);
      }
    }
    draw(6, 6, eye);
    draw(9, 6, eye);
    // Robe
    for (int y = 8; y <= 14; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, robe);
      }
    }
  }

  void _drawSamurai(void Function(int, int, Color) draw) {
    const helm = Color(0xFF0F172A);
    const neon = PixelColors.mpCyan;
    const armor = Color(0xFF334155);
    const visor = PixelColors.expPink;

    for (int x = 7; x <= 8; x++) {
      draw(x, 1, neon);
    }
    for (int y = 2; y <= 6; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, helm);
      }
    }
    for (int x = 5; x <= 10; x++) {
      draw(x, 5, visor);
    }
    for (int y = 7; y <= 12; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, armor);
      }
    }
    for (int y = 13; y <= 14; y++) {
      draw(5, y, helm);
      draw(10, y, helm);
    }
  }

  void _drawKingSlime(void Function(int, int, Color) draw) {
    const slime = Color(0xFF48CAE4);
    const crown = PixelColors.coinGold;
    const ruby = PixelColors.hpRed;
    const eye = Color(0xFF03045E);

    // Crown
    draw(6, 2, crown);
    draw(8, 1, crown);
    draw(10, 2, crown);
    for (int x = 6; x <= 10; x++) {
      draw(x, 3, crown);
    }
    draw(8, 3, ruby);

    // Slime Body
    for (int y = 5; y <= 14; y++) {
      int minX = (y < 8) ? 4 : 2;
      int maxX = (y < 8) ? 12 : 14;
      for (int x = minX; x <= maxX; x++) {
        draw(x, y, slime);
      }
    }
    // Eyes
    draw(5, 8, eye);
    draw(6, 8, eye);
    draw(10, 8, eye);
    draw(11, 8, eye);
    // Smile
    draw(7, 11, eye);
    draw(8, 11, eye);
    draw(9, 11, eye);
  }

  void _drawGoblinShaman(void Function(int, int, Color) draw) {
    const skin = Color(0xFF55A630);
    const hood = Color(0xFF6F1D1B);
    const eye = Color(0xFFFFD166);

    for (int y = 2; y <= 6; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, hood);
      }
    }
    // Ears
    draw(2, 6, skin);
    draw(3, 7, skin);
    draw(13, 6, skin);
    draw(12, 7, skin);
    // Face
    for (int y = 6; y <= 10; y++) {
      for (int x = 5; x <= 10; x++) {
        draw(x, y, skin);
      }
    }
    draw(6, 7, eye);
    draw(9, 7, eye);
    // Staff/Body
    for (int y = 11; y <= 14; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, hood);
      }
    }
  }

  void _drawNecromancer(void Function(int, int, Color) draw) {
    const robe = Color(0xFF240046);
    const skull = Color(0xFFE0AAFF);
    const eye = PixelColors.mpCyan;

    for (int y = 2; y <= 6; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, robe);
      }
    }
    for (int y = 6; y <= 9; y++) {
      for (int x = 5; x <= 10; x++) {
        draw(x, y, skull);
      }
    }
    draw(6, 7, eye);
    draw(9, 7, eye);
    for (int y = 10; y <= 14; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, robe);
      }
    }
  }

  void _drawRedDragon(void Function(int, int, Color) draw) {
    const scales = Color(0xFFD00000);
    const horn = PixelColors.coinGold;
    const eye = PixelColors.coinGold;
    const belly = Color(0xFFFFBA08);

    // Horns
    draw(3, 2, horn);
    draw(4, 3, horn);
    draw(12, 2, horn);
    draw(11, 3, horn);

    // Head
    for (int y = 4; y <= 8; y++) {
      for (int x = 4; x <= 11; x++) {
        draw(x, y, scales);
      }
    }
    draw(5, 6, eye);
    draw(10, 6, eye);

    // Body
    for (int y = 9; y <= 14; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, scales);
      }
    }
    for (int y = 10; y <= 13; y++) {
      for (int x = 6; x <= 9; x++) {
        draw(x, y, belly);
      }
    }
  }

  void _drawPotion(void Function(int, int, Color) draw, Color liquid) {
    const glass = Color(0xFFE2E8F0);
    const cork = Color(0xFF8B5E3C);

    // Cork
    for (int x = 7; x <= 8; x++) {
      draw(x, 2, cork);
      draw(x, 3, cork);
    }
    // Neck
    for (int x = 6; x <= 9; x++) {
      draw(x, 4, glass);
      draw(x, 5, glass);
    }
    // Flask Body
    for (int y = 6; y <= 13; y++) {
      int minX = (y < 8) ? 4 : 3;
      int maxX = (y < 8) ? 11 : 12;
      for (int x = minX; x <= maxX; x++) {
        draw(x, y, liquid);
      }
    }
    // Highlight
    draw(5, 7, Colors.white);
    draw(4, 8, Colors.white);
  }

  void _drawCoin(void Function(int, int, Color) draw) {
    const gold = PixelColors.coinGold;
    const rim = PixelColors.coinAmber;
    const highlight = Color(0xFFFFF3B0);

    for (int y = 3; y <= 12; y++) {
      int minX = (y == 3 || y == 12) ? 5 : ((y == 4 || y == 11) ? 4 : 3);
      int maxX = (y == 3 || y == 12) ? 10 : ((y == 4 || y == 11) ? 11 : 12);
      for (int x = minX; x <= maxX; x++) {
        draw(x, y, gold);
      }
    }
    // Inner border
    for (int y = 5; y <= 10; y++) {
      draw(5, y, rim);
      draw(10, y, rim);
    }
    draw(5, 4, highlight);
    draw(6, 4, highlight);
  }

  void _drawShield(void Function(int, int, Color) draw) {
    const metal = Color(0xFF94A3B8);
    const gold = PixelColors.coinGold;
    for (int y = 3; y <= 10; y++) {
      for (int x = 3; x <= 12; x++) {
        draw(x, y, metal);
      }
    }
    for (int y = 11; y <= 14; y++) {
      int offset = y - 10;
      for (int x = 3 + offset; x <= 12 - offset; x++) {
        draw(x, y, metal);
      }
    }
    // Cross
    for (int y = 5; y <= 11; y++) {
      draw(7, y, gold);
      draw(8, y, gold);
    }
    for (int x = 5; x <= 10; x++) {
      draw(x, 7, gold);
    }
  }

  void _drawSword(void Function(int, int, Color) draw) {
    const blade = Color(0xFFE2E8F0);
    const gold = PixelColors.coinGold;
    const hilt = Color(0xFF7F1D1D);

    // Tip
    draw(12, 3, blade);
    draw(11, 4, blade);
    draw(10, 5, blade);
    draw(9, 6, blade);
    draw(8, 7, blade);
    draw(7, 8, blade);
    // Guard
    draw(5, 10, gold);
    draw(6, 9, gold);
    draw(7, 10, gold);
    draw(8, 9, gold);
    draw(9, 8, gold);
    // Handle & Pommel
    draw(5, 11, hilt);
    draw(4, 12, hilt);
    draw(3, 13, gold);
  }

  void _drawTrophy(void Function(int, int, Color) draw) {
    const gold = PixelColors.coinGold;
    const base = Color(0xFF64748B);

    for (int y = 3; y <= 7; y++) {
      for (int x = 5; x <= 10; x++) {
        draw(x, y, gold);
      }
    }
    // Handles
    draw(3, 4, gold);
    draw(3, 5, gold);
    draw(12, 4, gold);
    draw(12, 5, gold);
    // Stem
    for (int y = 8; y <= 10; y++) {
      draw(7, y, gold);
      draw(8, y, gold);
    }
    // Base
    for (int x = 4; x <= 11; x++) {
      draw(x, 11, base);
      draw(x, 12, base);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelSpritePainter oldDelegate) {
    return oldDelegate.spriteType != spriteType ||
        oldDelegate.isGhost != isGhost;
  }
}
