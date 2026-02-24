import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/hotel_bundle_mock.dart';
import '../../domain/hotel_detail.dart';
import '../../domain/hotel_item.dart';
import '../../providers/hotel_providers.dart';
import '../widgets/hotel_bundle_card.dart';
import '../widgets/hotel_card.dart';
import '../widgets/hotel_detail_banner.dart';
import '../widgets/hotel_detail_booking_bar.dart';
import '../widgets/hotel_favorite_button.dart';
import '../widgets/hotel_detail_date_bar.dart';
import '../widgets/hotel_detail_facilities_grid.dart';
import '../widgets/hotel_detail_info_card.dart';
import '../widgets/hotel_detail_policy_section.dart';
import '../widgets/hotel_detail_room_card.dart';
import '../widgets/hotel_ui_constants.dart';

/// 酒店详情页：数据来自 Riverpod，日期选择、收藏、分享、地图
class HotelDetailPage extends ConsumerStatefulWidget {
  const HotelDetailPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends ConsumerState<HotelDetailPage> {
  @override
  void initState() {
    super.initState();
    final range = ref.read(hotelSelectedDatesProvider);
    if (range == null) {
      final now = DateTime.now();
      ref.read(hotelSelectedDatesProvider.notifier).state = DateTimeRange(start: now, end: now.add(const Duration(days: 1)));
    }
  }

  void _onShare(HotelDetail detail) {
    final link = 'https://app.example.com/hotels/${detail.id}';
    // Copy to clipboard (Flutter: Clipboard.setData)
    Clipboard.setData(ClipboardData(text: link));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('链接已复制'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _onMapTap(String address) async {
    final encoded = Uri.encodeComponent(address);
    final url = Uri.parse('https://maps.google.com/?q=$encoded');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  List<Widget> _buildSimilarHotelsSection(
    BuildContext context,
    String hotelId,
    ThemeData theme,
    AppLocalizations? l10n,
  ) {
    final similarAsync = ref.watch(similarHotelsProvider(hotelId));
    return similarAsync.when(
      data: (list) {
        if (list.isEmpty) return [];
        final title = l10n?.hotelSimilarHotels ?? '相似酒店';
        return [
          SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid3.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
              child: Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid2.h)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 132.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(width: HotelUIConstants.grid2.w),
                itemBuilder: (_, index) {
                  final item = list[index];
                  return SizedBox(
                    width: 200.w,
                    child: HotelCard(
                      hotel: item,
                      viewDetailLabel: l10n?.hotelViewDetail ?? '查看详情',
                      onTap: () => context.push('/hotels/${item.id}'),
                      imageCacheWidth: 200,
                      imageCacheHeight: 132,
                    ),
                  );
                },
              ),
            ),
          ),
        ];
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }

  List<Widget> _buildBundleSection(
    BuildContext context,
    String hotelId,
    ThemeData theme,
    AppLocalizations? l10n,
  ) {
    final bundles = getBundlesForHotel(hotelId);
    if (bundles.isEmpty) return [];
    return [
      SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid3.h)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
          child: Text(
            l10n?.hotelBundleSectionTitle ?? '超值套餐推荐',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid2.h)),
      ...bundles.map(
        (b) => SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: HotelUIConstants.grid2.w,
              right: HotelUIConstants.grid2.w,
              bottom: HotelUIConstants.grid2.h,
            ),
            child: HotelBundleCard(
              bundle: b,
              onBookBundle: () => context.push('/hotels/$hotelId/order?bundleId=${b.id}'),
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> _openDatePicker() async {
    final range = ref.read(hotelSelectedDatesProvider) ?? DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: range,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      ref.read(hotelSelectedDatesProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(hotelDetailProvider(widget.id));
    final dates = ref.watch(hotelSelectedDatesProvider);
    final favorites = ref.watch(hotelFavoritesProvider);
    final isFavorite = favorites.contains(widget.id);
    final l10n = AppLocalizations.of(context);

    return detailAsync.when(
      data: (detail) {
        if (detail == null) {
          final theme = Theme.of(context);
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.06),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hotel_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(height: HotelUIConstants.grid3.h),
                    Text(
                      l10n?.hotelNoRooms ?? '暂无可订房型',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: HotelUIConstants.grid3.h),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(l10n?.commonRetry ?? '返回'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final checkIn = dates?.start ?? DateTime.now();
        final checkOut = dates?.end ?? checkIn.add(const Duration(days: 1));
        final lowestPrice = detail.rooms.isEmpty ? 0.0 : detail.rooms.map((r) => r.price).reduce((a, b) => a < b ? a : b);

        final theme = Theme.of(context);
        final isTablet = HotelUIConstants.isTablet(context);
        final bannerHeight = isTablet ? 320.0 : 280.0;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.04),
                  theme.colorScheme.surface,
                ],
                stops: const [0.0, 0.25],
              ),
            ),
            child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    expandedHeight: bannerHeight,
                    pinned: true,
                    stretch: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => context.pop(),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.share_rounded),
                        onPressed: () => _onShare(detail),
                      ),
                      HotelFavoriteButton(
                        isFavorite: isFavorite,
                        onToggle: () => ref.read(hotelFavoritesProvider.notifier).toggle(widget.id),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: HotelDetailBanner(
                        detail: detail,
                        height: bannerHeight,
                        cornerRadius: 24,
                        isFavorite: isFavorite,
                        showOverlayButtons: false,
                        onShareTap: () => _onShare(detail),
                        onFavoriteTap: () => ref.read(hotelFavoritesProvider.notifier).toggle(widget.id),
                      ),
                      stretchModes: const [StretchMode.zoomBackground],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -24),
                      child: HotelDetailInfoCard(
                        detail: detail,
                        onMapTap: () => _onMapTap(detail.address),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid3.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                      child: HotelDetailDateBar(
                        checkIn: checkIn,
                        checkOut: checkOut,
                        onTap: _openDatePicker,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid3.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                      child: Text(
                        '房型列表',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid2.h)),
                  if (detail.rooms.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                        child: CartoonEmptyState(
                          type: CartoonEmptyType.noRooms,
                          message: l10n?.emptyStateNoRooms ?? '暂无可用房型，换个日期试试吧～',
                          onRetry: () => ref.invalidate(hotelDetailProvider(widget.id)),
                          retryLabel: l10n?.commonRetry ?? '重试',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => RepaintBoundary(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: HotelUIConstants.grid2.h),
                              child: HotelDetailRoomCard(
                                key: ValueKey('${detail.id}_room_$i'),
                                room: detail.rooms[i],
                                hotelId: detail.id,
                                roomIndex: i,
                              ),
                            ),
                          ),
                          childCount: detail.rooms.length,
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,
                        ),
                      ),
                    ),
                  ..._buildBundleSection(context, detail.id, theme, l10n),
                  SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid4.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                      child: HotelDetailPolicySection(detail: detail),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: HotelUIConstants.grid3.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w),
                      child: HotelDetailFacilitiesGrid(facilities: detail.facilities),
                    ),
                  ),
                  _buildSimilarHotelsSection(context, detail.id, theme, l10n),
                  SliverToBoxAdapter(child: SizedBox(height: 120.h)),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _AnimatedBookingBar(
                  visible: true,
                  child: HotelDetailBookingBar(
                    lowestPrice: lowestPrice,
                    hotelId: detail.id,
                    buttonLabel: l10n?.hotelViewRoomTypes ?? '查看房型',
                    onTap: () => context.push('/hotels/${detail.id}/order'),
                  ),
                ),
              ),
            ],
          ),
        ),
        );
      },
      loading: () {
        final theme = Theme.of(context);
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.04),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
                  ),
                  SizedBox(height: HotelUIConstants.grid3.h),
                  Text(
                    l10n?.commonLoading ?? '加载中...',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (err, _) {
        final theme = Theme.of(context);
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.04),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  SizedBox(height: HotelUIConstants.grid3.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid4.w),
                    child: Text(
                      l10n?.paymentFailedHint ?? '加载失败，请重试',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: HotelUIConstants.grid3.h),
                  TextButton(
                    onPressed: () => ref.invalidate(hotelDetailProvider(widget.id)),
                    child: Text(l10n?.commonRetry ?? '重试'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedBookingBar extends StatelessWidget {
  const _AnimatedBookingBar({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 1),
      duration: _duration,
      curve: _curve,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: _duration,
        child: child,
      ),
    );
  }
}
