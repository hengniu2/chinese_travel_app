import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../providers/profile_state_provider.dart';
import 'profile_sub_page.dart';

/// Wallet page — Alipay/WeChat Pay inspired: balance card, quick actions, transaction list.
class ProfileWalletPage extends ConsumerWidget {
  const ProfileWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Use wallet title explicitly (Wallet / 钱包) — avoid confusion with profileMyPrizes
    final title = l10n?.profileWallet ?? (Localizations.localeOf(context).languageCode == 'zh' ? '钱包' : 'Wallet');
    final profileAsync = ref.watch(profileStateProvider);

    return ProfileSubPage(
      title: title,
      child: profileAsync.when(
        data: (state) => _WalletContent(
          balance: state.walletBalance ?? 0,
          l10n: l10n,
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => _WalletContent(balance: 0, l10n: l10n),
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  const _WalletContent({
    required this.balance,
    required this.l10n,
  });

  final double balance;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _BalanceCard(balance: balance, l10n: l10n)),
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        SliverToBoxAdapter(child: _QuickActions(l10n: l10n)),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: _TransactionSectionHeader(l10n: l10n)),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        SliverToBoxAdapter(child: _TransactionList(l10n: l10n)),
        SliverToBoxAdapter(child: SizedBox(height: 32.h)),
      ],
    );
  }
}

/// Gradient balance card — prominent balance, soft gradient, subtle pattern.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.l10n,
  });

  final double balance;
  final AppLocalizations? l10n;

  static const List<Color> _gradientColors = [
    Color(0xFF1A237E),
    Color(0xFF283593),
    Color(0xFF3949AB),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3949AB).withValues(alpha: 0.35),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.account_balance_wallet_rounded, size: 120.sp, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      l10n?.profileWalletBalance ?? '余额',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                '¥${NumberFormat('#,##0.00').format(balance)}',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                l10n?.profileWalletSubtitle ?? '旅行钱包 · 安全便捷',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick actions: Top-up, Withdraw, Transaction details.
class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.l10n});

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.add_circle_outline_rounded,
        label: l10n?.profileWalletTopUp ?? '充值',
        onTap: () => context.push('/profile/wallet/top-up'),
      ),
      _ActionItem(
        icon: Icons.remove_circle_outline_rounded,
        label: l10n?.profileWalletWithdraw ?? '提现',
        onTap: () => context.push('/profile/wallet/withdraw'),
      ),
      _ActionItem(
        icon: Icons.list_alt_rounded,
        label: l10n?.profileWalletDetails ?? '明细',
        onTap: () => context.push('/profile/wallet/transactions'),
      ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions
            .map(
              (a) => Expanded(
                child: _QuickActionButton(
                  icon: a.icon,
                  label: a.label,
                  onTap: a.onTap,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String name) {
    final msg = AppLocalizations.of(context)?.profileFeatureComing(name) ?? '$name coming soon';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

/// Tappable quick-action cell: Material + InkWell so taps register and show feedback.
class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, size: 26.sp, color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.l10n});

  final String title;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontSize: 17.sp,
        ),
      ),
    );
  }
}

/// Transaction section: title + "View all" that navigates to full list.
class _TransactionSectionHeader extends StatelessWidget {
  const _TransactionSectionHeader({required this.l10n});

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final title = l10n?.profileWalletTransactions ?? '交易记录';
    final viewAll = Localizations.localeOf(context).languageCode == 'zh' ? '全部' : 'View all';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 17.sp,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/profile/wallet/transactions'),
            child: Text(
              viewAll,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Transaction list — mock items or empty state.
class _TransactionList extends StatelessWidget {
  const _TransactionList({required this.l10n});

  final AppLocalizations? l10n;

  static List<_TransactionItem> _mockTransactions() {
    final now = DateTime.now();
    return [
      _TransactionItem(
        id: '1',
        title: '订单支付',
        subtitle: '旅行套餐 · 杭州三日游',
        amount: -1288.00,
        time: now.subtract(const Duration(hours: 2)),
        type: TransactionType.payment,
      ),
      _TransactionItem(
        id: '2',
        title: '充值',
        subtitle: '微信支付',
        amount: 500.00,
        time: now.subtract(const Duration(days: 1)),
        type: TransactionType.topUp,
      ),
      _TransactionItem(
        id: '3',
        title: '退款',
        subtitle: '订单取消',
        amount: 288.50,
        time: now.subtract(const Duration(days: 3)),
        type: TransactionType.refund,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _mockTransactions();

    if (items.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56.sp,
              color: AppColors.textTertiary.withValues(alpha: 0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n?.profileWalletNoTransactions ?? '暂无交易记录',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _TransactionTile(item: items[i]),
              if (i < items.length - 1)
                Divider(height: 1, indent: 56.w + 12.w + 16.w, endIndent: 16.w, color: AppColors.divider),
            ],
          ],
        ),
      ),
    );
  }
}

enum TransactionType { payment, topUp, refund }

class _TransactionItem {
  const _TransactionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.type,
  });
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime time;
  final TransactionType type;
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});

  final _TransactionItem item;

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
                Text(
                  item.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isNegative ? '-' : '+'}¥${item.amount.abs().toStringAsFixed(2)}',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                DateFormat('MM/dd HH:mm').format(item.time),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
