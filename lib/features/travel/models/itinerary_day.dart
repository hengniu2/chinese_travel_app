/// A single day in a travel package itinerary.
/// Optional storytelling fields for immersive "Experience Moments".
class ItineraryDay {
  const ItineraryDay({
    required this.dayNumber,
    required this.title,
    required this.description,
    this.highlights = const [],
    this.images = const [],
    this.mealsIncluded,
    this.hotelInfo,
    this.emotionalDescription,
    this.photographyHighlights = const [],
    this.localCultureInsight,
    this.mapPreviewUrl,
  });

  final int dayNumber;
  final String title;
  final String description;
  final List<String> highlights;
  final List<String> images;
  final String? mealsIncluded;
  final String? hotelInfo;
  /// Short emotional / storytelling line for "Experience Moments".
  final String? emotionalDescription;
  /// Photo tips or must-capture spots.
  final List<String> photographyHighlights;
  /// Local culture or insider note.
  final String? localCultureInsight;
  /// Optional static map image or deep link for this day's route.
  final String? mapPreviewUrl;
}
