import 'package:flutter/material.dart';

import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../../../shared/design_system/design_system.dart';
import 'companion_theme.dart';

/// Sticky-style section header: bar + icon + title + optional subtitle + "查看更多".
/// Theme-driven bar color.
class CompanionSectionHeader extends StatelessWidget {
  const CompanionSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.barColor,
    this.subtitle,
    this.onSeeMore,
    this.isPinned = false,
    this.theme = CompanionThemeData.defaultTheme,
  });

  final String title;
  final IconData icon;
  final Color? barColor;
  final String? subtitle;
  final VoidCallback? onSeeMore;
  final bool isPinned;
  final CompanionThemeData theme;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final bar = barColor ?? theme.sectionBarColorResolved;
    final content = Padding(
      padding: EdgeInsets.only(
        left: compact ? 12 : 16,
        right: compact ? 12 : 16,
        top: 2,
        bottom: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [bar, bar.withValues(alpha: 0.75)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, size: 18, color: AppColors.textPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 17,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onSeeMore != null)
                AppTapScale(
                  onTap: onSeeMore!,
                  pressedScale: 0.96,
                  useRipple: true,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '查看更多',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.accentWarm,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: AppColors.accentWarm,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: EdgeInsets.only(left: compact ? 27 : 31),
              child: Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isPinned ? AppColors.card : Colors.transparent,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: FadeIn(
        duration: const Duration(milliseconds: 250),
        offsetY: 4,
        child: content,
      ),
    );
  }
}
