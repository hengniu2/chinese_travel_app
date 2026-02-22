import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/design_system/app_shadow.dart';
import '../../data/companion_list_mock.dart';
import '../../domain/companion_list_item.dart';
import '../widgets/companion_card.dart';
import '../widgets/companion_featured_card.dart';
import '../widgets/companion_list_filter_bar.dart';

/// 陪游发现页（Mafengwo 风格：头部、筛选、热门横滑、列表）
class CompanionsShellPage extends StatefulWidget {
  const CompanionsShellPage({super.key});

  @override
  State<CompanionsShellPage> createState() => _CompanionsShellPageState();
}

class _CompanionsShellPageState extends State<CompanionsShellPage>
    with SingleTickerProviderStateMixin {
  CompanionListFilters _filters = const CompanionListFilters();
  List<CompanionListItem> _list = [];
  List<CompanionListItem> _featured = [];
  bool _loading = true;
  bool _loadingMore = false;
  int _sortIndex = 0;
  int _skillIndex = 0;
  int _filterIndex = 0;
  static const int _pageSize = 10;
  int _loadedCount = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const List<String> _filterLabels = [
    '全部',
    '性别',
    '价格区间',
    '评分',
    '距离',
  ];

  static const List<String> _skillTagOptions = [
    '全部',
    '摄影跟拍',
    '人文讲解',
    '美食推荐',
    '路线规划',
    '历史文化',
    '园林讲解',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();
    _loadFeatured();
    _loadFirst();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  CompanionSort get _sort => switch (_sortIndex) {
        1 => CompanionSort.rating,
        2 => CompanionSort.priceAsc,
        3 => CompanionSort.priceDesc,
        _ => CompanionSort.recommended,
      };

  void _applyFilters() {
    final tag = _skillIndex == 0 ? null : _skillTagOptions[_skillIndex];
    _filters = _filters.copyWith(sort: _sort, tag: tag);
    _loadFirst();
  }

  Future<void> _loadFeatured() async {
    final list = getFeaturedCompanions();
    if (mounted) setState(() => _featured = list);
  }

  Future<void> _loadFirst() async {
    setState(() {
      _loading = true;
      _loadedCount = 0;
    });
    await Future.delayed(const Duration(milliseconds: 600));
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
    _sortIndex = 0;
    _skillIndex = 0;
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
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final next = all.skip(_loadedCount).take(_pageSize).toList();
    setState(() {
      _list.addAll(next);
      _loadedCount = _list.length;
      _loadingMore = false;
    });
  }

  void _onSortChanged(int index) {
    setState(() {
      _sortIndex = index;
      _applyFilters();
    });
  }

  void _onSkillChanged(int index) {
    setState(() {
      _skillIndex = index;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
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
                slivers: [
                  _buildHeader(context, l10n),
                  SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                  SliverToBoxAdapter(
                    child: CompanionListFilterBar(
                      selectedIndex: _filterIndex,
                      onSelected: _onFilterChanged,
                      labels: _filterLabels,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  ..._buildFeaturedSection(l10n),
                  _buildSectionTitle(l10n?.companionSectionAll ?? '全部陪游'),
                  if (_loading) ..._buildSkeletonSlivers(),
                  if (!_loading && _list.isEmpty) ..._buildEmptySlivers(l10n),
                  if (!_loading && _list.isNotEmpty) ..._buildListSlivers(context, l10n),
                  if (_loadingMore) _buildLoadingMoreSliver(),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  static const double _headerHeight = 190;

  Widget _buildHeader(BuildContext context, AppLocalizations? l10n) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: Container(
        height: _headerHeight.h + topPadding,
        decoration: BoxDecoration(
          borderRadius: AppRadius.headerBottomRadius,
          boxShadow: AppShadow.medium,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.headerBottomRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // AI illustration background — stretched to top (no SafeArea)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/header_companion.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryGradientWarmEnd,
                          AppColors.primaryGradientWarmStart,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Content overlay with safe top padding so title/search are below status bar
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: const Alignment(0.5, -0.3),
                        child: Text(
                          l10n?.companionDiscoveryTitle ?? '找陪游',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: const Offset(0, 1),
                                blurRadius: 4,
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 14.h,
                        child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppShadow.floating,
                    ),
                    child: Row(
                      children: [
                        AppTapScale(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_rounded, size: 18.sp, color: AppColors.sectionCompanion),
                              SizedBox(width: 6.w),
                              Text(
                                l10n?.companionCityHint ?? '选择城市',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 2.w),
                              Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 18.h,
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          color: AppColors.divider,
                        ),
                        Expanded(
                          child: AppTapScale(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(Icons.search_rounded, size: 20.sp, color: AppColors.textTertiary),
                                SizedBox(width: 10.w),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),   // inner Stack
        ),       // Padding
      ),         // Positioned overlay
            ],   // outer Stack children
          ),     // outer Stack
        ),       // ClipRRect
      ),         // Container
    );           // SliverToBoxAdapter
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 8.h),
        child: Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeaturedSection(AppLocalizations? l10n) {
    if (_featured.isEmpty) return [];
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 8.h),
          child: Text(
            l10n?.companionSectionFeatured ?? '热门陪游',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _featured.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, i) => CompanionFeaturedCard(companion: _featured[i]),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildSkeletonSlivers() {
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.itemSpacing.h),
              child: _CompanionCardSkeleton(),
            ),
            childCount: 4,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEmptySlivers(AppLocalizations? l10n) {
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: Icon(Icons.person_search_rounded, size: 72.sp, color: AppColors.textTertiary),
          message: l10n?.companionEmpty ?? '暂无符合条件的陪游',
          actionLabel: l10n?.companionFilterAll ?? '全部',
          onAction: _onRefresh,
        ),
      ),
    ];
  }

  List<Widget> _buildListSlivers(BuildContext context, AppLocalizations? l10n) {
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final companion = _list[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(companion.id),
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (index.clamp(0, 5) * 50)),
                curve: Curves.easeOutCubic,
                builder: (_, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: CompanionCard(companion: companion),
                ),
              );
            },
            childCount: _list.length,
          ),
        ),
      ),
    ];
  }

  Widget _buildLoadingMoreSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _CompanionCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.cardRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 14.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Container(
                        height: 22.h,
                        width: 56.w,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 16.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
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
