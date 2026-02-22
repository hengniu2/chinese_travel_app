import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/profile_ui_state.dart';
import '../../providers/profile_state_provider.dart';
import '../widgets/order_status_section.dart';
import '../widgets/profile_common_settings_section.dart';
import '../widgets/profile_header_sample_section.dart';
import '../widgets/profile_quick_cards_section.dart';
import '../widgets/profile_tools_grid_section.dart';

/// 页面背景色（样本风格浅灰）
const Color _kProfilePageBackground = Color(0xFFF5F6FA);

/// 区块间距（16dp，与样本一致）
const double _kSectionSpacing = 16;

/// 个人中心 · 全新结构：6 大区块、卡片化、浅底、下拉刷新
class ProfileShellPage extends ConsumerStatefulWidget {
  const ProfileShellPage({super.key});

  @override
  ConsumerState<ProfileShellPage> createState() => _ProfileShellPageState();
}

class _ProfileShellPageState extends ConsumerState<ProfileShellPage> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final profileAsync = ref.watch(profileStateProvider);

    const double kHeaderHeight = 188;
    final topPadding = kHeaderHeight.h;

    return Scaffold(
      backgroundColor: _kProfilePageBackground,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(profileStateProvider);
              await ref.read(profileStateProvider.future);
            },
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: topPadding)),
                SliverToBoxAdapter(child: SizedBox(height: _kSectionSpacing.h)),
                SliverToBoxAdapter(
                  child: profileAsync.when(
                    data: (ProfileUiState state) => OrderStatusSection(state: state),
                    loading: () => _OrderStatusSkeleton(),
                    error: (Object e, StackTrace st) => OrderStatusSection(state: ProfileUiState()),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: _kSectionSpacing.h)),
                SliverToBoxAdapter(
                  child: ProfileQuickCardsSection(
                    onMyFriends: () => context.push('/profile/my-friends'),
                    onCoupons: () => context.push('/profile/coupons'),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: _kSectionSpacing.h)),
                SliverToBoxAdapter(
                  child: ProfileToolsGridSection(
                    onNavigateTo: (path) => context.push(path),
                    onOrders: () => context.push('/orders'),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: _kSectionSpacing.h)),
                SliverToBoxAdapter(
                  child: ProfileCommonSettingsSection(
                    onNavigateTo: (path) => context.push(path),
                    onSettings: () => _showSettings(context, ref, ref.read(localeProvider)),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: profileAsync.when(
              data: (ProfileUiState state) => ProfileHeaderStrip(
                auth: auth,
                profileState: state,
                onSettings: () => _showSettings(context, ref, ref.read(localeProvider)),
                onLogout: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/auth/login');
                },
              ),
              loading: () => ProfileHeaderStrip(
                auth: auth,
                profileState: null,
                onSettings: () => _showSettings(context, ref, ref.read(localeProvider)),
                onLogout: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/auth/login');
                },
              ),
              error: (Object e, StackTrace st) => ProfileHeaderStrip(
                auth: auth,
                profileState: null,
                onSettings: () => _showSettings(context, ref, ref.read(localeProvider)),
                onLogout: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/auth/login');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.profileFeatureComing(name) ?? '$name coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSettings(BuildContext context, WidgetRef ref, Locale currentLocale) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        final sheetL10n = AppLocalizations.of(ctx);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 32.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                child: Text(
                  sheetL10n?.settingsTitle ?? 'Settings',
                  style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
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

class _OrderStatusSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24.r),
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
        children: List.generate(5, (_) => AppSkeleton(width: 48.w, height: 52.w, borderRadius: BorderRadius.circular(16.r))),
      ),
    );
  }
}
