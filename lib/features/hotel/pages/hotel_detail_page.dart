import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../data/hotel_model.dart';
import '../logic/hotel_provider.dart';
import '../theme/hotel_theme.dart';
import '../widgets/hotel_detail_banner.dart';
import '../widgets/hotel_detail_booking_bar.dart';
import '../widgets/hotel_detail_info_card.dart';
import '../widgets/hotel_detail_policy_section.dart';
import '../widgets/hotel_detail_facilities_grid.dart';
import '../components/date_selector.dart';
import '../widgets/room_card.dart';

/// Hotel detail: banner, info, dates, rooms, policy, facilities, booking bar.
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
      ref.read(hotelSelectedDatesProvider.notifier).state =
          DateTimeRange(start: now, end: now.add(const Duration(days: 1)));
    }
  }

  void _onShare(HotelDetail detail) {
    Clipboard.setData(ClipboardData(text: 'https://app.example.com/hotels/${detail.id}'));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('链接已复制'),
            behavior: SnackBarBehavior.floating),
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

  Future<void> _openDatePicker() async {
    final range = ref.read(hotelSelectedDatesProvider) ??
        DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)));
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: range,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: AppColors.primary),
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
                    Icon(Icons.hotel_rounded,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(height: HotelTheme.grid3.h),
                    Text(
                      l10n?.hotelNoRooms ?? '暂无可订房型',
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: HotelTheme.grid3.h),
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
        final lowestPrice = detail.rooms.isEmpty
            ? 0.0
            : detail.rooms.map((r) => r.price).reduce((a, b) => a < b ? a : b);
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
                stops: const [0.0, 0.25],
              ),
            ),
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(
                      child: HotelDetailBanner(
                        detail: detail,
                        height: 280,
                        cornerRadius: 24,
                        isFavorite: isFavorite,
                        onShareTap: () => _onShare(detail),
                        onFavoriteTap: () => ref
                            .read(hotelFavoritesProvider.notifier)
                            .toggle(widget.id),
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
                    SliverToBoxAdapter(child: SizedBox(height: HotelTheme.grid3.h)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: HotelTheme.grid2.w),
                        child: HotelDateSelector(
                          checkIn: checkIn,
                          checkOut: checkOut,
                          onTap: _openDatePicker,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: HotelTheme.grid3.h)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: HotelTheme.grid2.w),
                        child: Text(
                          '房型列表',
                          style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: HotelTheme.grid2.h)),
                    if (detail.rooms.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: HotelTheme.grid2.w),
                          child: Center(
                            child: Text(
                              l10n?.hotelNoRooms ?? '暂无可订房型',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                            horizontal: HotelTheme.grid2.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: HotelTheme.grid2.h),
                              child: HotelRoomCard(
                                room: detail.rooms[i],
                                hotelId: detail.id,
                                roomIndex: i,
                              ),
                            ),
                            childCount: detail.rooms.length,
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: HotelTheme.grid4.h)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: HotelTheme.grid2.w),
                        child: HotelDetailPolicySection(detail: detail),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: HotelTheme.grid3.h)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: HotelTheme.grid2.w),
                        child: HotelDetailFacilitiesGrid(
                            facilities: detail.facilities),
                      ),
                    ),
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
                      buttonLabel:
                          l10n?.hotelViewRoomTypes ?? '查看房型',
                      onTap: () =>
                          context.push('/hotels/${detail.id}/order'),
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
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary),
                  ),
                  SizedBox(height: HotelTheme.grid3.h),
                  Text(
                    l10n?.commonLoading ?? '加载中...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
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
                  Icon(Icons.error_outline_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant),
                  SizedBox(height: HotelTheme.grid3.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: HotelTheme.grid4.w),
                    child: Text(
                      l10n?.paymentFailedHint ?? '加载失败，请重试',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: HotelTheme.grid3.h),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(hotelDetailProvider(widget.id)),
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
  const _AnimatedBookingBar(
      {required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 320),
          child: child),
    );
  }
}
