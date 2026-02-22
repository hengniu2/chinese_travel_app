import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_shadow.dart';
import '../theme/hotel_theme.dart';

/// Horizontal filter bar (sort, star, price, etc.).
class HotelFilterBar extends StatelessWidget {
  const HotelFilterBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: HotelTheme.grid2.h, horizontal: HotelTheme.grid2.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: AppShadow.light,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(labels.length, (index) {
            final selected = index == selectedIndex;
            return Padding(
              padding: EdgeInsets.only(
                  right: index < labels.length - 1 ? HotelTheme.grid2.w : 0),
              child: _FilterCapsule(
                label: labels[index],
                selected: selected,
                onTap: () => onSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _FilterCapsule extends StatelessWidget {
  const _FilterCapsule({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9999),
          child: AnimatedContainer(
            duration: HotelTheme.animationFast,
            curve: HotelTheme.animationCurve,
            padding: EdgeInsets.symmetric(
                horizontal: HotelTheme.grid2.w, vertical: HotelTheme.grid2.h),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryDark,
                        AppColors.primary,
                      ],
                    )
                  : null,
              color: selected
                  ? null
                  : (theme.brightness == Brightness.dark
                      ? theme.colorScheme.surface.withValues(alpha: 0.6)
                      : AppColors.surface),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: selected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
