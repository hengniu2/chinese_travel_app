import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/hotel_repository.dart';
import '../../domain/hotel_item.dart';
import '../../data/hotel_recommendation_service.dart';
import '../../providers/hotel_compare_provider.dart';
import '../../providers/hotel_providers.dart';
import '../widgets/hotel_card.dart';
import '../widgets/hotel_card_skeleton.dart';
import '../widgets/hotel_floating_buttons.dart';
import '../widgets/hotel_list_filter_bar.dart';
import '../widgets/hotel_search_header.dart';
import '../widgets/hotel_ui_constants.dart';

/// 酒店列表页：排序 / 筛选 / 关键词搜索 / 分页 / 错误与空状态
class HotelsListPage extends ConsumerStatefulWidget {
  const HotelsListPage({super.key});

  @override
  ConsumerState<HotelsListPage> createState() => _HotelsListPageState();
}

class _HotelsListPageState extends ConsumerState<HotelsListPage> {
  int _filterIndex = 0;
  Timer? _searchDebounce;
  static const List<String> _filterLabels = ['智能排序', '区域位置', '酒店星级', '筛选'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hotelListStateProvider.notifier).loadFirst();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(hotelListQueryProvider.notifier).setSearchKeyword(value);
      ref.read(hotelListStateProvider.notifier).applyQuery();
    });
  }

  Future<void> _onRefresh() async {
    ref.read(hotelListQueryProvider.notifier).resetFilters();
    await ref.read(hotelListStateProvider.notifier).refresh();
  }

  void _onFilterSelected(int index) {
    setState(() => _filterIndex = index);
    if (index == 0) {
      ref.read(hotelListQueryProvider.notifier).setSort(HotelSort.default_);
      ref.read(hotelListStateProvider.notifier).applyQuery();
    } else if (index == 2) {
      _showStarSheet();
    } else if (index == 3) {
      _showFilterSheet();
    }
  }

  void _showStarSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(HotelUIConstants.cardRadius))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(HotelUIConstants.grid3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppLocalizations.of(ctx)?.filterStar ?? '星级筛选', style: AppTextStyles.headlineSmall),
              SizedBox(height: 16.h),
              ...[null, 3, 4, 5].map((star) {
                final selected = ref.read(hotelListQueryProvider).star == star;
                return ListTile(
                  title: Text(star == null ? '不限' : '$star星'),
                  trailing: selected ? Icon(Icons.check_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(hotelListQueryProvider.notifier).setStar(star);
                    ref.read(hotelListStateProvider.notifier).applyQuery();
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    final q = ref.read(hotelListQueryProvider);
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(HotelUIConstants.cardRadius))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(HotelUIConstants.grid3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppLocalizations.of(ctx)?.filterPriceRange ?? '价格区间', style: AppTextStyles.headlineSmall),
              SizedBox(height: 16.h),
              ...[
                (null, null, '不限'),
                (null, 300.0, '300以下'),
                (300.0, 600.0, '300-600'),
                (600.0, 1000.0, '600-1000'),
                (1000.0, null, '1000以上'),
              ].map((e) {
                final selected = q.priceMin == e.$1 && q.priceMax == e.$2;
                return ListTile(
                  title: Text(e.$3 == '不限' ? e.$3 : '¥${e.$3}'),
                  trailing: selected ? Icon(Icons.check_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(hotelListQueryProvider.notifier).setPriceRange(e.$1, e.$2);
                    ref.read(hotelListStateProvider.notifier).applyQuery();
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(hotelListStateProvider);
    final queryState = ref.watch(hotelListQueryProvider);
    final recommendationResult = ref.watch(hotelRecommendationResultProvider);
    final l10n = AppLocalizations.of(context);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.homeSearchCapsule,
              AppColors.homeSectionBlueStart.withValues(alpha: 0.4),
              AppColors.warmBackground,
            ],
            stops: const [0.0, 0.2, 0.6],
          ),
        ),
        child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollEndNotification) return false;
              final m = n.metrics;
              if (m.pixels >= m.maxScrollExtent - 200) ref.read(hotelListStateProvider.notifier).loadMore();
              return false;
            },
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: HotelSearchHeader(
                      title: l10n?.hotelListTitle ?? '酒店列表',
                      cityName: '北京',
                      searchPlaceholder: l10n?.hotelSearchPlaceholder ?? '酒店 / 关键词 / 品牌',
                      searchKeyword: queryState.searchKeyword,
                      onCityTap: () {},
                      onSearchChanged: _onSearchChanged,
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _FilterBarDelegate(
                      child: HotelListFilterBar(
                        labels: _filterLabels,
                        selectedIndex: _filterIndex,
                        onSelected: _onFilterSelected,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid2.h)),
                  if (listState.error != null) ..._buildErrorSlivers(listState.error!, l10n),
                  if (listState.error == null && listState.loading && listState.items.isEmpty) ..._buildSkeletonSlivers(),
                  if (listState.error == null && !listState.loading && listState.items.isEmpty) ..._buildEmptySlivers(l10n),
                  if (listState.error == null && listState.items.isNotEmpty) ..._buildListSlivers(context, listState.items, queryState, l10n, recommendationResult),
                  if (listState.loadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: HotelUIConstants.grid3.h),
                        child: Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final compareList = ref.watch(hotelCompareListProvider);
              return HotelFloatingButtons(
                compareCount: compareList.length,
                onMapTap: () => context.push('/hotels/map'),
                onCompareTap: () => context.push('/hotels/compare'),
              );
            },
          ),
        ],
      ),
    ));
  }

  List<Widget> _buildErrorSlivers(HotelListError error, AppLocalizations? l10n) {
    final message = error == HotelListError.noInternet
        ? (l10n?.emptyStateNoInternet ?? '网络开小差了，再试试吧')
        : (l10n?.emptyStateError ?? '加载失败，再试试吧');
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: CartoonEmptyState(
          type: CartoonEmptyType.noInternet,
          message: message,
          onRetry: () => ref.read(hotelListStateProvider.notifier).loadFirst(),
          retryLabel: l10n?.commonRetry ?? '重试',
        ),
      ),
    ];
  }

  List<Widget> _buildSkeletonSlivers() {
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: EdgeInsets.only(bottom: HotelUIConstants.grid2.h),
              child: const HotelCardSkeleton(),
            ),
            childCount: 5,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEmptySlivers(AppLocalizations? l10n) {
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: CartoonEmptyState(
          type: CartoonEmptyType.noHotels,
          message: l10n?.emptyStateNoHotels ?? '暂时没有找到合适的酒店哦～',
          onRetry: _onRefresh,
          retryLabel: l10n?.commonRetry ?? '重试',
        ),
      ),
    ];
  }

  List<Widget> _buildListSlivers(
    BuildContext context,
    List<HotelItem> hotels,
    HotelListQueryState queryState,
    AppLocalizations? l10n,
    HotelRecommendationResult? recommendationResult,
  ) {
    final isTablet = HotelUIConstants.isTablet(context);
    final viewDetailLabel = l10n?.hotelViewDetail ?? '查看详情';
    final compareList = ref.watch(hotelCompareListProvider);
    final compareNotifier = ref.read(hotelCompareListProvider.notifier);
    final theme = Theme.of(context);

    bool isInCompare(HotelItem h) => compareList.any((x) => x.id == h.id);
    bool canAdd(HotelItem h) => compareList.length < hotelCompareMaxCount && !isInCompare(h);

    final useSections = queryState.sort == HotelSort.default_ && recommendationResult != null;
    final List<HotelItem> orderedHotels = useSections ? recommendationResult!.sortedItems : hotels;
    final Set<String> pickedIds = useSections ? recommendationResult!.pickedIds : {};
    final Set<String> guessLikeIds = useSections ? recommendationResult!.guessLikeIds : {};

    Widget cardBuilder(HotelItem hotel, {required bool showSmartBadge}) {
      return HotelCard(
        key: ValueKey(hotel.id),
        hotel: hotel,
        viewDetailLabel: viewDetailLabel,
        onTap: () => context.push('/hotels/${hotel.id}'),
        imageCacheWidth: isTablet ? 400 : 336,
        imageCacheHeight: isTablet ? 320 : 212,
        isInCompare: isInCompare(hotel),
        canAddToCompare: canAdd(hotel),
        showSmartBadge: showSmartBadge,
        onCompareTap: () {
          if (isInCompare(hotel)) {
            compareNotifier.remove(hotel.id);
          } else {
            compareNotifier.add(hotel);
          }
        },
      );
    }

    if (useSections) {
      final picked = orderedHotels.where((h) => pickedIds.contains(h.id)).toList();
      final guessLike = orderedHotels.where((h) => guessLikeIds.contains(h.id)).toList();
      final rest = orderedHotels.where((h) => !pickedIds.contains(h.id) && !guessLikeIds.contains(h.id)).toList();
      final sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      );
      final slivers = <Widget>[];
      if (picked.isNotEmpty) {
        slivers.add(SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(HotelUIConstants.grid2.w, 0, HotelUIConstants.grid2.w, HotelUIConstants.grid1.h),
            child: Text(l10n?.hotelSmartPicked ?? '为你精选', style: sectionTitleStyle),
          ),
        ));
        slivers.add(_sliverListForHotels(picked, true, cardBuilder, isTablet));
      }
      if (guessLike.isNotEmpty) {
        slivers.add(SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(HotelUIConstants.grid2.w, HotelUIConstants.grid2.h, HotelUIConstants.grid2.w, HotelUIConstants.grid1.h),
            child: Text(l10n?.hotelGuessYouLike ?? '猜你喜欢', style: sectionTitleStyle),
          ),
        ));
        slivers.add(_sliverListForHotels(guessLike, true, cardBuilder, isTablet));
      }
      if (rest.isNotEmpty) {
        slivers.add(SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(HotelUIConstants.grid2.w, HotelUIConstants.grid2.h, HotelUIConstants.grid2.w, HotelUIConstants.grid1.h),
            child: Text(l10n?.hotelMoreHotels ?? '更多酒店', style: sectionTitleStyle),
          ),
        ));
        slivers.add(_sliverListForHotels(rest, false, cardBuilder, isTablet));
      }
      return slivers;
    }

    if (isTablet) {
      return [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: HotelUIConstants.grid2.h,
              crossAxisSpacing: HotelUIConstants.grid2.w,
              childAspectRatio: 1.15,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final hotel = orderedHotels[index];
                return RepaintBoundary(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: HotelUIConstants.grid2.h),
                    child: cardBuilder(hotel, showSmartBadge: false),
                  ),
                );
              },
              childCount: orderedHotels.length,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final hotel = orderedHotels[index];
              final stagger = index.clamp(0, 4);
              return RepaintBoundary(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(hotel.id),
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 280 + (stagger * 40)),
                  curve: Curves.easeInOut,
                  builder: (_, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, HotelUIConstants.grid2 * (1 - value)),
                      child: child!,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: HotelUIConstants.grid2.h),
                    child: cardBuilder(hotel, showSmartBadge: false),
                  ),
                ),
              );
            },
            childCount: orderedHotels.length,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
          ),
        ),
      ),
    ];
  }

  Widget _sliverListForHotels(
    List<HotelItem> list,
    bool showSmartBadge,
    Widget Function(HotelItem hotel, {required bool showSmartBadge}) cardBuilder,
    bool isTablet,
  ) {
    if (isTablet) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: HotelUIConstants.grid2.h,
            crossAxisSpacing: HotelUIConstants.grid2.w,
            childAspectRatio: 1.15,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
              padding: EdgeInsets.only(bottom: HotelUIConstants.grid2.h),
              child: cardBuilder(list[index], showSmartBadge: showSmartBadge),
            ),
            childCount: list.length,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
          ),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: EdgeInsets.only(bottom: HotelUIConstants.grid2.h),
            child: cardBuilder(list[index], showSmartBadge: showSmartBadge),
          ),
          childCount: list.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  _FilterBarDelegate({required this.child});
  final Widget child;

  @override
  double get minExtent => 52;

  @override
  double get maxExtent => 52;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
