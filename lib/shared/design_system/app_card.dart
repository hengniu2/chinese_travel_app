import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadow.dart';
import 'app_spacing.dart';

/// 统一卡片（立体阴影 + 可选点击动效）
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.border,
    this.elevated = true,
    this.boxShadow,
    this.animateTap = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;
  final bool elevated;
  /// 自定义阴影；为 null 时由 elevated 决定（true 用 cardElevated，false 无阴影）
  final List<BoxShadow>? boxShadow;
  final bool animateTap;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<BoxShadow>? get _effectiveShadow {
    if (widget.boxShadow != null) return widget.boxShadow;
    if (!widget.elevated) return null;
    if (widget.animateTap && widget.onTap != null && _controller.value > 0) {
      return AppShadow.cardHover;
    }
    return AppShadow.cardElevated;
  }

  Widget _buildContent() {
    return Container(
      padding: widget.padding ?? AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: widget.color ?? AppColors.backgroundCard,
        borderRadius: AppRadius.cardRadius,
        border: widget.border,
        boxShadow: _effectiveShadow,
      ),
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent();

    if (widget.onTap != null) {
      final child = widget.animateTap
          ? AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Transform.scale(
                scale: _scale.value,
                child: _buildContent(),
              ),
            )
          : content;
      content = Listener(
        onPointerDown: widget.animateTap ? (_) => _controller.forward() : null,
        onPointerUp: widget.animateTap ? (_) => _controller.reverse() : null,
        onPointerCancel: widget.animateTap ? (_) => _controller.reverse() : null,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.cardRadius,
            child: child,
          ),
        ),
      );
    }

    if (widget.margin != null) {
      return Padding(padding: widget.margin!, child: content);
    }
    return content;
  }
}
