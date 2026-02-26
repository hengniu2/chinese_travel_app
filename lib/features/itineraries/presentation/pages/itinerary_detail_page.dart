import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/itinerary_repository.dart';
import '../../data/itinerary_repository_provider.dart';

/// 行程详情 — GET /api/itineraries/:id，支持编辑与删除
class ItineraryDetailPage extends ConsumerWidget {
  const ItineraryDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(itineraryDetailProvider(id));
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('行程详情'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop()),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') context.push('/profile/itineraries/$id/edit');
              if (value == 'delete') {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('删除行程'),
                    content: const Text('确定要删除该行程吗？此操作不可恢复。'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('删除', style: TextStyle(color: AppColors.error))),
                    ],
                  ),
                );
                if (ok == true && context.mounted) {
                  await ref.read(itineraryRepositoryProvider).delete(id);
                  ref.invalidate(itineraryListProvider);
                  if (context.mounted) context.go('/profile/itineraries');
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('编辑')),
              const PopupMenuItem(value: 'delete', child: Text('删除', style: TextStyle(color: AppColors.error))),
            ],
          ),
        ],
      ),
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
                FilledButton.icon(onPressed: () => ref.invalidate(itineraryDetailProvider(id)), icon: const Icon(Icons.refresh_rounded), label: const Text('重试')),
              ],
            ),
          ),
        ),
        data: (dto) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoCard(label: '名称', value: dto.name ?? '未命名'),
              SizedBox(height: 12.h),
              _InfoCard(label: '状态', value: _statusLabel(dto.status)),
              if (dto.startDate != null) ...[
                SizedBox(height: 12.h),
                _InfoCard(label: '开始日期', value: '${dto.startDate!.year}-${dto.startDate!.month.toString().padLeft(2, '0')}-${dto.startDate!.day.toString().padLeft(2, '0')}'),
              ],
              if (dto.endDate != null) ...[
                SizedBox(height: 12.h),
                _InfoCard(label: '结束日期', value: '${dto.endDate!.year}-${dto.endDate!.month.toString().padLeft(2, '0')}-${dto.endDate!.day.toString().padLeft(2, '0')}'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT': return '草稿';
      case 'CONFIRMED': return '已确认';
      case 'COMPLETED': return '已完成';
      case 'CANCELLED': return '已取消';
      default: return status;
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
          SizedBox(height: 4.h),
          Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
