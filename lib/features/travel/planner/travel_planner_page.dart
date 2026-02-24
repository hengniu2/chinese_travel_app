import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../data/travel_assets.dart';
import '../models/planner_request.dart';
import '../services/planner_service.dart';
import '../state/state.dart';

/// Compact radius for Xiaohongshu/Mafengwo-style UI (max 6–8).
const double _kSectionPaddingH = 14;
const double _kSectionGap = 0;
const double _kMainCardRadius = 8;
const double _kMainCardPadding = 14;
const double _kHeaderBottomRadius = 2;

/// Smart planner form — sliver-based scroll, sticky sections, layered cards.
class TravelPlannerPage extends ConsumerStatefulWidget {
  const TravelPlannerPage({super.key});

  @override
  ConsumerState<TravelPlannerPage> createState() => _TravelPlannerPageState();
}

class _TravelPlannerPageState extends ConsumerState<TravelPlannerPage> {
  bool _themesExpanded = false;
  bool _hotRecsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(plannerFormStateProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFCF8),
              Color(0xFFF5F7F5),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, l10n),
            SliverToBoxAdapter(child: SizedBox(height: _kSectionGap)),
            _buildMainPlannerCard(
              context,
              ref,
              formState,
              l10n,
              theme,
              _themesExpanded,
              _hotRecsExpanded,
              () => setState(() => _themesExpanded = !_themesExpanded),
              () => setState(() => _hotRecsExpanded = !_hotRecsExpanded),
            ),
            if (formState.submitError != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(_kSectionPaddingH, 0, _kSectionPaddingH, 12),
                  child: Text(
                    formState.submitError!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.error,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  static const double _kHeaderHeight = 160;

  Widget _buildSliverAppBar(BuildContext context, AppLocalizations l10n) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerRadius = BorderRadius.only(
      bottomLeft: Radius.circular(_kHeaderBottomRadius),
      bottomRight: Radius.circular(_kHeaderBottomRadius),
    );
    return SliverToBoxAdapter(
      child: Container(
        height: _kHeaderHeight + topPadding,
        decoration: BoxDecoration(
          borderRadius: headerRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: headerRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  kPlannerHeaderImageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE8F0E0),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.2),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                            onPressed: () => context.pop(),
                            color: AppColors.textPrimary,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.9),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.plannerFormCta,
                              style: AppTextStyles.headlineLarge.copyWith(
                                fontSize: 24,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainPlannerCard(
    BuildContext context,
    WidgetRef ref,
    dynamic formState,
    AppLocalizations l10n,
    ThemeData theme,
    bool themesExpanded,
    bool hotRecsExpanded,
    VoidCallback onThemesToggle,
    VoidCallback onHotRecsToggle,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _kSectionPaddingH),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_kMainCardRadius),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF6),
              borderRadius: BorderRadius.circular(_kMainCardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  offset: const Offset(0, 6),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _PlannerCardTopAccent(),
                Padding(
                  padding: EdgeInsets.all(_kMainCardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSectionBlock(
                        child: _buildSummaryContent(formState.request, l10n),
                        tint: const Color(0xFFFDFEF9),
                        elevation: 0.5,
                      ),
                      _PlannerCardDivider(),
                      _buildSectionBlock(
                        title: '出行信息',
                        theme: theme,
                        child: _buildTripDetailsContent(formState.request, l10n),
                        tint: const Color(0xFFF9FCF9),
                        elevation: 0.3,
                      ),
                      _PlannerCardDivider(),
                      _buildSectionBlock(
                        title: '预算与主题',
                        theme: theme,
                        child: _buildBudgetThemesContent(
                          formState.request,
                          l10n,
                          themesExpanded,
                          onThemesToggle,
                        ),
                        tint: const Color(0xFFF7FBF8),
                        elevation: 0.4,
                      ),
                      _PlannerCardDivider(),
                      _buildSectionBlock(
                        title: '热门推荐',
                        theme: theme,
                        child: _buildHotRecommendationsContent(
                          l10n,
                          hotRecsExpanded,
                          onHotRecsToggle,
                        ),
                        tint: const Color(0xFFFCFDF9),
                        elevation: 0.3,
                      ),
                      _PlannerCardDivider(),
                      _buildCtaContent(context, ref, formState, l10n),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionBlock({
    String? title,
    ThemeData? theme,
    required Widget child,
    required Color tint,
    double elevation = 0.3,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03 * elevation),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null && theme != null) ...[
            Text(
              title,
              style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryContent(PlannerRequest request, AppLocalizations l10n) {
    final dest = request.destination ?? '—';
    final dep = request.departureCity ?? '—';
    final travelers = request.travelers?.toString() ?? '—';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _summaryRow(Icons.place_outlined, dest),
        SizedBox(height: _kSectionGap - 2),
        _summaryRow(Icons.flight_takeoff_rounded, dep),
        SizedBox(height: _kSectionGap - 2),
        _summaryRow(Icons.people_outline_rounded, '$travelers ${l10n.plannerFormTravelers}'),
      ],
    );
  }

  Widget _summaryRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TravelTypography.content(AppColors.textPrimary, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetailsContent(PlannerRequest request, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _detailRow(l10n.plannerFormDestination, request.destination ?? l10n.plannerFormDestinationHint),
        _sectionDivider(),
        _detailRow(l10n.plannerFormDeparture, request.departureCity ?? l10n.plannerFormDepartureHint),
        _sectionDivider(),
        _detailRow(
          l10n.plannerFormDateRange,
          request.dates != null
              ? '${request.dates!.start.toString().substring(0, 10)} — ${request.dates!.end.toString().substring(0, 10)}'
              : l10n.plannerFormDateRangeHint,
        ),
        _sectionDivider(),
        _detailRow(l10n.plannerFormTravelers, request.travelers?.toString() ?? l10n.plannerFormTravelersHint),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: TravelTypography.hint(AppColors.textTertiary, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TravelTypography.content(AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetThemesContent(
    PlannerRequest request,
    AppLocalizations l10n,
    bool themesExpanded,
    VoidCallback onViewMore,
  ) {
    const themeOptions = ['文化', '自然', '探险', '美食', '亲子', '摄影', '古镇', '海岛'];
    final selectedThemes = request.themes;
    final showAllThemes = themesExpanded || themeOptions.length <= 6;
    final showViewMoreButton = themeOptions.length > 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (request.budgetRange != null) ...[
          Text(
            '¥${request.budgetRange!.min?.toStringAsFixed(0) ?? '—'} — ¥${request.budgetRange!.max?.toStringAsFixed(0) ?? '—'}',
            style: TravelTypography.content(AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          l10n.plannerFormThemes,
          style: TravelTypography.hint(AppColors.textTertiary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: themeOptions.take(showAllThemes ? themeOptions.length : 6).map((t) {
            final selected = selectedThemes.contains(t);
            return TravelFilterChip(
              label: t,
              selected: selected,
              onTap: () {},
            );
          }).toList(),
        ),
        if (showViewMoreButton) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onViewMore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              themesExpanded ? '收起' : l10n.plannerViewMore,
              style: TravelTypography.label(TravelDesignTokens.primary, fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHotRecommendationsContent(
    AppLocalizations l10n,
    bool expanded,
    VoidCallback onViewMore,
  ) {
    const allItems = [
      ('杭州西湖', '2天1晚 · ¥699起'),
      ('成都美食', '3天2晚 · ¥1280起'),
      ('云南大理', '4天3晚 · ¥2180起'),
      ('北京文化线', '6天5晚 · ¥2980起'),
      ('厦门鼓浪屿', '4天3晚 · ¥1880起'),
    ];
    final items = expanded ? allItems : allItems.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...items.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  e.$1,
                  style: TravelTypography.content(AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                e.$2,
                style: TravelTypography.hint(AppColors.textTertiary, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onViewMore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              expanded ? '收起' : l10n.plannerViewMore,
              style: TravelTypography.label(TravelDesignTokens.primary, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCtaContent(
    BuildContext context,
    WidgetRef ref,
    dynamic formState,
    AppLocalizations l10n,
  ) {
    final isSubmitting = formState.isSubmitting as bool;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSubmitting
            ? null
            : () => _submitAndNavigate(context, ref),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSubmitting
                ? TravelDesignTokens.primary.withValues(alpha: 0.6)
                : TravelDesignTokens.primary,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: TravelDesignTokens.primary.withValues(alpha: 0.35),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  l10n.plannerGetPlan,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _submitAndNavigate(BuildContext context, WidgetRef ref) async {
    final formState = ref.read(plannerFormStateProvider);
    final notifier = ref.read(plannerFormStateProvider.notifier);
    notifier.setSubmitting(true);
    try {
      final service = ref.read(plannerServiceProvider);
      final result = await service.submitPlannerRequest(formState.request);
      ref.read(currentPlannerResultProvider.notifier).state = result;
      notifier.setSubmitting(false);
      if (context.mounted) context.push('/planner/planner/result');
    } catch (e) {
      notifier.setSubmitError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Main planner card: top accent & section dividers
// ─────────────────────────────────────────────────────────────────────────

class _PlannerCardTopAccent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            TravelDesignTokens.primary.withValues(alpha: 0.3),
            TravelDesignTokens.primary,
            TravelDesignTokens.primary.withValues(alpha: 0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class _PlannerCardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        painter: _GradientDividerPainter(),
      ),
    );
  }
}

class _GradientDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────
// Header: AI-style illustration (Chinese ink + modern travel)
// ─────────────────────────────────────────────────────────────────────────

class _PlannerHeaderIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1) Light green mountain gradient — layered soft peaks
    final mountainGrad = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        const Color(0xFF7CB87C).withValues(alpha: 0.35),
        const Color(0xFF9BC99B).withValues(alpha: 0.18),
        const Color(0xFFB8DCB8).withValues(alpha: 0.08),
        Colors.transparent,
      ],
      stops: const [0.0, 0.4, 0.7, 1.0],
    );
    final mountainPaint = Paint()..shader = mountainGrad.createShader(Rect.fromLTWH(0, 0, w, h));
    _drawInkMountains(canvas, size, mountainPaint);

    // 2) Abstract travel map lines (curved paths)
    final pathPaint = Paint()
      ..color = const Color(0xFF6B9B6B).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    _drawMapLines(canvas, size, pathPaint);

    // 3) Airplane route dotted line
    final dottedPaint = Paint()
      ..color = const Color(0xFF5A8A5A).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    _drawDottedRoute(canvas, size, dottedPaint);

    // 4) Soft cloud overlays
    _drawClouds(canvas, size);

    // 5) Subtle brush texture (noise-style dots)
    _drawBrushTexture(canvas, size);
  }

  void _drawInkMountains(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(0, h);
    path.quadraticBezierTo(w * 0.25, h * 0.5, w * 0.5, h * 0.72);
    path.quadraticBezierTo(w * 0.75, h * 0.55, w, h * 0.85);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(0, h);
    path2.quadraticBezierTo(w * 0.4, h * 0.65, w * 0.7, h * 0.78);
    path2.quadraticBezierTo(w * 1.1, h * 0.6, w, h);
    path2.close();
    canvas.drawPath(path2, Paint()..shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        const Color(0xFF8BC48B).withValues(alpha: 0.25),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h)));
  }

  void _drawMapLines(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.1, h * 0.75);
    path.quadraticBezierTo(w * 0.35, h * 0.5, w * 0.55, h * 0.6);
    path.quadraticBezierTo(w * 0.8, h * 0.45, w * 0.9, h * 0.55);
    canvas.drawPath(path, paint);
    final path2 = Path();
    path2.moveTo(w * 0.15, h * 0.82);
    path2.quadraticBezierTo(w * 0.5, h * 0.6, w * 0.85, h * 0.7);
    canvas.drawPath(path2, paint);
  }

  void _drawDottedRoute(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    const dotSpacing = 12.0;
    final path = Path();
    path.moveTo(w * 0.08, h * 0.68);
    path.quadraticBezierTo(w * 0.4, h * 0.35, w * 0.92, h * 0.5);
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      for (double d = 0; d < metric.length; d += dotSpacing) {
        final pos = metric.getTangentForOffset(d)?.position ?? Offset.zero;
        canvas.drawCircle(pos, 1.2, paint);
      }
    }
  }

  void _drawClouds(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.25, h * 0.28), width: 48, height: 22), cloudPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.72, h * 0.22), width: 56, height: 24), cloudPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.38), width: 40, height: 18), cloudPaint);
  }

  void _drawBrushTexture(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.03);
    final r = 0.8;
    for (var i = 0; i < 80; i++) {
      final x = (i * 17.3) % size.width;
      final y = (i * 11.7) % size.height;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PlannerHeaderGradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.25),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
