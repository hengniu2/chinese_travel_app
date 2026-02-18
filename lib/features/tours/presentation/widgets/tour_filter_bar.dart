import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/tour_item.dart';

/// 筛选条：城市 / 价格 / 天数 / 出发时间 / 类型
class TourFilterBar extends StatelessWidget {
  const TourFilterBar({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    this.cities = const [],
    this.types = const [],
  });

  final TourFilters filters;
  final ValueChanged<TourFilters> onFiltersChanged;
  final List<String> cities;
  final List<String> types;

  String get _cityLabel => filters.city != null && filters.city!.isNotEmpty ? filters.city! : '城市';
  String get _priceLabel {
    if (filters.priceMin != null && filters.priceMax != null) return '¥${filters.priceMin!.toInt()}-${filters.priceMax!.toInt()}';
    if (filters.priceMin != null) return '¥${filters.priceMin!.toInt()}起';
    if (filters.priceMax != null) return '¥${filters.priceMax!.toInt()}以下';
    return '价格';
  }
  String get _daysLabel {
    if (filters.daysMin != null && filters.daysMax != null) return '${filters.daysMin}-${filters.daysMax}天';
    if (filters.daysMin != null) return '${filters.daysMin}天以上';
    if (filters.daysMax != null) return '${filters.daysMax}天以内';
    return '天数';
  }
  String get _departureLabel {
    if (filters.departureFrom != null) {
      final d = filters.departureFrom!;
      return '${d.month}月${d.day}日起';
    }
    return '出发时间';
  }
  String get _typeLabel => filters.type != null && filters.type!.isNotEmpty ? filters.type! : '类型';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundCard,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Row(
        children: [
          _filterChip(context, _cityLabel, () => _showCitySheet(context)),
          _filterChip(context, _priceLabel, () => _showPriceSheet(context)),
          _filterChip(context, _daysLabel, () => _showDaysSheet(context)),
          _filterChip(context, _departureLabel, () => _showDepartureSheet(context)),
          _filterChip(context, _typeLabel, () => _showTypeSheet(context)),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, VoidCallback onTap) {
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

  void _showCitySheet(BuildContext context) {
    final list = cities.isEmpty ? ['不限', '丽江市', '西双版纳', '喀什', '三亚市'] : cities;
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
              child: Text('选择城市', style: AppTextStyles.headlineSmall),
            ),
            ...list.map((c) => ListTile(
                  title: Text(c),
                  trailing: (filters.city == c || (c == '不限' && (filters.city == null || filters.city!.isEmpty))) ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp) : null,
                  onTap: () {
                    onFiltersChanged(filters.copyWith(city: c == '不限' ? null : c));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showPriceSheet(BuildContext context) {
    final options = ['不限', '1000以下', '1000-3000', '3000-5000', '5000以上'];
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
              child: Text('选择价格', style: AppTextStyles.headlineSmall),
            ),
            ...options.map((o) => ListTile(
                  title: Text(o == '不限' ? o : '¥$o'),
                  trailing: _priceMatch(o) ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp) : null,
                  onTap: () {
                    double? min, max;
                    if (o == '1000以下') max = 1000;
                    else if (o == '1000-3000') { min = 1000; max = 3000; }
                    else if (o == '3000-5000') { min = 3000; max = 5000; }
                    else if (o == '5000以上') min = 5000;
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
    if (o == '1000以下') return filters.priceMax == 1000;
    if (o == '1000-3000') return filters.priceMin == 1000 && filters.priceMax == 3000;
    if (o == '3000-5000') return filters.priceMin == 3000 && filters.priceMax == 5000;
    if (o == '5000以上') return filters.priceMin == 5000;
    return false;
  }

  void _showDaysSheet(BuildContext context) {
    final options = ['不限', '1-3天', '4-5天', '6-7天', '8天以上'];
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
              child: Text('选择天数', style: AppTextStyles.headlineSmall),
            ),
            ...options.map((o) => ListTile(
                  title: Text(o),
                  trailing: _daysMatch(o) ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp) : null,
                  onTap: () {
                    int? dMin, dMax;
                    if (o == '1-3天') { dMin = 1; dMax = 3; }
                    else if (o == '4-5天') { dMin = 4; dMax = 5; }
                    else if (o == '6-7天') { dMin = 6; dMax = 7; }
                    else if (o == '8天以上') dMin = 8;
                    onFiltersChanged(filters.copyWith(daysMin: dMin, daysMax: dMax));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  bool _daysMatch(String o) {
    if (o == '不限') return filters.daysMin == null && filters.daysMax == null;
    if (o == '1-3天') return filters.daysMin == 1 && filters.daysMax == 3;
    if (o == '4-5天') return filters.daysMin == 4 && filters.daysMax == 5;
    if (o == '6-7天') return filters.daysMin == 6 && filters.daysMax == 7;
    if (o == '8天以上') return filters.daysMin == 8;
    return false;
  }

  void _showDepartureSheet(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: filters.departureFrom ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) onFiltersChanged(filters.copyWith(departureFrom: picked));
  }

  void _showTypeSheet(BuildContext context) {
    final list = types.isEmpty ? ['不限', '跟团游', '小包团', '自由行'] : types;
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
              child: Text('选择类型', style: AppTextStyles.headlineSmall),
            ),
            ...list.map((t) => ListTile(
                  title: Text(t),
                  trailing: (filters.type == t || (t == '不限' && (filters.type == null || filters.type!.isEmpty))) ? Icon(Icons.check_rounded, color: AppColors.primary, size: 22.sp) : null,
                  onTap: () {
                    onFiltersChanged(filters.copyWith(type: t == '不限' ? null : t));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
