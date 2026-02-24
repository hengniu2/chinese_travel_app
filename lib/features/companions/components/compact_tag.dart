import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';

/// Type of compact tag for theme-driven styling.
enum CompactTagType {
  urgency,
  fastResponse,
  trending,
  trustPlatform,
  trustVerified,
  level,
  senior,
  discountLimited,
  discountToday,
  groupDiscount,
  hot,
}

/// Reusable compact tag. Theme-driven; optional icon + label.
class CompactTag extends StatelessWidget {
  const CompactTag({
    super.key,
    required this.type,
    this.label,
    this.value,
    this.compact = false,
  });

  /// Tag type drives color and default label.
  final CompactTagType type;
  /// Override label (e.g. "今日仅剩2个名额" for urgency with value 2).
  final String? label;
  /// Used by some types (e.g. urgency = spots left, fastResponse = minutes).
  final int? value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (String text, IconData? icon, Color color) = _resolve();
    final isTrust = type == CompactTagType.trustPlatform || type == CompactTagType.trustVerified;
    final fontSize = compact ? 9.0 : (isTrust ? 11.0 : 10.0);
    final iconSize = compact ? 9.0 : (isTrust ? 12.0 : 10.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : (isTrust ? 7 : 6),
        vertical: compact ? 1 : (isTrust ? 3 : 2),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isTrust ? 0.14 : 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: isTrust ? 0.4 : 0.35), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            SizedBox(width: compact ? 2 : 3),
          ],
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  (String, IconData?, Color) _resolve() {
    switch (type) {
      case CompactTagType.urgency:
        return (
          label ?? '今日仅剩${value ?? 0}个名额',
          Icons.schedule_rounded,
          AppColors.price,
        );
      case CompactTagType.fastResponse:
        return (
          label ?? '平均${value ?? 5}分钟回复',
          Icons.speed_rounded,
          AppColors.success,
        );
      case CompactTagType.trending:
        return (
          label ?? '人气飙升',
          Icons.trending_up_rounded,
          AppColors.accentWarm,
        );
      case CompactTagType.trustPlatform:
        return ('平台保障', Icons.shield_rounded, AppColors.primaryDark);
      case CompactTagType.trustVerified:
        return ('已实名认证', Icons.verified_user_rounded, Color(0xFF1890FF));
      case CompactTagType.level:
        return (
          label ?? 'LV${value ?? 1}',
          null,
          AppColors.textSecondary,
        );
      case CompactTagType.senior:
        return (label ?? '资深', null, AppColors.accentGold);
      case CompactTagType.discountLimited:
        return ('限时优惠', null, AppColors.price);
      case CompactTagType.discountToday:
        return ('今日特价', null, AppColors.accentWarm);
      case CompactTagType.groupDiscount:
        return ('拼单优惠', null, AppColors.primary);
      case CompactTagType.hot:
        return ('热门', null, AppColors.price);
    }
  }
}
