import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';
import '../models/companion_list_item.dart';
import 'companion_theme.dart';

/// Enum-based ranking badge. Visible ranking for Chinese users; theme-driven colors.
class RankingBadge extends StatelessWidget {
  const RankingBadge({
    super.key,
    required this.badge,
    this.theme = CompanionThemeData.defaultTheme,
    this.fontSize = 9,
    this.iconSize = 10,
  });

  final CompanionRankBadge badge;
  final CompanionThemeData theme;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    switch (badge) {
      case CompanionRankBadge.top1Percent:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            gradient: theme.badgeTop1PercentGradient ??
                CompanionThemeData.defaultTheme.badgeTop1PercentGradient,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB8860B).withValues(alpha: 0.5),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            _label(badge),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
          ),
        );
      case CompanionRankBadge.cityPreferred:
        return _buildOutlined(
          _label(badge),
          theme.badgeCityPreferredColor ?? AppColors.accentCool,
          null,
        );
      case CompanionRankBadge.highPopularity:
        return _buildOutlined(
          _label(badge),
          theme.badgeHighPopularityColor ?? AppColors.accentWarm,
          null,
        );
      case CompanionRankBadge.verified:
        return _buildOutlined(
          _label(badge),
          theme.badgeVerifiedColor ?? AppColors.accentCool,
          Icons.verified_rounded,
        );
    }
  }

  Widget _buildOutlined(String label, Color color, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: icon != null ? 0.12 : 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withValues(alpha: icon != null ? 0.3 : 0.4),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            const SizedBox(width: 1),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  static String _label(CompanionRankBadge b) {
    return switch (b) {
      CompanionRankBadge.top1Percent => 'Top 1%',
      CompanionRankBadge.cityPreferred => '城市优选',
      CompanionRankBadge.highPopularity => '高人气',
      CompanionRankBadge.verified => '认证',
    };
  }
}
