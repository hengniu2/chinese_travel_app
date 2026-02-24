import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Capsule segmented control for Personal / Team mode.
/// Active: lime gradient + soft inner shadow. Inactive: light grey surface.
/// Sliding animation, radius 14, compact with icons.
class PersonalTeamToggle extends StatelessWidget {
  const PersonalTeamToggle({
    super.key,
    required this.isPersonal,
    required this.onChanged,
    this.personalLabel = '个人定制',
    this.teamLabel = '团队定制',
  });

  /// true = Personal (个人定制), false = Team (团队定制)
  final bool isPersonal;
  final ValueChanged<bool> onChanged;

  final String personalLabel;
  final String teamLabel;

  static const double _radius = 14;
  static const double _padding = 3;
  static const double _height = 36;

  static const Color _inactiveBg = Color(0xFFE8EAED);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final halfWidth = (width - _padding * 2) / 2;

        return Container(
          height: _height + _padding * 2,
          padding: const EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            color: _inactiveBg,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _padding + (isPersonal ? 0 : halfWidth),
                top: _padding,
                child: _ActiveIndicator(width: halfWidth, height: _height),
              ),
              Row(
                children: [
                  Expanded(
                    child: _ToggleTab(
                      icon: Icons.person_outline_rounded,
                      label: personalLabel,
                      selected: isPersonal,
                      onTap: () => onChanged(true),
                    ),
                  ),
                  Expanded(
                    child: _ToggleTab(
                      icon: Icons.groups_outlined,
                      label: teamLabel,
                      selected: !isPersonal,
                      onTap: () => onChanged(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActiveIndicator extends StatelessWidget {
  const _ActiveIndicator({required this.width, required this.height});

  final double width;
  final double height;

  static const Color _limeStart = Color(0xFFD4EE9E);
  static const Color _limeEnd = Color(0xFFB8E06C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_limeStart, _limeEnd],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.6),
            offset: const Offset(0, -1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? AppColors.textPrimary : AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? AppColors.textPrimary : AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
