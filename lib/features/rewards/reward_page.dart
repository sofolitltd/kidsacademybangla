import 'package:flutter/material.dart';

import '../../core/services/reward_service.dart';

class TreasurePage extends StatefulWidget {
  const TreasurePage({super.key});

  @override
  State<TreasurePage> createState() => _TreasurePageState();
}

class _TreasurePageState extends State<TreasurePage> {
  // Static cost mapping
  final Map<String, int> _costs = {
    'lion': 50,
    'tiger': 60,
    'elephant': 45,
    'monkey': 30,
    'dog': 25,
    'cat': 25,
    'cow': 35,
    'goat': 30,
    'horse': 45,
    'bear': 40,
    'fox': 35,
    'deer': 40,
    'giraffe': 55,
    'zebra': 55,
    'panda': 65,
    'kangaroo': 50,
    'snake': 25,
    'bird': 20,
    'fish': 20,
    'crocodile': 70,
    'mango': 25,
    'apple': 25,
    'banana': 20,
    'orange': 20,
    'jackfruit': 40,
    'litchi': 25,
    'grapes': 35,
    'guava': 20,
    'pineapple': 45,
    'watermelon': 50,
    'blackberry': 30,
    'papaya': 35,
    'pomegranate': 45,
    'strawberry': 40,
    'coconut': 40,
    'lemon': 15,
    'tamarind': 20,
    'wood_apple': 25,
    'plum': 20,
    'star_fruit': 25,
  };

  final List<Map<String, dynamic>> _allItems = [
    {
      'id': 'lion',
      'name': 'সিংহ',
      'image': 'assets/images/animals/lion.png',
      'color': Colors.orange,
    },
    {
      'id': 'tiger',
      'name': 'বাঘ',
      'image': 'assets/images/animals/tiger.png',
      'color': Colors.amber,
    },
    {
      'id': 'elephant',
      'name': 'হাতি',
      'image': 'assets/images/animals/elephant.png',
      'color': Colors.blueGrey,
    },
    {
      'id': 'monkey',
      'name': 'বানর',
      'image': 'assets/images/animals/monkey.png',
      'color': Colors.brown,
    },
    {
      'id': 'dog',
      'name': 'কুকুর',
      'image': 'assets/images/animals/dog.png',
      'color': Colors.brown,
    },
    {
      'id': 'cat',
      'name': 'বিড়াল',
      'image': 'assets/images/animals/cat.png',
      'color': Colors.grey,
    },
    {
      'id': 'cow',
      'name': 'গরু',
      'image': 'assets/images/animals/cow.png',
      'color': Colors.brown,
    },
    {
      'id': 'goat',
      'name': 'ছাগল',
      'image': 'assets/images/animals/goat.png',
      'color': Colors.grey,
    },
    {
      'id': 'horse',
      'name': 'ঘোড়া',
      'image': 'assets/images/animals/horse.png',
      'color': Colors.brown,
    },
    {
      'id': 'bear',
      'name': 'ভাল্লুক',
      'image': 'assets/images/animals/bear.png',
      'color': Colors.brown,
    },
    {
      'id': 'fox',
      'name': 'শিয়াল',
      'image': 'assets/images/animals/fox.png',
      'color': Colors.orange,
    },
    {
      'id': 'deer',
      'name': 'হরিণ',
      'image': 'assets/images/animals/deer.png',
      'color': Colors.brown,
    },
    {
      'id': 'giraffe',
      'name': 'জিরাফ',
      'image': 'assets/images/animals/giraffe.png',
      'color': Colors.orange,
    },
    {
      'id': 'zebra',
      'name': 'জেব্রা',
      'image': 'assets/images/animals/zebra.png',
      'color': Colors.black87,
    },
    {
      'id': 'panda',
      'name': 'পান্ডা',
      'image': 'assets/images/animals/panda.png',
      'color': Colors.black54,
    },
    {
      'id': 'kangaroo',
      'name': 'ক্যাঙ্গারু',
      'image': 'assets/images/animals/kangaroo.png',
      'color': Colors.brown,
    },
    {
      'id': 'snake',
      'name': 'সাপ',
      'image': 'assets/images/animals/snake.png',
      'color': Colors.green,
    },
    {
      'id': 'bird',
      'name': 'পাখি',
      'image': 'assets/images/animals/bird.png',
      'color': Colors.blue,
    },
    {
      'id': 'fish',
      'name': 'মাছ',
      'image': 'assets/images/animals/fish.png',
      'color': Colors.teal,
    },
    {
      'id': 'crocodile',
      'name': 'কুমির',
      'image': 'assets/images/animals/crocodile.png',
      'color': Colors.green,
    },
    {
      'id': 'mango',
      'name': 'আম',
      'image': 'assets/images/fruits/mango.png',
      'color': Colors.green,
    },
    {
      'id': 'apple',
      'name': 'আপেল',
      'image': 'assets/images/fruits/apple.png',
      'color': Colors.red,
    },
    {
      'id': 'banana',
      'name': 'কলা',
      'image': 'assets/images/fruits/banana.png',
      'color': Colors.yellow,
    },
    {
      'id': 'orange',
      'name': 'কমলা',
      'image': 'assets/images/fruits/orange.png',
      'color': Colors.orange,
    },
    {
      'id': 'jackfruit',
      'name': 'কাঁঠাল',
      'image': 'assets/images/fruits/jackfruit.png',
      'color': Colors.lightGreen,
    },
    {
      'id': 'litchi',
      'name': 'লিচু',
      'image': 'assets/images/fruits/litchi.png',
      'color': Colors.redAccent,
    },
    {
      'id': 'grapes',
      'name': 'আঙ্গুর',
      'image': 'assets/images/fruits/grapes.png',
      'color': Colors.purple,
    },
    {
      'id': 'guava',
      'name': 'পেয়ারা',
      'image': 'assets/images/fruits/guava.png',
      'color': Colors.green,
    },
    {
      'id': 'pineapple',
      'name': 'আনারস',
      'image': 'assets/images/fruits/pineapple.png',
      'color': Colors.orangeAccent,
    },
    {
      'id': 'watermelon',
      'name': 'তরমুজ',
      'image': 'assets/images/fruits/watermelon.png',
      'color': Colors.red,
    },
    {
      'id': 'blackberry',
      'name': 'জাম',
      'image': 'assets/images/fruits/blackberry.png',
      'color': Colors.deepPurple,
    },
    {
      'id': 'papaya',
      'name': 'পেঁপে',
      'image': 'assets/images/fruits/papaya.png',
      'color': Colors.orange,
    },
    {
      'id': 'pomegranate',
      'name': 'ডালিম',
      'image': 'assets/images/fruits/pomegranate.png',
      'color': Colors.red,
    },
    {
      'id': 'strawberry',
      'name': 'স্ট্রবেরি',
      'image': 'assets/images/fruits/strawberry.png',
      'color': Colors.red,
    },
    {
      'id': 'coconut',
      'name': 'নারকেল',
      'image': 'assets/images/fruits/coconut.png',
      'color': Colors.brown,
    },
    {
      'id': 'lemon',
      'name': 'লেবু',
      'image': 'assets/images/fruits/lemon.png',
      'color': Colors.yellowAccent,
    },
    {
      'id': 'tamarind',
      'name': 'তেঁতুল',
      'image': 'assets/images/fruits/tamarind.png',
      'color': Colors.brown,
    },
    {
      'id': 'wood_apple',
      'name': 'বেল',
      'image': 'assets/images/fruits/wood_apple.png',
      'color': Colors.green,
    },
    {
      'id': 'plum',
      'name': 'বরই',
      'image': 'assets/images/fruits/plum.png',
      'color': Colors.red,
    },
    {
      'id': 'star_fruit',
      'name': 'কামরাঙা',
      'image': 'assets/images/fruits/star_fruit.png',
      'color': Colors.yellow,
    },
  ];

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

    for (var item in _allItems) {
      final cost = _costs[item['id']] ?? 20;
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
      _showItemDetails(item);
    } else {
      _buyItem(item);
    }
  }

  void _buyItem(Map<String, dynamic> item) async {
    if (_userTokens >= item['cost']) {
      final success = await RewardService.spendTokens(item['cost']);
      if (success) {
        await RewardService.unlockItem(item['id']);
        _showCelebration(item);
        _loadData();
      }
    } else {
      _showNotEnoughTokens(item['cost'] - _userTokens);
    }
  }

  void _showItemDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) =>
              Transform.scale(scale: value, child: child),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: item['color'].withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: item['color'],
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        item['image'],
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item['color'],
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: item['color'].withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'চমৎকার!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: item['color'],
                    child: const Icon(
                      Icons.stars_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCelebration(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 অভিনন্দন! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(item['image'], height: 120),
            const SizedBox(height: 10),
            Text(
              'তুমি "${item['name']}" আনলক করেছ!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: const StadiumBorder(),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ধন্যবাদ!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
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
            child: Container(color: Colors.white.withOpacity(0.5)),
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
              color: Colors.black.withOpacity(0.05),
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
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
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
