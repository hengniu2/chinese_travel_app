import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/tour_list_mock.dart';
import '../../data/tour_repository_provider.dart';
import '../../domain/tour_item.dart';
import '../widgets/tour_card.dart';
import '../widgets/tour_filter_bar.dart';

/// 旅行团列表页（筛选 + API 数据）
class ToursListPage extends ConsumerStatefulWidget {
  const ToursListPage({super.key});

  @override
  ConsumerState<ToursListPage> createState() => _ToursListPageState();
}

class _ToursListPageState extends ConsumerState<ToursListPage> {
  TourFilters _filters = const TourFilters();

  TourListParams get _listParams => TourListParams(
        page: 1,
        pageSize: 20,
        minPrice: _filters.priceMin,
        maxPrice: _filters.priceMax,
        minDays: _filters.daysMin,
        maxDays: _filters.daysMax,
        region: _filters.city?.isNotEmpty == true ? _filters.city : null,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncList = ref.watch(tourListProvider(_listParams));
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Text(l10n?.toursTitle ?? '精选旅行线路'),
        backgroundColor: AppColors.homeSearchCapsule,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.homeSearchCapsule,
              border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: TourFilterBar(
              filters: _filters,
              onFiltersChanged: (f) => setState(() => _filters = f),
              cities: mockCities,
              types: mockTypes,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.homeSectionYellow,
                border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: asyncList.when(
                data: (res) => res.items.isEmpty
                    ? _buildEmpty(context)
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        cacheExtent: 200,
                        itemCount: res.items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final tour = res.items[index];
                          return TourCard(
                            tour: tour,
                            onTap: () => context.push('/tours/${tour.id}'),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.error),
                      SizedBox(height: 12.h),
                      Text(err.toString(), textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => ref.invalidate(tourListProvider(_listParams)),
                        child: Text(l10n?.commonRetry ?? '重试'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64.sp, color: AppColors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            l10n?.tourEmpty ?? '暂无符合条件的线路',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () => setState(() => _filters = const TourFilters()),
            child: Text(l10n?.filterClear ?? '清除筛选', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
