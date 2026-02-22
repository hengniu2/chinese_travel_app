import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'ai_itinerary_generator.dart';
import 'planner_recommendation_engine.dart';
import 'travel_package_repository.dart';

/// Result of a planner submission: recommended packages (scored & sorted) and/or custom draft.
class PlannerResult {
  const PlannerResult({
    required this.request,
    this.recommendedPackages = const [],
    this.scoredPackages = const [],
    this.customItineraryDraft,
  });

  final PlannerRequest request;
  /// Sorted list of packages (best match first).
  final List<TravelPackage> recommendedPackages;
  /// Full scored list when UI needs score (e.g. "Match: 85%").
  final List<ScoredPackage> scoredPackages;
  /// When AI itinerary is used (future): custom draft; null for package-only flow.
  final CustomItineraryDraft? customItineraryDraft;
}

/// Placeholder for AI-generated custom itinerary (future-ready).
class CustomItineraryDraft {
  const CustomItineraryDraft({
    this.title,
    this.days = const [],
    this.summary,
  });

  final String? title;
  final List<CustomItineraryDayDraft> days;
  final String? summary;
}

class CustomItineraryDayDraft {
  const CustomItineraryDayDraft({
    this.dayNumber,
    this.title,
    this.description,
  });

  final int? dayNumber;
  final String? title;
  final String? description;
}

/// Service for smart planner: uses recommendation engine to match packages,
/// and (future) AI itinerary generator for custom drafts.
class PlannerService {
  PlannerService(this._repository, this._engine, [this._aiGenerator]);

  final TravelPackageRepository _repository;
  final PlannerRecommendationEngine _engine;
  final AIItineraryGenerator? _aiGenerator;

  /// Submits planner request: fetches packages, scores and sorts via engine,
  /// returns result with recommended package list.
  Future<PlannerResult> submitPlannerRequest(PlannerRequest request) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final packages = await _repository.getPackages();
    final scored = _engine.recommend(request: request, packages: packages);
    final recommended = scored.map((s) => s.package).toList();
    return PlannerResult(
      request: request,
      recommendedPackages: recommended,
      scoredPackages: scored,
    );
  }

  /// Generates a custom itinerary draft (AI placeholder). Use when user
  /// chooses "Custom itinerary" instead of package list.
  Future<CustomItineraryDraft?> generateCustomItinerary(PlannerRequest request) async {
    return _aiGenerator?.generate(request);
  }
}

final plannerServiceProvider = Provider<PlannerService>((ref) {
  final repo = ref.watch(travelPackageRepositoryProvider);
  return PlannerService(
    repo,
    PlannerRecommendationEngine(),
    StubAIItineraryGenerator(),
  );
});
