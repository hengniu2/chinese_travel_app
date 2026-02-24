# Travel Service Module

Structured state management with Riverpod. Architecture prepared for API integration.

## Folder Structure

```
lib/features/travel_service/
├── data/                          # Repository layer
│   ├── flight_repository.dart     # Abstract interface
│   └── flight_repository_mock.dart # Mock implementation (swap for API)
│
├── models/                        # Domain models
│   ├── flight_search_params.dart  # SingleTrip, RoundTrip, MultiTrip params
│   ├── flight_item.dart           # Flight result item
│   ├── flight_filter.dart         # Filter/sort enum
│   ├── flight_booking.dart        # Booking state
│   ├── flight_order.dart          # Order model
│   ├── payment_info.dart          # Payment method/status
│   └── models.dart                # Barrel export
│
├── providers/                     # Riverpod state
│   ├── flight_search_provider.dart  # Form state + search results
│   ├── filter_provider.dart         # Result filter (price/time/airline)
│   ├── booking_provider.dart        # Selected flight booking
│   ├── payment_provider.dart        # Payment flow
│   ├── order_provider.dart          # Order creation/fetch
│   └── travel_service_providers.dart # Barrel export
│
├── presentation/
│   ├── pages/
│   │   ├── travel_service_page.dart
│   │   ├── flight_result_page.dart
│   │   ├── flight_result_page_refactored.dart  # Example
│   │   └── ...
│   └── widgets/
│       ├── single_trip_form.dart
│       ├── single_trip_form_refactored.dart     # Example
│       └── ...
│
└── README.md
```

## Providers

| Provider | Purpose |
|----------|---------|
| `flightSearchFormProvider` | Form inputs (departure, arrival, dates, passengers, cabin) |
| `flightSearchResultsProvider` | Async flight list from repository |
| `flightFilterProvider` | Sort filter (price, departure time, airline) |
| `flightBookingProvider` | Selected flight for booking |
| `paymentProvider` | Payment method + processing state |
| `orderProvider` | Order creation + fetch |

## API Integration

Replace `FlightRepositoryMock` with an API implementation:

```dart
// data/flight_repository_api.dart
class FlightRepositoryApi implements FlightRepository {
  FlightRepositoryApi(this._dio);

  final Dio _dio;

  @override
  Future<FlightSearchResult> searchFlights(FlightSearchParams params) async {
    final response = await _dio.post('/flights/search', data: _toJson(params));
    return FlightSearchResult(flights: _parseFlights(response.data));
  }
  // ...
}
```

Then in `flight_search_provider.dart`:

```dart
final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  return FlightRepositoryApi(ref.read(dioClientProvider));
});
```

## Luxury theme

The Travel Service module uses a dedicated **luxury theme** (`theme/luxury_travel_theme.dart`): cream background `#F8F6F1`, primary gold `#C6A769`, dark text `#1E1E1E`, muted olive `#7A8F6A`, soft shadows, and Noto Serif SC for large titles.

### Example usage

**1. Use theme for a full screen (e.g. in router):**

```dart
import 'package:your_app/features/travel_service/theme/luxury_travel_theme.dart';

// Wrap any Travel Service page so Theme.of(context) returns luxury colors/typography
pageBuilder: (context, state) => NoTransitionPage(
  child: Theme(
    data: LuxuryTravelTheme.theme,
    child: const TravelServicePage(),
  ),
),
```

**2. Use colors and typography directly in widgets:**

```dart
import 'package:your_app/features/travel_service/theme/luxury_travel_theme.dart';

// Colors
Container(
  color: LuxuryTravelTheme.background,
  child: Text(
    'Title',
    style: LuxuryTravelTheme.displayLarge(LuxuryTravelTheme.darkText),
  ),
)

// Buttons: Theme.of(context).colorScheme.primary is gold when wrapped with LuxuryTravelTheme.theme
FilledButton(
  onPressed: () {},
  child: Text('搜索', style: LuxuryTravelTheme.buttonLabel(LuxuryTravelTheme.darkText)),
)

// Cards and shadows
decoration: BoxDecoration(
  color: LuxuryTravelTheme.cardBackground,
  borderRadius: BorderRadius.circular(20),
  boxShadow: LuxuryTravelTheme.softShadow,
),
```

**3. Tab bar and bottom nav:** The theme’s `ThemeData` includes `tabBarTheme` and `bottomNavigationBarTheme` (gold selected state). When the route is wrapped with `LuxuryTravelTheme.theme`, Material widgets inherit these.

---

## Example Usage (refactored widgets)

- **SingleTripFormRefactored**: Form wired to `flightSearchFormProvider`
- **FlightResultPageRefactored**: Results from `flightSearchResultsProvider`, filter from `flightFilterProvider`

To use the refactored widgets, swap imports in `travel_service_page.dart` and route to `FlightResultPageRefactored`.
