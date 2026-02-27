import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../components/companion_components.dart';
import '../data/companion_list_mock.dart';
import '../data/companion_list_provider.dart';
import '../models/companion_list_item.dart';
import '../widgets/rating_widget.dart';

/// Companion card design system: professional commercial look — radius 16, subtle elevation
const double _kCompanionCardRadius = 16;
const List<BoxShadow> _kCompanionCardShadow = [
  BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 2),
    blurRadius: 8,
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Color(0x08000000),
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: -2,
  ),
];

// Helpers moved to companion_components (RankingBadge, CompactTag, GradientCTAButton, etc.)

/// 等级徽章 LV1–LV5 + 进度条
Widget _buildLevelBadge(int level, double progress) {
  final clampedLevel = level.clamp(1, 5);
  final clampedProgress = progress.clamp(0.0, 1.0);
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.textTertiary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: AppColors.textTertiary.withValues(alpha: 0.25), width: 0.5),
        ),
        child: Text(
          'LV$clampedLevel',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 8,
          ),
        ),
      ),
      if (clampedProgress > 0 && clampedLevel < 5) ...[
        const SizedBox(height: 2),
        SizedBox(
          width: 28,
          height: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: LinearProgressIndicator(
              value: clampedProgress,
              backgroundColor: AppColors.textTertiary.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

///  urgency: 今日仅剩N个名额
Widget _buildUrgencyIndicator(int spotsLeft) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: AppColors.price.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.price.withValues(alpha: 0.35), width: 0.5),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_rounded, size: 10, color: AppColors.price),
        const SizedBox(width: 3),
        Text(
          '今日仅剩$spotsLeft个名额',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.price,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}

/// 快回复徽章：平均N分钟回复
Widget _buildFastResponseBadge(int minutes) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      color: AppColors.success.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.success.withValues(alpha: 0.35), width: 0.5),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.speed_rounded, size: 10, color: AppColors.success),
        const SizedBox(width: 2),
        Text(
          '平均${minutes}分钟回复',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}

/// 信任信号：平台保障 + 已实名认证
Widget _buildTrustSignals({required bool isVerified, bool compact = false}) {
  final size = compact ? 9.0 : 10.0;
  final iconSize = compact ? 9.0 : 11.0;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.shield_rounded, size: iconSize, color: AppColors.textTertiary),
      SizedBox(width: compact ? 1 : 2),
      Text(
        '平台保障',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
          fontSize: size,
          fontWeight: FontWeight.w500,
        ),
      ),
      if (isVerified) ...[
        SizedBox(width: compact ? 4 : 8),
        Icon(Icons.verified_user_rounded, size: iconSize, color: AppColors.accentCool),
        SizedBox(width: compact ? 1 : 2),
        Text(
          '已实名认证',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.accentCool,
            fontSize: size,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ],
  );
}

/// 转化 CTA：亮渐变 + 阴影光晕
Widget _buildConversionCta({
  required String label,
  required VoidCallback onTap,
  double fontSize = 13,
  bool compact = false,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFD54F),
              Color(0xFFFFB300),
              Color(0xFFFF8F00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF8F00).withValues(alpha: 0.45),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color(0xFFFFB300).withValues(alpha: 0.3),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    ),
  );
}

/// 等级徽章（RankingBadge 封装）
Widget _buildRankBadge(CompanionRankBadge b) {
  return RankingBadge(badge: b);
}

/// 资深标签
Widget _buildSeniorBadge() {
  return CompactTag(type: CompactTagType.senior);
}

/// 人气飙升标签
Widget _buildTrendingTag() {
  return CompactTag(type: CompactTagType.trending);
}

/// 热门角标
Widget _buildHotBadge() {
  return CompactTag(type: CompactTagType.hot, compact: true);
}

/// 限时优惠/今日特价标签
Widget _buildDiscountTag(CompanionDiscountTag tag) {
  return CompactTag(
    type: tag == CompanionDiscountTag.limitedTime
        ? CompactTagType.discountLimited
        : CompactTagType.discountToday,
  );
}

/// 拼单优惠标签
Widget _buildGroupDiscountTag() {
  return CompactTag(type: CompactTagType.groupDiscount);
}

/// 套餐价格行（3h + 天 或 仅天）
Widget _buildPackagePrices(CompanionListItem companion) {
  final has3h = companion.pricePer3h != null;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (has3h) ...[
        _buildGradientPrice(companion.pricePer3h!, unit: '', fontSize: 12),
        const SizedBox(width: 4),
        Text(
          '·',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 4),
      ],
      _buildGradientPrice(
        companion.pricePerDay,
        unit: '/天',
        fontSize: has3h ? 12 : 14,
      ),
    ],
  );
}

/// 渐变价格文案
Widget _buildGradientPrice(
  double price, {
  String unit = '',
  double fontSize = 14,
}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: Text(
      '¥${price.toStringAsFixed(0)}$unit',
      style: AppTextStyles.caption.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
        color: Colors.white,
      ),
    ),
  );
}

/// 技能标签 → 图标（陪游常用）
IconData _companionTagToIcon(String tag) {
  final lower = tag.toLowerCase();
  if (lower.contains('摄影') || lower.contains('拍照')) return Icons.camera_alt_rounded;
  if (lower.contains('翻译')) return Icons.translate_rounded;
  if (lower.contains('导游') || lower.contains('导览')) return Icons.tour_rounded;
  if (lower.contains('驾驶') || lower.contains('司机')) return Icons.directions_car_rounded;
  if (lower.contains('美食') || lower.contains('餐饮')) return Icons.restaurant_rounded;
  if (lower.contains('户外') || lower.contains('徒步')) return Icons.hiking_rounded;
  return Icons.tag_rounded;
}

/// 收藏按钮：轻量动画（scale bounce）
class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.isFavorited,
    required this.count,
    required this.onTap,
    this.size = 14,
  });

  final bool isFavorited;
  final int count;
  final VoidCallback onTap;
  final double size;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.35)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Icon(
              widget.isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: widget.size,
              color: widget.isFavorited ? AppColors.accentWarm : AppColors.textTertiary,
            ),
          ),
          if (widget.count > 0) ...[
            const SizedBox(width: 2),
            Text(
              '${widget.count}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 找陪游 · 陪游发现页
class CompanionListPage extends ConsumerStatefulWidget {
  const CompanionListPage({super.key});

  @override
  ConsumerState<CompanionListPage> createState() => _CompanionListPageState();
}

/// Match companion by keyword: name, city, or tags (skills).
bool _companionMatchesSearch(CompanionListItem c, String query) {
  if (query.trim().isEmpty) return true;
  final q = query.trim().toLowerCase();
  if (c.name.toLowerCase().contains(q)) return true;
  if (c.city.toLowerCase().contains(q)) return true;
  if (c.tags.any((t) => t.toLowerCase().contains(q))) return true;
  if (c.languages?.any((l) => l.toLowerCase().contains(q)) ?? false) return true;
  return false;
}

class _CompanionListPageState extends ConsumerState<CompanionListPage>
    with TickerProviderStateMixin {
  CompanionListFilters _filters = const CompanionListFilters();
  List<CompanionListItem> _list = [];
  List<CompanionListItem> _fullListFromApi = [];
  List<CompanionListItem> _sponsored = [];
  List<CompanionListItem> _featured = [];
  List<CompanionListItem> _smartRecommendations = [];
  List<CompanionListItem> _recommended = [];
  bool _loading = true;
  final Set<String> _favoritedIds = {};
  bool _loadingMore = false;
  int _loadedCount = 0;
  int _filterIndex = 0;
  static const int _pageSize = 10;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<String> _filterLabels = [
    '热度',
    '评分',
    '价格升序',
    '价格降序',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim();
      if (q != _searchQuery) setState(() => _searchQuery = q);
    });
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatController = controller;
    _floatAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    _loadFirst();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _floatController?.dispose();
    super.dispose();
  }

  List<CompanionListItem> get _filteredList =>
      _searchQuery.isEmpty ? _list : _list.where((c) => _companionMatchesSearch(c, _searchQuery)).toList();
  List<CompanionListItem> get _filteredSponsored =>
      _searchQuery.isEmpty ? _sponsored : _sponsored.where((c) => _companionMatchesSearch(c, _searchQuery)).toList();
  List<CompanionListItem> get _filteredFeatured =>
      _searchQuery.isEmpty ? _featured : _featured.where((c) => _companionMatchesSearch(c, _searchQuery)).toList();
  List<CompanionListItem> get _filteredSmartRecommendations =>
      _searchQuery.isEmpty ? _smartRecommendations : _smartRecommendations.where((c) => _companionMatchesSearch(c, _searchQuery)).toList();
  List<CompanionListItem> get _filteredRecommended =>
      _searchQuery.isEmpty ? _recommended : _recommended.where((c) => _companionMatchesSearch(c, _searchQuery)).toList();

  CompanionSort get _sort => switch (_filterIndex) {
        1 => CompanionSort.rating,
        2 => CompanionSort.priceAsc,
        3 => CompanionSort.priceDesc,
        _ => CompanionSort.recommended,
      };

  void _applyFilters() {
    _filters = _filters.copyWith(sort: _sort);
    _loadFirst();
  }

  /// Deduplicate by companion id (first occurrence wins) so no card repeats across or within slides.
  static List<CompanionListItem> _deduplicateById(List<CompanionListItem> list) {
    final seen = <String>{};
    return list.where((c) => seen.add(c.id)).toList();
  }

  /// Derive sponsored, featured, recommended, and smart recommendation slides from API list (no mock).
  /// Uses deduplicated list so the same companion never appears in more than one slide.
  void _deriveSlidesFromApi(List<CompanionListItem> fromApi) {
    final list = _deduplicateById(fromApi);
    _sponsored = list.take(2).toList();
    _featured = list.skip(2).take(4).toList();
    _recommended = list.skip(6).take(6).toList();
    _smartRecommendations = list.skip(12).take(6).toList();
  }

  Future<void> _loadFirst() async {
    setState(() {
      _loading = true;
      _loadedCount = 0;
    });
    try {
      final fromApi = await ref.read(companionListFromApiProvider(_filters.city).future);
      if (!mounted) return;
      _fullListFromApi = _deduplicateById(fromApi);
      _deriveSlidesFromApi(_fullListFromApi);
      setState(() {
        _list = _fullListFromApi.take(_pageSize).toList();
        _loadedCount = _list.length;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      _fullListFromApi = [];
      _sponsored = [];
      _featured = [];
      _recommended = [];
      _smartRecommendations = [];
      setState(() {
        _list = [];
        _loadedCount = 0;
        _loading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    _filters = const CompanionListFilters();
    _filterIndex = 0;
    await _loadFirst();
  }

  void _onFilterChanged(int index) {
    setState(() {
      _filterIndex = index;
      _applyFilters();
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoritedIds.contains(id)) {
        _favoritedIds.remove(id);
      } else {
        _favoritedIds.add(id);
      }
    });
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _loading) return;
    final all = _fullListFromApi;
    if (_loadedCount >= all.length) return;
    setState(() => _loadingMore = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    final next = all.skip(_loadedCount).take(_pageSize).toList();
    setState(() {
      _list.addAll(next);
      _loadedCount = _list.length;
      _loadingMore = false;
    });
  }

  static const double _headerHeight = 168;
  static const double _searchBarHeight = 46;
  static const double _searchBarRadius = 18;
  static const double _headerBottomRadius = 8;

  AnimationController? _floatController;
  Animation<double>? _floatAnimation;
  final GlobalKey _allSectionKey = GlobalKey();

  void _scrollToAllSection() {
    final context = _allSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  static bool _isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360;

  /// Section separator: different color background only (no borders).
  SliverToBoxAdapter _sectionSpacer(Color nextSectionColor) {
    return SliverToBoxAdapter(
      child: Container(
        height: 14,
        width: double.infinity,
        color: nextSectionColor.withValues(alpha: 0.35),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final compact = _isCompact(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final totalHeaderHeight = _headerHeight + topPadding;
    final searchBarOverlap = 24.0;
    final searchBarTop = totalHeaderHeight - _searchBarHeight - searchBarOverlap;

    return Scaffold(
      backgroundColor: AppColors.companionSectionBright,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Scrollable content with top spacer so it starts below the fixed header
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n is ScrollEndNotification) return false;
                final m = n.metrics;
                if (m.pixels >= m.maxScrollExtent - 200) _loadMore();
                return false;
              },
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  cacheExtent: 400,
                  clipBehavior: Clip.none,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: totalHeaderHeight + 8),
                    ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        compact ? 12 : 16,
                        0,
                        compact ? 12 : 16,
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: _buildFilterCapsules(),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ..._buildSponsoredSection(l10n),
                  _sectionSpacer(AppColors.companionSectionBright),
                  ..._buildFeaturedSection(l10n),
                  _sectionSpacer(AppColors.companionSectionBright),
                  ..._buildSmartRecommendationSection(l10n),
                  _sectionSpacer(AppColors.companionSectionBright),
                  ..._buildRecommendedSection(l10n),
                  _sectionSpacer(AppColors.companionSectionBright),
                  ..._buildAllSection(context, l10n),
                  if (_loadingMore) _buildLoadingMoreSliver(),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Fixed header: always visible, image stretched to top of screen
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: totalHeaderHeight,
                child: _buildFixedHeader(context, topPadding, l10n),
              ),
            ),
            Positioned(
              top: searchBarTop,
              left: compact ? 12 : 16,
              right: compact ? 12 : 16,
              child: _buildFloatingSearchBar(l10n),
            ),
          ],
        ),
    );
  }

  static final BorderRadius _headerRadius = BorderRadius.only(
    bottomLeft: Radius.circular(_headerBottomRadius),
    bottomRight: Radius.circular(_headerBottomRadius),
  );

  /// Fixed-height header that does not scroll or shrink (stays full size).
  Widget _buildFixedHeader(
    BuildContext context,
    double topPadding,
    AppLocalizations? l10n,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: _headerRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: _headerRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/header_companion.png',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              bottom: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 360;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 12 : 16,
                      14,
                      compact ? 12 : 16,
                      36,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                l10n?.companionDiscoveryTitle ?? '找陪游',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: AppTextStyles.header(
                                  const Color(0xFF1A1A1A),
                                  fontSize: 38,
                                ).copyWith(
                                  height: 1.15,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      offset: const Offset(0, 2),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '发现城市里的宝藏向导',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 13,
                                  color: const Color(0xFF555555),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildFloatingGlassLuggage(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingGlassLuggage() {
    final animation = _floatAnimation;
    if (animation == null) {
      return _buildGlassLuggageChild();
    }
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = 4.0 * (0.5 - (animation.value - 0.5).abs());
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: _buildGlassLuggageChild(),
    );
  }

  Widget _buildGlassLuggageChild() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        Icons.luggage_rounded,
        size: 28,
        color: AppColors.accentWarm,
      ),
    );
  }

  Widget _buildFloatingSearchBar(AppLocalizations? l10n) {
    return Container(
      height: _searchBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_searchBarRadius),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Flexible(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(_searchBarRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: AppColors.accentWarm,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n?.companionCityHint ?? '选择城市',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: AppColors.divider,
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: l10n?.companionSearchPlaceholder ?? '城市、技能、关键词',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        )
                      : null,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(_searchBarRadius),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: AppShadow.light,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCapsules() {
    final compact = MediaQuery.sizeOf(context).width < 360;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16, vertical: 4),
        itemCount: _filterLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == _filterIndex;
          return _FilterPill(
            label: _filterLabels[i],
            selected: selected,
            onTap: () => _onFilterChanged(i),
          );
        },
      ),
    );
  }

  List<Widget> _buildSponsoredSection(AppLocalizations? l10n) {
    if (_filteredSponsored.isEmpty) return [];
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => CompanionSectionHeader(
          title: '推荐置顶',
          barColor: AppColors.accentGold,
          icon: Icons.campaign_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            decoration: BoxDecoration(
              color: AppColors.companionSectionBright,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
              height: 172,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _filteredSponsored.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = _filteredSponsored[i];
                  return RepaintBoundary(
                    child: CompanionCard(
                      config: CompanionCardConfig(
                        companion: c,
                        variant: CompanionCardVariant.featured,
                        onTap: () => context.push('/companions/${c.id}'),
                        showHotBadge: false,
                        isSponsored: true,
                        isFavorited: _favoritedIds.contains(c.id),
                        onFavoriteTap: () => _toggleFavorite(c.id),
                        isDarkSurface: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildFeaturedSection(AppLocalizations? l10n) {
    if (_filteredFeatured.isEmpty) return [];
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => CompanionSectionHeader(
          title: l10n?.companionSectionFeatured ?? '热门陪游',
          barColor: AppColors.accentWarm,
          icon: Icons.local_fire_department_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          child: DecorativeSectionContainer(
            tintColor: AppColors.companionSectionBright,
            accentColor: AppColors.accentWarm,
            child: SizedBox(
              height: 172,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _filteredFeatured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = _filteredFeatured[i];
                  return RepaintBoundary(
                    child: CompanionCard(
                      config: CompanionCardConfig(
                        companion: c,
                        variant: CompanionCardVariant.featured,
                        onTap: () => context.push('/companions/${c.id}'),
                        showHotBadge: i == 0,
                        isFavorited: _favoritedIds.contains(c.id),
                        onFavoriteTap: () => _toggleFavorite(c.id),
                        isDarkSurface: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildSmartRecommendationSection(AppLocalizations? l10n) {
    if (_filteredSmartRecommendations.isEmpty) return [];
    final items = _filteredSmartRecommendations;
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => CompanionSectionHeader(
          title: '为你推荐',
          barColor: AppColors.accentGold,
          icon: Icons.auto_awesome_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
          subtitle: '根据你的浏览推荐',
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          child: DecorativeSectionContainer(
            tintColor: AppColors.companionSectionBright,
            accentColor: AppColors.accentCool,
            borderRadius: 16,
            margin: EdgeInsets.only(
              left: MediaQuery.sizeOf(context).width < 360 ? 10 : 12,
              right: MediaQuery.sizeOf(context).width < 360 ? 10 : 12,
              bottom: 8,
            ),
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final c = items[i];
                  return RepaintBoundary(
                    child: CompanionCard(
                      config: CompanionCardConfig(
                        companion: c,
                        variant: CompanionCardVariant.smart,
                        onTap: () => context.push('/companions/${c.id}'),
                        isFavorited: _favoritedIds.contains(c.id),
                        onFavoriteTap: () => _toggleFavorite(c.id),
                        isDarkSurface: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildRecommendedSection(AppLocalizations? l10n) {
    if (_filteredRecommended.isEmpty) return [];
    final items = _filteredRecommended;
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => CompanionSectionHeader(
          title: '推荐陪游',
          barColor: AppColors.primary,
          icon: Icons.thumb_up_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          child: DecorativeSectionContainer(
            tintColor: AppColors.companionSectionBright,
            accentColor: AppColors.primary,
            child: SizedBox(
              height: 172,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = items[i];
                  return RepaintBoundary(
                    child: CompanionCard(
                      config: CompanionCardConfig(
                        companion: c,
                        variant: CompanionCardVariant.featured,
                        onTap: () => context.push('/companions/${c.id}'),
                        showHotBadge: false,
                        isFavorited: _favoritedIds.contains(c.id),
                        onFavoriteTap: () => _toggleFavorite(c.id),
                        isDarkSurface: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildAllSection(BuildContext context, AppLocalizations? l10n) {
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => CompanionSectionHeader(
          title: l10n?.companionSectionAll ?? '全部陪游',
          barColor: AppColors.accentCool,
          icon: Icons.people_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          key: _allSectionKey,
          child: DecorativeSectionContainer(
            tintColor: AppColors.companionSectionBright,
            accentColor: AppColors.accentCool,
            child: _loading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _CompanionListCardSkeleton(),
                      ),
                    ),
                  )
                : _filteredList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: EmptyState(
                          icon: Icon(
                            Icons.person_search_rounded,
                            size: 48,
                            color: AppColors.textTertiary,
                          ),
                          message: _searchQuery.isNotEmpty
                              ? '未找到匹配的陪游'
                              : (l10n?.companionEmpty ?? '暂无符合条件的陪游'),
                          actionLabel: l10n?.companionFilterAll ?? '全部',
                          onAction: _searchQuery.isNotEmpty ? () { _searchController.clear(); setState(() => _searchQuery = ''); } : _onRefresh,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        itemCount: _filteredList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final companion = _filteredList[index];
                          return FadeIn(
                            delay: Duration(milliseconds: (index % 8) * 35),
                            offsetY: 6,
                            child: RepaintBoundary(
                              child: CompanionCard(
                                config: CompanionCardConfig(
                                  companion: companion,
                                  variant: CompanionCardVariant.list,
                                  onTap: () =>
                                      context.push('/companions/${companion.id}'),
                                  isFavorited: _favoritedIds.contains(companion.id),
                                  onFavoriteTap: () =>
                                      _toggleFavorite(companion.id),
                                  bookNowLabel: l10n?.companionBookNow ?? '立即预约',
                                  pricePerDaySuffix: l10n?.companionPricePerDay ?? '/天',
                                  serviceCountFormat: l10n?.companionServiceCount != null
                                      ? (count) => l10n!.companionServiceCount(count)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    ];
  }

  Widget _buildLoadingMoreSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Filter pill: active gradient yellow-green, inactive white + soft shadow ───
class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: selected ? null : Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.35),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: selected ? Colors.white : const Color(0xFF1A1A1A),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              fontSize: compact ? 14 : 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sticky section header: white bg + shadow when pinned, smooth animation ───
class _StickySectionHeader extends StatelessWidget {
  const _StickySectionHeader({
    required this.title,
    required this.barColor,
    required this.icon,
    this.onSeeMore,
    required this.isPinned,
    this.subtitle,
  });

  final String title;
  final Color barColor;
  final IconData icon;
  final VoidCallback? onSeeMore;
  final bool isPinned;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final content = Padding(
      padding: EdgeInsets.only(
        left: compact ? 12 : 16,
        right: compact ? 12 : 16,
        top: 4,
        bottom: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
            width: 5,
            height: 18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  barColor,
                  barColor.withValues(alpha: 0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 17,
                color: const Color(0xFF1A1A1A),
                letterSpacing: 0.8,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppTapScale(
            onTap: onSeeMore,
            pressedScale: 0.96,
            useRipple: true,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '查看更多',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: EdgeInsets.only(left: compact ? 27 : 31),
              child: Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isPinned ? AppColors.card : Colors.transparent,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: FadeIn(
        duration: const Duration(milliseconds: 250),
        offsetY: 4,
        child: content,
      ),
    );
  }
}

// ─── Section container: pastel tint + soft shapes + texture + travel icons ───
class _CompanionSectionContainer extends StatelessWidget {
  const _CompanionSectionContainer({
    required this.child,
    required this.tintColor,
    this.accentColor,
  });

  final Widget child;
  final Color tintColor;
  final Color? accentColor;

  static const double _radius = 14;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? tintColor;
    final compact = MediaQuery.sizeOf(context).width < 360;
    return Container(
      margin: EdgeInsets.only(
        left: compact ? 10 : 12,
        right: compact ? 10 : 12,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        color: tintColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _SectionShapesPainter(accentColor: accent),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionShapesPainter extends CustomPainter {
  _SectionShapesPainter({required this.accentColor});

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

// ─── Smart recommendation section: premium gradient, gold accent ───
class _SmartRecommendationSectionContainer extends StatelessWidget {
  const _SmartRecommendationSectionContainer({required this.child});

  final Widget child;

  static const double _radius = 16;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    return Container(
      margin: EdgeInsets.only(
        left: compact ? 10 : 12,
        right: compact ? 10 : 12,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDF8F0),
            Color(0xFFFFF9F0),
            Color(0xFFFFF5E8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _SectionShapesPainter(accentColor: AppColors.accentGold),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── Smart recommendation card: larger, premium feel ───
class _SmartRecommendationCard extends StatelessWidget {
  const _SmartRecommendationCard({
    required this.companion,
    required this.onTap,
    this.isFavorited = false,
    this.onFavoriteTap,
  });

  final CompanionListItem companion;
  final VoidCallback onTap;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;

  static const double _avatarSize = 52;
  static const double _cardWidth = 156;

  bool get _isSenior => companion.experienceYears >= 5;

  @override
  Widget build(BuildContext context) {
    final skills = companion.tags.take(3).toList();
    final displayBadges = companion.rankBadges.isNotEmpty
        ? companion.rankBadges.take(2).toList()
        : <CompanionRankBadge>[
            if (companion.isVerified) CompanionRankBadge.verified,
          ];
    final useSeniorFallback = companion.rankBadges.isEmpty && _isSenior;

    return AppTapScale(
      onTap: onTap,
      enableHover: kIsWeb,
      child: Container(
        width: _cardWidth,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withValues(alpha: 0.08),
              offset: const Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
            const BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: 'companion_avatar_${companion.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentGold.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: companion.avatarUrl.isNotEmpty
                          ? Image.network(
                              companion.avatarUrl,
                              width: _avatarSize,
                              height: _avatarSize,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                            )
                          : _avatarPlaceholder(),
                    ),
                  ),
                ),
                if (companion.isOnline) _buildOnlineDot(),
              ],
            ),
            if (companion.achievementIcons.isNotEmpty) ...[
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: companion.achievementIcons.take(3).map((icon) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Icon(icon, size: 11, color: AppColors.accentGold),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    companion.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (displayBadges.isNotEmpty)
                  ...displayBadges.expand((b) => [
                        const SizedBox(width: 2),
                        _buildRankBadge(b),
                      ]),
                if (useSeniorFallback) ...[
                  const SizedBox(width: 2),
                  _buildSeniorBadge(),
                ],
                if (companion.isTrending) ...[
                  const SizedBox(width: 2),
                  _buildTrendingTag(),
                ],
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLevelBadge(companion.level, companion.levelProgress),
                const SizedBox(width: 6),
                if (onFavoriteTap != null)
                  _FavoriteButton(
                    isFavorited: isFavorited,
                    count: companion.favoritesCount + (isFavorited ? 1 : 0),
                    onTap: onFavoriteTap!,
                    size: 12,
                  )
                else if (companion.favoritesCount > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 9, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Text(
                        '${companion.favoritesCount}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                if (companion.viewCount > 0) ...[
                  if (onFavoriteTap != null || companion.favoritesCount > 0) const SizedBox(width: 6),
                  Text(
                    '${companion.viewCount}浏览',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 3),
            RatingWidget(
              rating: companion.rating,
              iconSize: 11,
              fontSize: 11,
              suffix: '${companion.reviewCount}条',
              starColor: AppColors.textTertiary,
            ),
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < skills.length && i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Icon(_companionTagToIcon(skills[i]), size: 11, color: AppColors.textTertiary),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 3),
            _buildPackagePrices(companion),
            if (companion.spotsLeftToday != null && companion.spotsLeftToday! <= 3) ...[
              const SizedBox(height: 2),
              Center(child: _buildUrgencyIndicator(companion.spotsLeftToday!)),
            ],
            if (companion.responseTimeMinutes != null && companion.responseTimeMinutes! <= 10) ...[
              const SizedBox(height: 2),
              Center(child: _buildFastResponseBadge(companion.responseTimeMinutes!)),
            ],
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: _buildConversionCta(
                label: '立即预约',
                onTap: onTap,
                fontSize: 13,
                compact: true,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: _buildTrustSignals(isVerified: companion.isVerified, compact: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineDot() {
    return Positioned(
      right: 2,
      bottom: 2,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          border: Border.all(color: AppColors.card, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.7),
              blurRadius: 4,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    final initial = companion.name.isNotEmpty ? companion.name[0] : '?';
    final hue = (companion.name.hashCode % 360).toDouble();
    final color = HSLColor.fromAHSL(1, hue, 0.4, 0.65).toColor();
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      color: color.withValues(alpha: 0.3),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ─── Featured horizontal card: rank, badges, monetization, package prices ───
class _FeaturedCompanionCard extends StatelessWidget {
  const _FeaturedCompanionCard({
    required this.companion,
    required this.onTap,
    this.showHotBadge = false,
    this.isSponsored = false,
    this.isFavorited = false,
    this.onFavoriteTap,
  });

  final CompanionListItem companion;
  final VoidCallback onTap;
  final bool showHotBadge;
  final bool isSponsored;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;

  static const double _avatarSize = 42;
  static const double _cardWidth = 124;

  bool get _isSenior => companion.experienceYears >= 5;

  @override
  Widget build(BuildContext context) {
    final skills = companion.tags.take(3).toList();
    final displayBadges = companion.rankBadges.isNotEmpty
        ? companion.rankBadges.take(2).toList()
        : <CompanionRankBadge>[
            if (companion.isVerified) CompanionRankBadge.verified,
          ];
    final useSeniorFallback = companion.rankBadges.isEmpty && _isSenior;

    return AppTapScale(
      onTap: onTap,
      enableHover: kIsWeb,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _cardWidth,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(_kCompanionCardRadius),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: _kCompanionCardShadow,
            ),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Avatar + Hot badge + achievement icons under
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: [
                    Hero(
                      tag: 'companion_avatar_${companion.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: ClipOval(
                          child: companion.avatarUrl.isNotEmpty
                              ? Image.network(
                                  companion.avatarUrl,
                                  width: _avatarSize,
                                  height: _avatarSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                                )
                              : _avatarPlaceholder(),
                        ),
                      ),
                    ),
                    if (companion.isOnline) _buildOnlineDot(),
                    if (showHotBadge)
                      Positioned(top: -1, right: -1, child: _buildHotBadge()),
                    if (isSponsored)
                      Positioned(
                        top: -1,
                        left: -1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.textTertiary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '广告',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (companion.achievementIcons.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: companion.achievementIcons.take(3).map((icon) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Icon(icon, size: 10, color: AppColors.accentGold),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            if (companion.cityRank != null && showHotBadge)
              Text(
                '#${companion.cityRank} · ${companion.city}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 2),
            // 2. Name + rank badges + 人气飙升
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    companion.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (displayBadges.isNotEmpty)
                  ...displayBadges.expand((b) => [
                        const SizedBox(width: 2),
                        _buildRankBadge(b),
                      ]),
                if (useSeniorFallback) ...[
                  const SizedBox(width: 2),
                  _buildSeniorBadge(),
                ],
                if (companion.isTrending) ...[
                  const SizedBox(width: 2),
                  _buildTrendingTag(),
                ],
              ],
            ),
            // 2b. Level + 收藏(可点击) + 浏览量
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLevelBadge(companion.level, companion.levelProgress),
                const SizedBox(width: 6),
                if (onFavoriteTap != null)
                  _FavoriteButton(
                    isFavorited: isFavorited,
                    count: companion.favoritesCount + (isFavorited ? 1 : 0),
                    onTap: onFavoriteTap!,
                    size: 12,
                  )
                else if (companion.favoritesCount > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 9, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Text(
                        '${companion.favoritesCount}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                if (companion.viewCount > 0) ...[
                  if (onFavoriteTap != null || companion.favoritesCount > 0) const SizedBox(width: 6),
                  Text(
                    '${companion.viewCount}浏览',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            // 3. Compact rating row
            const SizedBox(height: 2),
            RatingWidget(
              rating: companion.rating,
              iconSize: 10,
              fontSize: 10,
              suffix: '${companion.reviewCount}条',
              starColor: AppColors.textTertiary,
            ),
            // 4. Skill icons (neutral)
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < skills.length && i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Icon(_companionTagToIcon(skills[i]), size: 10, color: AppColors.textTertiary),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 2),
            if (companion.discountTag != null || companion.hasGroupDiscount)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (companion.discountTag != null)
                      _buildDiscountTag(companion.discountTag!),
                    if (companion.discountTag != null && companion.hasGroupDiscount)
                      const SizedBox(width: 4),
                    if (companion.hasGroupDiscount) _buildGroupDiscountTag(),
                  ],
                ),
              ),
            // 5. Package prices (3h | 1d) — Price hierarchy
            _buildPackagePrices(companion),
            if (companion.spotsLeftToday != null && companion.spotsLeftToday! <= 3) ...[
              const SizedBox(height: 2),
              Center(child: _buildUrgencyIndicator(companion.spotsLeftToday!)),
            ],
            if (companion.responseTimeMinutes != null && companion.responseTimeMinutes! <= 10) ...[
              const SizedBox(height: 2),
              Center(child: _buildFastResponseBadge(companion.responseTimeMinutes!)),
            ],
            const SizedBox(height: 4),
            // 6. CTA (bright gradient + glow)
            SizedBox(
              width: double.infinity,
              child: _buildConversionCta(
                label: '立即预约',
                onTap: onTap,
                fontSize: 12,
                compact: true,
              ),
            ),
            const SizedBox(height: 3),
            Center(
              child: _buildTrustSignals(isVerified: companion.isVerified, compact: true),
            ),
          ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineDot() {
    return Positioned(
      right: 2,
      bottom: 2,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          border: Border.all(
            color: AppColors.card,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.7),
              blurRadius: 4,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    final initial = companion.name.isNotEmpty ? companion.name[0] : '?';
    final hue = (companion.name.hashCode % 360).toDouble();
    final color = HSLColor.fromAHSL(1, hue, 0.4, 0.65).toColor();
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      color: color.withValues(alpha: 0.3),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ─── All companions list card: radius 16, badges, gradient price, tinted sections ───
class _CompanionListCard extends StatelessWidget {
  const _CompanionListCard({
    required this.companion,
    required this.onTap,
    this.l10n,
    this.isFavorited = false,
    this.onFavoriteTap,
  });

  final CompanionListItem companion;
  final VoidCallback onTap;
  final AppLocalizations? l10n;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;

  static const double _avatarSize = 72;

  bool get _isSenior => companion.experienceYears >= 5;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      enableHover: kIsWeb,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: companion.isSponsored
                  ? AppColors.accentGold.withValues(alpha: 0.04)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(_kCompanionCardRadius),
              border: Border.all(
                color: companion.isSponsored
                    ? AppColors.accentGold.withValues(alpha: 0.2)
                    : AppColors.border,
                width: 1,
              ),
              boxShadow: _kCompanionCardShadow,
            ),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Header row — Avatar | Name + small badges
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomRight,
                        children: [
                          Hero(
                            tag: 'companion_avatar_${companion.id}',
                            child: ClipOval(
                              child: companion.avatarUrl.isNotEmpty
                                  ? Image.network(
                                      companion.avatarUrl,
                                      width: _avatarSize,
                                      height: _avatarSize,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                                    )
                                  : _avatarPlaceholder(),
                            ),
                          ),
                          if (companion.isOnline) _buildOnlineBadge(),
                        ],
                      ),
                      if (companion.achievementIcons.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: companion.achievementIcons.take(3).map((icon) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: Icon(icon, size: 12, color: AppColors.accentGold),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                companion.name,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (companion.rankBadges.isNotEmpty)
                              ...companion.rankBadges.take(3).expand((b) => [
                                    const SizedBox(width: 4),
                                    _buildRankBadge(b),
                                  ]),
                            if (companion.rankBadges.isEmpty && companion.isVerified) ...[
                              const SizedBox(width: 4),
                              _buildRankBadge(CompanionRankBadge.verified),
                            ],
                            if (companion.rankBadges.isEmpty && _isSenior) ...[
                              const SizedBox(width: 4),
                              _buildSeniorBadge(),
                            ],
                            if (companion.isTrending) ...[
                              const SizedBox(width: 4),
                              _buildTrendingTag(),
                            ],
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLevelBadge(companion.level, companion.levelProgress),
                            if (companion.favoritesCount > 0 || companion.viewCount > 0) ...[
                              const SizedBox(width: 8),
                              if (onFavoriteTap != null)
                                _FavoriteButton(
                                  isFavorited: isFavorited,
                                  count: companion.favoritesCount + (isFavorited ? 1 : 0),
                                  onTap: onFavoriteTap!,
                                  size: 14,
                                )
                              else if (companion.favoritesCount > 0)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite_border_rounded, size: 11, color: AppColors.textTertiary),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${companion.favoritesCount}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textTertiary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              if (companion.viewCount > 0) ...[
                                const SizedBox(width: 6),
                                Text(
                                  '${companion.viewCount}浏览',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                        if (companion.discountTag != null || companion.hasGroupDiscount) ...[
                          const SizedBox(height: 2),
                          Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              if (companion.discountTag != null)
                                _buildDiscountTag(companion.discountTag!),
                              if (companion.hasGroupDiscount) _buildGroupDiscountTag(),
                            ],
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          companion.cityRank != null
                              ? '#${companion.cityRank} ${companion.city} · ${companion.experienceYears}年经验'
                              : '${companion.city} · ${companion.experienceYears}年经验',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Section 2: Skills — neutral small badges, tinted background
            if (companion.tags.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.5),
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: companion.tags.take(4).map((tag) {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 72),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.border,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _companionTagToIcon(tag),
                              size: 10,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                tag,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            // Section 3: Conversion — Price → CTA → Trust (hierarchy)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryPale.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(_kCompanionCardRadius),
                  bottomRight: Radius.circular(_kCompanionCardRadius),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata (neutral, compact)
                  Row(
                    children: [
                      RatingWidget(
                        rating: companion.rating,
                        iconSize: 10,
                        fontSize: 9,
                        suffix: '${companion.reviewCount}条',
                        starColor: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n?.companionServiceCount(companion.completedOrders) ??
                            '已服务${companion.completedOrders}次',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Row 1: Price (eye focus) + Urgency + Fast response
                  Row(
                    children: [
                      if (companion.pricePer3h != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('3h ', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                            _buildGradientPrice(companion.pricePer3h!, unit: '', fontSize: 14),
                            Text(' · ', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                            _buildGradientPrice(companion.pricePerDay, unit: l10n?.companionPricePerDay ?? '/天', fontSize: 16),
                          ],
                        )
                      else
                        _buildGradientPrice(companion.pricePerDay, unit: l10n?.companionPricePerDay ?? '/天', fontSize: 18),
                      const SizedBox(width: 8),
                      if (companion.spotsLeftToday != null && companion.spotsLeftToday! <= 3)
                        _buildUrgencyIndicator(companion.spotsLeftToday!),
                      if (companion.responseTimeMinutes != null && companion.responseTimeMinutes! <= 10) ...[
                        const SizedBox(width: 6),
                        _buildFastResponseBadge(companion.responseTimeMinutes!),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Row 2: CTA (bright gradient + glow)
                  SizedBox(
                    width: double.infinity,
                    child: _buildConversionCta(
                      label: l10n?.companionBookNow ?? '立即预约',
                      onTap: onTap,
                      fontSize: 13,
                      compact: true,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Row 3: Trust signal
                  _buildTrustSignals(isVerified: companion.isVerified),
                ],
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildOnlineBadge() {
    return Positioned(
      right: 2,
      bottom: 2,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          border: Border.all(color: AppColors.card, width: 1.5),
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    final initial = companion.name.isNotEmpty ? companion.name[0] : '?';
    final hue = (companion.name.hashCode % 360).toDouble();
    final color = HSLColor.fromAHSL(1, hue, 0.4, 0.6).toColor();
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      color: color.withValues(alpha: 0.25),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _CompanionListCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(_kCompanionCardRadius),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: _kCompanionCardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Container(
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 140),
                  child: Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: List.generate(
                    3,
                    (_) => Container(
                      height: 20,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
