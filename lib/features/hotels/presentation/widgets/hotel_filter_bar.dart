import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_item.dart';

/// 酒店筛选条：日期 / 价格 / 星级 / 排序
class HotelFilterBar extends StatelessWidget {
  const HotelFilterBar({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  final HotelFilters filters;
  final ValueChanged<HotelFilters> onFiltersChanged;

  String get _dateLabel {
    if (filters.checkIn != null && filters.checkOut != null) {
      return '${filters.checkIn!.month}/${filters.checkIn!.day}-${filters.checkOut!.month}/${filters.checkOut!.day}';
    }
    if (filters.checkIn != null) return '${filters.checkIn!.month}月${filters.checkIn!.day}日入住';
    return '入住/退房';
  }

  String get _priceLabel {
    if (filters.priceMin != null && filters.priceMax != null) {
      return '¥${filters.priceMin!.toInt()}-${filters.priceMax!.toInt()}';
    }
    if (filters.priceMin != null) return '¥${filters.priceMin!.toInt()}起';
    if (filters.priceMax != null) return '¥${filters.priceMax!.toInt()}以下';
    return '价格';
  }

  String get _starLabel {
    if (filters.star != null) return '${filters.star}星';
    return '星级';
  }

  String get _sortLabel {
    switch (filters.sort) {
      case HotelSort.priceAsc:
        return '价格↑';
      case HotelSort.priceDesc:
        return '价格↓';
      case HotelSort.scoreDesc:
        return '评分';
      case HotelSort.starDesc:
        return '星级';
      case HotelSort.default_:
        return '排序';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundCard,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Row(
        children: [
          _chip(context, _dateLabel, () => _showDateSheet(context)),
          _chip(context, _priceLabel, () => _showPriceSheet(context)),
          _chip(context, _starLabel, () => _showStarSheet(context)),
          _chip(context, _sortLabel, () => _showSortSheet(context)),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.smRadius,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 12.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDateSheet(BuildContext context) async {
    final now = DateTime.now();
    final checkIn = filters.checkIn ?? now;
    final checkOut = filters.checkOut ?? now.add(const Duration(days: 1));
    final pickedIn = await showDatePicker(
      context: context,
      initialDate: checkIn,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedIn == null || !context.mounted) return;
    final pickedOut = await showDatePicker(
      context: context,
      initialDate: checkOut.isAfter(pickedIn) ? checkOut : pickedIn.add(const Duration(days: 1)),
      firstDate: pickedIn,
      lastDate: pickedIn.add(const Duration(days: 30)),
    );
    if (pickedOut != null) {
      onFiltersChanged(filters.copyWith(checkIn: pickedIn, checkOut: pickedOut));
    } else {
      onFiltersChanged(filters.copyWith(checkIn: pickedIn, checkOut: pickedIn.add(const Duration(days: 1))));
    }
  }

  void _showPriceSheet(BuildContext context) {
    const options = ['不限', '300以下', '300-600', '600-1000', '1000以上'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('价格区间', style: AppTextStyles.headlineSmall),
            ),
            ...options.map((o) => ListTile(
                  title: Text(o == '不限' ? o : '¥$o'),
                  trailing: _priceMatch(o) ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp) : null,
                  onTap: () {
                    double? min, max;
                    if (o == '300以下') max = 300;
                    else if (o == '300-600') { min = 300; max = 600; }
                    else if (o == '600-1000') { min = 600; max = 1000; }
                    else if (o == '1000以上') min = 1000;
                    onFiltersChanged(filters.copyWith(priceMin: min, priceMax: max));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  bool _priceMatch(String o) {
    if (o == '不限') return filters.priceMin == null && filters.priceMax == null;
    if (o == '300以下') return filters.priceMax == 300;
    if (o == '300-600') return filters.priceMin == 300 && filters.priceMax == 600;
    if (o == '600-1000') return filters.priceMin == 600 && filters.priceMax == 1000;
    if (o == '1000以上') return filters.priceMin == 1000;
    return false;
  }

  void _showStarSheet(BuildContext context) {
    const stars = [0, 3, 4, 5]; // 0 = 不限
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('星级筛选', style: AppTextStyles.headlineSmall),
            ),
            ...stars.map((s) => ListTile(
                  title: Text(s == 0 ? '不限' : '$s星'),
                  trailing: (filters.star == s || (s == 0 && filters.star == null))
                      ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp)
                      : null,
                  onTap: () {
                    onFiltersChanged(filters.copyWith(star: s == 0 ? null : s));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final options = [
      (HotelSort.default_, '默认'),
      (HotelSort.priceAsc, '价格从低到高'),
      (HotelSort.priceDesc, '价格从高到低'),
      (HotelSort.scoreDesc, '评分最高'),
      (HotelSort.starDesc, '星级最高'),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('排序', style: AppTextStyles.headlineSmall),
            ),
            ...options.map((e) => ListTile(
                  title: Text(e.$2),
                  trailing: filters.sort == e.$1 ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp) : null,
                  onTap: () {
                    onFiltersChanged(filters.copyWith(sort: e.$1));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
