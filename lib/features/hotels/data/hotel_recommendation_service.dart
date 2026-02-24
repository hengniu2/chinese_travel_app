import 'dart:math';

import '../domain/hotel_item.dart';
import '../domain/hotel_recommendation_prefs.dart';

/// Weights for the simulated recommendation score (sum should be 1.0).
class RecommendationWeights {
  const RecommendationWeights({
    this.ratingWeight = 0.3,
    this.distanceWeight = 0.2,
    this.priceWeight = 0.25,
    this.userPreferenceWeight = 0.25,
  });

  final double ratingWeight;
  final double distanceWeight;
  final double priceWeight;
  final double userPreferenceWeight;
}

/// Result of scoring: sorted list + ids for "为你精选" and "猜你喜欢".
class HotelRecommendationResult {
  const HotelRecommendationResult({
    required this.sortedItems,
    required this.pickedIds,
    required this.guessLikeIds,
  });

  final List<HotelItem> sortedItems;
  final Set<String> pickedIds;
  final Set<String> guessLikeIds;
}

/// Simulated AI recommendation: score by rating, distance, price, user prefs.
HotelRecommendationResult computeRecommendations(
  List<HotelItem> items,
  HotelRecommendationPrefs prefs, {
  RecommendationWeights weights = const RecommendationWeights(),
  int pickedCount = 3,
  int guessLikeCount = 5,
}) {
  if (items.isEmpty) {
    return HotelRecommendationResult(
      sortedItems: [],
      pickedIds: {},
      guessLikeIds: {},
    );
  }

  final scores = <String, double>{};
  final scoreList = items.map((h) {
    final s = _scoreHotel(h, prefs, weights, items);
    scores[h.id] = s;
    return (h, s);
  }).toList();
  scoreList.sort((a, b) => b.$2.compareTo(a.$2));
  final sorted = scoreList.map((e) => e.$1).toList();

  final pickedIds = sorted.take(pickedCount).map((h) => h.id).toSet();
  final guessLikeIds = sorted.skip(pickedCount).take(guessLikeCount).map((h) => h.id).toSet();

  return HotelRecommendationResult(
    sortedItems: sorted,
    pickedIds: pickedIds,
    guessLikeIds: guessLikeIds,
  );
}

double _scoreHotel(
  HotelItem h,
  HotelRecommendationPrefs prefs,
  RecommendationWeights w,
  List<HotelItem> all,
) {
  double ratingScore = 0.5;
  if (h.score != null) {
    ratingScore = (h.score!.clamp(0.0, 5.0)) / 5.0;
  }

  double distanceScore = 0.5;
  if (h.distanceKm != null) {
    distanceScore = 1.0 - (h.distanceKm!.clamp(0.0, 20.0) / 20.0);
  }

  double priceScore = 0.5;
  if (prefs.budgetMin != null || prefs.budgetMax != null) {
    final min = prefs.budgetMin ?? 0.0;
    final max = prefs.budgetMax ?? double.infinity;
    if (h.price >= min && h.price <= max) {
      priceScore = 1.0;
    } else if (h.price < min) {
      priceScore = 0.7;
    } else {
      final overspend = h.price - max;
      priceScore = (1.0 - (overspend / (max + 100)).clamp(0.0, 1.0)).clamp(0.0, 1.0);
    }
  } else {
    final prices = all.map((x) => x.price).where((p) => p > 0).toList();
    if (prices.isNotEmpty) {
      final median = _median(prices);
      if (median > 0) {
        final ratio = h.price / median;
        priceScore = ratio <= 1.0 ? 1.0 - (1.0 - ratio) * 0.3 : (2.0 - ratio.clamp(1.0, 2.0));
        priceScore = priceScore.clamp(0.0, 1.0);
      }
    }
  }

  double prefScore = 0.5;
  if (prefs.preferredStar != null && h.star == prefs.preferredStar) prefScore += 0.2;
  if (prefs.preferredFacilities.isNotEmpty && h.features.isNotEmpty) {
    final match = prefs.preferredFacilities.where((f) => h.features.any((x) => x.contains(f) || f.contains(x))).length;
    prefScore += 0.2 * (match / prefs.preferredFacilities.length).clamp(0.0, 1.0);
  }
  if (prefs.preferredLocation != null && prefs.preferredLocation!.isNotEmpty) {
    if (h.address != null && h.address!.contains(prefs.preferredLocation!)) prefScore += 0.15;
    if (h.name.contains(prefs.preferredLocation!)) prefScore += 0.1;
  }
  if (prefs.bookingHistoryIds.contains(h.id)) prefScore += 0.1;
  prefScore = prefScore.clamp(0.0, 1.0);

  return w.ratingWeight * ratingScore +
      w.distanceWeight * distanceScore +
      w.priceWeight * priceScore +
      w.userPreferenceWeight * prefScore;
}

double _median(List<double> list) {
  final sorted = List<double>.from(list)..sort();
  final n = sorted.length;
  if (n == 0) return 0;
  if (n.isOdd) return sorted[n ~/ 2];
  return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
}
