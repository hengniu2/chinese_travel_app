import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';

/// 陪游筛选条：药丸式 Chips，横向滚动，紧凑
class CompanionListFilterBar extends StatelessWidget {
  const CompanionListFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.labels = const ['全部', '性别', '价格区间', '评分', '距离'],
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<String> labels;

  static const double _pillRadius = 9999;
  static const double _barHeight = 40;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _barHeight.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: labels.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return _PillChip(
            label: labels[i],
            selected: selected,
            onTap: () => onSelected(i),
          );
        },
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CompanionListFilterBar._pillRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(CompanionListFilterBar._pillRadius),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
