import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/data/catalog_repository.dart';
import '../../catalog/data/catalog_repository_provider.dart';
import '../models/companion_detail.dart';
import 'companion_detail_from_api_mapper.dart';

/// Fetches companion detail from API: profile + rating + reviews + availability.
/// Use this to drive CompanionDetailPage with real data.
final companionDetailProvider = FutureProvider.family<CompanionDetail, String>((ref, companionId) async {
  final catalog = ref.read(catalogRepositoryProvider);
  final profile = await catalog.getCompanion(companionId);
  final from = DateTime.now();
  final to = from.add(const Duration(days: 90));
  final ratingFuture = catalog.getCompanionRating(companionId);
  final reviewsFuture = catalog.getCompanionReviews(companionId, page: 1, pageSize: 20);
  final availabilityFuture = catalog.getCompanionAvailability(
    companionId,
    from: from.toIso8601String().substring(0, 10),
    to: to.toIso8601String().substring(0, 10),
  );
  final ratingData = await ratingFuture;
  final reviewsResp = await reviewsFuture;
  final slots = await availabilityFuture;
  final reviewItems = reviewsResp.items;
  return companionDetailFromApi(
    profile: profile,
    rating: ratingData,
    reviewItems: reviewItems,
    availabilitySlots: slots is List ? slots : null,
  );
});
