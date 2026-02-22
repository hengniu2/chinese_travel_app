import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';

/// Favorite heart button with bounce on tap and subtle yellow confetti when adding.
class HotelFavoriteButton extends StatefulWidget {
  const HotelFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
  });

  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  State<HotelFavoriteButton> createState() => _HotelFavoriteButtonState();
}

class _HotelFavoriteButtonState extends State<HotelFavoriteButton>
    with SingleTickerProviderStateMixin {
  static const _bounceDuration = Duration(milliseconds: 350);
  static const _curve = Curves.easeInOut;

  late AnimationController _bounceController;
  late Animation<double> _bounceScale;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(duration: _bounceDuration, vsync: this);
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _bounceController, curve: _curve));
  }

  @override
  void didUpdateWidget(HotelFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isFavorite && widget.isFavorite) {
      _bounceController.forward(from: 0);
      _showConfetti();
    }
  }

  void _showConfetti() {
    if (!mounted) return;
    // Defer to next frame so we are not inserting overlay during build/update.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Use root overlay to avoid descendant assertion when widget is under a shell navigator.
      final navigator = Navigator.maybeOf(context, rootNavigator: true);
      final overlay = navigator?.overlay;
      if (overlay == null || !mounted) return;
      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (context) => Material(
          type: MaterialType.transparency,
          child: _ConfettiBurst(
            onComplete: () {
              if (entry.mounted) entry.remove();
            },
          ),
        ),
      );
      overlay.insert(entry);
      Future.delayed(const Duration(milliseconds: 650), () {
        if (entry.mounted) entry.remove();
      });
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedBuilder(
        animation: _bounceScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceScale.value,
            child: child,
          );
        },
        child: Icon(
          widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        ),
      ),
      onPressed: () => widget.onToggle(),
    );
  }
}

/// Subtle yellow confetti burst (premium, not childish).
class _ConfettiBurst extends StatefulWidget {
  const _ConfettiBurst({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _angles;
  late List<double> _sizes;

  static const _particleCount = 12;
  static const _duration = Duration(milliseconds: 600);
  static const _spread = 80.0;

  @override
  void initState() {
    super.initState();
    final r = math.Random();
    _angles = List.generate(_particleCount, (_) => r.nextDouble() * 2 * math.pi);
    _sizes = List.generate(_particleCount, (_) => 3.0 + r.nextDouble() * 4);
    _controller = AnimationController(duration: _duration, vsync: this)
      ..forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(
              progress: _controller.value,
              spread: _spread,
              angles: _angles,
              sizes: _sizes,
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.spread,
    required this.angles,
    required this.sizes,
  });

  final double progress;
  final double spread;
  final List<double> angles;
  final List<double> sizes;

  static Color get _yellow => AppColors.primary;
  static Color get _amber => AppColors.primaryLight;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 60);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    if (opacity <= 0) return;

    for (var i = 0; i < angles.length; i++) {
      final dist = progress * spread * (0.6 + (i % 3) * 0.2);
      final x = center.dx + math.cos(angles[i]) * dist;
      final y = center.dy + math.sin(angles[i]) * dist - progress * 20;
      final particleOpacity = opacity * (1 - progress * 0.5);
      final color = (i % 2 == 0 ? _yellow : _amber).withValues(alpha: particleOpacity);
      canvas.drawCircle(Offset(x, y), sizes[i], Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
