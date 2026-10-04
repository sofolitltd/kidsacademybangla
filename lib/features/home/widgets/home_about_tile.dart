import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_reveal.dart';

/// Footer entry to the About / developer page.
class HomeAboutTile extends StatelessWidget {
  static const Color _accent = Color(0xFFFF7F50);

  const HomeAboutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeReveal(
      revealKey: 'about_tile',
      child: PressScale(
        onTap: () => context.push('/about'),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 28, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFB074), _accent],
                  ),
                ),
                child: const Text('💛', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ডেভেলপার সম্পর্কে',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2A1E),
                      ),
                    ),
                    Text(
                      'অ্যাপের গল্প, যোগাযোগ ও রেটিং',
                      style: TextStyle(fontSize: 13, color: Color(0xFF8D6E63)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _accent),
            ],
          ),
        ),
      ),
    );
  }
}
