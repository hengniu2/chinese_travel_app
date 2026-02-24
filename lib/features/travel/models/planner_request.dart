import 'package:flutter/material.dart';

/// Request payload for the smart planner / custom plan flow.
class PlannerRequest {
  const PlannerRequest({
    this.destination,
    this.departureCity,
    this.dates,
    this.travelers,
    this.budgetRange,
    this.themes = const [],
    this.preferences,
  });

  final String? destination;
  final String? departureCity;
  final DateTimeRange? dates;
  final int? travelers;
  final PriceRange? budgetRange;
  final List<String> themes;
  final String? preferences;

  PlannerRequest copyWith({
    String? destination,
    String? departureCity,
    DateTimeRange? dates,
    int? travelers,
    PriceRange? budgetRange,
    List<String>? themes,
    String? preferences,
  }) {
    return PlannerRequest(
      destination: destination ?? this.destination,
      departureCity: departureCity ?? this.departureCity,
      dates: dates ?? this.dates,
      travelers: travelers ?? this.travelers,
      budgetRange: budgetRange ?? this.budgetRange,
      themes: themes ?? this.themes,
      preferences: preferences ?? this.preferences,
    );
  }
}

/// Budget range for planner (min–max or single target).
class PriceRange {
  const PriceRange({this.min, this.max});

  final double? min;
  final double? max;

  PriceRange copyWith({double? min, double? max}) {
    return PriceRange(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}
