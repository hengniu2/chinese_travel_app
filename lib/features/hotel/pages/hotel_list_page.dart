import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_gradients.dart';
import '../data/hotel_model.dart';
import '../logic/hotel_provider.dart';
import '../theme/hotel_theme.dart';
import '../components/header.dart';
import '../components/filter_bar.dart';
import '../widgets/hotel_card.dart';
import '../widgets/hotel_card_skeleton.dart';
import '../widgets/hotel_floating_buttons.dart';
import '../../../shared/design_system/travel_primary_button.dart';

/// Hotel list: search, filter, sort, pagination, empty/error states.
class HotelListPage extends ConsumerStatefulWidget {
  const HotelListPage({super.key});

  @override
  ConsumerState<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends ConsumerState<HotelListPage> {
  int _filterIndex = 0;
  Timer? _searchDebounce;
  static const List<String> _filterLabels = [
    '智能排序',
    '区域位置',
    '酒店星级',
    '筛选',
  ];

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
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(HotelTheme.cardRadius))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(HotelTheme.grid3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  AppLocalizations.of(ctx)?.filterStar ?? '星级筛选',
                  style: AppTextStyles.headlineSmall),
              SizedBox(height: 16.h),
              ...([null, 3, 4, 5].map((star) {
                final selected =
                    ref.read(hotelListQueryProvider).star == star;
                return ListTile(
                  title: Text(star == null ? '不限' : '$star星'),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref.read(hotelListQueryProvider.notifier).setStar(star);
                    ref.read(hotelListStateProvider.notifier).applyQuery();
                    Navigator.pop(ctx);
                  },
                );
              })),
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
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(HotelTheme.cardRadius))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(HotelTheme.grid3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  AppLocalizations.of(ctx)?.filterPriceRange ?? '价格区间',
                  style: AppTextStyles.headlineSmall),
              SizedBox(height: 16.h),
              ...([
                (null, null, '不限'),
                (null, 300.0, '300以下'),
                (300.0, 600.0, '300-600'),
                (600.0, 1000.0, '600-1000'),
                (1000.0, null, '1000以上'),
              ].map((e) {
                final selected = q.priceMin == e.$1 && q.priceMax == e.$2;
                return ListTile(
                  title: Text(e.$3 == '不限' ? e.$3 : '¥${e.$3}'),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref
                        .read(hotelListQueryProvider.notifier)
                        .setPriceRange(e.$1, e.$2);
                    ref.read(hotelListStateProvider.notifier).applyQuery();
                    Navigator.pop(ctx);
                  },
                );
              })),
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.98),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppGradients.hotelHeaderMint.first
                  .withValues(alpha: theme.brightness == Brightness.dark ? 0.15 : 0.08),
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.35],
          ),
        ),
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n is ScrollEndNotification) return false;
                final m = n.metrics;
                if (m.pixels >= m.maxScrollExtent - 200) {
                  ref.read(hotelListStateProvider.notifier).loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: HotelHeader(
                        title: l10n?.hotelListTitle ?? '酒店列表',
                        cityName: '北京',
                        searchPlaceholder:
                            l10n?.hotelSearchPlaceholder ?? '酒店 / 关键词 / 品牌',
                        searchKeyword: queryState.searchKeyword,
                        onCityTap: () {},
                        onSearchChanged: _onSearchChanged,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _FilterBarDelegate(
                        child: HotelFilterBar(
                          labels: _filterLabels,
                          selectedIndex: _filterIndex,
                          onSelected: _onFilterSelected,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: HotelTheme.grid2.h)),
                    if (listState.error != null)
                      ..._buildErrorSlivers(listState.error!, l10n),
                    if (listState.error == null &&
                        listState.loading &&
                        listState.items.isEmpty)
                      ..._buildSkeletonSlivers(),
                    if (listState.error == null &&
                        !listState.loading &&
                        listState.items.isEmpty)
                      ..._buildEmptySlivers(l10n),
                    if (listState.error == null && listState.items.isNotEmpty)
                      ..._buildListSlivers(listState.items, l10n),
                    if (listState.loadingMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: HotelTheme.grid3.h),
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
            const HotelFloatingButtons(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildErrorSlivers(
      HotelListError error, AppLocalizations? l10n) {
    final message = error == HotelListError.noInternet
        ? '网络不可用，请检查后重试'
        : '加载失败，请重试';
    final theme = Theme.of(context);
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: _HotelEmptyIllustration(
          icon: error == HotelListError.noInternet
              ? Icons.wifi_off_rounded
              : Icons.error_outline_rounded,
          message: message,
          actionLabel: l10n?.commonRetry ?? '重试',
          onAction: () =>
              ref.read(hotelListStateProvider.notifier).loadFirst(),
          iconColor: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }

  List<Widget> _buildSkeletonSlivers() {
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: HotelTheme.grid2.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: EdgeInsets.only(bottom: HotelTheme.grid2.h),
              child: const HotelCardSkeleton(),
            ),
            childCount: 5,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEmptySlivers(AppLocalizations? l10n) {
    final theme = Theme.of(context);
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: _HotelEmptyIllustration(
          icon: Icons.hotel_rounded,
          message: l10n?.hotelEmpty ?? '暂无符合条件的酒店',
          actionLabel: l10n?.commonRetry ?? '重试',
          onAction: _onRefresh,
          iconColor: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }

  List<Widget> _buildListSlivers(
      List<HotelItem> hotels, AppLocalizations? l10n) {
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: HotelTheme.grid2.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final hotel = hotels[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(hotel.id),
                tween: Tween(begin: 0, end: 1),
                duration: HotelTheme.animationNormal +
                    (HotelTheme.animationStagger * index.clamp(0, 5)),
                curve: HotelTheme.animationCurve,
                builder: (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, HotelTheme.grid2 * (1 - value)),
                    child: child!,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: HotelTheme.grid2.h),
                  child: HotelCard(
                    hotel: hotel,
                    viewDetailLabel: l10n?.hotelViewDetail ?? '查看详情',
                    onTap: () => context.push('/hotels/${hotel.id}'),
                  ),
                ),
              );
            },
            childCount: hotels.length,
          ),
        ),
      ),
    ];
  }
}

class _HotelEmptyIllustration extends StatelessWidget {
  const _HotelEmptyIllustration({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: HotelTheme.grid3.w,
        vertical: HotelTheme.grid4.h,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: message,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.06),
                    ),
                  ),
                  Container(
                    width: 88.w,
                    height: 88.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  Icon(icon, size: 48.sp, color: color),
                ],
              ),
            ),
            SizedBox(height: HotelTheme.grid3.h),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: HotelTheme.grid3.h),
              TravelPrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                expand: false,
              ),
            ],
          ],
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
