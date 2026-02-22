import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../state/package_data_state.dart';
import '../state/state.dart';

/// Step 6: Confirmation. Success, order number, trip summary, View Order / Back to Home / Share.
class BookingConfirmationPage extends ConsumerWidget {
  const BookingConfirmationPage({super.key, required this.packageId});

  final String packageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageAsync = ref.watch(travelPackageDetailProvider(packageId));
    final booking = ref.watch(travelBookingStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return packageAsync.when(
      data: (package) {
        if (package == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.bookingConfirmation)),
            body: const Center(child: Text('Package not found')),
          );
        }
        final orderId = booking.orderId ?? '—';

        return Scaffold(
          backgroundColor: TravelDesignTokens.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TravelDesignTokens.screenHorizontal,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: TravelDesignTokens.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.bookingSuccessTitle,
                    style: TravelDesignTokens.titleXL(null),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.bookingOrderNumber(orderId),
                    style: TravelDesignTokens.body(AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
                    decoration: BoxDecoration(
                      color: TravelDesignTokens.card,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: TravelDesignTokens.shadowLevel1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.title,
                          style: TravelDesignTokens.titleL(null),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${package.durationDays} days · ${booking.departureDate != null ? DateFormat.yMMMd().format(booking.departureDate!) : "—"} · ${booking.travelerCount} travelers',
                          style: TravelDesignTokens.body(AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: TravelPrimaryButton(
                      label: l10n.bookingViewOrder,
                      onPressed: () {
                        ref.read(travelBookingStateProvider.notifier).reset();
                        context.go('/orders/$orderId');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TravelOutlineButton(
                      label: l10n.bookingBackToHome,
                      onPressed: () {
                        ref.read(travelBookingStateProvider.notifier).reset();
                        context.go('/planner');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.bookingShareTrip)),
                      );
                    },
                    icon: const Icon(Icons.share_rounded, size: 20),
                    label: Text(l10n.bookingShareTrip),
                    style: TextButton.styleFrom(
                      foregroundColor: TravelDesignTokens.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
  },
      loading: () => Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
