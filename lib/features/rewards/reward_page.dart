import 'package:flutter/material.dart';

import '../../core/services/reward_service.dart';
import '../rewards/data/reward_item_data.dart';
import '../rewards/widgets/reward_dialogs.dart';

class TreasurePage extends StatefulWidget {
  const TreasurePage({super.key});

  @override
  State<TreasurePage> createState() => _TreasurePageState();
}

class _TreasurePageState extends State<TreasurePage> {
  int _userTokens = 0;
  List<String> _unlockedIds = [];
  List<Map<String, dynamic>> _sortedList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tokens = await RewardService.getTokens();
    final unlocked = await RewardService.getUnlockedItems();

    List<Map<String, dynamic>> unlockedItems = [];
    List<Map<String, dynamic>> lockedItems = [];

    for (var item in rewardAllItems) {
      final cost = rewardCosts[item['id']] ?? 20;
      final fullItem = {...item, 'cost': cost};
      if (unlocked.contains(item['id'])) {
        unlockedItems.add(fullItem);
      } else {
        lockedItems.add(fullItem);
      }
    }

    if (mounted) {
      setState(() {
        _userTokens = tokens;
        _unlockedIds = unlocked;
        _sortedList = [...unlockedItems.reversed, ...lockedItems];
        _isLoading = false;
      });
    }
  }

  void _handleCardTap(Map<String, dynamic> item, bool isUnlocked) {
    if (isUnlocked) {
      showItemDetails(context, item);
    } else {
      _buyItem(item);
    }
  }

  void _buyItem(Map<String, dynamic> item) async {
    if (_userTokens >= item['cost']) {
      final success = await RewardService.spendTokens(item['cost']);
      if (success) {
        await RewardService.unlockItem(item['id']);
        showCelebration(context, item);
        _loadData();
      }
    } else {
      _showNotEnoughTokens(item['cost'] - _userTokens);
    }
  }

  void _showNotEnoughTokens(int needed) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ওহ! আরো $needed টি টোকেন লাগবে! ⭐️'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'গিফট',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [_buildTokenBadge(), const SizedBox(width: 16)],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.5)),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: _sortedList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _sortedList.length) {
                        return _buildMysteryBox();
                      }
                      final item = _sortedList[index];
                      final isUnlocked = _unlockedIds.contains(item['id']);
                      return _buildCard(item, isUnlocked);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTokenBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.white, size: 18),
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
    );
  }

  Widget _buildCard(Map<String, dynamic> item, bool isUnlocked) {
    return InkWell(
      onTap: () => _handleCardTap(item, isUnlocked),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked ? item['color'] : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Opacity(
                      opacity: isUnlocked ? 1 : 0.35,
                      child: Image.asset(item['image'], fit: BoxFit.contain),
                    ),
                  ),
                  if (!isUnlocked)
                    const Icon(
                      Icons.lock_rounded,
                      size: 40,
                      color: Colors.black38,
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isUnlocked ? item['color'] : Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
              child: isUnlocked
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${item['cost']}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMysteryBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.help_outline_rounded, color: Colors.black26, size: 40),
          Text(
            '???',
            style: TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
