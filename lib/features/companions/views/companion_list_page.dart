import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../data/companion_list_mock.dart';
import '../models/companion_list_item.dart';
import '../widgets/rating_widget.dart';

IconData _companionTagToIcon(String tag) {
  if (tag.contains('摄影') || tag.contains('跟拍')) return Icons.camera_alt_rounded;
  if (tag.contains('美食')) return Icons.restaurant_rounded;
  if (tag.contains('讲解') || tag.contains('文化')) return Icons.menu_book_rounded;
  if (tag.contains('路线') || tag.contains('规划')) return Icons.route_rounded;
  if (tag.contains('方言') || tag.contains('沟通')) return Icons.translate_rounded;
  return Icons.auto_awesome_rounded;
}

/// 找陪游 · 陪游发现页
class CompanionListPage extends StatefulWidget {
  const CompanionListPage({super.key});

  @override
  State<CompanionListPage> createState() => _CompanionListPageState();
}

class _CompanionListPageState extends State<CompanionListPage>
    with TickerProviderStateMixin {
  CompanionListFilters _filters = const CompanionListFilters();
  List<CompanionListItem> _list = [];
  List<CompanionListItem> _featured = [];
  List<CompanionListItem> _recommended = [];
  bool _loading = true;
  bool _loadingMore = false;
  int _loadedCount = 0;
  int _filterIndex = 0;
  static const int _pageSize = 10;

  static const List<String> _filterLabels = [
    '全部',
    '性别',
    '价格区间',
    '评分',
    '距离',
  ];

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatController = controller;
    _floatAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    _loadFeatured();
    _loadFirst();
  }

  @override
  void dispose() {
    _floatController?.dispose();
    super.dispose();
  }

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

  Future<void> _loadFeatured() async {
    final featured = getFeaturedCompanions();
    final recommended = getRecommendedCompanions();
    if (mounted) setState(() {
      _featured = featured;
      _recommended = recommended;
    });
  }

  Future<void> _loadFirst() async {
    setState(() {
      _loading = true;
      _loadedCount = 0;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final full = getCompanionList(_filters);
    setState(() {
      _list = full.take(_pageSize).toList();
      _loadedCount = _list.length;
      _loading = false;
    });
  }

  Future<void> _onRefresh() async {
    _filters = const CompanionListFilters();
    _filterIndex = 0;
    await Future.wait([_loadFeatured(), _loadFirst()]);
  }

  void _onFilterChanged(int index) {
    setState(() {
      _filterIndex = index;
      _applyFilters();
    });
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _loading) return;
    final all = getCompanionList(_filters);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    final compact = _isCompact(context);

    final searchBarOverlap = 24.0;
    final searchBarTop = _headerHeight + topPadding - _searchBarHeight - searchBarOverlap;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          NotificationListener<ScrollNotification>(
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
                physics: const AlwaysScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                slivers: [
                  _buildHeader(context, topPadding, l10n),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 8),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 12 : 16,
                        0,
                        compact ? 12 : 16,
                        8,
                      ),
                      child: _buildFilterCapsules(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ..._buildFeaturedSection(l10n),
                  SliverToBoxAdapter(child: _SectionGradientDivider(tintColor: AppColors.accentWarm)),
                  ..._buildRecommendedSection(l10n),
                  SliverToBoxAdapter(child: _SectionGradientDivider(tintColor: AppColors.primary)),
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

  Widget _buildHeader(
    BuildContext context,
    double topPadding,
    AppLocalizations? l10n,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        height: _headerHeight + topPadding,
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
              Positioned.fill(
                child: Image.asset(
                  'assets/header_companion.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Content: left text, right glass square
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 8,
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
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(_searchBarRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n?.companionSearchPlaceholder ?? '城市、技能、关键词',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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

  List<Widget> _buildFeaturedSection(AppLocalizations? l10n) {
    if (_featured.isEmpty) return [];
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => _StickySectionHeader(
          title: l10n?.companionSectionFeatured ?? '热门陪游',
          barColor: AppColors.accentWarm,
          icon: Icons.local_fire_department_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          child: _CompanionSectionContainer(
            tintColor: const Color(0xFFFFF5EB),
            accentColor: AppColors.accentWarm,
            child: SizedBox(
              height: 158,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _FeaturedCompanionCard(
                  companion: _featured[i],
                  onTap: () => context.push('/companions/${_featured[i].id}'),
                  showHotBadge: i == 0,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildRecommendedSection(AppLocalizations? l10n) {
    if (_recommended.isEmpty) return [];
    final items = _recommended;
    return [
      SliverStickyHeader.builder(
        builder: (context, state) => _StickySectionHeader(
          title: '推荐陪游',
          barColor: AppColors.primary,
          icon: Icons.thumb_up_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          child: _CompanionSectionContainer(
            tintColor: const Color(0xFFF8FCE8),
            accentColor: AppColors.primary,
            child: SizedBox(
              height: 158,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _FeaturedCompanionCard(
                  companion: items[i],
                  onTap: () => context.push('/companions/${items[i].id}'),
                  showHotBadge: false,
                ),
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
        builder: (context, state) => _StickySectionHeader(
          title: l10n?.companionSectionAll ?? '全部陪游',
          barColor: AppColors.accentCool,
          icon: Icons.people_rounded,
          isPinned: state.isPinned,
          onSeeMore: _scrollToAllSection,
        ),
        overlapsContent: false,
        sliver: SliverToBoxAdapter(
          key: _allSectionKey,
          child: _CompanionSectionContainer(
            tintColor: const Color(0xFFF0F7FF),
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
              : _list.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: EmptyState(
                        icon: Icon(
                          Icons.person_search_rounded,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        message: l10n?.companionEmpty ?? '暂无符合条件的陪游',
                        actionLabel: l10n?.companionFilterAll ?? '全部',
                        onAction: _onRefresh,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      itemCount: _list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, index) {
                        final companion = _list[index];
                        return _CompanionListCard(
                          companion: companion,
                          onTap: () =>
                              context.push('/companions/${companion.id}'),
                          l10n: l10n,
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
  });

  final String title;
  final Color barColor;
  final IconData icon;
  final VoidCallback? onSeeMore;
  final bool isPinned;

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
      child: Row(
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
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
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
      child: content,
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
        border: Border.all(
          color: accent.withValues(alpha: 0.15),
          width: 1,
        ),
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

class _SectionGradientDivider extends StatelessWidget {
  const _SectionGradientDivider({this.tintColor});

  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final color = tintColor ?? AppColors.divider;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      height: 1,
      color: color.withValues(alpha: 0.5),
    );
  }
}

// ─── Featured horizontal card: elevated style, accent ring, ribbon, skill icons, quick-book ───
class _FeaturedCompanionCard extends StatelessWidget {
  const _FeaturedCompanionCard({
    required this.companion,
    required this.onTap,
    this.showHotBadge = false,
  });

  final CompanionListItem companion;
  final VoidCallback onTap;
  final bool showHotBadge;

  static const double _avatarSize = 42;
  static const double _cardRadius = 14;
  static const double _cardWidth = 124;

  @override
  Widget build(BuildContext context) {
    final skills = companion.tags.take(3).toList();
    return AppTapScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Container(
          width: _cardWidth,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_cardRadius),
            border: Border.all(color: AppColors.accentWarm.withValues(alpha: 0.25), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
              BoxShadow(
                color: AppColors.accentWarm.withValues(alpha: 0.06),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentWarm.withValues(alpha: showHotBadge ? 0 : 0.5),
                            width: showHotBadge ? 0 : 2,
                          ),
                          boxShadow: showHotBadge ? null : [
                            BoxShadow(
                              color: AppColors.accentWarm.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                      if (companion.isOnline) _buildOnlineDot(),
                      if (showHotBadge) _buildHotRibbon(),
                    ],
                  ),
                  const SizedBox(height: 1),
                  SizedBox(
                    width: double.infinity,
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
                  if (skills.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < skills.length && i < 3; i++) ...[
                          if (i > 0) const SizedBox(width: 2),
                          Icon(
                            _companionTagToIcon(skills[i]),
                            size: 10,
                            color: AppColors.accentWarm.withValues(alpha: 0.9),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 1),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.accentWarm,
                        const Color(0xFFE85A4A),
                      ],
                      stops: const [0.0, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      '¥${companion.pricePerDay.toStringAsFixed(0)}/天',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                offset: const Offset(0, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '立即预约',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHotRibbon() {
    return Positioned(
      top: -2,
      right: -2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accentWarm, const Color(0xFFE85A4A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentWarm.withValues(alpha: 0.4),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Text(
          '热门',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
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

// ─── All companions list card: radius 16–18, structured, compact, no overflow ───
class _CompanionListCard extends StatelessWidget {
  const _CompanionListCard({
    required this.companion,
    required this.onTap,
    this.l10n,
  });

  final CompanionListItem companion;
  final VoidCallback onTap;
  final AppLocalizations? l10n;

  static const double _avatarSize = 72;
  static const double _cardRadius = 17;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(_cardRadius),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Avatar | Name + badge, City + experience
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
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
                    if (companion.isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success,
                            border: Border.all(
                              color: AppColors.card,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.6),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          if (companion.isVerified) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCool.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_rounded, size: 12, color: AppColors.accentCool),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        '已认证',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.accentCool,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${companion.city} · ${companion.experienceYears}年经验',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
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
            // Middle: Skills as small icon + text tags (radius 12)
            if (companion.tags.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
              children: companion.tags.take(4).map((tag) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 72),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentWarm.withValues(alpha: 0.1),
                          AppColors.accentWarm.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accentWarm.withValues(alpha: 0.25),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _companionTagToIcon(tag),
                          size: 12,
                          color: AppColors.accentWarm.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            tag,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
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
            ],
            // Bottom: Rating | Orders | Price | [spacer] | Small booking button (right)
            const SizedBox(height: 6),
            Row(
              children: [
                Flexible(
                  flex: 0,
                  fit: FlexFit.loose,
                  child: RatingWidget(
                    rating: companion.rating,
                    iconSize: 11,
                    fontSize: 10,
                    suffix: '${companion.reviewCount}条',
                  ),
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    l10n?.companionServiceCount(companion.completedOrders) ??
                        '已服务${companion.completedOrders}次',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.accentWarm, const Color(0xFFE85A4A)],
                            stops: const [0.0, 1.0],
                          ).createShader(bounds),
                          child: Text(
                            '¥${companion.pricePerDay.toStringAsFixed(0)}',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        l10n?.companionPricePerDay ?? '/天',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPale,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n?.companionBookNow ?? '预约',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
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
