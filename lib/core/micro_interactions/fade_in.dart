import 'package:flutter/material.dart';

import 'luxury_constants.dart';

/// Lightweight fade-in (opacity + optional translate). 250ms, easeInOutCubic.
class FadeIn extends StatefulWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = LuxuryInteractions.duration,
    this.curve = LuxuryInteractions.luxuryCurve,
    this.offsetY = 6,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double offsetY;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _translate = Tween<double>(begin: widget.offsetY, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _translate.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
