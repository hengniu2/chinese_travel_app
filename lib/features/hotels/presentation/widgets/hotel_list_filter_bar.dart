import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/design_system/app_shadow.dart';
import 'hotel_ui_constants.dart';

/// Premium filter bar: sliding highlight pill, 8px grid, glass-style surface.
class HotelListFilterBar extends StatefulWidget {
  const HotelListFilterBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<HotelListFilterBar> createState() => _HotelListFilterBarState();
}

class _HotelListFilterBarState extends State<HotelListFilterBar>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 280);
  static const _curve = Curves.easeInOut;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _duration, vsync: this);
    _animation = Tween<double>(begin: widget.selectedIndex.toDouble(), end: widget.selectedIndex.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: _curve));
  }

  @override
  void didUpdateWidget(HotelListFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _animation = Tween<double>(
        begin: oldWidget.selectedIndex.toDouble(),
        end: widget.selectedIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: _curve));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: HotelUIConstants.grid2.h, horizontal: HotelUIConstants.grid2.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: AppShadow.light,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = widget.labels.length;
          final segmentWidth = constraints.maxWidth / count;
          final pillWidth = segmentWidth - HotelUIConstants.grid2.w;
          final pillLeft = HotelUIConstants.grid1.w;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final left = pillLeft + (_animation.value * segmentWidth) + (segmentWidth - pillWidth) / 2;
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: left,
                    child: Container(
                      width: pillWidth,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryDark, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(count, (index) {
                      final selected = index == widget.selectedIndex;
                      return Expanded(
                        child: Semantics(
                          button: true,
                          selected: selected,
                          label: widget.labels[index],
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.onSelected(index),
                              borderRadius: BorderRadius.circular(9999),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: HotelUIConstants.grid2.h,
                                  horizontal: HotelUIConstants.grid1.w,
                                ),
                                child: Text(
                                  widget.labels[index],
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
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
