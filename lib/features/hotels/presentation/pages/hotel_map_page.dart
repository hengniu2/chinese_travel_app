import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_item.dart';
import '../../providers/hotel_map_provider.dart';
import '../../providers/hotel_providers.dart';
import '../widgets/hotel_mini_card.dart';
import '../widgets/hotel_ui_constants.dart';

/// Map-based hotel discovery: price markers, cluster support, tap → mini card in bottom sheet.
class HotelMapPage extends ConsumerStatefulWidget {
  const HotelMapPage({super.key});

  @override
  ConsumerState<HotelMapPage> createState() => _HotelMapPageState();
}

class _HotelMapPageState extends ConsumerState<HotelMapPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hotelListStateProvider.notifier).loadFirst();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hotelsAsync = ref.watch(hotelMapListProvider);
    final selected = ref.watch(hotelMapSelectedProvider);
    final userAsync = ref.watch(userLocationProvider);

    final hotels = hotelsAsync;
    final userLatLng = userAsync.valueOrNull != null
        ? LatLng(
            userAsync.value!.latitude,
            userAsync.value!.longitude,
          )
        : null;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: kDefaultMapCenter,
              initialZoom: 11,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onMapEvent: (event) {
                if (event is MapEventMoveEnd) {
                  ref.read(hotelMapCenterProvider.notifier).state =
                      event.camera.center;
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.chinese_travel_app',
              ),
              if (userLatLng != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLatLng,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.info,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: hotels
                    .map(
                      (h) => Marker(
                        point: LatLng(h.latitude!, h.longitude!),
                        width: 56,
                        height: 36,
                        child: _PriceMarker(
                          hotel: h,
                          isSelected: selected?.id == h.id,
                          onTap: () {
                            ref
                                .read(hotelMapSelectedProvider.notifier)
                                .state = h;
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(HotelUIConstants.grid2.w),
              child: Row(
                children: [
                  _MapAppBarButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  if (userLatLng != null)
                    _MapAppBarButton(
                      icon: Icons.my_location_rounded,
                      onTap: () {
                        _mapController.move(userLatLng, 14);
                      },
                    ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.28,
            minChildSize: 0.12,
            maxChildSize: 0.6,
            snap: true,
            snapSizes: const [0.28, 0.45, 0.6],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(HotelUIConstants.cardRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        HotelUIConstants.grid2.w,
                        12.h,
                        HotelUIConstants.grid2.w,
                        8.h,
                      ),
                      child: Text(
                        l10n?.hotelMapSheetTitle ?? '选择酒店',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(
                          HotelUIConstants.grid2.w,
                          0,
                          HotelUIConstants.grid2.w,
                          HotelUIConstants.grid4.h + MediaQuery.paddingOf(context).bottom,
                        ),
                        children: [
                          if (selected != null) ...[
                            HotelMiniCard(
                              hotel: selected,
                              isActive: true,
                              onTap: () => context.push('/hotels/${selected.id}'),
                            ),
                            SizedBox(height: 12.h),
                          ],
                          ...hotels
                              .where((h) => selected == null || h.id != selected.id)
                              .take(10)
                              .map(
                                (h) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: HotelMiniCard(
                                    hotel: h,
                                    isActive: selected?.id == h.id,
                                    onTap: () {
                                      ref
                                          .read(hotelMapSelectedProvider.notifier)
                                          .state = h;
                                      _mapController.move(
                                        LatLng(h.latitude!, h.longitude!),
                                        14,
                                      );
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MapAppBarButton extends StatelessWidget {
  const _MapAppBarButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(HotelUIConstants.overlayButtonRadius),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(HotelUIConstants.overlayButtonRadius),
        child: SizedBox(
          width: HotelUIConstants.minTouchTarget,
          height: HotelUIConstants.minTouchTarget,
          child: Icon(icon, size: 22.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _PriceMarker extends StatefulWidget {
  const _PriceMarker({
    required this.hotel,
    required this.isSelected,
    required this.onTap,
  });

  final HotelItem hotel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_PriceMarker> createState() => _PriceMarkerState();
}

class _PriceMarkerState extends State<_PriceMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceScale;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.25), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(_PriceMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isSelected && widget.isSelected) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceScale,
        builder: (_, child) => Transform.scale(
          scale: _bounceScale.value,
          child: child,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primaryPale
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected ? AppColors.primary : AppColors.border,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¥',
                style: AppTextStyles.priceSmall.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.price,
                ),
              ),
              Text(
                widget.hotel.price.toStringAsFixed(0),
                style: AppTextStyles.titleSmall.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.price,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
