import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

/// 首页（含入口至旅行团列表）
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appTitle ?? '享梦游'),
      ),
      body: ListView(
        padding: AppSpacing.paddingPage,
        children: [
          const SizedBox(height: 16),
          Text(l10n?.tabHome ?? '首页', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 24),
          AppCard(
            onTap: () => context.push('/tours'),
            child: Row(
              children: [
                Icon(Icons.tour_rounded, color: AppColors.primary, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n?.homeToursCardTitle ?? '精选旅行线路', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 4),
                      Text(l10n?.homeToursCardSubtitle ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => context.push('/hotels'),
            child: Row(
              children: [
                Icon(Icons.hotel_rounded, color: AppColors.primary, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n?.homeHotelsCardTitle ?? '酒店', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 4),
                      Text(l10n?.homeHotelsCardSubtitle ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => context.push('/orders'),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n?.homeOrdersCardTitle ?? '我的订单', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 4),
                      Text(l10n?.homeOrdersCardSubtitle ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
