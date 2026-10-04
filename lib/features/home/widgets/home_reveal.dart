import 'package:flutter/material.dart';

/// Fade + slide + soft scale entrance. Plays once per [revealKey]; items that
/// were already revealed (e.g. scrolled back into view) appear instantly.
class HomeReveal extends StatefulWidget {
  static final Set<String> _revealed = {};

  final String revealKey;
  final Duration delay;
  final Widget child;

  const HomeReveal({
    super.key,
    required this.revealKey,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<HomeReveal> createState() => _HomeRevealState();
}

class _HomeRevealState extends State<HomeReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    if (HomeReveal._revealed.contains(widget.revealKey)) {
      _controller.value = 1;
    } else {
      HomeReveal._revealed.add(widget.revealKey);
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final t = _curve.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 28),
            child: Transform.scale(scale: 0.94 + 0.06 * t, child: child),
          ),
        );
      },
    );
  }
}

/// Springy press feedback for tappable cards.
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const PressScale({super.key, required this.child, this.onTap});

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.95 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
