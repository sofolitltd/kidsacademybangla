import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = true;

  final List<Category> _categories = [
    Category(
      title: 'বাংলা স্বরবর্ণ',
      imagePath: 'assets/images/categories/bangla_vowels.png',
      color: Colors.deepOrange,
      categoryKey: 'bangla_vowels',
    ),
    Category(
      title: 'বাংলা ব্যঞ্জনবর্ণ',
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
      title: 'ইংরেজি বর্ণমালা',
      imagePath: 'assets/images/categories/english_alphabets.png',
      color: Colors.red,
      categoryKey: 'english_alphabets',
    ),
    Category(
      title: 'ইংরেজি সংখ্যা',
      imagePath: 'assets/images/categories/english_numbers.png',
      color: Colors.purple,
      categoryKey: 'english_numbers',
    ),
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
    Category(
      title: 'প্রাণীর নাম',
      imagePath: 'assets/images/categories/animals.png',
      color: Colors.orange,
      categoryKey: 'animals',
    ),
    Category(
      title: 'ফলের নাম',
      imagePath: 'assets/images/categories/fruits.png',
      color: Colors.pink,
      categoryKey: 'fruits',
    ),
    Category(
      title: 'রঙের নাম',
      imagePath: 'assets/images/categories/colors.png',
      color: Colors.cyan,
      categoryKey: 'colors',
    ),
    Category(
      title: 'ইংরেজি ছড়া',
      imagePath: 'assets/images/categories/english_rhymes.png',
      color: Colors.blueAccent,
      categoryKey: 'english_rhymes',
    ),
    Category(
      title: 'বাংলা ছড়া',
      imagePath: 'assets/images/categories/bangla_rhymes.png',
      color: Colors.amber,
      categoryKey: 'bangla_rhymes',
    ),
    Category(
      title: 'আল্লাহর ৯৯ নাম',
      imagePath: 'assets/images/categories/allah_names.png',
      color: const Color(0xFF2E7D32), // Using the new function
      categoryKey: 'allah_names',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          //
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          //
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: .3)),
          ),

          //
          Column(
            children: [
              //
              AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.white,
                title: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Kids Academy'.toUpperCase(),
                      style: TextStyle(fontSize: 24, height: 1),
                    ),
                    const Text(
                      'Bangla',
                      style: TextStyle(fontSize: 12, height: 1),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ToggleButtons(
                      isSelected: [_isGridView, !_isGridView],
                      onPressed: (int index) {
                        setState(() {
                          _isGridView = index == 0;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Theme.of(
                        context,
                      ).colorScheme.primary,
                      selectedColor: Colors.white,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.8),
                      color: Theme.of(context).colorScheme.primary,
                      constraints: const BoxConstraints(
                        minHeight: 36.0,
                        minWidth: 36.0,
                      ),
                      children: const <Widget>[
                        Icon(Icons.grid_view, size: 20),
                        Icon(Icons.view_list, size: 20),
                      ],
                    ),
                  ),
                ],
              ),

              //
              Expanded(
                child: _isGridView ? _buildGridView() : _buildListView(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1, // Made cards more square
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          elevation: 2,
          color: category.color.withValues(alpha: 0.3),
          shadowColor: category.color.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              context.go(
                '/details/${category.categoryKey}',
                extra: {'title': category.title, 'color': category.color},
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    category.imagePath,
                    height: 80, // Made image larger
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // color: category.color,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      padding: .all(12),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          elevation: 2,
          color: category.color.withValues(alpha: 0.3),
          shadowColor: category.color.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white30,
              radius: 32,
              child: Image.asset(category.imagePath, height: 60, width: 60),
            ),
            title: Text(
              category.title,
              style: TextStyle(
                fontSize: 20,
                // color: category.color,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () {
              context.go(
                '/details/${category.categoryKey}',
                extra: {'title': category.title, 'color': category.color},
              );
            },
          ),
        );
      },
    );
  }
}
