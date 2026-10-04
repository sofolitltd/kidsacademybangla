import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Crisp, gradient-filled geometric shapes drawn in code (no emoji).
/// [shape] is the English shape name from the data ('Circle', 'Square', ...).
class ShapeArt extends StatelessWidget {
  final String shape;
  final double size;

  const ShapeArt({super.key, required this.shape, this.size = 80});

  static const Map<String, List<Color>> _palette = {
    'circle': [Color(0xFFFF8A80), Color(0xFFE53935)],
    'square': [Color(0xFF82B1FF), Color(0xFF1E66F5)],
    'triangle': [Color(0xFFFFE082), Color(0xFFFFA000)],
    'rectangle': [Color(0xFFA5D6A7), Color(0xFF2E9E4F)],
    'pentagon': [Color(0xFFCE93D8), Color(0xFF8E24AA)],
    'hexagon': [Color(0xFF80DEEA), Color(0xFF00A5BD)],
    'octagon': [Color(0xFFFFAB91), Color(0xFFE64A19)],
    'star': [Color(0xFFFFF59D), Color(0xFFFBC02D)],
    'diamond': [Color(0xFF90CAF9), Color(0xFF5C6BC0)],
    'oval': [Color(0xFFF48FB1), Color(0xFFD81B60)],
  };

  @override
  Widget build(BuildContext context) {
    final key = shape.toLowerCase();
    final colors = _palette[key] ?? _palette['circle']!;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ShapePainter(key, colors)),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final String shape;
  final List<Color> colors;

  _ShapePainter(this.shape, this.colors);

  Path _polygon(Rect r, int sides, {double rotation = -math.pi / 2}) {
    final c = r.center;
    final rad = r.shortestSide / 2;
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final a = rotation + 2 * math.pi * i / sides;
      final p = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  Path _star(Rect r) {
    final c = r.center;
    final outer = r.shortestSide / 2;
    final inner = outer * 0.42;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final rad = i.isEven ? outer : inner;
      final a = -math.pi / 2 + math.pi * i / 5;
      final p = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  Path _pathFor(Size size) {
    final pad = size.width * 0.08;
    final box = Rect.fromLTWH(
      pad,
      pad,
      size.width - 2 * pad,
      size.height - 2 * pad,
    );
    switch (shape) {
      case 'square':
        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: box.center,
              width: box.width * 0.9,
              height: box.height * 0.9,
            ),
            Radius.circular(box.width * 0.12),
          ),
        );
      case 'rectangle':
        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: box.center,
              width: box.width,
              height: box.height * 0.64,
            ),
            Radius.circular(box.width * 0.1),
          ),
        );
      case 'triangle':
        return _polygon(
          Rect.fromLTWH(
            box.left,
            box.top + box.height * 0.08,
            box.width,
            box.height,
          ),
          3,
        );
      case 'pentagon':
        return _polygon(box, 5);
      case 'hexagon':
        return _polygon(box, 6, rotation: 0);
      case 'octagon':
        return _polygon(box, 8, rotation: math.pi / 8);
      case 'star':
        return _star(box);
      case 'diamond':
        return _polygon(
          Rect.fromCenter(
            center: box.center,
            width: box.width,
            height: box.height,
          ),
          4,
        );
      case 'oval':
        return Path()..addOval(
          Rect.fromCenter(
            center: box.center,
            width: box.width * 0.72,
            height: box.height,
          ),
        );
      default:
        return Path()..addOval(box);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _pathFor(size);
    final bounds = path.getBounds();

    // Soft ground shadow.
    canvas.drawPath(
      path.shift(Offset(0, size.height * 0.04)),
      Paint()
        ..color = colors.last.withValues(alpha: 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.05),
    );

    // Gradient body.
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(bounds),
    );

    // Glossy highlight clipped to the shape.
    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.center,
          colors: [
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(bounds),
    );
    canvas.restore();

    // Crisp light edge.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.025
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  @override
  bool shouldRepaint(covariant _ShapePainter old) => old.shape != shape;
}
