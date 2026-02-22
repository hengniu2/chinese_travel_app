import '../models/planner_request.dart';
import 'planner_service.dart';

/// Future-ready: interface for AI-generated custom itineraries.
/// Implement with real AI/LLM integration when ready.
abstract class AIItineraryGenerator {
  /// Generates a custom itinerary draft from the planner request.
  /// Returns null if generation is disabled or fails.
  Future<CustomItineraryDraft?> generate(PlannerRequest request);
}

/// Stub implementation: returns a placeholder draft for UI development.
class StubAIItineraryGenerator implements AIItineraryGenerator {
  @override
  Future<CustomItineraryDraft?> generate(PlannerRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final destination = request.destination ?? 'your destination';
    final days = request.dates != null
        ? request.dates!.end.difference(request.dates!.start).inDays
        : 3;
    return CustomItineraryDraft(
      title: 'Custom draft: $destination',
      summary: 'AI-generated itinerary (placeholder). Connect your AI service to generate real day-by-day plans.',
      days: List.generate(
        days.clamp(1, 7),
        (i) => CustomItineraryDayDraft(
          dayNumber: i + 1,
          title: 'Day ${i + 1}',
          description: 'Activities for day ${i + 1} (AI-generated content will appear here).',
        ),
      ),
    );
  }
}
