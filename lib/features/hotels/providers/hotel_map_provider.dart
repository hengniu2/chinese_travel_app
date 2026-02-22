import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../domain/hotel_item.dart';
import 'hotel_providers.dart';

/// User's current position (nullable until permission granted and fetched).
final userLocationProvider = FutureProvider<Position?>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.denied) {
    return null;
  }
  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  } catch (_) {
    return null;
  }
});

/// Convert Position to LatLng for flutter_map.
LatLng? positionToLatLng(Position? p) =>
    p != null ? LatLng(p.latitude, p.longitude) : null;

/// Default map center (Beijing).
const LatLng kDefaultMapCenter = LatLng(39.908, 116.397);

/// Hotels that have coordinates, for map display. Sorted by distance when user location available.
final hotelMapListProvider = Provider<List<HotelItem>>((ref) {
  final listState = ref.watch(hotelListStateProvider);
  final userAsync = ref.watch(userLocationProvider);
  final items = listState.items
      .where((h) => h.latitude != null && h.longitude != null)
      .toList();
  final userPos = userAsync.valueOrNull;
  if (userPos != null && items.isNotEmpty) {
    final user = LatLng(userPos.latitude, userPos.longitude);
    const distance = Distance();
    items.sort((a, b) {
      final da = distance.as(
          LengthUnit.Kilometer, user, LatLng(a.latitude!, a.longitude!));
      final db = distance.as(
          LengthUnit.Kilometer, user, LatLng(b.latitude!, b.longitude!));
      return da.compareTo(db);
    });
  }
  return items;
});

/// Selected hotel on map (for mini card in bottom sheet). Null = none selected.
final hotelMapSelectedProvider = StateProvider<HotelItem?>((ref) => null);

/// Last map center for dynamic refresh. Optional.
final hotelMapCenterProvider = StateProvider<LatLng?>((ref) => null);
