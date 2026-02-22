import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../coupon/providers/coupon_provider.dart';
import '../../domain/booking.dart';
import '../../providers/hotel_booking_provider.dart';

/// Payment method for hotel booking.
enum HotelPaymentMethod {
  wechat,
  alipay,
  creditCard,
}

/// Step 3: Payment — WeChat Pay, Alipay, Credit Card. Simulated payment logic.
class HotelBookingPaymentPage extends ConsumerStatefulWidget {
  const HotelBookingPaymentPage({super.key});

  @override
  ConsumerState<HotelBookingPaymentPage> createState() =>
      _HotelBookingPaymentPageState();
}

class _HotelBookingPaymentPageState extends ConsumerState<HotelBookingPaymentPage> {
  HotelPaymentMethod? _selectedMethod;
  bool _paying = false;

  Future<void> _doPay() async {
    if (_selectedMethod == null) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                l10n?.paymentSelectMethodFirst ?? '请选择支付方式')),
      );
      return;
    }
    final draft = ref.read(hotelBookingDraftProvider);
    if (draft == null) {
      context.pop();
      return;
    }

    setState(() => _paying = true);
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final selectedCoupon = ref.read(selectedCouponForBookingProvider);
    final discount = ref.read(hotelBookingCouponDiscountProvider);
    final orderId =
        'HB${draft.hotelId}_${draft.roomId}_${DateTime.now().millisecondsSinceEpoch}';

    final booking = HotelBooking(
      id: orderId,
      hotelId: draft.hotelId,
      roomId: draft.roomId,
      roomName: draft.roomName,
      hotelName: draft.hotelName,
      checkIn: draft.checkIn,
      checkOut: draft.checkOut,
      guests: draft.guests,
      roomPrice: draft.roomPrice,
      serviceFee: draft.serviceFee,
      couponDiscount: discount,
      couponId: selectedCoupon?.id,
      status: BookingStatus.paid,
      paymentMethod: _selectedMethod!.name,
      createdAt: DateTime.now(),
    );

    ref.read(hotelBookingsProvider.notifier).addBooking(booking);
    ref.read(hotelBookingDraftProvider.notifier).clear();
    ref.read(selectedCouponForBookingProvider.notifier).state = null;

    setState(() => _paying = false);
    if (mounted) context.pushReplacement('/hotels/booking/success');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(hotelBookingDraftProvider);
    final total = ref.watch(hotelBookingTotalPayableProvider);

    if (draft == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n?.hotelBookingPaymentTitle ?? '支付'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            l10n?.hotelNoRooms ?? '请先填写入住人信息',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    if (_paying) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 72.w,
                  height: 72.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n?.paymentPaying ?? '支付中...',
                  style: AppTextStyles.headlineSmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n?.paymentDoNotClose ?? '请勿关闭页面',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n?.hotelBookingPaymentTitle ?? '支付'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountCard(context, draft, total, l10n),
            SizedBox(height: 24.h),
            Text(
              l10n?.paymentSelectMethod ?? '选择支付方式',
              style: AppTextStyles.headlineSmall
                  .copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 14.h),
            _buildWechatCard(context, l10n),
            SizedBox(height: 12.h),
            _buildAlipayCard(context, l10n),
            SizedBox(height: 12.h),
            _buildCreditCard(context, l10n),
            SizedBox(height: 32.h),
            _buildPayButton(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(
    BuildContext context,
    HotelBookingDraft draft,
    double total,
    AppLocalizations? l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${draft.hotelName} · ${draft.roomName}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                l10n?.paymentAmountDue ?? '应付金额 ',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              Text('¥', style: AppTextStyles.priceLarge.copyWith(fontSize: 18.sp)),
              Text(
                total.toStringAsFixed(0),
                style: AppTextStyles.priceLarge.copyWith(fontSize: 28.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _wechatColor = Color(0xFF07C160);
  static const _wechatLight = Color(0xFFE8F8F0);
  static const _alipayColor = Color(0xFF1677FF);
  static const _alipayLight = Color(0xFFE8F1FF);
  static const _cardColor = Color(0xFF6366F1);
  static const _cardLight = Color(0xFFEEF2FF);

  Widget _buildWechatCard(BuildContext context, AppLocalizations? l10n) {
    final selected = _selectedMethod == HotelPaymentMethod.wechat;
    return _PaymentMethodTile(
      selected: selected,
      accentColor: _wechatColor,
      accentLight: _wechatLight,
      icon: Icons.chat_rounded,
      title: l10n?.paymentWechat ?? '微信支付',
      subtitle: l10n?.paymentWechatHint ?? '使用微信完成支付',
      onTap: () => setState(() => _selectedMethod = HotelPaymentMethod.wechat),
    );
  }

  Widget _buildAlipayCard(BuildContext context, AppLocalizations? l10n) {
    final selected = _selectedMethod == HotelPaymentMethod.alipay;
    return _PaymentMethodTile(
      selected: selected,
      accentColor: _alipayColor,
      accentLight: _alipayLight,
      icon: Icons.account_balance_wallet_rounded,
      title: l10n?.paymentAlipay ?? '支付宝',
      subtitle: l10n?.paymentAlipayHint ?? '使用支付宝完成支付',
      onTap: () => setState(() => _selectedMethod = HotelPaymentMethod.alipay),
    );
  }

  Widget _buildCreditCard(BuildContext context, AppLocalizations? l10n) {
    final selected = _selectedMethod == HotelPaymentMethod.creditCard;
    return _PaymentMethodTile(
      selected: selected,
      accentColor: _cardColor,
      accentLight: _cardLight,
      icon: Icons.credit_card_rounded,
      title: l10n?.paymentCreditCard ?? '信用卡',
      subtitle: l10n?.paymentCreditCardHint ?? '使用信用卡或借记卡支付',
      onTap: () =>
          setState(() => _selectedMethod = HotelPaymentMethod.creditCard),
    );
  }

  Widget _buildPayButton(BuildContext context, AppLocalizations? l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _doPay,
        borderRadius: AppRadius.largeRadius,
        child: Container(
          width: double.infinity,
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
            borderRadius: AppRadius.largeRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Text(
            l10n?.paymentConfirm ?? '确认支付',
            style: AppTextStyles.button.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.selected,
    required this.accentColor,
    required this.accentLight,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final Color accentColor;
  final Color accentLight;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: selected
                ? accentLight.withValues(alpha: 0.6)
                : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accentColor : AppColors.border,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.15),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ]
                : AppShadow.card,
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: accentLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accentColor, size: 28.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: selected ? accentColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? accentColor : AppColors.textTertiary,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check_rounded, size: 16.sp, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
