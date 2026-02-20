import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/providers/auth_provider.dart';

/// 个人中心首页：头像、实名认证、我的订单、收藏、钱包、优惠券、消息、设置
class ProfileShellPage extends ConsumerWidget {
  const ProfileShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final auth = ref.watch(authProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n?.tabProfile ?? '我的'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: AppGradientBackground(
        colors: AppGradientBackground.pageGradient,
        stops: AppGradientBackground.pageGradientStops,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        child: ListView(
        padding: EdgeInsets.only(bottom: 24.h),
        children: [
          _buildUserHeader(context, ref, auth, l10n),
          SizedBox(height: 16.h),
          _buildMenuCard(
            context,
            children: [
              _menuTile(context, icon: Icons.receipt_long_rounded, label: l10n?.profileMyOrders ?? '我的订单', onTap: () => context.push('/orders')),
              _divider(),
              _menuTile(context, icon: Icons.favorite_border_rounded, label: l10n?.profileFavorites ?? '收藏', onTap: () => _placeholder(context, l10n?.profileFavorites ?? '收藏')),
              _divider(),
              _menuTile(context, icon: Icons.account_balance_wallet_outlined, label: l10n?.profileWallet ?? '钱包', onTap: () => _placeholder(context, l10n?.profileWallet ?? '钱包')),
              _divider(),
              _menuTile(context, icon: Icons.confirmation_number_outlined, label: l10n?.profileCoupons ?? '优惠券', onTap: () => _placeholder(context, l10n?.profileCoupons ?? '优惠券')),
            ],
          ),
          SizedBox(height: 12.h),
          _buildMenuCard(
            context,
            children: [
              _menuTile(context, icon: Icons.chat_bubble_outline_rounded, label: l10n?.profileMessages ?? '消息', onTap: () => context.push('/messages')),
              _divider(),
              _menuTile(context, icon: Icons.settings_outlined, label: l10n?.profileSettings ?? '设置', onTap: () => _showSettings(context, ref, locale)),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, WidgetRef ref, AuthState auth, AppLocalizations? l10n) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: AppShadow.cardElevated,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (!auth.isAuthenticated) context.push('/auth/login');
            },
            borderRadius: BorderRadius.circular(48.r),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: AppColors.primaryLight,
                  child: auth.isAuthenticated
                      ? Text(
                          '用',
                          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                        )
                      : Icon(Icons.person_outline_rounded, size: 40.sp, color: AppColors.primary),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.isAuthenticated ? (l10n?.profileLoggedIn ?? '已登录') : (l10n?.profileLogin ?? '点击登录'),
                        style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      _buildVerifiedStatus(context, l10n, auth.isAuthenticated),
                    ],
                  ),
                ),
                if (auth.isAuthenticated)
                  TextButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go('/auth/login');
                    },
                    child: Text(l10n?.profileLogout ?? '退出登录'),
                  )
                else
                  Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 24.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedStatus(BuildContext context, AppLocalizations? l10n, bool isLoggedIn) {
    final verified = isLoggedIn; // 可改为从 auth 或用户信息读取是否已实名
    final row = Row(
      children: [
        Icon(
          verified ? Icons.verified_rounded : Icons.verified_outlined,
          size: 16.sp,
          color: verified ? AppColors.primary : AppColors.textTertiary,
        ),
        SizedBox(width: 4.w),
        Text(
          verified ? (l10n?.profileVerified ?? '已实名认证') : (l10n?.profileNotVerified ?? '未实名认证'),
          style: AppTextStyles.bodySmall.copyWith(
            color: verified ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ],
    );
    if (verified) return row;
    return GestureDetector(
      onTap: () => context.push('/verify-name'),
      child: row,
    );
  }

  Widget _buildMenuCard(BuildContext context, {List<BoxShadow>? boxShadow, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.cardRadius,
        boxShadow: boxShadow ?? AppShadow.cardElevated,
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 24.sp, color: AppColors.textSecondary),
      title: Text(label, style: AppTextStyles.bodyLarge),
      trailing: Icon(Icons.chevron_right_rounded, size: 22.sp, color: AppColors.textTertiary),
    );
  }

  Widget _divider() {
    return Divider(height: 1, indent: 56.w, endIndent: 16.w, color: AppColors.divider);
  }

  void _placeholder(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.profileFeatureComing(name) ?? '$name 功能开发中')));
  }

  void _showSettings(BuildContext context, WidgetRef ref, Locale currentLocale) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (ctx) {
        final sheetL10n = AppLocalizations.of(ctx);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(sheetL10n?.settingsTitle ?? '设置', style: AppTextStyles.headlineSmall),
              ),
              ListTile(
                title: Text(sheetL10n?.languageZh ?? '中文'),
                trailing: currentLocale.languageCode == 'zh'
                    ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp)
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).state = const Locale('zh');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(sheetL10n?.languageEn ?? 'English'),
              trailing: currentLocale.languageCode == 'en'
                  ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).state = const Locale('en');
                Navigator.pop(ctx);
              },
            ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}
