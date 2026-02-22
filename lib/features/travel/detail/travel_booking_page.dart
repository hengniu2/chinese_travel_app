import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import '../state/state.dart';

/// Booking flow from Detail. Uses travelBookingStateProvider.
/// Structure only; no visual redesign.
class TravelBookingPage extends ConsumerWidget {
  const TravelBookingPage({super.key, required this.packageId});

  final String packageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(travelBookingStateProvider.notifier).startBooking(packageId);
    final booking = ref.watch(travelBookingStateProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Package: $packageId', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 8),
              Text('Travelers: ${booking.travelerCount}'),
              Text('Departure date: ${booking.departureDate ?? "—"}'),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ref.read(travelBookingStateProvider.notifier).reset();
                  context.pop();
                },
                child: const Text('Confirm (placeholder)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
