import 'package:flutter/material.dart';

import '../../core/micro_interactions/luxury_constants.dart';

/// Luxury tap: buttons 0.96 scale; cards use [cardStyleTap] for 4px lift on tap.
class AppTapScale extends StatefulWidget {
  const AppTapScale({
    super.key,
    required this.child,
    this.onTap,
    this.enableHover = false,
    this.useRipple = false,
    /// When true, press does 4px lift (no scale). Use for cards.
    this.cardStyleTap = false,
    this.pressedScale = LuxuryInteractions.buttonPressedScale,
    this.hoverLift = LuxuryInteractions.cardLiftPx,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool useRipple;
  final bool cardStyleTap;
  final double pressedScale;
  final double hoverLift;
  final BorderRadius? borderRadius;

  static const Duration _duration = LuxuryInteractions.duration;
  static const Curve _curve = LuxuryInteractions.luxuryCurve;

  @override
  State<AppTapScale> createState() => _AppTapScaleState();
}

class _AppTapScaleState extends State<AppTapScale>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScale;
  late Animation<double> _pressLift;
  late AnimationController _hoverController;
  late Animation<double> _hoverScale;
  late Animation<double> _hoverTranslate;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: AppTapScale._duration,
      vsync: this,
    );
    _pressScale = Tween<double>(begin: 1, end: widget.pressedScale).animate(
      CurvedAnimation(parent: _pressController, curve: AppTapScale._curve),
    );
    _pressLift = Tween<double>(begin: 0, end: -widget.hoverLift).animate(
      CurvedAnimation(parent: _pressController, curve: AppTapScale._curve),
    );
    _hoverController = AnimationController(
      duration: AppTapScale._duration,
      vsync: this,
    );
    _hoverScale = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: AppTapScale._curve),
    );
    _hoverTranslate = Tween<double>(begin: 0, end: -widget.hoverLift).animate(
      CurvedAnimation(parent: _hoverController, curve: AppTapScale._curve),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    if (widget.onTap != null) {
      if (widget.useRipple) {
        content = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            splashColor: Colors.black.withValues(alpha: 0.06),
            highlightColor: Colors.black.withValues(alpha: 0.04),
            child: content,
          ),
        );
      } else {
        content = GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: content,
        );
      }
    }

    content = Listener(
      onPointerDown: (_) => _pressController.forward(),
      onPointerUp: (_) => _pressController.reverse(),
      onPointerCancel: (_) => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, _hoverController]),
        builder: (_, c) {
          final pressScale = widget.cardStyleTap ? 1.0 : _pressScale.value;
          final pressLift = widget.cardStyleTap ? _pressLift.value : 0.0;
          final hoverScale = (widget.enableHover && !widget.cardStyleTap) ? _hoverScale.value : 1.0;
          final hoverDy = widget.enableHover ? _hoverTranslate.value : 0.0;
          return Transform.translate(
            offset: Offset(0, hoverDy + pressLift),
            child: Transform.scale(
              scale: pressScale * hoverScale,
              alignment: Alignment.center,
              child: c,
            ),
          );
        },
        child: widget.enableHover
            ? MouseRegion(
                onEnter: (_) => _hoverController.forward(),
                onExit: (_) => _hoverController.reverse(),
                child: content,
              )
            : content,
      ),
    );
    return content;
  }
}
