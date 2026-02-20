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

/// 支付宝蓝、微信绿（品牌色）
class _PaymentColors {
  static const Color alipay = Color(0xFF1677FF);
  static const Color alipayLight = Color(0xFFE8F1FF);
  static const Color wechat = Color(0xFF07C160);
  static const Color wechatLight = Color(0xFFE8F8F0);
}

/// 支付页：支付宝/微信卡片样式、勾选强化、支付按钮渐变、支付成功动画
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
  final bool simulateFail;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with TickerProviderStateMixin {
  PaymentMethod? _selectedMethod;
  bool _paying = false;
  bool? _success;
  late AnimationController _successController;
  late Animation<double> _successScale;
  late Animation<double> _successOpacity;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _successScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
    _successOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

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
    if (_success == true) _successController.forward();
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

  Widget _buildSelectScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n?.paymentTitle ?? '收银台'),
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
            _buildAmountCard(context),
            SizedBox(height: 24.h),
            Text(
              l10n?.paymentSelectMethod ?? '选择支付方式',
              style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 14.h),
            _buildAlipayCard(context),
            SizedBox(height: 12.h),
            _buildWechatCard(context),
            SizedBox(height: 32.h),
            _buildGradientPayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context) {
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
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                l10n?.paymentAmountDue ?? '应付金额 ',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              Text('¥', style: AppTextStyles.priceLarge.copyWith(fontSize: 18.sp)),
              Text(
                widget.amount,
                style: AppTextStyles.priceLarge.copyWith(fontSize: 28.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            l10n?.paymentOrderNo(widget.orderId) ?? '订单号 ${widget.orderId}',
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildAlipayCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = _selectedMethod == PaymentMethod.alipay;
    return _PaymentMethodCard(
      selected: selected,
      accentColor: _PaymentColors.alipay,
      accentLight: _PaymentColors.alipayLight,
      icon: Icons.account_balance_wallet_rounded,
      title: l10n?.paymentAlipay ?? '支付宝',
      subtitle: l10n?.paymentAlipayHint ?? '使用支付宝完成支付',
      onTap: () => setState(() => _selectedMethod = PaymentMethod.alipay),
    );
  }

  Widget _buildWechatCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = _selectedMethod == PaymentMethod.wechat;
    return _PaymentMethodCard(
      selected: selected,
      accentColor: _PaymentColors.wechat,
      accentLight: _PaymentColors.wechatLight,
      icon: Icons.chat_rounded,
      title: l10n?.paymentWechat ?? '微信支付',
      subtitle: l10n?.paymentWechatHint ?? '使用微信完成支付',
      onTap: () => setState(() => _selectedMethod = PaymentMethod.wechat),
    );
  }

  Widget _buildGradientPayButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
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

  Widget _buildPayingScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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

  Widget _buildSuccessScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _successController,
                builder: (_, __) => Transform.scale(
                  scale: _successScale.value,
                  child: Opacity(
                    opacity: _successOpacity.value,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPale,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.check_circle_rounded, size: 64.sp, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              AnimatedBuilder(
                animation: _successController,
                builder: (_, __) => Opacity(
                  opacity: _successOpacity.value,
                  child: Text(
                    l10n?.paymentSuccess ?? '支付成功',
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n?.paymentOrderNo(widget.orderId) ?? '订单号 ${widget.orderId}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 48.h),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: l10n?.orderReturnToOrders ?? '返回订单页',
                  onPressed: _goToOrders,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFailureScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
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
              AppButton(label: l10n?.paymentRetry ?? '重试', onPressed: _retry),
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

/// 支付方式卡片：品牌色 + 勾选强化
class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
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
            color: selected ? accentLight.withValues(alpha: 0.6) : AppColors.card,
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
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
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
