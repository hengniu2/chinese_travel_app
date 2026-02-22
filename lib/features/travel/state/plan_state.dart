import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../services/planner_service.dart';

/// Current planner result (set after submit). Used by result page and for save/edit/share.
final currentPlannerResultProvider =
    StateProvider<PlannerResult?>((ref) => null);

/// List of plans saved by the user. Persisted in memory; can add persistence later.
final savedPlansProvider =
    StateNotifierProvider<PlanStateNotifier, List<SavedPlan>>(
  (ref) => PlanStateNotifier(),
);

class PlanStateNotifier extends StateNotifier<List<SavedPlan>> {
  PlanStateNotifier() : super([]);

  void savePlan(SavedPlan plan) {
    state = [...state, plan];
  }

  void removePlan(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

/// Extension or helper: build SavedPlan from current result.
SavedPlan savedPlanFromResult(PlannerResult result, {String? name}) {
  final id = 'plan_${result.request.destination ?? "trip"}_${DateTime.now().millisecondsSinceEpoch}';
  return SavedPlan(
    id: id,
    request: result.request,
    recommendedPackageIds:
        result.recommendedPackages.map((p) => p.id).toList(),
    savedAt: DateTime.now(),
    name: name,
  );
}
