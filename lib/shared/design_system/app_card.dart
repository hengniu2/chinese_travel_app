import 'package:flutter/material.dart';

import '../../core/micro_interactions/luxury_constants.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadow.dart';
import 'app_spacing.dart';

/// 统一卡片：点击时上浮 4px（luxury curve），可选悬停上浮。
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
    /// 桌面/Web 悬停时轻微上浮（lift）
    this.enableHover = false,
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
  final bool enableHover;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressLift;
  late AnimationController _hoverController;
  late Animation<double> _hoverTranslate;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: LuxuryInteractions.duration,
      vsync: this,
    );
    _pressLift = Tween<double>(begin: 0, end: -LuxuryInteractions.cardLiftPx).animate(
      CurvedAnimation(parent: _pressController, curve: LuxuryInteractions.luxuryCurve),
    );
    _hoverController = AnimationController(
      duration: LuxuryInteractions.duration,
      vsync: this,
    );
    _hoverTranslate = Tween<double>(begin: 0, end: -LuxuryInteractions.cardLiftPx).animate(
      CurvedAnimation(parent: _hoverController, curve: LuxuryInteractions.luxuryCurve),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  List<BoxShadow>? get _effectiveShadow {
    if (widget.boxShadow != null) return widget.boxShadow;
    if (!widget.elevated) return null;
    final isHovered = widget.enableHover && _hoverController.value > 0;
    final isPressed = widget.animateTap && widget.onTap != null && _pressController.value > 0;
    if (isHovered || isPressed) return AppShadow.cardHover;
    return AppShadow.cardElevated;
  }

  double get _liftY {
    final pressLift = (widget.animateTap && widget.onTap != null) ? _pressLift.value : 0.0;
    final hoverLift = widget.enableHover ? _hoverTranslate.value : 0.0;
    return pressLift != 0 ? pressLift : hoverLift;
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
      final hasHoverOrPress = widget.animateTap || widget.enableHover;
      final child = hasHoverOrPress
          ? AnimatedBuilder(
              animation: Listenable.merge([_pressController, _hoverController]),
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _liftY),
                child: _buildContent(),
              ),
            )
          : content;
      content = Listener(
        onPointerDown: widget.animateTap ? (_) => _pressController.forward() : null,
        onPointerUp: widget.animateTap ? (_) => _pressController.reverse() : null,
        onPointerCancel: widget.animateTap ? (_) => _pressController.reverse() : null,
        child: widget.enableHover
            ? MouseRegion(
                onEnter: (_) => _hoverController.forward(),
                onExit: (_) => _hoverController.reverse(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: AppRadius.cardRadius,
                    child: child,
                  ),
                ),
              )
            : Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: AppRadius.cardRadius,
                  child: child,
                ),
              ),
      );
    } else if (widget.enableHover) {
      content = MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _hoverTranslate.value),
            child: _buildContent(),
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
