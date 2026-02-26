import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/ticket_repository_provider.dart';
import '../../domain/ticket_detail.dart';

/// 门票详情页 — 使用 catalog API，标题 + 价格 + 说明 + 立即预订
class TicketDetailPage extends ConsumerWidget {
  const TicketDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(ticketDetailProvider(id));
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
                FilledButton.icon(
                  onPressed: () => ref.invalidate(ticketDetailProvider(id)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
        data: (detail) => Scaffold(
          backgroundColor: AppColors.warmBackground,
          body: _TicketDetailContent(detail: detail),
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
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24.w), child: const Text('立即预订')),
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

class _TicketDetailContent extends StatelessWidget {
  const _TicketDetailContent({required this.detail});

  final TicketDetail detail;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.h,
          pinned: true,
          backgroundColor: AppColors.card,
          foregroundColor: AppColors.textPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryPale,
                    AppColors.primaryPale.withValues(alpha: 0.5),
                  ],
                ),
              ),
              child: Center(
                child: Icon(Icons.confirmation_number_rounded, size: 80.sp, color: AppColors.primary),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.attractionName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      '¥${detail.price.toStringAsFixed(0)}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.price,
                        fontSize: 28.sp,
                      ),
                    ),
                    if (detail.ticketType != null && detail.ticketType!.isNotEmpty) ...[
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPale,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          detail.ticketType!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (detail.location != null && detail.location!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18.sp, color: AppColors.textSecondary),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          detail.location!,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
                if (detail.validityDays != null && detail.validityDays! > 0) ...[
                  SizedBox(height: 8.h),
                  Text(
                    '有效期内使用 · ${detail.validityDays}天有效',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                ],
                if (detail.description != null && detail.description!.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Text(
                    '门票说明',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      detail.description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
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
