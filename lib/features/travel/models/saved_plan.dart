import 'planner_request.dart';

/// A plan saved by the user (request + recommended package ids + metadata).
class SavedPlan {
  const SavedPlan({
    required this.id,
    required this.request,
    required this.recommendedPackageIds,
    required this.savedAt,
    this.name,
  });

  final String id;
  final PlannerRequest request;
  final List<String> recommendedPackageIds;
  final DateTime savedAt;
  final String? name;

  SavedPlan copyWith({
    String? id,
    PlannerRequest? request,
    List<String>? recommendedPackageIds,
    DateTime? savedAt,
    String? name,
  }) {
    return SavedPlan(
      id: id ?? this.id,
      request: request ?? this.request,
      recommendedPackageIds: recommendedPackageIds ?? this.recommendedPackageIds,
      savedAt: savedAt ?? this.savedAt,
      name: name ?? this.name,
    );
  }
}
