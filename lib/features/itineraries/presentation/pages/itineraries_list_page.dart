import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/itinerary_repository.dart';
import '../../data/itinerary_repository_provider.dart';

/// 我的行程列表页 — GET /api/itineraries
class ItinerariesListPage extends ConsumerWidget {
  const ItinerariesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(itineraryListProvider);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('我的行程'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/profile/itineraries/create'),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('新建'),
          ),
        ],
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
                  onPressed: () => ref.invalidate(itineraryListProvider),
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
                  Icon(Icons.route_rounded, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text('暂无行程', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 8.h),
                  FilledButton.icon(
                    onPressed: () => context.push('/profile/itineraries/create'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('新建行程'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(itineraryListProvider),
            color: AppColors.primary,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: res.items.length,
              itemBuilder: (_, i) {
                final item = res.items[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _ItineraryCard(
                    dto: item,
                    onTap: () => context.push('/profile/itineraries/${item.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/profile/itineraries/create'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: AppColors.iconOutlineOnLight),
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  const _ItineraryCard({required this.dto, required this.onTap});

  final ApiItineraryDto dto;
  final VoidCallback onTap;

  static String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT': return '草稿';
      case 'CONFIRMED': return '已确认';
      case 'COMPLETED': return '已完成';
      case 'CANCELLED': return '已取消';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = dto.name ?? '未命名行程';
    final dateRange = (dto.startDate != null && dto.endDate != null)
        ? '${dto.startDate!.year}-${dto.startDate!.month.toString().padLeft(2, '0')}-${dto.startDate!.day.toString().padLeft(2, '0')} 至 ${dto.endDate!.year}-${dto.endDate!.month.toString().padLeft(2, '0')}-${dto.endDate!.day.toString().padLeft(2, '0')}'
        : '未设置日期';
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
                child: Icon(Icons.route_rounded, size: 28.sp, color: AppColors.primary),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 4.h),
                    Text(dateRange, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6.r)),
                      child: Text(_statusLabel(dto.status), style: AppTextStyles.overline.copyWith(color: AppColors.textSecondary, fontSize: 11.sp)),
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
