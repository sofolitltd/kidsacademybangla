import 'package:flutter/material.dart';
import '../../../utils/lucide.dart';

class FocusControlBar extends StatelessWidget {
  final bool isPlaying;
  final bool isAutoPlaying;
  final Color color;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onPlayCurrent;
  final VoidCallback onToggleAutoPlay;
  final VoidCallback? onStopAutoPlay;
  final VoidCallback onSpeakCurrent;

  const FocusControlBar({
    super.key,
    required this.isPlaying,
    required this.isAutoPlaying,
    required this.color,
    required this.onPrevious,
    required this.onNext,
    required this.onPlayCurrent,
    required this.onToggleAutoPlay,
    required this.onStopAutoPlay,
    required this.onSpeakCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            icon: isPlaying ? LucideIcons.speakerHigh : LucideIcons.speakerNone,
            onPressed: onPlayCurrent,
            color: color,
          ),
          _buildButton(
            icon: LucideIcons.speakerHigh,
            onPressed: onSpeakCurrent,
            color: color,
          ),
          _buildButton(
            icon: isAutoPlaying ? LucideIcons.pause : LucideIcons.play,
            onPressed: onToggleAutoPlay,
            color: Colors.green,
            large: true,
          ),
          _buildButton(
            icon: LucideIcons.stop,
            onPressed: onStopAutoPlay,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    bool large = false,
  }) {
    final size = large ? 64.0 : 50.0;
    final iconSize = large ? 32.0 : 26.0;
    return AnimatedOpacity(
      opacity: onPressed != null ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: LucideIcon(icon, color: color, size: iconSize),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
