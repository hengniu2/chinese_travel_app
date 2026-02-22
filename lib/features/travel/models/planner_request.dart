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
}

/// Budget range for planner (min–max or single target).
class PriceRange {
  const PriceRange({this.min, this.max});

  final double? min;
  final double? max;
}
