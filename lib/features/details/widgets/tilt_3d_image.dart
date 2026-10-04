import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Gives a flat image a 3D feel:
/// - drag to tilt (vertical) and spin around (horizontal, with momentum),
/// - tilting the phone gently shifts the view,
/// - a slow idle float with a breathing shadow,
/// - a glossy highlight that moves with the rotation.
/// The back face shows [back], or a darkened mirror of [child] if null.
class Tilt3DImage extends StatefulWidget {
  final Widget child;
  final Widget? back;
  final double height;

  const Tilt3DImage({
    super.key,
    required this.child,
    this.back,
    this.height = 300,
  });

  @override
  State<Tilt3DImage> createState() => _Tilt3DImageState();
}

class _Tilt3DImageState extends State<Tilt3DImage>
    with SingleTickerProviderStateMixin {
  static const double _twoPi = math.pi * 2;

  late final Ticker _ticker;
  StreamSubscription<AccelerometerEvent>? _sensorSub;
  Duration _last = Duration.zero;

  double _rotX = 0;
  double _rotY = 0;
  double _velY = 0; // rad/s
  double _sensorX = 0;
  double _sensorY = 0;
  double _time = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    try {
      _sensorSub = accelerometerEventStream().listen((e) {
        // Phone held upright: gravity is mostly on y. Map the lean to a tilt.
        _sensorY = (e.x / 9.8).clamp(-1.0, 1.0) * -0.3;
        _sensorX = ((e.y / 9.8) - 0.6).clamp(-1.0, 1.0) * 0.3;
      }, onError: (_) {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sensorSub?.cancel();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt = ((elapsed - _last).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _last = elapsed;
    _time += dt;

    if (!_dragging) {
      // Momentum with friction.
      _rotY += _velY * dt;
      _velY *= math.pow(0.04, dt).toDouble();

      // Once slow, settle on the nearest front-facing angle.
      if (_velY.abs() < 1.0) {
        final target = (_rotY / _twoPi).roundToDouble() * _twoPi + _sensorY;
        _rotY += (target - _rotY) * math.min(1.0, dt * 6);
      }
      _rotX += (_sensorX - _rotX) * math.min(1.0, dt * 6);
    }
    setState(() {});
  }

  void _onDrag(double dx, double dy) {
    _rotY += dx * 0.012;
    _rotX = (_rotX - dy * 0.01).clamp(-0.7, 0.7);
  }

  @override
  Widget build(BuildContext context) {
    // Gentle "breathing" beat: eased scale up and down, no vertical travel.
    final beat = 0.5 - 0.5 * math.cos(_time * _twoPi / 2.8); // 0..1
    final beatScale = 1 + 0.06 * beat;
    final isBack = math.cos(_rotY) < 0;

    Widget face;
    if (!isBack) {
      face = widget.child;
    } else if (widget.back != null) {
      face = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: widget.back,
      );
    } else {
      face = ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withValues(alpha: 0.35),
          BlendMode.srcATop,
        ),
        child: widget.child,
      );
    }

    // Moving highlight, painted only over the image's opaque pixels.
    final glare = math.sin(_rotY) * 1.2 + _rotX;
    face = ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment(-1.5 + glare, -1),
        end: Alignment(-0.5 + glare, 1),
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: 0.28),
          Colors.white.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect),
      child: face,
    );

    final shadowScale = 1.0 + 0.06 * beat;
    final squash = 0.6 + 0.4 * math.cos(_rotX).abs();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (_) {
        _dragging = true;
        _velY = 0;
      },
      onHorizontalDragUpdate: (d) => _onDrag(d.delta.dx, 0),
      onHorizontalDragEnd: (d) {
        _dragging = false;
        _velY = (d.primaryVelocity ?? 0) * 0.012;
      },
      onVerticalDragStart: (_) => _dragging = true,
      onVerticalDragUpdate: (d) => _onDrag(0, d.delta.dy),
      onVerticalDragEnd: (_) => _dragging = false,
      onVerticalDragCancel: () => _dragging = false,
      onHorizontalDragCancel: () => _dragging = false,
      child: SizedBox(
        height: widget.height + 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: Transform.scale(
                scale: shadowScale,
                child: Container(
                  width: widget.height * 0.55 * squash,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Transform.scale(
                scale: beatScale,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateX(_rotX)
                    ..rotateY(_rotY),
                  child: SizedBox(height: widget.height, child: face),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
