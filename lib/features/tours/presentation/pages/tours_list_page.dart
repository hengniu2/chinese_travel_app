import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/tour_list_mock.dart';
import '../../domain/tour_item.dart';
import '../widgets/tour_card.dart';
import '../widgets/tour_filter_bar.dart';

/// 旅行团列表页（筛选 + 高级卡片）
class ToursListPage extends StatefulWidget {
  const ToursListPage({super.key});

  @override
  State<ToursListPage> createState() => _ToursListPageState();
}

class _ToursListPageState extends State<ToursListPage> {
  TourFilters _filters = const TourFilters();
  late List<TourItem> _tours;

  @override
  void initState() {
    super.initState();
    _tours = getTourList(_filters);
  }

  void _applyFilters(TourFilters f) {
    setState(() {
      _filters = f;
      _tours = getTourList(_filters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n?.toursTitle ?? '精选旅行线路'),
        backgroundColor: Colors.transparent,
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
      body: AppGradientBackground(
        colors: AppGradientBackground.pageGradient,
        stops: AppGradientBackground.pageGradientStops,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TourFilterBar(
            filters: _filters,
            onFiltersChanged: _applyFilters,
            cities: mockCities,
            types: mockTypes,
          ),
          Expanded(
            child: _tours.isEmpty
                ? _buildEmpty(context)
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    cacheExtent: 200,
                    itemCount: _tours.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final tour = _tours[index];
                      return TourCard(
                        tour: tour,
                        onTap: () => context.push('/tours/${tour.id}'),
                      );
                    },
                  ),
          ),
        ],
        ),
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
            onPressed: () => _applyFilters(const TourFilters()),
            child: Text(l10n?.filterClear ?? '清除筛选', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
