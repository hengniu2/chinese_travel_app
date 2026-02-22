import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../../profile/providers/membership_provider.dart';
import '../state/state.dart';
import '../services/booking_availability.dart';
import 'booking_step_indicator.dart';

/// Step 5: Payment. WeChat, Alipay, Credit card. Secure badge, order summary, Pay Now.
class BookingPaymentPage extends ConsumerStatefulWidget {
  const BookingPaymentPage({super.key, required this.packageId});

  final String packageId;

  @override
  ConsumerState<BookingPaymentPage> createState() => _BookingPaymentPageState();
}

class _BookingPaymentPageState extends ConsumerState<BookingPaymentPage> {
  String? _selectedMethod;
  bool _paying = false;

  @override
  Widget build(BuildContext context) {
    final packageAsync = ref.watch(travelPackageDetailProvider(widget.packageId));
    final booking = ref.watch(travelBookingStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return packageAsync.when(
      data: (package) {
        if (package == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.bookingPayment)),
            body: const Center(child: Text('Package not found')),
          );
        }
        final availability = ref.read(bookingAvailabilityProvider);
        final addOns = availability.getAddOns(package);
        final selectedAddOns = addOns.where((a) => booking.selectedAddOnIds.contains(a.id)).toList();
        final baseTotal = (booking.datePrice ?? package.price) * booking.travelerCount;
        final addOnsTotal = selectedAddOns.fold<double>(0, (s, a) => s + a.price);
        final subtotal = baseTotal + addOnsTotal;
        final membership = ref.read(userMembershipProfileProvider);
        final pointsDiscount = booking.pointsToRedeem > 0
            ? computePointsDiscount(
                booking.pointsToRedeem,
                membership.points,
                subtotal,
              )
            : 0;
        final total = subtotal - pointsDiscount;

        if (_paying) {
          return Scaffold(
            backgroundColor: TravelDesignTokens.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    l10n.paymentPaying,
                    style: TravelDesignTokens.body(AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: TravelDesignTokens.background,
          appBar: AppBar(
            title: Text(l10n.bookingPayment),
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
                  child: BookingStepIndicator(currentStep: 5, totalSteps: 6),
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
                        const SizedBox(height: 16),
                        Text(
                          l10n.paymentSelectMethod,
                          style: TravelDesignTokens.titleL(null),
                        ),
                        const SizedBox(height: 10),
                        _MethodCard(
                          id: 'wechat',
                          label: l10n.paymentWechat,
                          hint: l10n.paymentWechatHint,
                          icon: Icons.chat_rounded,
                          color: const Color(0xFF07C160),
                          selected: _selectedMethod == 'wechat',
                          onTap: () => setState(() => _selectedMethod = 'wechat'),
                        ),
                        const SizedBox(height: 10),
                        _MethodCard(
                          id: 'alipay',
                          label: l10n.paymentAlipay,
                          hint: l10n.paymentAlipayHint,
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF1677FF),
                          selected: _selectedMethod == 'alipay',
                          onTap: () => setState(() => _selectedMethod = 'alipay'),
                        ),
                        const SizedBox(height: 10),
                        _MethodCard(
                          id: 'card',
                          label: l10n.bookingCreditCard,
                          hint: 'Pay with credit card',
                          icon: Icons.credit_card_rounded,
                          color: AppColors.textSecondary,
                          selected: _selectedMethod == 'card',
                          onTap: () => setState(() => _selectedMethod = 'card'),
                        ),
                        const SizedBox(height: 24),
                        Container(
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
                                l10n.bookingOrderSummary,
                                style: TravelDesignTokens.titleL(null),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                package.title,
                                style: TravelDesignTokens.body(null),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.paymentAmountDue,
                                    style: TravelDesignTokens.body(
                                      AppColors.textSecondary,
                                    ),
                                  ),
                                  PriceTag(price: total, size: PriceTagSize.medium),
                                ],
                              ),
                            ],
                          ),
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
                    label: l10n.bookingPayNow,
                    onPressed: _selectedMethod == null
                        ? null
                        : () async {
                            setState(() => _paying = true);
                            await Future.delayed(
                              const Duration(milliseconds: 1800),
                            );
                            if (!mounted) return;
                            final orderId =
                                'T${DateTime.now().millisecondsSinceEpoch}';
                            ref
                                .read(travelBookingStateProvider.notifier)
                                .setOrderId(orderId);
                            if (booking.pointsToRedeem > 0 && pointsDiscount > 0) {
                              ref
                                  .read(userMembershipProfileProvider.notifier)
                                  .usePointsForDiscount(
                                    booking.pointsToRedeem,
                                    subtotal,
                                  );
                            }
                            ref
                                .read(userMembershipProfileProvider.notifier)
                                .onPurchaseCompleted(total);
                            setState(() => _paying = false);
                            if (mounted) {
                              context.pushReplacement(
                                '/planner/detail/${widget.packageId}/booking/confirmation',
                              );
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingPayment)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingPayment)),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.id,
    required this.label,
    required this.hint,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final String label;
  final String hint;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
          decoration: BoxDecoration(
            color: TravelDesignTokens.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? TravelDesignTokens.primary : AppColors.divider,
              width: selected ? 2 : 1,
            ),
            boxShadow: TravelDesignTokens.shadowLevel1,
          ),
          child: Row(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TravelDesignTokens.body(null).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      hint,
                      style: TravelDesignTokens.caption(AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: TravelDesignTokens.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
