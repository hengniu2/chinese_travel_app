import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/insurance_repository_provider.dart';
import '../../domain/insurance_item.dart';

/// 旅行保险列表页 — 使用 catalog API
class InsuranceListPage extends ConsumerWidget {
  const InsuranceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(insuranceListProvider);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('旅行保险'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: asyncList.when(
        loading: () => ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: 5,
          itemBuilder: (_, __) => _InsuranceCardSkeleton(),
        ),
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
                FilledButton.icon(
                  onPressed: () => ref.invalidate(insuranceListProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
        data: (res) {
          if (res.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text('暂无保险产品', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(insuranceListProvider),
            color: AppColors.primary,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: res.items.length,
              itemBuilder: (_, i) {
                final item = res.items[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _InsuranceCard(
                    item: item,
                    onTap: () => context.push('/profile/insurance/${item.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _InsuranceCard extends StatelessWidget {
  const _InsuranceCard({required this.item, required this.onTap});

  final InsuranceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 8)],
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(12.r)),
                child: Icon(Icons.shield_rounded, size: 28.sp, color: AppColors.primary),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (item.insuranceType != null) ...[
                      SizedBox(height: 4.h),
                      Text(item.insuranceType!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                    SizedBox(height: 8.h),
                    Text('¥${item.price.toStringAsFixed(0)}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.price, fontSize: 18.sp)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 24.sp, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsuranceCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        children: [
          Container(width: 56.w, height: 56.w, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12.r))),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16.h, width: double.infinity, color: AppColors.surface),
                SizedBox(height: 8.h),
                Container(height: 14.h, width: 80.w, color: AppColors.surface),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
