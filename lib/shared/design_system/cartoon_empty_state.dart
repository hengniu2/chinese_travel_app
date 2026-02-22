import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tap_scale.dart';

/// Cartoon-style empty state: cute travel mascot, yellow luggage, smiling cloud.
/// Cases: no hotels, no rooms, no internet, loading. Friendly Chinese tone; yellow gradient retry.
enum CartoonEmptyType {
  noHotels,
  noRooms,
  noInternet,
  loading,
}

class CartoonEmptyState extends StatefulWidget {
  const CartoonEmptyState({
    super.key,
    required this.type,
    required this.message,
    this.onRetry,
    this.retryLabel,
    this.padding,
  });

  final CartoonEmptyType type;
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final EdgeInsets? padding;

  @override
  State<CartoonEmptyState> createState() => _CartoonEmptyStateState();
}

class _CartoonEmptyStateState extends State<CartoonEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final padding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 48);

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (_, _) => _CartoonIllustration(
                type: widget.type,
                bounceOffset: 4 * math.sin(_bounceAnimation.value * math.pi),
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.onRetry != null &&
                widget.retryLabel != null &&
                widget.retryLabel!.isNotEmpty &&
                widget.type != CartoonEmptyType.loading) ...[
              const SizedBox(height: 24),
              _YellowGradientButton(
                label: widget.retryLabel!,
                onPressed: widget.onRetry!,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CartoonIllustration extends StatelessWidget {
  const _CartoonIllustration({
    required this.type,
    required this.bounceOffset,
    required this.isDark,
  });

  final CartoonEmptyType type;
  final double bounceOffset;
  final bool isDark;

  Color get _yellow => isDark ? AppColors.darkPrimary : AppColors.primary;
  Color get _yellowDark =>
      isDark ? AppColors.darkPrimary.withValues(alpha: 0.7) : AppColors.primaryDark;
  Color get _mascotSkin =>
      isDark ? const Color(0xFF3D3D3D) : const Color(0xFFFFE0BD);
  Color get _cloudColor =>
      isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Empty state illustration',
      child: SizedBox(
        width: 160,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Smiling cloud (no internet / loading)
            if (type == CartoonEmptyType.noInternet ||
                type == CartoonEmptyType.loading)
              Positioned(
                top: 0,
                child: Transform.translate(
                  offset: Offset(0, bounceOffset * 0.5),
                  child: _SmilingCloud(
                    color: _cloudColor,
                    smileColor: isDark
                        ? AppColors.darkTextSecondary
                        : const Color(0xFF666666),
                  ),
                ),
              ),
            // Mascot + luggage
            Positioned(
              bottom: 8,
              child: Transform.translate(
                offset: Offset(0, bounceOffset),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _TravelMascot(skinColor: _mascotSkin),
                    const SizedBox(width: 8),
                    if (type == CartoonEmptyType.noHotels ||
                        type == CartoonEmptyType.noRooms)
                      _YellowLuggage(yellow: _yellow, yellowDark: _yellowDark),
                  ],
                ),
              ),
            ),
            // Loading: small spinner near mascot
            if (type == CartoonEmptyType.loading)
              Positioned(
                right: 0,
                bottom: 40,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _yellow,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TravelMascot extends StatelessWidget {
  const _TravelMascot({required this.skinColor});

  final Color skinColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 80,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Cap (travel cap)
          Positioned(
            top: 0,
            child: CustomPaint(
              size: const Size(36, 20),
              painter: _CapPainter(skinColor: skinColor),
            ),
          ),
          // Head
          Positioned(
            top: 14,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: skinColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Eyes
                  Positioned(
                    left: 10,
                    top: 14,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 14,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Smile
                  Positioned(
                    bottom: 12,
                    child: CustomPaint(
                      size: const Size(16, 8),
                      painter: _SmilePainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body (oval)
          Positioned(
            bottom: 0,
            child: Container(
              width: 36,
              height: 32,
              decoration: BoxDecoration(
                color: skinColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapPainter extends CustomPainter {
  _CapPainter({required this.skinColor});

  final Color skinColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = skinColor;
    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.9)
      ..lineTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.9, size.height * 0.9)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    _drawSmile(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmileStrokePainter extends CustomPainter {
  _SmileStrokePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    _drawSmile(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawSmile(Canvas canvas, Size size, Paint paint) {
  final path = Path()
    ..moveTo(0, size.height)
    ..quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      size.height,
    );
  canvas.drawPath(path, paint);
}

class _YellowLuggage extends StatelessWidget {
  const _YellowLuggage({required this.yellow, required this.yellowDark});

  final Color yellow;
  final Color yellowDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 36,
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: yellow.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Middle strip (suitcase detail)
          Center(
            child: Container(
              width: 36,
              height: 6,
              decoration: BoxDecoration(
                color: yellowDark,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Wheels
          Positioned(
            left: 10,
            bottom: 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: yellowDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: yellowDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmilingCloud extends StatelessWidget {
  const _SmilingCloud({required this.color, required this.smileColor});

  final Color color;
  final Color smileColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cloud puffs
          Positioned(left: 0, top: 8, child: _cloudPuff(20)),
          Positioned(left: 18, top: 0, child: _cloudPuff(24)),
          Positioned(left: 38, top: 4, child: _cloudPuff(22)),
          Positioned(left: 52, top: 10, child: _cloudPuff(18)),
          // Smile
          Positioned(
            bottom: 6,
            child: CustomPaint(
              size: const Size(28, 12),
              painter: _SmileStrokePainter(color: smileColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cloudPuff(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _YellowGradientButton extends StatelessWidget {
  const _YellowGradientButton({
    required this.label,
    required this.onPressed,
    required this.isDark,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = isDark
        ? [AppColors.darkPrimary, AppColors.darkPrimary.withValues(alpha: 0.85)]
        : [AppColors.primary, AppColors.primaryDark];
    final onPrimary = isDark ? AppColors.darkOnPrimary : Colors.white;

    return AppTapScale(
      onTap: onPressed,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
