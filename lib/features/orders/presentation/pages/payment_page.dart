import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

/// 支付方式
enum PaymentMethod {
  alipay,
  wechat,
}

/// 支付页：选择方式 → 支付中动画 → 支付成功/失败页 → 返回订单
class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.orderId,
    required this.amount,
    this.title,
    this.simulateFail = false,
  });

  final String orderId;
  final String amount;
  final String? title;
  /// 为 true 时模拟支付失败（便于测试失败页）
  final bool simulateFail;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _selectedMethod;
  bool _paying = false;
  bool? _success; // null=未出结果, true=成功, false=失败

  Future<void> _doPay() async {
    if (_selectedMethod == null) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.paymentSelectMethodFirst ?? '请选择支付方式')));
      return;
    }
    setState(() => _paying = true);
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    setState(() {
      _paying = false;
      _success = !widget.simulateFail;
    });
  }

  void _retry() {
    setState(() => _success = null);
  }

  void _goToOrders() {
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    if (_paying) return _buildPayingScreen(context);
    if (_success == true) return _buildSuccessScreen(context);
    if (_success == false) return _buildFailureScreen(context);
    return _buildSelectScreen(context);
  }

  /// 支付方式选择页
  Widget _buildSelectScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.paymentTitle ?? '收银台'),
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
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null) ...[
                    Text(widget.title!, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 12.h),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(l10n?.paymentAmountDue ?? '应付金额 ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 18.sp)),
                      Text(widget.amount, style: AppTextStyles.price.copyWith(fontSize: 28.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(l10n?.paymentOrderNo(widget.orderId) ?? '订单号 ${widget.orderId}', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(l10n?.paymentSelectMethod ?? '选择支付方式', style: AppTextStyles.headlineSmall),
            SizedBox(height: 12.h),
            _paymentTile(
              context: context,
              method: PaymentMethod.alipay,
              icon: Icons.account_balance_wallet_rounded,
              title: l10n?.paymentAlipay ?? '支付宝',
              subtitle: l10n?.paymentAlipayHint ?? '使用支付宝完成支付',
            ),
            SizedBox(height: 10.h),
            _paymentTile(
              context: context,
              method: PaymentMethod.wechat,
              icon: Icons.chat_rounded,
              title: l10n?.paymentWechat ?? '微信支付',
              subtitle: l10n?.paymentWechatHint ?? '使用微信完成支付',
            ),
            SizedBox(height: 48.h),
            AppButton(
              label: l10n?.paymentConfirm ?? '确认支付',
              onPressed: _doPay,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile({
    required BuildContext context,
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final selected = _selectedMethod == method;
    return AppCard(
      onTap: () => setState(() => _selectedMethod = method),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 28.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                SizedBox(height: 2.h),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
            color: selected ? AppColors.primary : AppColors.textTertiary,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  /// 支付中动画页
  Widget _buildPayingScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              SizedBox(height: 24.h),
              Text(l10n?.paymentPaying ?? '支付中...', style: AppTextStyles.headlineSmall),
              SizedBox(height: 8.h),
              Text(
                l10n?.paymentDoNotClose ?? '请勿关闭页面',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 支付成功页
  Widget _buildSuccessScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, size: 88.sp, color: AppColors.primary),
              SizedBox(height: 24.h),
              Text(l10n?.paymentSuccess ?? '支付成功', style: AppTextStyles.headlineMedium),
              SizedBox(height: 8.h),
              Text(l10n?.paymentOrderNo(widget.orderId) ?? '订单号 ${widget.orderId}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              SizedBox(height: 48.h),
              AppButton(
                label: l10n?.orderReturnToOrders ?? '返回订单页',
                onPressed: _goToOrders,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 支付失败页
  Widget _buildFailureScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_rounded, size: 88.sp, color: AppColors.error),
              SizedBox(height: 24.h),
              Text(l10n?.paymentFailed ?? '支付失败', style: AppTextStyles.headlineMedium),
              SizedBox(height: 8.h),
              Text(
                l10n?.paymentFailedHint ?? '请重试或更换支付方式',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 48.h),
              AppButton(
                label: l10n?.paymentRetry ?? '重试',
                onPressed: _retry,
              ),
              SizedBox(height: 16.h),
              AppButton(
                label: l10n?.orderReturnToOrders ?? '返回订单页',
                onPressed: _goToOrders,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
