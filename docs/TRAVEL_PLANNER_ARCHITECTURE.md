# Travel Planner module — architecture (structure & logic)

Refactor completed: **structure and logic only**. No visual redesign.

---

## 1. Module structure

```
lib/features/travel/
├── landing/
│   └── travel_landing_page.dart      # Entry: Discover packages | Smart planner
├── discovery/
│   └── travel_discovery_page.dart    # List packages, filter → detail
├── detail/
│   ├── travel_detail_page.dart       # Package detail (tabs: Overview, Itinerary)
│   └── travel_booking_page.dart      # Booking flow from detail
├── planner/
│   ├── travel_planner_page.dart      # Smart planner form
│   └── planner_result_page.dart      # Custom plan result
├── components/
│   ├── package_card_placeholder.dart # Reusable package card (placeholder)
│   └── components.dart
├── models/
│   ├── travel_package.dart           # TravelPackage, FaqItem
│   ├── itinerary_day.dart            # ItineraryDay
│   ├── cost_breakdown.dart           # CostBreakdown
│   ├── planner_request.dart          # PlannerRequest, PriceRange
│   └── models.dart
├── services/
│   ├── travel_package_repository.dart
│   ├── travel_package_data_source.dart  # Mock data source
│   ├── planner_service.dart
│   └── services.dart
├── state/
│   ├── travel_ui_state.dart          # UI only: selected tab, filter sheet, etc.
│   ├── travel_filter_state.dart      # Discovery filters
│   ├── planner_form_state.dart       # Smart planner form
│   ├── package_data_state.dart       # Package list & detail (FutureProvider)
│   ├── booking_state.dart            # Booking flow state
│   └── state.dart
└── travel.dart                       # Barrel
```

---

## 2. Core data models

- **TravelPackage** — id, title, subtitle, heroImages, departureCity, destinations, durationDays/Nights, price, originalPrice, tags, themes, groupSize, rating, reviewsCount, itinerary, costBreakdown, policies, faq.
- **ItineraryDay** — dayNumber, title, description, highlights, images, mealsIncluded, hotelInfo.
- **CostBreakdown** — included, excluded, optionalAddOns (list of strings).
- **PlannerRequest** — destination, departureCity, dates (DateTimeRange?), travelers, budgetRange (PriceRange), themes, preferences.

---

## 3. Navigation flow

- **Landing** (`/planner`) → **Discovery** (`/planner/discovery`) or **Smart planner** (`/planner/planner`).
- **Landing** → **Smart planner** → **Custom plan result** (`/planner/planner/result`).
- **Discovery** → **Filter** (UI state: filter sheet) → **Detail** (`/planner/detail/:id`).
- **Detail** → **Itinerary tab** (UI state: selectedDetailTab) → **Booking** (`/planner/detail/:id/booking`).

Routes under the **planner** shell branch:

| Path | Page |
|------|------|
| `/planner` | TravelLandingPage |
| `/planner/discovery` | TravelDiscoveryPage |
| `/planner/detail/:id` | TravelDetailPage |
| `/planner/detail/:id/booking` | TravelBookingPage |
| `/planner/planner` | TravelPlannerPage |
| `/planner/planner/result` | PlannerResultPage |

---

## 4. State management (Riverpod)

- **UI state** — `travelUiStateProvider`: selectedDetailTab, isFilterSheetOpen, isPlannerFormExpanded. No business data.
- **Filter state** — `travelFilterStateProvider`: departureCity, destinations, priceMin/Max, durationDaysMin/Max, themes, groupSize.
- **Planner form state** — `plannerFormStateProvider`: PlannerRequest, isSubmitting, submitError.
- **Package data** — `travelPackageListProvider` (FutureProvider), `travelPackageDetailProvider(id)`, `selectedPackageIdProvider`.
- **Booking state** — `travelBookingStateProvider`: packageId, departureDate, travelerCount, notes.

UI and business logic are separated; filters and planner form are not mixed with package or booking state.

---

## 5. Smart planner logic (implemented)

- **PlannerRecommendationEngine** — Scores packages by budget range, destination, duration (from dates), themes, and group size. Weights: budget 30%, destination 30%, duration 20%, themes 12%, group size 8%. Returns `List<ScoredPackage>` sorted by score.
- **PlannerService** — Uses engine + repository: `submitPlannerRequest(request)` returns `PlannerResult` (request + recommendedPackages + scoredPackages). Optional `generateCustomItinerary(request)` calls **AIItineraryGenerator** (stub) for custom draft.
- **Plan state** — `currentPlannerResultProvider` (last result), `savedPlansProvider` (list of `SavedPlan`). Helpers: `savedPlanFromResult()`, Save / Edit / Share / Request consultant (UI actions).
- **AI itinerary** — `AIItineraryGenerator` interface + `StubAIItineraryGenerator` placeholder. Future: plug in real AI/LLM.

## 6. Next steps (UI system)

- Apply design system and HOME_STYLE_REFERENCE to landing, discovery, detail, planner, and booking.
- Replace placeholders with real list/detail/booking UI.
- Connect filter UI to `travelFilterStateProvider` and apply filters in discovery (e.g. in repository or derived provider).
- Planner form and result page are wired: submit → engine → result page with recommendations, Save/Edit/Share/Consultant, and optional custom itinerary draft.
