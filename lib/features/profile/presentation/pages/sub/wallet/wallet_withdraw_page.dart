import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/design_system/design_system.dart';
import '../profile_sub_page.dart';

String _locale(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

/// Withdraw sub-screen: amount + bank/account (commercial wallet style).
class WalletWithdrawPage extends StatelessWidget {
  const WalletWithdrawPage({super.key});

  static String title(AppLocalizations? l10n) =>
      l10n?.profileWalletWithdraw ?? '提现';

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
              _locale(context) == 'zh' ? '提现金额' : 'Withdraw amount',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: '¥ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.h),
            Text(
              _locale(context) == 'zh' ? '全部提现' : 'Withdraw all',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              _locale(context) == 'zh' ? '提现账户' : 'Withdraw account',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance_rounded, color: AppColors.primary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _locale(context) == 'zh' ? '添加银行卡' : 'Add bank card',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)?.profileFeatureComing(
                                AppLocalizations.of(context)?.profileWalletWithdraw ??
                                    '提现') ??
                            '提现功能即将上线',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(title(l10n)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
