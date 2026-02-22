import 'cost_breakdown.dart';
import 'itinerary_day.dart';

/// Core travel product: package with itinerary, cost breakdown, policies, FAQ.
class TravelPackage {
  const TravelPackage({
    required this.id,
    required this.title,
    required this.subtitle,
    this.heroImages = const [],
    this.departureCity,
    this.destinations = const [],
    this.durationDays,
    this.durationNights,
    required this.price,
    this.originalPrice,
    this.tags = const [],
    this.themes = const [],
    this.groupSize,
    this.rating,
    this.reviewsCount,
    this.itinerary = const [],
    this.costBreakdown,
    this.policies,
    this.faq = const [],
    this.visaInfo,
    this.insuranceInfo,
    this.cancellationPolicy,
    this.importantNotes,
    this.reviews = const [],
    this.bookingsLast7Days,
    this.remainingCapacity,
    this.verifiedLocalPartner = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> heroImages;
  final String? departureCity;
  final List<String> destinations;
  final int? durationDays;
  final int? durationNights;
  final double price;
  final double? originalPrice;
  final List<String> tags;
  final List<String> themes;
  final String? groupSize;
  final double? rating;
  final int? reviewsCount;
  final List<ItineraryDay> itinerary;
  final CostBreakdown? costBreakdown;
  final String? policies;
  final List<FaqItem> faq;
  /// Notice: visa requirements.
  final String? visaInfo;
  /// Notice: insurance info.
  final String? insuranceInfo;
  /// Notice: cancellation policy.
  final String? cancellationPolicy;
  /// Notice: important notes.
  final String? importantNotes;
  /// User reviews for Reviews tab.
  final List<PackageReview> reviews;
  /// Social proof: number of people who booked in the last 7 days.
  final int? bookingsLast7Days;
  /// Remaining spots; if non-null and below threshold, show limited-stock UI.
  final int? remainingCapacity;
  /// Whether the operator is a verified local partner (trust badge).
  final bool verifiedLocalPartner;
}

/// Threshold below which to show "limited stock" indicator.
const int kLimitedStockThreshold = 6;

/// Single user review for package detail.
class PackageReview {
  const PackageReview({
    required this.authorName,
    required this.rating,
    required this.content,
    this.date,
  });

  final String authorName;
  final double rating;
  final String content;
  final String? date;
}

/// FAQ entry for package detail.
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
