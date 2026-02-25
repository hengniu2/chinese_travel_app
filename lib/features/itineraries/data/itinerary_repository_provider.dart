import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/authenticated_dio.dart';
import 'itinerary_repository.dart';

final itineraryRepositoryProvider = Provider<ItineraryRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return ItineraryRepository(dio);
});
