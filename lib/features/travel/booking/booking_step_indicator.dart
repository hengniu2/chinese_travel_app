import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';

/// Minimal step indicator: "Step X of Y" for booking flow.
class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(totalSteps * 2 - 1, (i) {
          if (i.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                width: 20,
                height: 2,
                color: (i ~/ 2) < currentStep
                    ? TravelDesignTokens.primary
                    : AppColors.divider,
              ),
            );
          }
          final step = i ~/ 2 + 1;
          final active = step == currentStep;
          final done = step < currentStep;
          return Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? TravelDesignTokens.primary
                  : active
                      ? TravelDesignTokens.primary
                      : AppColors.divider,
            ),
            child: done
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TravelDesignTokens.caption(Colors.white).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
          );
        }),
      ],
    );
  }
}
