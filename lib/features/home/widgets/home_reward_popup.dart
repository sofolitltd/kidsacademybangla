import 'package:flutter/material.dart';
import '../../../utils/lucide.dart';

class HomeRewardPopup extends StatelessWidget {
  final int earnedTokens;
  final VoidCallback onDismiss;

  const HomeRewardPopup({
    super.key,
    required this.earnedTokens,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
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
                    LucideIcon(
                      LucideIcons.star,
                      color: Colors.amber,
                      size: 100,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "চমৎকার হয়েছে!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "তুমি $earnedTokens টি নতুন টোকেন পেয়েছ!",
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
                        onPressed: onDismiss,
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
}
