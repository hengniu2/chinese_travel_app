import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../models/booking_models.dart';
import '../state/package_data_state.dart';
import '../state/state.dart';
import '../services/booking_availability.dart';
import 'booking_step_indicator.dart';

/// Step 3: Optional add-ons. List with icon, description, price, toggle. Live total at bottom.
class BookingAddOnsPage extends ConsumerWidget {
  const BookingAddOnsPage({super.key, required this.packageId});

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
            appBar: AppBar(title: Text(l10n.bookingAddOns)),
            body: const Center(child: Text('Package not found')),
          );
        }
        final availability = ref.read(bookingAvailabilityProvider);
        final addOns = availability.getAddOns(package);
        final selectedIds = booking.selectedAddOnIds.toSet();
        final addOnsTotal = addOns
            .where((a) => selectedIds.contains(a.id))
            .fold<double>(0, (s, a) => s + a.price);
        final baseTotal = (booking.datePrice ?? package.price) * booking.travelerCount;
        final total = baseTotal + addOnsTotal;

        return Scaffold(
          backgroundColor: TravelDesignTokens.background,
          appBar: AppBar(
            title: Text(l10n.bookingAddOns),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TravelDesignTokens.screenHorizontal,
                    vertical: 12,
                  ),
                  child: BookingStepIndicator(currentStep: 3, totalSteps: 6),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TravelDesignTokens.screenHorizontal,
                    ),
                    children: [
                      ...addOns.map(
                        (addOn) => _AddOnCard(
                          addOn: addOn,
                          selected: selectedIds.contains(addOn.id),
                          onChanged: () {
                            ref.read(travelBookingStateProvider.notifier).toggleAddOn(addOn.id);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    TravelDesignTokens.screenHorizontal,
                    12,
                    TravelDesignTokens.screenHorizontal,
                    16,
                  ),
                  decoration: BoxDecoration(
                    color: TravelDesignTokens.card,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        offset: const Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.bookingEstimatedTotal,
                            style: TravelDesignTokens.titleL(null),
                          ),
                          PriceTag(price: total, size: PriceTagSize.large),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TravelPrimaryButton(
                          label: l10n.bookingNext,
                          onPressed: () => context.push(
                            '/planner/detail/$packageId/booking/review',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingAddOns)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingAddOns)),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _AddOnCard extends StatelessWidget {
  const _AddOnCard({
    required this.addOn,
    required this.selected,
    required this.onChanged,
  });

  final BookingAddOn addOn;
  final bool selected;
  final VoidCallback onChanged;

  static IconData _iconFor(String? iconId) {
    switch (iconId) {
      case 'transfer':
        return Icons.directions_car_rounded;
      case 'upgrade':
        return Icons.hotel_rounded;
      case 'insurance':
        return Icons.verified_user_rounded;
      case 'guide':
        return Icons.person_rounded;
      default:
        return Icons.add_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Row(
        children: [
          Icon(
            _iconFor(addOn.iconId),
            size: 32,
            color: selected ? TravelDesignTokens.primary : AppColors.textTertiary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addOn.name,
                  style: TravelDesignTokens.titleL(null).copyWith(fontSize: 16),
                ),
                if (addOn.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    addOn.description!,
                    style: TravelDesignTokens.caption(null),
                  ),
                ],
                const SizedBox(height: 6),
                PriceTag(price: addOn.price, size: PriceTagSize.small),
              ],
            ),
          ),
          Switch(
            value: selected,
            onChanged: (_) => onChanged(),
            activeColor: TravelDesignTokens.primary,
          ),
        ],
      ),
    );
  }
}
