import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../../profile/providers/membership_provider.dart';
import '../models/travel_package.dart';
import '../state/state.dart';
import '../services/booking_availability.dart';
import 'booking_step_indicator.dart';

/// Step 4: Review & confirm. Trip info, travelers, add-ons, cancellation. Price breakdown. CTA Proceed to payment.
class BookingReviewPage extends ConsumerWidget {
  const BookingReviewPage({super.key, required this.packageId});

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
            appBar: AppBar(title: Text(l10n.bookingReview)),
            body: const Center(child: Text('Package not found')),
          );
        }
        final availability = ref.read(bookingAvailabilityProvider);
        final addOns = availability.getAddOns(package);
        final selectedAddOns = addOns.where((a) => booking.selectedAddOnIds.contains(a.id)).toList();
        final basePrice = (booking.datePrice ?? package.price) * booking.travelerCount;
        final addOnsTotal = selectedAddOns.fold<double>(0, (s, a) => s + a.price);
        const taxRate = 0.0;
        final subtotal = basePrice + addOnsTotal + (basePrice * taxRate);
        final membership = ref.watch(userMembershipProfileProvider);
        final pointsDiscountYuan = booking.pointsToRedeem > 0
            ? computePointsDiscount(
                booking.pointsToRedeem,
                membership.points,
                subtotal,
              )
            : 0;
        final total = subtotal - pointsDiscountYuan;

        return Scaffold(
          backgroundColor: TravelDesignTokens.background,
          appBar: AppBar(
            title: Text(l10n.bookingReview),
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
                  child: BookingStepIndicator(currentStep: 4, totalSteps: 6),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TravelDesignTokens.screenHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TrustBadgesRow.fromPackage(
                          package: package,
                          labelCancellation: l10n.trustCancellationGuarantee,
                          labelSecurePayment: l10n.trustSecurePayment,
                          labelVerifiedPartner: l10n.trustVerifiedLocalPartner,
                          compact: true,
                        ),
                        const SizedBox(height: 14),
                        if (package.bookingsLast7Days != null && package.bookingsLast7Days! > 0) ...[
                          BookingsLast7DaysIndicator(
                            message: l10n.trustBookingsLast7Days(package.bookingsLast7Days!),
                            compact: true,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (package.remainingCapacity != null &&
                            package.remainingCapacity! < kLimitedStockThreshold) ...[
                          LimitedStockIndicator(
                            message: l10n.trustLimitedStock(package.remainingCapacity!),
                            compact: true,
                          ),
                          const SizedBox(height: 10),
                        ],
                        _Block(
                          title: l10n.bookingTripInfo,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(package.title, style: TravelDesignTokens.titleL(null)),
                              const SizedBox(height: 4),
                              Text(
                                '${package.durationDays} days · ${booking.departureDate != null ? DateFormat.yMMMd().format(booking.departureDate!) : "—"} · ${booking.travelerCount} ${l10n.bookingTravelersCount}',
                                style: TravelDesignTokens.body(AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _Block(
                          title: l10n.bookingTravelerList,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: booking.travelers.take(booking.travelerCount).map((t) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '${t.name ?? "—"} · ${t.phone ?? "—"}',
                                  style: TravelDesignTokens.body(null),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (selectedAddOns.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _Block(
                            title: l10n.bookingAddOns,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: selectedAddOns.map((a) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(a.name, style: TravelDesignTokens.body(null)),
                                      Text(
                                        '¥${a.price.toStringAsFixed(0)}',
                                        style: TravelDesignTokens.body(null),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        if (package.cancellationPolicy != null &&
                            package.cancellationPolicy!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _Block(
                            title: l10n.detailNoticeCancellation,
                            child: Text(
                              package.cancellationPolicy!,
                              style: TravelDesignTokens.caption(null),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        _PointsRedeemBlock(
                          orderTotal: subtotal,
                          pointsBalance: membership.points,
                          pointsToRedeem: booking.pointsToRedeem,
                          pointsDiscountYuan: pointsDiscountYuan,
                          l10n: l10n,
                          onToggle: (use, points) {
                            ref.read(travelBookingStateProvider.notifier).setPointsToRedeem(points);
                          },
                        ),
                        const SizedBox(height: 20),
                        _PriceBlock(
                          basePrice: basePrice,
                          addOnsTotal: addOnsTotal,
                          tax: basePrice * taxRate,
                          discount: pointsDiscountYuan.toDouble(),
                          total: total,
                          l10n: l10n,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TravelDesignTokens.screenHorizontal,
                    12,
                    TravelDesignTokens.screenHorizontal,
                    16,
                  ),
                  child: TravelPrimaryButton(
                    label: l10n.bookingProceedToPayment,
                    onPressed: () => context.push(
                      '/planner/detail/$packageId/booking/payment',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingReview)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingReview)),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TravelDesignTokens.titleL(null).copyWith(fontSize: 16)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _PointsRedeemBlock extends StatelessWidget {
  const _PointsRedeemBlock({
    required this.orderTotal,
    required this.pointsBalance,
    required this.pointsToRedeem,
    required this.pointsDiscountYuan,
    required this.l10n,
    required this.onToggle,
  });

  final double orderTotal;
  final int pointsBalance;
  final int pointsToRedeem;
  final int pointsDiscountYuan;
  final AppLocalizations l10n;
  final void Function(bool use, int points) onToggle;

  @override
  Widget build(BuildContext context) {
    final maxDiscount = (orderTotal * 0.2).floor();
    final maxPoints = (maxDiscount * 10).clamp(0, pointsBalance);
    final usePoints = pointsToRedeem > 0;

    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.membershipUsePoints,
                  style: TravelDesignTokens.titleL(null).copyWith(fontSize: 16),
                ),
              ),
              Switch(
                value: usePoints,
                onChanged: pointsBalance >= 100
                    ? (v) {
                        onToggle(v, v ? maxPoints : 0);
                      }
                    : null,
                activeTrackColor: TravelDesignTokens.primary.withValues(alpha: 0.5),
                activeThumbColor: TravelDesignTokens.primary,
              ),
            ],
          ),
          if (pointsBalance < 100)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                l10n.membershipPointsRedeemHint,
                style: TravelDesignTokens.caption(AppColors.textTertiary),
              ),
            )
          else if (usePoints && pointsDiscountYuan > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                l10n.membershipPointsOff(pointsDiscountYuan, pointsToRedeem),
                style: TravelDesignTokens.body(TravelDesignTokens.primary),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({
    required this.basePrice,
    required this.addOnsTotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.l10n,
  });

  final double basePrice;
  final double addOnsTotal;
  final double tax;
  final double discount;
  final double total;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.bookingOrderSummary, style: TravelDesignTokens.titleL(null)),
          const SizedBox(height: 12),
          _row(l10n.bookingBasePrice, basePrice),
          if (addOnsTotal > 0) _row(l10n.bookingAddOns, addOnsTotal),
          if (tax > 0) _row('Taxes', tax),
          if (discount > 0) _row(l10n.membershipDiscount, -discount),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.bookingEstimatedTotal, style: TravelDesignTokens.titleL(null)),
              PriceTag(price: total, size: PriceTagSize.large),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TravelDesignTokens.body(AppColors.textSecondary)),
          Text('¥${value.toStringAsFixed(0)}', style: TravelDesignTokens.body(null)),
        ],
      ),
    );
  }
}
