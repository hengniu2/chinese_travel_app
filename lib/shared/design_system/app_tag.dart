import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

/// 标签样式
enum AppTagStyle {
  /// 主色填充
  primary,
  /// 主色浅底
  primaryLight,
  /// 灰色
  default_,
  /// 价格/热门红
  hot,
}

/// 统一标签
class AppTag extends StatelessWidget {
  const AppTag({
    super.key,
    required this.label,
    this.style = AppTagStyle.primaryLight,
    this.icon,
    this.padding,
  });

  final String label;
  final AppTagStyle style;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _resolveColors();
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: style == AppTagStyle.primary ? 10 : 8,
          vertical: 4,
        );

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _resolveColors() {
    switch (style) {
      case AppTagStyle.primary:
        return (AppColors.primary, Colors.white);
      case AppTagStyle.primaryLight:
        return (AppColors.primaryLight, AppColors.primary);
      case AppTagStyle.default_:
        return (AppColors.surface, AppColors.textSecondary);
      case AppTagStyle.hot:
        return (AppColors.tagHot.withValues(alpha: 0.12), AppColors.tagHot);
    }
  }
}
