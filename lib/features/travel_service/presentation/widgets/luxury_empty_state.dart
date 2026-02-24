import 'package:flutter/material.dart';

import '../../theme/luxury_travel_theme.dart';

/// Luxury empty state: minimal line illustration, calm copy, gold accent underline, optional CTA.
/// Use for no-results (e.g. flights), empty lists. Calm, premium tone — not playful.
class LuxuryEmptyState extends StatelessWidget {
  const LuxuryEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.illustration,
    this.ctaLabel,
    this.onCtaTap,
    this.padding,
  });

  /// Main line (e.g. "暂无匹配航班"). Shown with gold underline.
  final String title;

  /// Calm hint (e.g. "请调整筛选条件").
  final String? subtitle;

  /// Optional custom illustration. If null, uses [LuxuryEmptyIllustration].
  final Widget? illustration;

  /// Optional CTA button label.
  final String? ctaLabel;

  /// Optional CTA callback.
  final VoidCallback? onCtaTap;

  final EdgeInsetsGeometry? padding;

  /// Preset for no matching flights. Title + subtitle + optional "调整筛选" CTA.
  factory LuxuryEmptyState.flightNoResults({
    Key? key,
    String title = '暂无匹配航班',
    String subtitle = '请调整筛选条件',
    String? ctaLabel,
    VoidCallback? onCtaTap,
    EdgeInsetsGeometry? padding,
  }) {
    return LuxuryEmptyState(
      key: key,
      title: title,
      subtitle: subtitle,
      ctaLabel: ctaLabel,
      onCtaTap: onCtaTap,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null)
              illustration!
            else
              const LuxuryEmptyIllustration(),
            const SizedBox(height: 32),
            _TitleWithUnderline(title: title),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.textTertiary).copyWith(
                  height: 1.55,
                ),
              ),
            ],
            if (ctaLabel != null && onCtaTap != null) ...[
              const SizedBox(height: 28),
              _LuxuryEmptyCta(
                label: ctaLabel!,
                onPressed: onCtaTap!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Gold accent underline under the title.
class _TitleWithUnderline extends StatelessWidget {
  const _TitleWithUnderline({required this.title});

  final String title;

  static const double _underlineHeight = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 72,
          height: _underlineHeight,
          decoration: const BoxDecoration(
            color: LuxuryTravelTheme.primaryGold,
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
      ],
    );
  }
}

/// Outlined gold CTA. Calm, not loud.
class _LuxuryEmptyCta extends StatelessWidget {
  const _LuxuryEmptyCta({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: LuxuryTravelTheme.primaryGold,
        side: const BorderSide(color: LuxuryTravelTheme.primaryGold, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: LuxuryTravelTheme.buttonLabel(LuxuryTravelTheme.primaryGold).copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Minimal line illustration: thin strokes, single color. Calm, premium.
class LuxuryEmptyIllustration extends StatelessWidget {
  const LuxuryEmptyIllustration({
    super.key,
    this.size = 80,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MinimalLineIllustrationPainter(
          color: color ?? LuxuryTravelTheme.textTertiary.withValues(alpha: 0.6),
          strokeWidth: 1.2,
        ),
        size: Size(size, size),
      ),
    );
  }
}

/// Draws a minimal "empty search / no results" motif: soft horizon line and a simple shape (e.g. magnifier or doc).
class _MinimalLineIllustrationPainter extends CustomPainter {
  _MinimalLineIllustrationPainter({
    required this.color,
    this.strokeWidth = 1.2,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width * 0.5;
    final cy = size.height * 0.45;
    final r = size.width * 0.22;

    // Minimal magnifier circle (search / no results)
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Handle
    final handleStart = Offset(cx + r * 0.7, cy + r * 0.7);
    final handleEnd = Offset(cx + r * 1.6, cy + r * 1.6);
    canvas.drawLine(handleStart, handleEnd, paint);

    // Calm horizontal line below (ground / horizon)
    final lineY = size.height * 0.82;
    final lineMargin = size.width * 0.15;
    canvas.drawLine(
      Offset(lineMargin, lineY),
      Offset(size.width - lineMargin, lineY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MinimalLineIllustrationPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
