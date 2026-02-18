import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_agreement_checkbox.dart';
import '../../../companions/domain/companion_order.dart';
import '../../../companions/presentation/widgets/traveler_form_card.dart';
import '../../data/tour_detail_mock.dart';
import '../../domain/tour_detail.dart';

/// 旅行团下单页：出行人信息（姓名/身份证/手机号）、支持多人 → 提交后跳转支付页
class TourOrderPage extends StatefulWidget {
  const TourOrderPage({super.key, required this.tourId});

  final String tourId;

  @override
  State<TourOrderPage> createState() => _TourOrderPageState();
}

class _TourOrderPageState extends State<TourOrderPage> {
  late TourDetail _detail;
  List<TravelerInfo> _travelers = [TravelerInfo()];
  bool _agreed = false;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _detail = getTourDetail(widget.tourId);
  }

  void _addTraveler() {
    setState(() => _travelers.add(TravelerInfo()));
  }

  void _removeTraveler(int index) {
    if (_travelers.length <= 1) return;
    setState(() => _travelers.removeAt(index));
  }

  bool _validate() {
    for (var i = 0; i < _travelers.length; i++) {
      final t = _travelers[i];
      if (t.name.trim().isEmpty) {
        setState(() => _error = '请填写第${i + 1}位出行人姓名');
        return false;
      }
      if (t.idCard.trim().length < 15) {
        setState(() => _error = '请填写第${i + 1}位出行人身份证号');
        return false;
      }
      if (t.phone.trim().length < 11) {
        setState(() => _error = '请填写第${i + 1}位出行人手机号');
        return false;
      }
    }
    if (!_agreed) {
      setState(() => _error = '请阅读并同意用户协议与隐私政策');
      return false;
    }
    setState(() => _error = null);
    return true;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    // 跳转支付页面，传递订单信息
    final orderId = 'tour_${widget.tourId}_${DateTime.now().millisecondsSinceEpoch}';
    final uri = Uri(
      path: '/payment',
      queryParameters: {
        'orderId': orderId,
        'amount': _detail.price.toStringAsFixed(0),
        'title': _detail.title,
      },
    );
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.tourOrderTitle ?? '填写订单'),
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
            _buildProductSummary(),
            SizedBox(height: 24.h),
            _section('出行人信息', _buildTravelersSection()),
            _section('同意协议', _buildAgreementSection()),
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

  Widget _buildProductSummary() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_detail.title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp)),
              Text(_detail.price.toStringAsFixed(0), style: AppTextStyles.price.copyWith(fontSize: 22.sp)),
              Text(' /人起', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
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

  Widget _buildTravelersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '请填写每位出行人的姓名、身份证、手机号，确保与证件一致',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 12.h),
        ...List.generate(
          _travelers.length,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: TravelerFormCard(
              traveler: _travelers[i],
              index: i,
              onChanged: (updated) => setState(() => _travelers[i] = updated),
              onRemove: _travelers.length > 1 ? () => _removeTraveler(i) : null,
              canRemove: _travelers.length > 1,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: _addTraveler,
          icon: Icon(Icons.add_rounded, size: 20.sp, color: AppColors.primary),
          label: Text('添加出行人', style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
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
