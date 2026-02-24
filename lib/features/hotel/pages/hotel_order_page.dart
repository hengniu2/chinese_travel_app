import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../../auth/presentation/widgets/auth_agreement_checkbox.dart';
import '../../companions/models/companion_order.dart';
import '../../companions/widgets/traveler_form_card.dart';
import '../data/hotel_mock_data.dart';
import '../data/hotel_model.dart';
import '../data/room_model.dart';

/// Hotel order: guest info, agreement, submit to payment.
class HotelOrderPage extends StatefulWidget {
  const HotelOrderPage({
    super.key,
    required this.hotelId,
    this.roomIndex,
  });

  final String hotelId;
  final int? roomIndex;

  @override
  State<HotelOrderPage> createState() => _HotelOrderPageState();
}

class _HotelOrderPageState extends State<HotelOrderPage> {
  HotelDetail? _detail;
  List<TravelerInfo> _guests = [TravelerInfo()];
  bool _agreed = false;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _detail = getHotelDetailForOrder(widget.hotelId);
  }

  RoomType? get _selectedRoom {
    if (_detail == null) return null;
    if (widget.roomIndex != null &&
        widget.roomIndex! < _detail!.rooms.length &&
        _detail!.rooms[widget.roomIndex!].stockStatus !=
            RoomStockStatus.soldOut) {
      return _detail!.rooms[widget.roomIndex!];
    }
    for (final r in _detail!.rooms) {
      if (r.stockStatus != RoomStockStatus.soldOut) return r;
    }
    return null;
  }

  double get _orderAmount => _selectedRoom?.price ?? 0;

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
        setState(() =>
            _error = l10n?.orderGuestNameError(n) ?? '请填写第${n}位入住人姓名');
        return false;
      }
      if (g.idCard.trim().length < 15) {
        setState(() =>
            _error = l10n?.orderGuestIdError(n) ?? '请填写第${n}位入住人身份证号');
        return false;
      }
      if (g.phone.trim().length < 11) {
        setState(() =>
            _error = l10n?.orderGuestPhoneError(n) ?? '请填写第${n}位入住人手机号');
        return false;
      }
    }
    if (!_agreed) {
      setState(() =>
          _error = l10n?.orderAgreementRequired ?? '请阅读并同意用户协议与隐私政策');
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
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    final orderId =
        'hotel_${widget.hotelId}_${DateTime.now().millisecondsSinceEpoch}';
    final uri = Uri(
      path: '/payment',
      queryParameters: {
        'orderId': orderId,
        'amount': _orderAmount.toStringAsFixed(0),
        'title': '${_detail!.name} ${_selectedRoom!.name}',
      },
    );
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_detail == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n?.hotelOrderTitle ?? '填写订单'),
          backgroundColor: AppColors.backgroundCard,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(child: Text('酒店不存在')),
      );
    }

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
            _section(
                l10n?.sectionGuests ?? '入住人信息',
                _buildGuestsSection(context)),
            _section(
                l10n?.sectionAgreement ?? '同意协议',
                _buildAgreementSection()),
            if (_error != null) ...[
              SizedBox(height: 12.h),
              Text(_error!,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.error)),
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

  Widget _buildProductSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final room = _selectedRoom;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_detail!.name,
              style: AppTextStyles.bodyLarge
                  .copyWith(fontWeight: FontWeight.w600)),
          if (room != null) ...[
            SizedBox(height: 6.h),
            Text(room.name,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                  '¥',
                  style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp)),
              Text(
                  _orderAmount.toStringAsFixed(0),
                  style: AppTextStyles.price.copyWith(fontSize: 22.sp)),
              Text(
                  l10n?.hotelOrderProductPerNight ?? ' /晚',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary)),
            ],
          ),
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
          l10n?.orderGuestHint ??
              '请填写每位入住人的姓名、身份证、手机号，确保与证件一致',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textSecondary),
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
              onChanged: (updated) =>
                  setState(() => _guests[i] = updated),
              onRemove: _guests.length > 1 ? () => _removeGuest(i) : null,
              canRemove: _guests.length > 1,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: _addGuest,
          icon: Icon(Icons.add_rounded, size: 20.sp, color: AppColors.primary),
          label: Text(
              l10n?.hotelAddGuest ?? '添加入住人',
              style: TextStyle(
                  color: AppColors.primary, fontSize: 14.sp)),
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
