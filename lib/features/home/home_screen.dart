import 'dart:async';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/ad_service.dart';
import '../../core/services/age_service.dart';
import '../../core/services/reward_service.dart';
import '../../core/services/update_service.dart';
import '../../core/services/profile_service.dart';
import '../home/data/home_category_data.dart';
import '../home/widgets/home_reward_popup.dart';
import '../home/widgets/home_age_picker.dart';
import '../home/widgets/home_profile_section.dart';
import '../home/widgets/home_category_card.dart';
import '../home/widgets/home_about_tile.dart';
import '../home/widgets/home_banner_ad.dart';
import '../home/widgets/home_reveal.dart';
import '../home/widgets/home_top_controls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = true;
  bool _showRewardPopup = false;
  Timer? _rewardTimer;
  int _userTokens = 0;
  int _earnedTokensThisSession = 0;
  List<ChildProfile> _profiles = [];
  bool _showLater = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadProfiles();
    AgeService.level.addListener(_onLevelChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // First launch with no profile and no chosen level: ask once.
      if (AgeService.level.value == null) _pickAge();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) UpdateService.checkForUpdate(context);
      });
    });
  }

  Future<void> _loadInitialData() async {
    final tokens = await RewardService.getTokens();
    if (mounted) setState(() => _userTokens = tokens);
  }

  Future<void> _loadProfiles() async {
    final profiles = await ProfileService.getAllProfiles();
    // A new or edited birth date can change the level.
    await AgeService.load();
    if (mounted) setState(() => _profiles = profiles);
  }

  void _onLevelChanged() {
    if (mounted) setState(() => _showLater = false);
  }

  Future<void> _pickAge() async {
    final picked = await showAgePicker(context);
    if (picked != null) await AgeService.setLevel(picked);
  }

  @override
  void dispose() {
    AgeService.level.removeListener(_onLevelChanged);
    _rewardTimer?.cancel();
    super.dispose();
  }

  void _showRewardSuccess() async {
    // Award 1-2 random tokens
    int amount = Random().nextInt(2) + 1;
    await RewardService.addTokens(amount);
    final updatedTokens = await RewardService.getTokens();

    setState(() {
      _userTokens = updatedTokens;
      _earnedTokensThisSession = amount;
      _showRewardPopup = true;
    });

    _rewardTimer?.cancel();
    _rewardTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showRewardPopup = false);
    });
  }

  /// Called when the child returns from a category. Rate limited in AdService.
  void _showAdIfReady() {
    // Stars may have been earned in a game while away.
    _loadInitialData();
    if (mounted) AdService.instance.maybeShowNativeBreak(context);
  }

  /// Opt-in reward: the child taps the "+" next to the stars.
  void _watchAdForStar() {
    AdService.instance.showRewarded(_showRewardSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final level = AgeService.level.value;
    // Categories that suit the child now, kept in their groups; the rest are
    // tucked into one collapsed section rather than locked away.
    final forNow = <CategoryGroup>[];
    final later = <Category>[];
    for (final group in groupedCategories) {
      final fits = <Category>[];
      for (final c in group.items) {
        (level == null || c.minAge <= level ? fits : later).add(c);
      }
      if (fits.isNotEmpty) {
        forNow.add(CategoryGroup(groupName: group.groupName, items: fits));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.white.withValues(alpha: .3)),
                ],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/logo_text.png', height: 80),
                        Row(
                          children: [
                            HomeTokenPill(
                              tokens: _userTokens,
                              onWatchAd: _watchAdForStar,
                              onTap: () async {
                                await context.push('/stickers');
                                _loadInitialData();
                              },
                            ),
                            const SizedBox(width: 10),
                            HomeViewToggle(
                              isGrid: _isGridView,
                              onChanged: (v) => setState(() => _isGridView = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HomeProfileSection(
                    profiles: _profiles,
                    onProfilesChanged: _loadProfiles,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: HomeAgeChip(level: level, onTap: _pickAge),
                    ),
                  ),
                ),
                for (final group in forNow) ..._buildGroupSlivers(group),
                if (later.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
                      child: _buildLaterToggle(later.length),
                    ),
                  ),
                  if (_showLater)
                    ..._buildGroupSlivers(
                      CategoryGroup(groupName: '', items: later),
                    ),
                ],
                // A single banner, at the very end of the list.
                SliverToBoxAdapter(
                  child: HomeBannerAd(
                    slot: 'g${groupedCategories.length - 1}',
                  ),
                ),
                const SliverToBoxAdapter(child: HomeAboutTile()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
          if (_showRewardPopup)
            HomeRewardPopup(
              earnedTokens: _earnedTokensThisSession,
              onDismiss: () => setState(() => _showRewardPopup = false),
            ),
        ],
      ),
    );
  }

  /// Header + lazily built grid/list per group, so only visible cards are built.
  List<Widget> _buildGroupSlivers(CategoryGroup group) {
    final items = group.items;
    return [
      if (group.groupName.isEmpty)
        const SliverToBoxAdapter(child: SizedBox(height: 16))
      else
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
            child: HomeReveal(
              revealKey: 'header_${group.groupName}',
              child: _buildSectionHeader(group.groupName),
            ),
          ),
        ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: _isGridView
            ? SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: .9,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final category = items[i];
                  return HomeReveal(
                    revealKey: 'grid_${category.categoryKey}',
                    delay: Duration(milliseconds: i.isOdd ? 90 : 0),
                    child: RepaintBoundary(
                      child: HomeCategoryCard(
                        category: category,
                        onAdShown: _showAdIfReady,
                      ),
                    ),
                  );
                }, childCount: items.length),
              )
            : SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final category = items[i];
                  return HomeReveal(
                    revealKey: 'list_${category.categoryKey}',
                    child: RepaintBoundary(
                      child: HomeCategoryListTile(
                        category: category,
                        onAdShown: _showAdIfReady,
                      ),
                    ),
                  );
                },
              ),
      ),
    ];
  }

  /// Collapsed "for when you're older" section header.
  Widget _buildLaterToggle(int count) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _showLater = !_showLater),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 3,
          ),
        ),
        child: Row(
          children: [
            const Text('🌱', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'আরও বড় হলে ($countটি বিষয়)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2A1E),
                ),
              ),
            ),
            Icon(
              _showLater
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              size: 28,
              color: Colors.brown.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    const accent = Color(0xFFFF7F50);
    return Row(
      children: [
        Container(
          width: 6,
          height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFB074), accent],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D2A1E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.35),
                  accent.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
