import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/review_repository.dart';
import '../../data/review_repository_provider.dart';

/// 我的评价列表 — GET /api/reviews
class MyReviewsListPage extends ConsumerWidget {
  const MyReviewsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(myReviewsListProvider);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('我的评价'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: asyncList.when(
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
                FilledButton.icon(
                  onPressed: () => ref.invalidate(myReviewsListProvider),
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
                  Icon(Icons.rate_review_outlined, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text('暂无评价', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 8.h),
                  Text('完成订单后可对服务进行评价', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myReviewsListProvider),
            color: AppColors.primary,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: res.items.length,
              itemBuilder: (_, i) {
                final item = res.items[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _ReviewCard(dto: item),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.dto});

  final ApiReviewDto dto;

  static String _targetLabel(String type) {
    switch (type.toUpperCase()) {
      case 'COMPANION': return '陪游';
      case 'MERCHANT': return '商家';
      case 'PACKAGE': return '套餐';
      case 'HOTEL': return '酒店';
      case 'TICKET': return '门票';
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = dto.createdAt != null
        ? '${dto.createdAt!.year}-${dto.createdAt!.month.toString().padLeft(2, '0')}-${dto.createdAt!.day.toString().padLeft(2, '0')}'
        : '';
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(8.r)),
                child: Text(_targetLabel(dto.targetType), style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              ...List.generate(5, (i) => Icon(i < dto.rating ? Icons.star_rounded : Icons.star_border_rounded, size: 16.sp, color: AppColors.accentGold)),
            ],
          ),
          if (dto.content.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(dto.content, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary), maxLines: 4, overflow: TextOverflow.ellipsis),
          ],
          SizedBox(height: 8.h),
          Text(dateStr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
