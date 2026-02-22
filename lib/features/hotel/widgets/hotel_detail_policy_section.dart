import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_shadow.dart';
import '../data/hotel_model.dart';
import '../theme/hotel_theme.dart';

/// Policy section: check-in/out, reception, cancellation (accordion).
class HotelDetailPolicySection extends StatefulWidget {
  const HotelDetailPolicySection({
    super.key,
    required this.detail,
  });

  final HotelDetail detail;

  @override
  State<HotelDetailPolicySection> createState() =>
      _HotelDetailPolicySectionState();
}

class _HotelDetailPolicySectionState extends State<HotelDetailPolicySection> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final items = <_PolicyItem>[
      if (widget.detail.policyCheckInOut != null)
        _PolicyItem(
          title: '入离时间',
          content: widget.detail.policyCheckInOut!,
          icon: Icons.calendar_today_rounded,
        ),
      if (widget.detail.policyReception != null)
        _PolicyItem(
          title: '接待政策',
          content: widget.detail.policyReception!,
          icon: Icons.people_rounded,
        ),
      _PolicyItem(
        title: '取消规则',
        content: widget.detail.cancellationPolicy,
        icon: Icons.rule_rounded,
      ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: HotelTheme.grid2.h),
          child: Text(
            '酒店政策',
            style: AppTextStyles.headlineSmall
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        ...List.generate(items.length, (i) {
          final item = items[i];
          final expanded = _expandedIndex == i;
          return _PolicyTile(
            title: item.title,
            content: item.content,
            icon: item.icon,
            expanded: expanded,
            onTap: () =>
                setState(() => _expandedIndex = expanded ? null : i),
          );
        }),
      ],
    );
  }
}

class _PolicyItem {
  const _PolicyItem({
    required this.title,
    required this.content,
    required this.icon,
  });
  final String title;
  final String content;
  final IconData icon;
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({
    required this.title,
    required this.content,
    required this.icon,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final String content;
  final IconData icon;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: HotelTheme.grid2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(HotelTheme.imageRadius),
        boxShadow: isDark ? null : AppShadow.light,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20.sp, color: AppColors.primary),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24.sp,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(top: 12.h, left: 30.w),
                    child: Text(
                      content,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 220),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
