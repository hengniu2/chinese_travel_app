import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/hotel_list_mock.dart';
import '../../domain/hotel_item.dart';
import '../widgets/hotel_card.dart';
import '../widgets/hotel_filter_bar.dart';

/// 酒店列表页（日期 / 价格 / 星级 / 排序）
class HotelsListPage extends StatefulWidget {
  const HotelsListPage({super.key});

  @override
  State<HotelsListPage> createState() => _HotelsListPageState();
}

class _HotelsListPageState extends State<HotelsListPage> {
  HotelFilters _filters = const HotelFilters();
  late List<HotelItem> _hotels;

  @override
  void initState() {
    super.initState();
    _hotels = getHotelList(_filters);
  }

  void _onFiltersChanged(HotelFilters f) {
    setState(() {
      _filters = f;
      _hotels = getHotelList(_filters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.hotelsTitle ?? '酒店'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HotelFilterBar(
            filters: _filters,
            onFiltersChanged: _onFiltersChanged,
          ),
          Expanded(
            child: _hotels.isEmpty
                ? _buildEmpty(context)
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: _hotels.length,
                    separatorBuilder: (_, __) => SizedBox(height: 14.h),
                    itemBuilder: (context, index) {
                      final hotel = _hotels[index];
                      return HotelCard(
                        hotel: hotel,
                        onTap: () => context.push('/hotels/${hotel.id}'),
                      );
                    },
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel_outlined, size: 64.sp, color: AppColors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            l10n?.hotelEmpty ?? '暂无符合条件的酒店',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
