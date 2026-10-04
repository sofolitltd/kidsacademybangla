import 'package:flutter/material.dart';

class ProfileProgressIndicator extends StatelessWidget {
  final int currentStep;

  const ProfileProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['সন্তান', 'বাবা-মা', 'ভাই-বোন', 'পরিবার', 'যোগাযোগ'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isActive ? Colors.green : Colors.grey.shade300,
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.green : Colors.grey.shade300,
                      ),
                      child: Center(
                        child: isCurrent
                            ? const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 14,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                    if (index < 4)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < currentStep
                              ? Colors.green
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
