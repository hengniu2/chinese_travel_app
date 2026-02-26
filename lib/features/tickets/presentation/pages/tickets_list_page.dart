import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/ticket_repository_provider.dart';
import '../../domain/ticket_item.dart';

/// 景区门票列表页 — 使用 catalog API，卡片列表 + 下拉刷新 + 空状态
class TicketsListPage extends ConsumerStatefulWidget {
  const TicketsListPage({super.key});

  @override
  ConsumerState<TicketsListPage> createState() => _TicketsListPageState();
}

class _TicketsListPageState extends ConsumerState<TicketsListPage> {
  static const _query = TicketListQuery(page: 1, pageSize: 30);

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(ticketListProvider(_query));
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('景区门票'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: asyncList.when(
        loading: () => ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: 6,
          itemBuilder: (_, __) => _TicketCardSkeleton(),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.textTertiary),
                SizedBox(height: 16.h),
                Text(
                  err.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 24.h),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(ticketListProvider(_query)),
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
                  Icon(Icons.confirmation_number_outlined, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text(
                    '暂无门票',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '稍后再来看看',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(ticketListProvider(_query)),
            color: AppColors.primary,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: res.items.length,
              itemBuilder: (_, i) {
                final item = res.items[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _TicketCard(
                    item: item,
                    onTap: () => context.push('/profile/tickets/${item.id}'),
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

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.item, required this.onTap});

  final TicketItem item;
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
            border: Border.all(color: AppColors.border, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.confirmation_number_rounded, size: 36.sp, color: AppColors.primary),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.attractionName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.location != null && item.location!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textTertiary),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              item.location!,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Text(
                      '¥${item.price.toStringAsFixed(0)}',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.price,
                        fontSize: 18.sp,
                      ),
                    ),
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

class _TicketCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16.h, width: double.infinity, color: AppColors.surface),
                SizedBox(height: 8.h),
                Container(height: 12.h, width: 120.w, color: AppColors.surface),
                SizedBox(height: 12.h),
                Container(height: 18.h, width: 60.w, color: AppColors.surface),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
