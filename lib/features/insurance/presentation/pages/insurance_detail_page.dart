import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/insurance_repository_provider.dart';
import '../../domain/insurance_detail.dart';

/// 保险详情页 — 使用 catalog API
class InsuranceDetailPage extends ConsumerWidget {
  const InsuranceDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(insuranceDetailProvider(id));
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.textTertiary),
                SizedBox(height: 16.h),
                Text(err.toString().replaceFirst('Exception: ', ''), textAlign: TextAlign.center),
                SizedBox(height: 24.h),
                FilledButton.icon(onPressed: () => ref.invalidate(insuranceDetailProvider(id)), icon: const Icon(Icons.refresh_rounded), label: const Text('重试')),
              ],
            ),
          ),
        ),
        data: (detail) => Scaffold(
          backgroundColor: AppColors.warmBackground,
          body: _InsuranceDetailContent(detail: detail),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
                  Text('¥${detail.price.toStringAsFixed(0)}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.price, fontSize: 18.sp)),
                  const Spacer(),
                  SizedBox(
                    height: 48.h,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.iconOutlineOnLight),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24.w), child: const Text('立即购买')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsuranceDetailContent extends StatelessWidget {
  const _InsuranceDetailContent({required this.detail});

  final InsuranceDetail detail;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180.h,
          pinned: true,
          backgroundColor: AppColors.card,
          foregroundColor: AppColors.textPrimary,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop()),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primaryPale, AppColors.primaryPale.withValues(alpha: 0.5)]),
              ),
              child: Center(child: Icon(Icons.shield_rounded, size: 72.sp, color: AppColors.primary)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.name, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text('¥${detail.price.toStringAsFixed(0)}', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.price, fontSize: 28.sp)),
                    if (detail.insuranceType != null) ...[
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(8.r)),
                        child: Text(detail.insuranceType!, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 12.h),
                Text('有效期 ${detail.validityDays} 天', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                if (detail.coverageAmount != null && detail.coverageAmount! > 0) ...[
                  SizedBox(height: 8.h),
                  Text('保额 ¥${detail.coverageAmount!.toStringAsFixed(0)}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                ],
                if (detail.description != null && detail.description!.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Text('产品说明', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.border)),
                    child: Text(detail.description!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5)),
                  ),
                ],
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
