import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_package.dart';
import '../services/travel_package_repository.dart';

/// Package data state: list for discovery, selected package for detail.
/// Fetched via repository; filtered list derived from filter state.
final travelPackageListProvider = FutureProvider<List<TravelPackage>>((ref) {
  final repo = ref.watch(travelPackageRepositoryProvider);
  return repo.getPackages();
});

final travelPackageDetailProvider =
    FutureProvider.family<TravelPackage?, String>((ref, id) async {
  final repo = ref.watch(travelPackageRepositoryProvider);
  return repo.getPackageById(id);
});

/// Currently selected package ID (e.g. for detail → booking flow).
final selectedPackageIdProvider = StateProvider<String?>((ref) => null);
