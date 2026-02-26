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

/// 统一按钮（主/次/禁用）+ 点击缩放反馈
class AppButton extends StatefulWidget {
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
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final AppButtonVariant variant;
  /// 覆盖主按钮背景（如登录/注册用深绿）
  final Color? backgroundColor;
  /// 覆盖主按钮文字/图标色
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? iconTrailing;
  final bool loading;
  final double minHeight;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _enabled =>
      !widget.loading &&
      (widget.variant != AppButtonVariant.disabled) &&
      widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = _enabled ? widget.onPressed : null;
    final (backgroundColor, foregroundColor, border) = _resolveColors();

    final child = widget.loading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.variant == AppButtonVariant.primary
                    ? foregroundColor
                    : AppColors.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                SizedBox(width: AppSpacing.sm),
              ],
              Text(
                widget.label,
                style: widget.variant == AppButtonVariant.primary
                    ? AppTextStyles.button.copyWith(color: foregroundColor)
                    : AppTextStyles.buttonSecondary.copyWith(color: foregroundColor),
              ),
              if (widget.iconTrailing != null) ...[
                SizedBox(width: AppSpacing.sm),
                widget.iconTrailing!,
              ],
            ],
          );

    final content = Container(
      constraints: BoxConstraints(minHeight: widget.minHeight),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.buttonRadius,
        border: border != null ? Border.all(color: border, width: 1.5) : null,
        boxShadow: widget.variant == AppButtonVariant.primary && _enabled
            ? AppShadow.floating
            : null,
      ),
      child: child,
    );

    final button = Material(
      color: Colors.transparent,
      borderRadius: AppRadius.buttonRadius,
      child: Listener(
        onPointerDown: _enabled ? (_) => _controller.forward() : null,
        onPointerUp: _enabled ? (_) => _controller.reverse() : null,
        onPointerCancel: _enabled ? (_) => _controller.reverse() : null,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, c) => Transform.scale(scale: _scale.value, child: c),
          child: InkWell(
            onTap: effectiveOnPressed,
            borderRadius: AppRadius.buttonRadius,
            child: content,
          ),
        ),
      ),
    );

    if (widget.expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  (Color, Color, Color?) _resolveColors() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        final bg = widget.backgroundColor ?? (_enabled ? AppColors.primary : AppColors.primaryPale);
        final fg = widget.foregroundColor ?? Colors.white;
        return (bg, fg, null);
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
