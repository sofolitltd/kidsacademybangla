import 'package:flutter/material.dart';

class ProfileNavigationButtons extends StatelessWidget {
  final int currentStep;
  final bool isEditing;
  final bool isLoading;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSave;

  const ProfileNavigationButtons({
    super.key,
    required this.currentStep,
    required this.isEditing,
    required this.isLoading,
    required this.onPrev,
    required this.onNext,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == 4;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (isEditing)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onSave,
                icon: const Icon(Icons.save),
                label: const Text('সংরক্ষণ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          if (isEditing) const SizedBox(height: 12),
          Row(
            children: [
              if (currentStep > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPrev,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('পূর্ববর্তী'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.green),
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (currentStep > 0) const SizedBox(width: 12),
              if (!isLastStep)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('পরবর্তী'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              if (isLastStep && !isEditing)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onSave,
                    icon: const Icon(Icons.save),
                    label: const Text('সংরক্ষণ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
