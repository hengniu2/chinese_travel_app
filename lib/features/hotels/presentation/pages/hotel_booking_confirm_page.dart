import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../coupon/domain/coupon.dart';
import '../../../coupon/presentation/widgets/hotel_coupon_card.dart';
import '../../../coupon/providers/coupon_provider.dart';
import '../../../profile/providers/membership_provider.dart';
import '../../data/hotel_detail_mock.dart';
import '../../domain/hotel_detail.dart';
import '../../providers/hotel_booking_provider.dart';

/// Step 1: Confirm order — hotel info, room, check-in/out, coupon selector, price breakdown.
class HotelBookingConfirmPage extends ConsumerStatefulWidget {
  const HotelBookingConfirmPage({
    super.key,
    required this.hotelId,
    this.roomIndex,
  });

  final String hotelId;
  final int? roomIndex;

  @override
  ConsumerState<HotelBookingConfirmPage> createState() =>
      _HotelBookingConfirmPageState();
}

class _HotelBookingConfirmPageState
    extends ConsumerState<HotelBookingConfirmPage> {
  static const double _serviceFee = 15;

  HotelDetail? _detail;
  RoomType? _room;
  DateTime? _checkIn;
  DateTime? _checkOut;

  @override
  void initState() {
    super.initState();
    _detail = getHotelDetail(widget.hotelId);
    _room = _selectedRoom(_detail, widget.roomIndex);
    final now = DateTime.now();
    _checkIn = now.add(const Duration(days: 1));
    _checkOut = _checkIn!.add(const Duration(days: 1));
  }

  RoomType? _selectedRoom(HotelDetail? detail, int? roomIndex) {
    if (detail == null) return null;
    if (roomIndex != null &&
        roomIndex < detail.rooms.length &&
        detail.rooms[roomIndex].stockStatus != RoomStockStatus.soldOut) {
      return detail.rooms[roomIndex];
    }
    for (final r in detail.rooms) {
      if (r.stockStatus != RoomStockStatus.soldOut) return r;
    }
    return null;
  }

  void _startDraftAndGoToGuest() {
    if (_detail == null || _room == null || _checkIn == null || _checkOut == null) return;
    ref.read(hotelBookingDraftProvider.notifier).startDraft(HotelBookingDraft(
          hotelId: _detail!.id,
          hotelName: _detail!.name,
          roomId: _room!.id,
          roomName: _room!.name,
          roomPrice: _room!.price,
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          serviceFee: _serviceFee,
        ));
    context.push('/hotels/booking/guest');
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkIn!, end: _checkOut!),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (range != null && mounted) {
      setState(() {
        _checkIn = range.start;
        _checkOut = range.end;
      });
    }
  }

  void _openCouponPicker() {
    final l10n = AppLocalizations.of(context);
    final orderAmount = (_room?.price ?? 0) + _serviceFee;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Text(
                l10n?.couponSelect ?? '选择优惠券',
                style: Theme.of(ctx)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: FutureBuilder<List<Coupon>>(
                  future: ref.read(myAvailableCouponsProvider.future),
                  builder: (ctx, snap) {
                    final list = snap.data ?? [];
                    final applicable = applicableCoupons(list, orderAmount);
                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        ListTile(
                          title: Text(
                              l10n?.couponNoThreshold ?? '不使用'),
                          trailing:
                              ref.watch(selectedCouponForBookingProvider) == null
                                  ? Icon(Icons.check_rounded,
                                      color: Theme.of(ctx).colorScheme.primary)
                                  : null,
                          onTap: () {
                            ref
                                .read(selectedCouponForBookingProvider.notifier)
                                .state = null;
                            Navigator.of(ctx).pop();
                          },
                        ),
                        ...applicable.map((c) {
                          final data = couponCardDataFromCoupon(c,
                              l10n: l10n,
                              forClaim: false,
                              onSelect: () {
                            ref
                                .read(selectedCouponForBookingProvider.notifier)
                                .state = c;
                            Navigator.of(ctx).pop();
                          });
                          return CouponCard(
                            data: data,
                            borderRadius: 20,
                          );
                        }),
                        if (applicable.isEmpty && list.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              '当前订单金额未满足其他优惠券条件',
                              style: Theme.of(ctx)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(ctx)
                                          .colorScheme
                                          .onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Coupon>>>(myAvailableCouponsProvider, (_, next) {
      next.whenData((list) {
        if (ref.read(selectedCouponForBookingProvider) == null &&
            list.isNotEmpty &&
            _room != null) {
          final best = getBestCoupon(list, _room!.price + _serviceFee);
          if (best != null) {
            ref.read(selectedCouponForBookingProvider.notifier).state = best;
          }
        }
      });
    });
    final l10n = AppLocalizations.of(context);
    if (_detail == null || _room == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n?.hotelOrderTitle ?? '填写订单')),
        body: Center(
            child: Text(l10n?.hotelNoRooms ?? '暂无可订房型')),
      );
    }

    final discount = ref.watch(hotelBookingCouponDiscountProvider);
    final membership = ref.watch(userMembershipProfileProvider);
    final vipDiscount = computeVipDiscount(membership, _room!.price + _serviceFee);
    final total = (_room!.price + _serviceFee - discount - vipDiscount).clamp(0.0, double.infinity);
    final fmt = DateFormat('MM/dd');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.hotelBookingConfirmTitle ?? '确认订单'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHotelCard(l10n),
            SizedBox(height: 20.h),
            _buildDateCard(l10n, fmt),
            SizedBox(height: 20.h),
            _section(
              l10n?.profileCoupons ?? '优惠券',
              _buildCouponSection(context),
            ),
            SizedBox(height: 20.h),
            _section(
              l10n?.hotelPriceBreakdown ?? '费用明细',
              _buildPriceBreakdown(l10n, discount, vipDiscount, total),
            ),
            SizedBox(height: 28.h),
            AppButton(
              label: l10n?.hotelContinueToGuest ?? '下一步：填写入住人',
              onPressed: _startDraftAndGoToGuest,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(AppLocalizations? l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _detail!.name,
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6.h),
          Text(
            _room!.name,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          if (_detail!.address.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              _detail!.address,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textTertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateCard(AppLocalizations? l10n, DateFormat fmt) {
    return AppTapScale(
      onTap: _pickDates,
      child: AppCard(
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 22.sp, color: AppColors.primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.orderCheckIn ?? '入住',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                  Text(
                    fmt.format(_checkIn!),
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 36.h,
              color: AppColors.border,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.orderCheckOut ?? '离店',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                  Text(
                    fmt.format(_checkOut!),
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedCouponForBookingProvider);
    return AppTapScale(
      onTap: _openCouponPicker,
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: selected == null
                  ? Text(
                      l10n?.couponSelect ?? '选择优惠券',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    )
                  : Text(
                      selected.discountLabel(),
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(
      AppLocalizations? l10n, double discount, double vipDiscount, double total) {
    return AppCard(
      child: Column(
        children: [
          _priceRow(
            l10n?.hotelRoomPrice ?? '房费', _room!.price.toStringAsFixed(0)),
          SizedBox(height: 10.h),
          _priceRow(
            l10n?.hotelServiceFee ?? '服务费', _serviceFee.toStringAsFixed(0)),
          if (discount > 0) ...[
            SizedBox(height: 10.h),
            _priceRow(
              l10n?.couponDiscount ?? '优惠',
              discount.toStringAsFixed(0),
              isDiscount: true,
            ),
          ],
          if (vipDiscount > 0) ...[
            SizedBox(height: 10.h),
            _priceRow(
              l10n?.vipDiscountLabel ?? 'VIP折扣',
              vipDiscount.toStringAsFixed(0),
              isDiscount: true,
            ),
          ],
          SizedBox(height: 14.h),
          Divider(height: 1, color: AppColors.border),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.couponFinalAmount ?? '实付金额',
                style: AppTextStyles.titleMedium
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('¥', style: AppTextStyles.priceSmall),
                  Text(
                    total.toStringAsFixed(0),
                    style: AppTextStyles.price.copyWith(fontSize: 22.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondary),
        ),
        Text(
          isDiscount ? '-¥$value' : '¥$value',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _section(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
