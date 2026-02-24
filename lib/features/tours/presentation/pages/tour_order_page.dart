import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_agreement_checkbox.dart';
import '../../../companions/models/companion_order.dart';
import '../../../companions/widgets/traveler_form_card.dart';
import '../../data/tour_detail_mock.dart';
import '../../domain/tour_detail.dart';

/// 旅行团填写订单页：表单卡片化、出行人动态添加、身份证风格、错误提示、底部悬浮支付
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
  /// 当前错误所在出行人索引（用于高亮或滚动）
  int? _errorTravelerIndex;
  String? _errorTravelerField;

  @override
  void initState() {
    super.initState();
    _detail = getTourDetail(widget.tourId);
  }

  void _addTraveler() {
    setState(() {
      _travelers.add(TravelerInfo());
      _error = null;
      _errorTravelerIndex = null;
      _errorTravelerField = null;
    });
  }

  void _removeTraveler(int index) {
    if (_travelers.length <= 1) return;
    setState(() {
      _travelers.removeAt(index);
      _error = null;
      _errorTravelerIndex = null;
      _errorTravelerField = null;
    });
  }

  bool _validate(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    for (var i = 0; i < _travelers.length; i++) {
      final t = _travelers[i];
      final n = i + 1;
      if (t.name.trim().isEmpty) {
        setState(() {
          _error = l10n?.orderTravelerNameError(n) ?? '请填写第$n位出行人姓名';
          _errorTravelerIndex = i;
          _errorTravelerField = 'name';
        });
        return false;
      }
      if (t.idCard.trim().length < 15) {
        setState(() {
          _error = l10n?.orderTravelerIdError(n) ?? '请填写第$n位出行人身份证号';
          _errorTravelerIndex = i;
          _errorTravelerField = 'idCard';
        });
        return false;
      }
      if (t.phone.trim().length < 11) {
        setState(() {
          _error = l10n?.orderTravelerPhoneError(n) ?? '请填写第$n位出行人手机号';
          _errorTravelerIndex = i;
          _errorTravelerField = 'phone';
        });
        return false;
      }
    }
    if (!_agreed) {
      setState(() {
        _error = l10n?.orderAgreementRequired ?? '请阅读并同意用户协议与隐私政策';
        _errorTravelerIndex = null;
        _errorTravelerField = null;
      });
      return false;
    }
    setState(() {
      _error = null;
      _errorTravelerIndex = null;
      _errorTravelerField = null;
    });
    return true;
  }

  Future<void> _submit() async {
    if (!_validate(context)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n?.tourOrderTitle ?? '填写订单'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null) _buildErrorCard(),
                  _buildProductCard(context),
                  SizedBox(height: 20.h),
                  _buildTravelersCard(context),
                  SizedBox(height: 20.h),
                  _buildAgreementCard(),
                ],
              ),
            ),
          ),
          _buildFloatingBar(context),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 20.sp, color: AppColors.error),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                _error!,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            _detail.title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('¥', style: AppTextStyles.priceLarge.copyWith(fontSize: 14.sp)),
              Text(
                _detail.price.toStringAsFixed(0),
                style: AppTextStyles.priceLarge.copyWith(fontSize: 24.sp),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  l10n?.tourOrderProductPerPerson ?? ' /人起',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravelersCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            l10n?.sectionTravelers ?? '出行人信息',
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n?.orderTravelerHint ?? '请填写每位出行人的姓名、身份证、手机号，确保与证件一致',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            _travelers.length,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: TravelerFormCard(
                traveler: _travelers[i],
                index: i,
                labelPrefix: '出行人',
                onChanged: (updated) => setState(() => _travelers[i] = updated),
                onRemove: _travelers.length > 1 ? () => _removeTraveler(i) : null,
                canRemove: _travelers.length > 1,
                nameError: _errorTravelerIndex == i && _errorTravelerField == 'name' ? _error : null,
                idCardError: _errorTravelerIndex == i && _errorTravelerField == 'idCard' ? _error : null,
                phoneError: _errorTravelerIndex == i && _errorTravelerField == 'phone' ? _error : null,
              ),
            ),
          ),
          InkWell(
            onTap: _addTraveler,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 22.sp, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Text(
                    l10n?.tourAddTraveler ?? '添加出行人',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      child: AuthAgreementCheckbox(
        value: _agreed,
        onChanged: (v) => setState(() {
          _agreed = v;
          if (v) _error = null;
        }),
        onAgreementTap: () => context.push('/auth/agreement?type=user'),
        onPrivacyTap: () => context.push('/auth/agreement?type=privacy'),
      ),
    );
  }

  Widget _buildFloatingBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: AppShadow.heavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('¥', style: AppTextStyles.priceLarge.copyWith(fontSize: 16.sp)),
            Text(
              _detail.price.toStringAsFixed(0),
              style: AppTextStyles.priceLarge.copyWith(fontSize: 26.sp),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                '起',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 13.sp),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 160.w,
              child: AppButton(
                label: l10n?.tourSubmitPay ?? '提交并去支付',
                loading: _submitting,
                onPressed: _submit,
                minHeight: 48,
                expand: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
