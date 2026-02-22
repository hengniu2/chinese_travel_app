import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tap_scale.dart';

/// Data for the premium coupon card (design system level, no domain dependency).
class CouponCardData {
  const CouponCardData({
    required this.discountDisplay,
    required this.isRate,
    this.conditionText = '无门槛',
    required this.expiryText,
    required this.buttonLabel,
    this.onButtonTap,
    this.isDisabled = false,
    this.title,
    this.flashRemaining,
  });

  /// Big value: "30", "10", "9折"
  final String discountDisplay;
  /// If true, no "¥" prefix (e.g. 9折)
  final bool isRate;
  final String conditionText;
  final String expiryText;
  final String buttonLabel;
  final VoidCallback? onButtonTap;
  final bool isDisabled;
  final String? title;
  /// For flash: "剩余 23:45"
  final String? flashRemaining;
}

/// Premium OTA-style coupon card: yellow gradient border, rounded 20, cartoon perforated edge.
/// Use [CouponCardData] for content; build data from [Coupon] in the coupon feature.
class CouponCard extends StatelessWidget {
  const CouponCard({
    super.key,
    required this.data,
    this.borderRadius = 20,
  });

  final CouponCardData data;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderGradient = isDark
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkPrimary,
              AppColors.darkPrimary.withValues(alpha: 0.8),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          );
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.card;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final buttonBg = isDark ? AppColors.darkPrimary : AppColors.primary;
    final buttonFg = isDark ? AppColors.darkOnPrimary : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius + 2),
        child: CustomPaint(
          painter: _PerforatedBorderPainter(
            gradient: borderGradient,
            borderRadius: borderRadius,
            strokeWidth: 3,
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - 1),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LeftDiscountStrip(
                      discountDisplay: data.discountDisplay,
                      isRate: data.isRate,
                      title: data.title,
                      isDisabled: data.isDisabled,
                      isDark: isDark,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.conditionText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: data.isDisabled ? textSecondary : textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            if (data.flashRemaining != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  data.flashRemaining!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.accentWarm,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            Text(
                              data.expiryText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _ClaimButton(
                              label: data.buttonLabel,
                              onTap: data.isDisabled ? null : data.onButtonTap,
                              backgroundColor: buttonBg,
                              foregroundColor: buttonFg,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeftDiscountStrip extends StatelessWidget {
  const _LeftDiscountStrip({
    required this.discountDisplay,
    required this.isRate,
    this.title,
    required this.isDisabled,
    required this.isDark,
  });

  final String discountDisplay;
  final bool isRate;
  final String? title;
  final bool isDisabled;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final stripColor = isDisabled
        ? (isDark ? AppColors.darkBorder : AppColors.textTertiary)
        : (isDark ? AppColors.darkPrimary : AppColors.primary);
    final fg = isDisabled
        ? (isDark ? AppColors.darkTextSecondary : Colors.white70)
        : (isDark ? AppColors.darkOnPrimary : Colors.white);

    return Container(
      width: 108,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: stripColor.withValues(alpha: isDisabled ? 0.6 : 1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(17),
          bottomLeft: Radius.circular(17),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isRate)
            Text(
              '¥',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          Text(
            discountDisplay,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: fg,
              height: 1.1,
            ),
          ),
          if (title != null && title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 11,
                  color: fg.withValues(alpha: 0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({
    required this.label,
    this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: onTap != null ? backgroundColor : backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
    );
    if (onTap != null) {
      return AppTapScale(
        onTap: onTap,
        child: child,
      );
    }
    return child;
  }
}

/// Cartoon perforated edge: dashed border with gradient.
class _PerforatedBorderPainter extends CustomPainter {
  _PerforatedBorderPainter({
    required this.gradient,
    required this.borderRadius,
    this.strokeWidth = 3,
  });

  final Gradient gradient;
  final double borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, path, paint, dashWidth: 6, gap: 4);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint,
      {required double dashWidth, required double gap}) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        if (next > distance) {
          final extractPath = metric.extractPath(distance, next);
          canvas.drawPath(extractPath, paint);
        }
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
