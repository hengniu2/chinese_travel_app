import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/design_system/design_system.dart';
import '../profile_sub_page.dart';

/// Top-up sub-screen: amount selection + payment method (Alipay/WeChat Pay style).
class WalletTopUpPage extends StatelessWidget {
  const WalletTopUpPage({super.key});

  static String title(AppLocalizations? l10n) =>
      l10n?.profileWalletTopUp ?? '充值';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ProfileSubPage(
      title: title(l10n),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'zh'
                  ? '充值金额'
                  : 'Top-up amount',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [100, 200, 500, 1000, 2000, 5000]
                  .map(
                    (amount) => _AmountChip(
                      amount: amount,
                      onTap: () => _submitTopUp(context, amount),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 24.h),
            Text(
              Localizations.localeOf(context).languageCode == 'zh'
                  ? '支付方式'
                  : 'Payment method',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            _PaymentMethodTile(
              icon: Icons.account_balance_wallet_rounded,
              label: '微信支付',
              onTap: () => _submitTopUp(context, 0),
            ),
            SizedBox(height: 8.h),
            _PaymentMethodTile(
              icon: Icons.payment_rounded,
              label: '支付宝',
              onTap: () => _submitTopUp(context, 0),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  void _submitTopUp(BuildContext context, int amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.profileFeatureComing(
                  AppLocalizations.of(context)?.profileWalletTopUp ?? '充值') ??
              '充值功能即将上线',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.amount, required this.onTap});

  final int amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text('¥$amount', style: AppTextStyles.titleMedium),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(icon, size: 24.sp, color: AppColors.primary),
              SizedBox(width: 12.w),
              Text(label, style: AppTextStyles.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
