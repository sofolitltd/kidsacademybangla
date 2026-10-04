import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/profile_service.dart';
import 'home_reveal.dart';

class HomeProfileSection extends StatelessWidget {
  static const Color _accent = Color(0xFFFF7F50);

  final List<ChildProfile> profiles;
  final VoidCallback onProfilesChanged;

  const HomeProfileSection({
    super.key,
    required this.profiles,
    required this.onProfilesChanged,
  });

  Future<void> _addChild(BuildContext context) async {
    await context.push('/profile/form');
    onProfilesChanged();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = profiles.isEmpty;

    return HomeReveal(
      revealKey: 'profile_section',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFB074), _accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text('👶', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'আমার পরিচয়',
                        style: TextStyle(
                          fontFamily: "SolaimanLipi",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D2A1E),
                        ),
                      ),
                      Text(
                        isEmpty
                            ? 'সন্তানের তথ্য দিন, সে নিজের পরিচয় শিখবে'
                            : 'সন্তান নিজের পরিচয় শিখুক!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "SolaimanLipi",
                          fontSize: 13,
                          color: Colors.brown.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildAddButton(context, labeled: isEmpty),
              ],
            ),
            if (!isEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: profiles.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) =>
                      _buildProfileChip(context, profiles[i]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, {required bool labeled}) {
    return PressScale(
      onTap: () => _addChild(context),
      child: Container(
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: labeled ? 14 : 0),
        constraints: const BoxConstraints(minWidth: 36),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [Color(0xFFFFB074), _accent]),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            if (labeled) ...[
              const SizedBox(width: 4),
              const Text(
                'যোগ করুন',
                style: TextStyle(
                  fontFamily: "SolaimanLipi",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileChip(BuildContext context, ChildProfile profile) {
    return PressScale(
      onTap: () async {
        await context.push('/profile/learn/${profile.id}');
        onProfilesChanged();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 4, 14, 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _accent.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accent.withValues(alpha: 0.15),
              ),
              child: const Text('👶', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: Text(
                profile.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "SolaimanLipi",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2A1E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
