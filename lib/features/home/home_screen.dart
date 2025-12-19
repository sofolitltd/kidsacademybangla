import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/services/reward_service.dart';

class Category {
  final String title;
  final String imagePath;
  final Color color;
  final String categoryKey;

  Category({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.categoryKey,
  });
}

class CategoryGroup {
  final String groupName;
  final List<Category> items;

  CategoryGroup({required this.groupName, required this.items});
}

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

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadRewardedAd();
  }

  Future<void> _loadInitialData() async {
    final tokens = await RewardService.getTokens();
    if (mounted) setState(() => _userTokens = tokens);
  }

  @override
  void dispose() {
    _rewardTimer?.cancel();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // TEST ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() => _rewardedAd = ad);
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadRewardedAd();
              _showRewardSuccess();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
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

  int _backCounter = 0;
  void _showAdIfReady() {
    _backCounter++;
    // Show ad every time they return from a category
    // todo: change 100 to 2 in when 100+ user
    if (_rewardedAd != null && _backCounter % 100 == 0) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => debugPrint("Earned!"),
      );
      _rewardedAd = null;
    }
  }

  final List<CategoryGroup> _groupedCategories = [
    CategoryGroup(
      groupName: 'বাংলা শিক্ষা',
      items: [
        Category(
          title: 'স্বরবর্ণ',
          imagePath: 'assets/images/categories/bangla_vowels.png',
          color: Colors.deepOrange,
          categoryKey: 'bangla_vowels',
        ),
        Category(
          title: 'ব্যঞ্জনবর্ণ',
          imagePath: 'assets/images/categories/bangla_consonants.png',
          color: Colors.green,
          categoryKey: 'bangla_consonants',
        ),
        Category(
          title: 'বাংলা সংখ্যা',
          imagePath: 'assets/images/categories/bangla_numbers.png',
          color: Colors.blue,
          categoryKey: 'bangla_numbers',
        ),
        Category(
          title: 'বাংলা ছড়া',
          imagePath: 'assets/images/categories/bangla_rhymes.png',
          color: Colors.amber,
          categoryKey: 'bangla_rhymes',
        ),
      ],
    ),
    CategoryGroup(
      groupName: 'English Learning',
      items: [
        Category(
          title: 'Alphabets',
          imagePath: 'assets/images/categories/english_alphabets.png',
          color: Colors.red,
          categoryKey: 'english_alphabets',
        ),
        Category(
          title: 'Numbers',
          imagePath: 'assets/images/categories/english_numbers.png',
          color: Colors.purple,
          categoryKey: 'english_numbers',
        ),
        Category(
          title: 'Rhymes',
          imagePath: 'assets/images/categories/english_rhymes.png',
          color: Colors.blueAccent,
          categoryKey: 'english_rhymes',
        ),
      ],
    ),
    CategoryGroup(
      groupName: 'আরবি শিক্ষা',
      items: [
        Category(
          title: 'আরবি হরফ',
          imagePath: 'assets/images/categories/arabic_alphabets.png',
          color: Colors.teal,
          categoryKey: 'arabic_alphabets',
        ),
        Category(
          title: 'আরবি সংখ্যা',
          imagePath: 'assets/images/categories/arabic_numbers.png',
          color: Colors.indigo,
          categoryKey: 'arabic_numbers',
        ),
      ],
    ),
    CategoryGroup(
      groupName: 'সাধারণ শিক্ষা',
      items: [
        Category(
          title: 'প্রাণী',
          imagePath: 'assets/images/categories/animals.png',
          color: Colors.orange,
          categoryKey: 'animals',
        ),
        Category(
          title: 'ফল',
          imagePath: 'assets/images/categories/fruits.png',
          color: Colors.pink,
          categoryKey: 'fruits',
        ),
        Category(
          title: 'রঙ',
          imagePath: 'assets/images/categories/colors.png',
          color: Colors.cyan,
          categoryKey: 'colors',
        ),
      ],
    ),
    CategoryGroup(
      groupName: 'ইসলামিক',
      items: [
        Category(
          title: 'আল্লাহর ৯৯ নাম',
          imagePath: 'assets/images/categories/allah_names.png',
          color: const Color(0xFF449A4A),
          categoryKey: 'allah_names',
        ),
        Category(
          title: 'ছোট সূরা',
          imagePath: 'assets/images/categories/small_suras.png',
          color: const Color(0xFFEEEAAC),
          categoryKey: 'small_suras',
        ),
      ],
    ),
  ];

  RewardedAd? _rewardedAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: .3)),
          ),
          SafeArea(
            child: CustomScrollView(
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
                            GestureDetector(
                              onTap: () async {
                                await context.push('/stickers');
                                _loadInitialData();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.stars,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$_userTokens',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ToggleButtons(
                              isSelected: [_isGridView, !_isGridView],
                              onPressed: (int index) =>
                                  setState(() => _isGridView = index == 0),
                              borderRadius: BorderRadius.circular(12),
                              selectedBorderColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              selectedColor: Colors.white,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.8),
                              color: Theme.of(context).colorScheme.primary,
                              constraints: const BoxConstraints(
                                minHeight: 40,
                                minWidth: 40,
                              ),
                              children: const [
                                Icon(Icons.grid_view, size: 22),
                                Icon(Icons.view_list, size: 22),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final group = _groupedCategories[index];
                    return _buildGroupSection(group);
                  }, childCount: _groupedCategories.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
          if (_showRewardPopup) _buildRewardPopup(),
        ],
      ),
    );
  }

  Widget _buildRewardPopup() {
    return GestureDetector(
      onTap: () => setState(() => _showRewardPopup = false),
      child: Container(
        color: Colors.black.withOpacity(0.6),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) =>
                Transform.scale(scale: value, child: child),
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 40.0,
                ),
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 100),
                    const SizedBox(height: 24),
                    const Text(
                      "চমৎকার হয়েছে!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "তুমি $_earnedTokensThisSession টি নতুন টোকেন পেয়েছ!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () =>
                            setState(() => _showRewardPopup = false),
                        child: const Text(
                          "ঠিক আছে",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSection(CategoryGroup group) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(group.groupName),
          const SizedBox(height: 16),
          _isGridView
              ? _buildGridItems(group.items)
              : _buildListItems(group.items),
        ],
      ),
    );
  }

  Widget _buildGridItems(List<Category> items) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: items.map((category) => _buildCategoryCard(category)).toList(),
    );
  }

  Widget _buildListItems(List<Category> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildCategoryListTile(items[index]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Card(
      elevation: 0,
      color: category.color.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: .8), width: 2),
      ),
      child: InkWell(
        onTap: () async {
          await context.push(
            '/details/${category.categoryKey}',
            extra: {'title': category.title, 'color': category.color},
          );
          _showAdIfReady();
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset(category.imagePath, fit: BoxFit.cover),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListTile(Category category) {
    return Card(
      elevation: 0,
      color: category.color.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.8), width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.white30,
          radius: 26,
          child: Image.asset(category.imagePath, height: 36, width: 36),
        ),
        title: Text(
          category.title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 18,
        ),
        onTap: () async {
          await context.push(
            '/details/${category.categoryKey}',
            extra: {'title': category.title, 'color': category.color},
          );
          _showAdIfReady();
        },
      ),
    );
  }
}
