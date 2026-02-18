import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// 通用顶部栏（可配置返回、标题、右侧操作）
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.onLeadingTap,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final VoidCallback? onLeadingTap;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.backgroundCard;
    final fg = foregroundColor ?? AppColors.textPrimary;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          (onLeadingTap != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                  onPressed: onLeadingTap,
                )
              : null),
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.headlineSmall.copyWith(color: fg),
                )
              : null),
      actions: actions,
    );
  }
}
