import 'package:material_ui/material_ui.dart';

import '../../../core/services/age_service.dart';
import 'home_reveal.dart';

const Color _accent = Color(0xFFFF7F50);
const Color _ink = Color(0xFF3D2A1E);

/// Bottom sheet where a parent picks the child's age band.
/// Returns the chosen level, or null if dismissed.
Future<int?> showAgePicker(BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      final current = AgeService.level.value;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'সন্তানের বয়স কত?',
                style: TextStyle(
                  fontFamily: 'SolaimanLipi',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'বয়স অনুযায়ী বিষয় সাজানো হবে। পরে বদলানো যাবে।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SolaimanLipi',
                  fontSize: 14,
                  color: Colors.brown.shade400,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  for (final level in AgeService.levels)
                    _AgeOption(
                      level: level,
                      selected: level == current,
                      onTap: () => Navigator.of(context).pop(level),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _AgeOption extends StatelessWidget {
  final int level;
  final bool selected;
  final VoidCallback onTap;

  const _AgeOption({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? _accent.withValues(alpha: 0.18)
              : const Color(0xFFFFF6EE),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _accent : _accent.withValues(alpha: 0.25),
            width: selected ? 3 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AgeService.emoji(level), style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 4),
            Text(
              AgeService.label(level),
              style: const TextStyle(
                fontFamily: 'SolaimanLipi',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small pill on the home screen showing the current level; tap to change.
class HomeAgeChip extends StatelessWidget {
  final int? level;
  final VoidCallback onTap;

  const HomeAgeChip({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final level = this.level;
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _accent.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level == null ? '🎂' : AgeService.emoji(level),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Text(
              level == null ? 'বয়স বাছুন' : 'বয়স: ${AgeService.label(level)}',
              style: const TextStyle(
                fontFamily: 'SolaimanLipi',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _ink,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more_rounded,
              size: 20,
              color: Colors.brown.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
