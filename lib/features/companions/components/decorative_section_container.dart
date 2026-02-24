import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';

/// Decorative section container: tint background, optional border, soft shapes.
/// Easy to extend with more decoration (e.g. pattern, icon).
class DecorativeSectionContainer extends StatelessWidget {
  const DecorativeSectionContainer({
    super.key,
    required this.child,
    required this.tintColor,
    this.accentColor,
    this.borderRadius = 14,
    this.margin,
    this.decorationPainter,
  });

  final Widget child;
  final Color tintColor;
  final Color? accentColor;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final CustomPainter? decorationPainter;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? tintColor;
    final compact = MediaQuery.sizeOf(context).width < 360;
    final marginResolved = margin ??
        EdgeInsets.only(
          left: compact ? 10 : 12,
          right: compact ? 10 : 12,
          bottom: 4,
        );

    return Container(
      margin: marginResolved,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: tintColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1),
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            if (decorationPainter != null)
              Positioned.fill(
                child: CustomPaint(
                  painter: decorationPainter,
                ),
              )
            else
              Positioned.fill(
                child: CustomPaint(
                  painter: _DefaultShapesPainter(accentColor: accent),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}

class _DefaultShapesPainter extends CustomPainter {
  _DefaultShapesPainter({required this.accentColor});
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width - 30, 40), 36, paint);
    canvas.drawCircle(Offset(24, size.height - 30), 28, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
