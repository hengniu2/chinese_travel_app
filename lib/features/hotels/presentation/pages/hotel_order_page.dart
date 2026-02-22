import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_agreement_checkbox.dart';
import '../../../companions/domain/companion_order.dart';
import '../../../companions/presentation/widgets/traveler_form_card.dart';
import '../../../coupon/domain/coupon.dart';
import '../../../coupon/presentation/widgets/hotel_coupon_card.dart';
import '../../../coupon/providers/coupon_provider.dart';
import '../../data/hotel_detail_mock.dart';
import '../../domain/hotel_detail.dart';

/// 酒店预订页：优惠券、入住人信息 → 提交前优惠券确认弹窗 → 支付页
class HotelOrderPage extends ConsumerStatefulWidget {
  const HotelOrderPage({
    super.key,
    required this.hotelId,
    this.roomIndex,
  });

  final String hotelId;
  /// 选中的房型下标，null 则用第一个可订房型
  final int? roomIndex;

  @override
  ConsumerState<HotelOrderPage> createState() => _HotelOrderPageState();
}

class _HotelOrderPageState extends ConsumerState<HotelOrderPage> {
  late HotelDetail _detail;
  List<TravelerInfo> _guests = [TravelerInfo()];
  bool _agreed = false;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _detail = getHotelDetail(widget.hotelId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.listen<AsyncValue<List<Coupon>>>(myAvailableCouponsProvider, (_, next) {
      next.whenData((list) {
        if (ref.read(selectedCouponForBookingProvider) == null && list.isNotEmpty) {
          final best = getBestCoupon(list, _orderAmount);
          if (best != null) {
            ref.read(selectedCouponForBookingProvider.notifier).state = best;
          }
        }
      });
    });
  }

  RoomType? get _selectedRoom {
    if (widget.roomIndex != null &&
        widget.roomIndex! < _detail.rooms.length &&
        _detail.rooms[widget.roomIndex!].stockStatus != RoomStockStatus.soldOut) {
      return _detail.rooms[widget.roomIndex!];
    }
    for (final r in _detail.rooms) {
      if (r.stockStatus != RoomStockStatus.soldOut) return r;
    }
    return null;
  }

  double get _orderAmount => _selectedRoom?.price ?? 0;

  double get _discount {
    final selected = ref.read(selectedCouponForBookingProvider);
    return discountForSelectedCoupon(selected, _orderAmount);
  }

  double get _finalAmount => finalAmountAfterCoupon(_orderAmount, ref.read(selectedCouponForBookingProvider));

  void _addGuest() {
    setState(() => _guests.add(TravelerInfo()));
  }

  void _removeGuest(int index) {
    if (_guests.length <= 1) return;
    setState(() => _guests.removeAt(index));
  }

  bool _validate(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    for (var i = 0; i < _guests.length; i++) {
      final g = _guests[i];
      final n = i + 1;
      if (g.name.trim().isEmpty) {
        setState(() => _error = l10n?.orderGuestNameError(n) ?? '请填写第${n}位入住人姓名');
        return false;
      }
      if (g.idCard.trim().length < 15) {
        setState(() => _error = l10n?.orderGuestIdError(n) ?? '请填写第${n}位入住人身份证号');
        return false;
      }
      if (g.phone.trim().length < 11) {
        setState(() => _error = l10n?.orderGuestPhoneError(n) ?? '请填写第${n}位入住人手机号');
        return false;
      }
    }
    if (!_agreed) {
      setState(() => _error = l10n?.orderAgreementRequired ?? '请阅读并同意用户协议与隐私政策');
      return false;
    }
    setState(() => _error = null);
    return true;
  }

  Future<void> _submit() async {
    if (!_validate(context)) return;
    if (_selectedRoom == null) {
      final l10n = AppLocalizations.of(context);
      setState(() => _error = l10n?.hotelNoRooms ?? '暂无可订房型');
      return;
    }
    final l10n = AppLocalizations.of(context);
    final selected = ref.read(selectedCouponForBookingProvider);
    final discount = _discount;

    if (selected != null && discount > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n?.profileCoupons ?? '优惠券'),
          content: Text(
            l10n?.couponApplyConfirm(discount.toStringAsFixed(0)) ?? '使用该优惠券可省 ¥${discount.toStringAsFixed(0)}，确认使用？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n?.commonCancel ?? '取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n?.commonConfirm ?? '确认'),
            ),
          ],
        ),
      );
      if (!mounted || confirmed != true) return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    final orderId = 'hotel_${widget.hotelId}_${DateTime.now().millisecondsSinceEpoch}';
    final params = <String, String>{
      'orderId': orderId,
      'amount': _finalAmount.toStringAsFixed(0),
      'title': '${_detail.name} ${_selectedRoom!.name}',
    };
    if (selected != null) params['couponId'] = selected.id;
    final uri = Uri(path: '/payment', queryParameters: params);
    context.push(uri.toString());
  }

  void _openCouponPicker() {
    final l10n = AppLocalizations.of(context);
    final orderAmount = _orderAmount;
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
              const SizedBox(height: 12),
              Text(
                l10n?.couponSelect ?? '选择优惠券',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
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
                          title: Text(l10n?.couponNoThreshold ?? '不使用'),
                          trailing: ref.watch(selectedCouponForBookingProvider) == null
                              ? Icon(Icons.check_rounded, color: Theme.of(ctx).colorScheme.primary)
                              : null,
                          onTap: () {
                            ref.read(selectedCouponForBookingProvider.notifier).state = null;
                            Navigator.of(ctx).pop();
                          },
                        ),
                        ...applicable.map((c) {
                          final data = couponCardDataFromCoupon(c, l10n: l10n, forClaim: false, onSelect: () {
                            ref.read(selectedCouponForBookingProvider.notifier).state = c;
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
                              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant),
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.hotelOrderTitle ?? '填写订单'),
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
            _buildProductSummary(context),
            SizedBox(height: 24.h),
            _section(l10n?.profileCoupons ?? '优惠券', _buildCouponSection(context)),
            _section(l10n?.sectionGuests ?? '入住人信息', _buildGuestsSection(context)),
            _section(l10n?.sectionAgreement ?? '同意协议', _buildAgreementSection()),
            if (_error != null) ...[
              SizedBox(height: 12.h),
              Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ],
            SizedBox(height: 24.h),
            AppButton(
              label: l10n?.tourSubmitPay ?? '提交并去支付',
              loading: _submitting,
              onPressed: _submit,
            ),
            SizedBox(height: 32.h),
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
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    )
                  : Text(
                      selected.discountLabel(),
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final room = _selectedRoom;
    final discount = _discount;
    final finalAmt = _finalAmount;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_detail.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          if (room != null) ...[
            SizedBox(height: 6.h),
            Text(room.name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp)),
              Text(_orderAmount.toStringAsFixed(0), style: AppTextStyles.price.copyWith(fontSize: 22.sp)),
              Text(l10n?.hotelOrderProductPerNight ?? ' /晚', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
            ],
          ),
          if (discount > 0) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(l10n?.couponDiscount ?? '优惠', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                Text('-¥${discount.toStringAsFixed(0)}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(l10n?.couponFinalAmount ?? '实付', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text('¥${finalAmt.toStringAsFixed(0)}', style: AppTextStyles.price.copyWith(fontSize: 18.sp)),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              l10n?.couponSavedAmount(discount.toStringAsFixed(0)) ?? '已为您节省 ¥${discount.toStringAsFixed(0)}',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
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

  Widget _buildGuestsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.orderGuestHint ?? '请填写每位入住人的姓名、身份证、手机号，确保与证件一致',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 12.h),
        ...List.generate(
          _guests.length,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: TravelerFormCard(
              traveler: _guests[i],
              index: i,
              labelPrefix: l10n?.guestLabel ?? '入住人',
              onChanged: (updated) => setState(() => _guests[i] = updated),
              onRemove: _guests.length > 1 ? () => _removeGuest(i) : null,
              canRemove: _guests.length > 1,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: _addGuest,
          icon: Icon(Icons.add_rounded, size: 20.sp, color: AppColors.primary),
          label: Text(l10n?.hotelAddGuest ?? '添加入住人', style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreementSection() {
    return AuthAgreementCheckbox(
      value: _agreed,
      onChanged: (v) => setState(() => _agreed = v),
      onAgreementTap: () => context.push('/auth/agreement?type=user'),
      onPrivacyTap: () => context.push('/auth/agreement?type=privacy'),
    );
  }
}
