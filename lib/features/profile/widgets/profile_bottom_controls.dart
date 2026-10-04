import 'package:flutter/material.dart';

class ProfileBottomControls extends StatelessWidget {
  final bool isPlaying;
  final bool isSlowMode;
  final bool isEmpty;
  final VoidCallback onToggleSlowMode;
  final VoidCallback onPlayAll;

  const ProfileBottomControls({
    super.key,
    required this.isPlaying,
    required this.isSlowMode,
    required this.isEmpty,
    required this.onToggleSlowMode,
    required this.onPlayAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggleSlowMode,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSlowMode
                    ? Colors.orange.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSlowMode ? Colors.orange : Colors.grey.shade300,
                ),
              ),
              child: Text(
                isSlowMode ? '🐕‍🦺 ধ�ীর' : '🐕 স্বাভাবিক',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSlowMode ? Colors.orange : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isEmpty ? null : onPlayAll,
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow, size: 24),
                label: Text(
                  isPlaying ? 'থামান' : 'সব শুনুন',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPlaying ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
