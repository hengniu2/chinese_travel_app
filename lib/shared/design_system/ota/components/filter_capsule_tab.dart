import 'package:flutter/material.dart';

import '../colors.dart';
import '../gradients.dart';
import '../radius.dart';
import '../shadows.dart';
import '../spacing.dart';
import '../typography.dart';

/// Scrollable horizontal filter tabs. Selected tab uses gradient; smooth animation.
/// Stateless; parent controls [selectedIndex] and [onSelected].
class FilterCapsuleTab extends StatelessWidget {
  const FilterCapsuleTab({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.padding,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? EdgeInsets.symmetric(horizontal: OtaSpacing.screenHorizontal, vertical: OtaSpacing.xxs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (index) {
          final selected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: index < labels.length - 1 ? OtaSpacing.xxs : 0),
            child: _FilterCapsule(
              label: labels[index],
              selected: selected,
              onTap: () => onSelected(index),
            ),
          );
        }),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: OtaRadius.pillRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: OtaSpacing.xs, vertical: OtaSpacing.xxs),
          decoration: BoxDecoration(
            gradient: selected ? OtaGradients.selectedTabGradient : null,
            color: selected ? null : OtaColors.tertiaryYellow.withValues(alpha: 0.6),
            borderRadius: OtaRadius.pillRadius,
            boxShadow: selected ? OtaShadows.level1 : null,
          ),
          child: Text(
            label,
            style: OtaTypography.label(selected ? OtaColors.textPrimary : OtaColors.textSecondary).copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
