/// User preferences for AI-based hotel recommendation (simulated).
/// Factors: booking history, budget, location, room type, facilities.
class HotelRecommendationPrefs {
  const HotelRecommendationPrefs({
    this.budgetMin,
    this.budgetMax,
    this.preferredStar,
    this.preferredLocation,
    this.preferredRoomType,
    this.preferredFacilities = const [],
    this.bookingHistoryIds = const [],
  });

  final double? budgetMin;
  final double? budgetMax;
  final int? preferredStar;
  final String? preferredLocation;
  final String? preferredRoomType;
  final List<String> preferredFacilities;
  final List<String> bookingHistoryIds;
}
