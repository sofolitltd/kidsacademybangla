import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final Map<String, String> item;
  final Color color;
  final bool isPlaying;
  final VoidCallback onTap;

  const ProfileInfoCard({
    super.key,
    required this.item,
    required this.color,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        transform: isPlaying
            ? (Matrix4.identity()..scale(0.98))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: isPlaying
              ? color.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPlaying ? color : color.withValues(alpha: 0.3),
            width: isPlaying ? 3 : 2,
          ),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                item['icon']!,
                style: TextStyle(fontSize: isPlaying ? 32 : 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isPlaying
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['value']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isPlaying ? Colors.white : color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.volume_up,
                color: isPlaying
                    ? Colors.white.withValues(alpha: 0.8)
                    : color.withValues(alpha: 0.4),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
