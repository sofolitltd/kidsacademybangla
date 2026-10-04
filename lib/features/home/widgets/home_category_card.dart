import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/lucide.dart';
import '../data/home_category_data.dart';
import 'home_reveal.dart';

class HomeCategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onAdShown;

  const HomeCategoryCard({super.key, required this.category, this.onAdShown});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: () async {
        await context.push(
          '/details/${category.categoryKey}',
          extra: {'title': category.title, 'color': category.color},
        );
        onAdShown?.call();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 0.1),
                    radius: 0.75,
                    colors: [
                      category.color.withValues(alpha: 0.32),
                      category.color.withValues(alpha: 0),
                    ],
                  ),
                ),
                padding: const EdgeInsets.only(top: 8),
                child: category.emoji != null
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            category.emoji!,
                            style: const TextStyle(fontSize: 52),
                          ),
                        ),
                      )
                    : Image.asset(category.imagePath, fit: BoxFit.cover),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    category.color.withValues(alpha: 0.95),
                    category.color.withValues(alpha: 0.75),
                  ],
                ),
                // Outer radius 20 minus the 3px border.
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(17),
                ),
              ),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.2,
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
}

class HomeCategoryListTile extends StatelessWidget {
  final Category category;
  final VoidCallback? onAdShown;

  const HomeCategoryListTile({
    super.key,
    required this.category,
    this.onAdShown,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: () async {
        await context.push(
          '/details/${category.categoryKey}',
          extra: {'title': category.title, 'color': category.color},
        );
        onAdShown?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.8,
                  colors: [
                    category.color.withValues(alpha: 0.32),
                    category.color.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                  width: 1,
                ),
                image: category.emoji != null
                    ? null
                    : DecorationImage(
                        image: AssetImage(category.imagePath),
                        fit: BoxFit.cover,
                      ),
              ),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: category.emoji != null
                  ? FittedBox(
                      child: Text(
                        category.emoji!,
                        style: const TextStyle(fontSize: 48),
                      ),
                    )
                  : null,
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                category.title,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 24,
                  color: Color.lerp(category.color, Colors.black, 0.35),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            LucideIcon(LucideIcons.caretRight, color: category.color, size: 32),
          ],
        ),
      ),
    );
  }
}
