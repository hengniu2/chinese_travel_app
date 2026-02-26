import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/authenticated_dio.dart';
import 'itinerary_repository.dart';

final itineraryRepositoryProvider = Provider<ItineraryRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return ItineraryRepository(dio);
});

final itineraryListProvider = FutureProvider<ItineraryListResponse>((ref) async {
  final repo = ref.watch(itineraryRepositoryProvider);
  return repo.list(page: 1, pageSize: 50);
});

final itineraryDetailProvider = FutureProvider.family<ApiItineraryDto, String>((ref, id) async {
  final repo = ref.watch(itineraryRepositoryProvider);
  return repo.get(id);
});
