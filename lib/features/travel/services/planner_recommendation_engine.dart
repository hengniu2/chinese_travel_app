import 'package:flutter/material.dart';

import '../models/models.dart';

/// Result of scoring one package against a planner request.
class ScoredPackage {
  const ScoredPackage({
    required this.package,
    required this.score,
    this.budgetMatch = 0,
    this.destinationMatch = 0,
    this.durationMatch = 0,
    this.themesMatch = 0,
    this.groupSizeMatch = 0,
  });

  final TravelPackage package;
  final double score;
  final double budgetMatch;
  final double destinationMatch;
  final double durationMatch;
  final double themesMatch;
  final double groupSizeMatch;
}

/// Intelligent recommendation engine: matches packages to planner request by
/// budget range, destination, duration, themes, and group size. Scores and sorts.
class PlannerRecommendationEngine {
  /// Weights for each dimension (sum = 1.0). Adjust for product priority.
  static const double _weightBudget = 0.30;
  static const double _weightDestination = 0.30;
  static const double _weightDuration = 0.20;
  static const double _weightThemes = 0.12;
  static const double _weightGroupSize = 0.08;

  /// Score and sort packages for the given request. Returns list sorted by
  /// score descending (best match first).
  List<ScoredPackage> recommend({
    required PlannerRequest request,
    required List<TravelPackage> packages,
  }) {
    if (packages.isEmpty) return [];

    final scored = packages.map((p) => _scoreOne(request, p)).toList();
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored;
  }

  ScoredPackage _scoreOne(PlannerRequest request, TravelPackage package) {
    final budget = _scoreBudget(request.budgetRange, package.price);
    final destination = _scoreDestination(request.destination, package);
    final duration = _scoreDuration(request.dates, package.durationDays);
    final themes = _scoreThemes(request.themes, package.themes);
    final groupSize = _scoreGroupSize(request.travelers, package.groupSize);

    final score = _weightBudget * budget +
        _weightDestination * destination +
        _weightDuration * duration +
        _weightThemes * themes +
        _weightGroupSize * groupSize;

    return ScoredPackage(
      package: package,
      score: score,
      budgetMatch: budget,
      destinationMatch: destination,
      durationMatch: duration,
      themesMatch: themes,
      groupSizeMatch: groupSize,
    );
  }

  /// 1.0 if price within range; 0.5 if slightly over/under; 0 if no range or far off.
  double _scoreBudget(PriceRange? range, double price) {
    if (range == null) return 1.0;
    final min = range.min;
    final max = range.max;
    if (min == null && max == null) return 1.0;
    if (min != null && max != null) {
      if (price >= min && price <= max) return 1.0;
      final span = max - min;
      if (price < min) {
        final over = (min - price) / (span > 0 ? span : 1);
        return over <= 0.5 ? 0.7 : (over <= 1 ? 0.4 : 0);
      }
      final over = (price - max) / (span > 0 ? span : 1);
      return over <= 0.5 ? 0.7 : (over <= 1 ? 0.4 : 0);
    }
    if (min != null) {
      if (price >= min) return 1.0;
      return price >= min * 0.8 ? 0.6 : 0;
    }
    // max only
    if (price <= max!) return 1.0;
    return price <= max * 1.2 ? 0.6 : 0;
  }

  /// 1.0 if destination matches (case-insensitive, contains or equals).
  double _scoreDestination(String? destination, TravelPackage package) {
    if (destination == null || destination.trim().isEmpty) return 1.0;
    final d = destination.trim().toLowerCase();
    for (final city in package.destinations) {
      if (city.toLowerCase().contains(d) || d.contains(city.toLowerCase())) {
        return 1.0;
      }
    }
    final title = package.title.toLowerCase();
    final subtitle = package.subtitle.toLowerCase();
    if (title.contains(d) || subtitle.contains(d)) return 0.8;
    return 0;
  }

  /// 1.0 if trip length fits requested date range length (days).
  double _scoreDuration(DateTimeRange? dates, int? packageDays) {
    if (packageDays == null) return 0.5;
    if (dates == null) return 1.0;
    final requestedDays = dates.end.difference(dates.start).inDays;
    if (requestedDays <= 0) return 1.0;
    final diff = (packageDays - requestedDays).abs();
    if (diff == 0) return 1.0;
    if (diff == 1) return 0.8;
    if (diff <= 2) return 0.5;
    return 0.2;
  }

  /// Overlap between request themes and package themes (normalized).
  double _scoreThemes(List<String> requestThemes, List<String> packageThemes) {
    if (requestThemes.isEmpty) return 1.0;
    if (packageThemes.isEmpty) return 0.3;
    final r = requestThemes.map((t) => t.trim().toLowerCase()).toSet();
    var matches = 0;
    for (final t in packageThemes) {
      if (r.contains(t.trim().toLowerCase())) matches++;
    }
    if (matches == 0) return 0;
    return (matches / r.length).clamp(0.0, 1.0);
  }

  /// 1.0 if traveler count fits group size (e.g. "2-8人" or "4-12人").
  double _scoreGroupSize(int? travelers, String? groupSize) {
    if (travelers == null) return 1.0;
    if (groupSize == null || groupSize.isEmpty) return 0.5;
    final s = groupSize.trim();
    // Try parse "2-8人" or "4-12人" style
    final regex = RegExp(r'(\d+)\s*[-–]\s*(\d+)');
    final match = regex.firstMatch(s);
    if (match != null) {
      final low = int.tryParse(match.group(1) ?? '') ?? 0;
      final high = int.tryParse(match.group(2) ?? '') ?? 0;
      if (travelers >= low && travelers <= high) return 1.0;
      if (travelers < low) return travelers >= low - 2 ? 0.6 : 0.2;
      return travelers <= high + 2 ? 0.6 : 0.2;
    }
    return 0.5;
  }
}
