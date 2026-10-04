import 'package:flutter/material.dart';
import '../../../core/services/ad_service.dart';
import '../../../utils/lucide.dart';
import 'home_reveal.dart';

const Color _accent = Color(0xFFFF7F50);

BoxDecoration _glass(double radius) => BoxDecoration(
  color: Colors.white.withValues(alpha: 0.4),
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
  boxShadow: [
    BoxShadow(
      color: _accent.withValues(alpha: 0.18),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);

/// Glass pill showing the star balance.
class HomeTokenPill extends StatelessWidget {
  final int tokens;
  final VoidCallback onTap;

  /// Opt-in "watch an ad for a star" action, shown as a small + when ready.
  final VoidCallback? onWatchAd;

  const HomeTokenPill({
    super.key,
    required this.tokens,
    required this.onTap,
    this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(5, 0, 14, 0),
        decoration: _glass(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD66B), Color(0xFFFFA928)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const LucideIcon(
                LucideIcons.star,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$tokens',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D2A1E),
              ),
            ),
            if (onWatchAd != null)
              ValueListenableBuilder<bool>(
                valueListenable: AdService.instance.rewardedReady,
                builder: (context, ready, _) {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: ready
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: PressScale(
                              onTap: onWatchAd,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFFB074), _accent],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Glass segmented switch (grid / list) with a sliding gradient thumb.
class HomeViewToggle extends StatelessWidget {
  final bool isGrid;
  final ValueChanged<bool> onChanged;

  const HomeViewToggle({
    super.key,
    required this.isGrid,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double w = 44, h = 28;
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: _glass(24),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: isGrid ? 0 : w,
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB074), _accent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _segment(Icons.grid_view_rounded, true, w, h),
              _segment(Icons.view_agenda_rounded, false, w, h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segment(IconData icon, bool grid, double w, double h) {
    final selected = isGrid == grid;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(grid),
      child: SizedBox(
        width: w,
        height: h,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              icon,
              key: ValueKey(selected),
              size: 20,
              color: selected ? Colors.white : Colors.brown.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
