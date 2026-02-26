import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/design_system/design_system.dart';
import '../profile_sub_page.dart';

/// Full transaction history sub-screen (commercial wallet style).
class WalletTransactionsPage extends StatelessWidget {
  const WalletTransactionsPage({super.key});

  static String title(AppLocalizations? l10n) =>
      l10n?.profileWalletTransactions ?? '交易记录';

  static List<_TxItem> _mockTransactions() {
    final now = DateTime.now();
    return [
      _TxItem('1', '订单支付', '旅行套餐 · 杭州三日游', -1288.00, now.subtract(const Duration(hours: 2))),
      _TxItem('2', '充值', '微信支付', 500.00, now.subtract(const Duration(days: 1))),
      _TxItem('3', '退款', '订单取消', 288.50, now.subtract(const Duration(days: 3))),
      _TxItem('4', '订单支付', '酒店预订', -680.00, now.subtract(const Duration(days: 5))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = _mockTransactions();
    return ProfileSubPage(
      title: title(l10n),
      child: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text(
                    l10n?.profileWalletNoTransactions ?? '暂无交易记录',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: _TxTile(item: item),
                );
              },
            ),
    );
  }
}

class _TxItem {
  const _TxItem(this.id, this.title, this.subtitle, this.amount, this.time);
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime time;
}

class _TxTile extends StatelessWidget {
  const _TxTile({required this.item});
  final _TxItem item;

  @override
  Widget build(BuildContext context) {
    final isNegative = item.amount < 0;
    final color = isNegative ? AppColors.textPrimary : AppColors.success;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: (isNegative ? AppColors.price : AppColors.success).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isNegative ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 22.sp,
              color: isNegative ? AppColors.price : AppColors.success,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                SizedBox(height: 2.h),
                Text(item.subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12.sp)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isNegative ? '-' : '+'}¥${item.amount.abs().toStringAsFixed(2)}',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, color: color),
              ),
              SizedBox(height: 2.h),
              Text(DateFormat('MM/dd HH:mm').format(item.time), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11.sp)),
            ],
          ),
        ],
      ),
    );
  }
}
