import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/planner_request.dart';

/// Smart planner form state (destination, dates, travelers, budget, themes).
/// Business logic for planner flow; not mixed with UI state.
class PlannerFormState {
  const PlannerFormState({
    this.request = const PlannerRequest(),
    this.isSubmitting = false,
    this.submitError,
  });

  final PlannerRequest request;
  final bool isSubmitting;
  final String? submitError;

  PlannerFormState copyWith({
    PlannerRequest? request,
    bool? isSubmitting,
    String? submitError,
  }) {
    return PlannerFormState(
      request: request ?? this.request,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError,
    );
  }
}

final plannerFormStateProvider =
    StateNotifierProvider<PlannerFormStateNotifier, PlannerFormState>(
  (ref) => PlannerFormStateNotifier(),
);

class PlannerFormStateNotifier extends StateNotifier<PlannerFormState> {
  PlannerFormStateNotifier() : super(const PlannerFormState());

  void updateRequest(PlannerRequest request) {
    state = state.copyWith(request: request, submitError: null);
  }

  void setSubmitting(bool submitting) {
    state = state.copyWith(isSubmitting: submitting);
  }

  void setSubmitError(String? message) {
    state = state.copyWith(submitError: message, isSubmitting: false);
  }

  void reset() {
    state = const PlannerFormState();
  }
}
