import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadow.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// 按钮变体
enum AppButtonVariant {
  /// 主按钮（绿色填充）
  primary,
  /// 次按钮（描边/白底）
  secondary,
  /// 禁用
  disabled,
}

/// 统一按钮（主/次/禁用）
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.onPressed,
    this.icon,
    this.iconTrailing,
    this.loading = false,
    this.minHeight = 48,
    this.expand = true,
  });

  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? iconTrailing;
  final bool loading;
  final double minHeight;
  final bool expand;

  bool get _enabled => !loading && (variant != AppButtonVariant.disabled) && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = _enabled ? onPressed : null;

    final (backgroundColor, foregroundColor, border) = _resolveColors();

    final child = loading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary ? Colors.white : AppColors.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: variant == AppButtonVariant.primary
                    ? AppTextStyles.button.copyWith(color: foregroundColor)
                    : AppTextStyles.buttonSecondary.copyWith(color: foregroundColor),
              ),
              if (iconTrailing != null) ...[
                SizedBox(width: AppSpacing.sm),
                iconTrailing!,
              ],
            ],
          );

    final button = Material(
      color: backgroundColor,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: effectiveOnPressed,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: border != null ? Border.all(color: border, width: 1.5) : null,
            boxShadow: variant == AppButtonVariant.primary && _enabled ? AppShadow.light : null,
          ),
          child: child,
        ),
      ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  (Color, Color, Color?) _resolveColors() {
    switch (variant) {
      case AppButtonVariant.primary:
        return (
          _enabled ? AppColors.primary : AppColors.primaryLight2,
          Colors.white,
          null,
        );
      case AppButtonVariant.secondary:
        return (
          Colors.white,
          _enabled ? AppColors.primary : AppColors.textTertiary,
          _enabled ? AppColors.primary : AppColors.border,
        );
      case AppButtonVariant.disabled:
        return (
          AppColors.surface,
          AppColors.textTertiary,
          AppColors.border,
        );
    }
  }
}
