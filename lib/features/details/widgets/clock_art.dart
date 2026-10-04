import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Analog clock drawn in code that shows an exact time, so lessons like
/// "৩:০০" are readable at a glance (replaces the generic clock emoji).
class ClockArt extends StatelessWidget {
  final int hour;
  final int minute;
  final double size;
  final Color color;

  const ClockArt({
    super.key,
    required this.hour,
    this.minute = 0,
    this.size = 90,
    this.color = const Color(0xFF3F51B5),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ClockPainter(hour, minute, color)),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final Color color;

  _ClockPainter(this.hour, this.minute, this.color);

  static const _bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  String _bangla(int n) => '$n'.split('').map((c) => _bn[int.parse(c)]).join();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final dark = Color.lerp(color, Colors.black, 0.35)!;

    // Soft shadow.
    canvas.drawCircle(
      c.translate(0, r * 0.05),
      r * 0.96,
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.12),
    );

    // Rim.
    canvas.drawCircle(
      c,
      r * 0.97,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.35)!, dark],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    // Face.
    final faceR = r * 0.85;
    canvas.drawCircle(c, faceR, Paint()..color = Colors.white);
    canvas.drawCircle(
      c,
      faceR,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white, color.withValues(alpha: 0.10)],
          stops: const [0.6, 1],
        ).createShader(Rect.fromCircle(center: c, radius: faceR)),
    );

    // Minute ticks and hour ticks.
    for (var i = 0; i < 60; i++) {
      final isHour = i % 5 == 0;
      final a = 2 * math.pi * i / 60 - math.pi / 2;
      final outer = faceR * 0.97;
      final inner = faceR * (isHour ? 0.86 : 0.92);
      canvas.drawLine(
        c + Offset(math.cos(a), math.sin(a)) * inner,
        c + Offset(math.cos(a), math.sin(a)) * outer,
        Paint()
          ..color = isHour ? dark : dark.withValues(alpha: 0.4)
          ..strokeWidth = isHour ? r * 0.035 : r * 0.015
          ..strokeCap = StrokeCap.round,
      );
    }

    // Numbers 1-12.
    for (var n = 1; n <= 12; n++) {
      final a = 2 * math.pi * n / 12 - math.pi / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: _bangla(n),
          style: TextStyle(
            fontFamily: 'SolaimanLipi',
            fontSize: r * 0.26,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final p = c + Offset(math.cos(a), math.sin(a)) * (faceR * 0.68);
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }

    // Hands.
    final minuteAngle = 2 * math.pi * (minute / 60) - math.pi / 2;
    final hourAngle =
        2 * math.pi * (((hour % 12) + minute / 60) / 12) - math.pi / 2;

    void hand(double angle, double length, double width, Color col) {
      final end = c + Offset(math.cos(angle), math.sin(angle)) * length;
      final tail = c - Offset(math.cos(angle), math.sin(angle)) * (r * 0.08);
      canvas.drawLine(
        tail,
        end,
        Paint()
          ..color = col
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    hand(hourAngle, faceR * 0.45, r * 0.08, const Color(0xFFE53935));
    hand(minuteAngle, faceR * 0.68, r * 0.05, dark);

    // Centre cap.
    canvas.drawCircle(c, r * 0.07, Paint()..color = const Color(0xFFE53935));
    canvas.drawCircle(c, r * 0.03, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter old) =>
      old.hour != hour || old.minute != minute || old.color != color;
}
