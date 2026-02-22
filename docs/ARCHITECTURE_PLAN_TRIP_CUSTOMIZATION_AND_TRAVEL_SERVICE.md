# Architecture Plan: Trip Customization & Travel Service Search

**Status:** Plan only — no UI implementation yet.  
**Scope:** Two new feature modules aligned with existing Chinese travel super-app style and codebase patterns.  
**Visual reference:** `docs/HOME_STYLE_REFERENCE.md`, `docs/DESIGN_LANGUAGE.md`, and the provided UI screenshots (定制旅行, 出行服务).

---

## 1. Folder structure

Follow existing feature layout: `presentation/` (pages, widgets), `data/`, `domain/`, and `providers/` where state is non-trivial.

### 1.1 Trip Customization (定制旅行)

```
lib/features/trip_customization/
├── data/
│   ├── trip_customization_repository.dart   # (optional) API / submit handler
│   └── trip_customization_mock.dart         # 经典案例、行程案例 list data
├── domain/
│   ├── customization_type.dart              # enum: personal | team
│   ├── classic_case_item.dart               # 经典案例 card model
│   └── itinerary_case_item.dart             # 行程案例 card model
├── presentation/
│   ├── pages/
│   │   └── trip_customization_page.dart     # Main screen (定制旅行)
│   └── widgets/
│       ├── trip_customization_hero.dart    # Gradient hero + title + tagline chip
│       ├── customization_type_segment.dart # 个人定制 | 团队定制
│       ├── destination_input_tile.dart     # 我想去... with location icon
│       ├── phone_input_tile.dart           # +86 + phone placeholder
│       ├── classic_case_card.dart          # Image + duration overlay + label
│       ├── itinerary_case_card.dart        # Image + top-left overlay + label
│       └── horizontal_case_list.dart      # Reusable horizontal list of cards
├── providers/
│   └── trip_customization_provider.dart    # Form state + submit (Riverpod)
└── trip_customization.dart                 # Barrel export (optional)
```

**Routing:** Replace or reuse current `/custom-travel` → point to `TripCustomizationPage` (can keep `CustomTravelPage` name in router or rename to `trip_customization_page`).

---

### 1.2 Travel Service Search (出行服务)

```
lib/features/travel_service_search/
├── data/
│   ├── travel_service_search_repository.dart  # (optional) search API
│   └── travel_service_search_mock.dart        # Default stations, airlines, etc.
├── domain/
│   ├── trip_type.dart                         # enum: oneWay | roundTrip | multiCity
│   ├── search_form_state.dart                 # departure, arrival, date, passengers, cabin, airline
│   └── passenger_counts.dart                 # adult, child, infant
├── presentation/
│   ├── pages/
│   │   ├── travel_service_search_page.dart    # Main screen (出行服务)
│   │   ├── date_picker_page.dart              # (optional) full-screen or modal
│   │   ├── passenger_picker_page.dart         # 成人/儿童/婴儿
│   │   └── search_results_page.dart           # Results list (post-搜索)
│   └── widgets/
│       ├── travel_service_hero.dart           # Green gradient + 享梦游/出行服务 + illustrations
│       ├── trip_type_tab_bar.dart             # 单程 | 往返 | 多程
│       ├── search_form_card.dart              # White card wrapping form
│       ├── departure_arrival_tile.dart        # 出发 / 到达 + swap icon
│       ├── search_input_tile.dart             # Icon + label + value + chevron (date, passengers, cabin, airline)
│       ├── search_cta_button.dart             # 搜索 button (grey/primary as per design)
│       └── floating_action_group.dart        # Right-side FAB stack (document, home)
├── providers/
│   └── travel_service_search_provider.dart   # Form state + trip type (Riverpod)
└── travel_service_search.dart               # Barrel export (optional)
```

**Routing:** New top-level route, e.g. `/travel-service` or `/travel-service-search`, with optional nested routes for pickers and results:

- `/travel-service` → `TravelServiceSearchPage`
- `/travel-service/date` → date picker (if full-screen)
- `/travel-service/passengers` → passenger picker
- `/travel-service/results` → `SearchResultsPage` (with query params or state)

---

## 2. Main screens and subcomponents

### 2.1 Trip Customization (定制旅行)

| Screen | Responsibility |
|--------|----------------|
| **TripCustomizationPage** | Single scrollable screen: hero, form card (segment + destination + phone + CTA), 经典案例 section, 行程案例 section. |

**Subcomponents:**

| Component | Role |
|-----------|------|
| **TripCustomizationHero** | Gradient background (green tones), back button, title "定制旅行" (stylized/outline), pill chip "安心定,随心玩 省心游" with optional arrow, decorative map graphic (asset or positioned illustration). |
| **CustomizationTypeSegment** | Two options: "个人定制" (subtitle "亲子.蜜月.好友") and "团队定制" (subtitle "团建/素拓/会务"). Selected state drives form semantics. |
| **DestinationInputTile** | Leading location pin icon, placeholder "我想去...", rounded border, tappable → optional destination picker or search. |
| **PhoneInputTile** | Prefix "+86", placeholder "请填写手机号码,便于联系您". Single row, rounded. |
| **ClassicCaseCard** | Image (cover), bottom-left overlay with duration (e.g. "8天7晚"), label below image. Used in horizontal list. |
| **ItineraryCaseCard** | Image (cover), top-left overlay (e.g. "法国8日游"), label below. Used in horizontal list. |
| **HorizontalCaseList** | Horizontal `ListView` of case cards; section title (经典案例 / 行程案例) + optional "more" icon. |

---

### 2.2 Travel Service Search (出行服务)

| Screen | Responsibility |
|--------|----------------|
| **TravelServiceSearchPage** | App bar, hero (branding + illustrations), white form card (tabs + fields + search button), optional FAB group. |
| **DatePickerPage** (or modal) | Choose date; return value to form. |
| **PassengerPickerPage** | Adult/child/infant counts; return to form. |
| **SearchResultsPage** | Display results after "搜索"; layout TBD (list/detail). |

**Subcomponents:**

| Component | Role |
|-----------|------|
| **TravelServiceHero** | Green gradient, branding "享梦游" + "出行服务", tagline "出行安心 服务放心 安心购", cartoon airplane + train illustrations (assets). |
| **TripTypeTabBar** | Three tabs: 单程, 往返, 多程. Underline or highlight for selected. |
| **SearchFormCard** | White `AppCard`-style container with rounded top corners, shadow, containing all form rows. |
| **DepartureArrivalTile** | Two labels "出发" / "到达" with swap icon (⇌) between; tappable to select stations. |
| **SearchInputTile** | Reusable row: leading icon (calendar, person, ticket, airplane), title, value text, trailing chevron. Used for date, passengers, cabin, airline. |
| **SearchCtaButton** | Primary action "搜索" with optional trailing icon; style per screenshot (e.g. grey fill or primary green). |
| **FloatingActionGroup** | Two stacked FABs (e.g. document, home) on the right. |

---

## 3. Reusable widgets to create or extend

These live in `lib/shared/` (design system or widgets) so both features and future screens can use them.

| Widget | Purpose | Notes |
|--------|---------|--------|
| **AppSegmentedControl** / **AppChoiceChips** | Two- or N-way selection (e.g. 个人定制/团队定制, 单程/往返/多程). | Use `AppColors`, `AppRadius`, `AppTextStyles`; match HOME_STYLE_REFERENCE spacing and tap feedback. |
| **AppSelectionTile** | One row: optional leading icon, title, value, trailing chevron. | Same as SearchInputTile abstraction; can be generic in shared. |
| **AppHeroWithBranding** | Gradient + optional back button + title(s) + tagline chip + decorative graphic. | Parameterize gradient, text, asset; align with Home header height/spacing where applicable. |
| **AppGradientBackground** | Already exists; use for hero areas. | Extend or wrap for trip_customization / travel_service hero variants (green gradient, optional overlay graphic). |
| **AppInputField** (or **AppTextField**) | Rounded bordered field with optional leading icon, placeholder. | If not present, add to design system; used for destination and phone. |
| **AppImageCard** | Card with image, optional overlay (position + text), label below. | Reuse for 经典案例 and 行程案例; overlay position (bottom-left vs top-left) as parameter. |
| **AppFloatingActionButton** / **AppFabGroup** | Single FAB or vertical group. | Right-side FABs for travel service search. |
| **AppTabBar** (custom) | Underline tabs (e.g. 单程/往返/多程). | Match design system colors and typography; consider existing TabBar or custom. |

**Existing components to reuse:**

- `AppCard`, `AppButton`, `AppGradientBackground`, `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppShadow`
- `TapScale` or `AppTapScale` for press feedback on cards/tiles
- `AppNetworkImage` for case cards and any remote images

---

## 4. State management approach

**Use existing pattern: Riverpod.**

- **Where:** Feature-level state in `providers/` under each feature; global/shared deps (e.g. auth, router) via existing `Provider`/`NotifierProvider`.
- **Form state:** Hold in a **Notifier** (or **StateNotifier**) that owns:
  - **Trip Customization:** `CustomizationType` (personal/team), destination string, phone string; optional loading/success/error for submit.
  - **Travel Service Search:** `TripType`, departure/arrival IDs or names, date, `PassengerCounts`, cabin, airline; optional loading/results for search.
- **UI consumes:** `ref.watch(provider)` in the page; `ref.read(provider.notifier)` for actions (update field, submit, search). Prefer a single form-state provider per feature so the form is one source of truth.
- **Navigation:** Keep using `context.push` / `context.pop` and, if needed, pass result back via route result or a provider (e.g. set selected date in provider when returning from date picker).

**Suggested provider names:**

- `tripCustomizationFormProvider` → `NotifierProvider<TripCustomizationFormNotifier, TripCustomizationFormState>`
- `travelServiceSearchFormProvider` → `NotifierProvider<TravelServiceSearchFormNotifier, TravelServiceSearchFormState>`

**Optional:**

- `classicCasesProvider` / `itineraryCasesProvider` as `FutureProvider<List<...>>` if data is async and shared.
- For search results: `searchResultsProvider` (e.g. `FutureProvider` that depends on form state and runs when user taps 搜索).

---

## 5. Implementation plan (order of work)

Execute in this order so dependencies and style are consistent.

### Phase 1 — Shared and design system

1. **Document**  
   - Add trip customization & travel service screen notes to `docs/HOME_STYLE_REFERENCE.md` (hero heights, card padding, segment/tab styles) if new constants appear.

2. **Reusable widgets (shared)**  
   - Implement **AppSegmentedControl** (or **AppChoiceChips**) and use it in both features.  
   - Implement **AppSelectionTile** (icon + title + value + chevron).  
   - Implement or formalize **AppInputField** / **AppTextField** (icon, placeholder, border radius from design system).  
   - Implement **AppImageCard** (image, overlay position, overlay text, label below; optional tap).  
   - Implement **AppFloatingActionButton** / **AppFabGroup** if not present.  
   - Ensure **AppGradientBackground** (or a thin hero wrapper) can drive hero sections with title + chip + graphic.

### Phase 2 — Trip Customization (定制旅行)

3. **Domain & data**  
   - Add `domain/customization_type.dart`, `classic_case_item.dart`, `itinerary_case_item.dart`.  
   - Add `data/trip_customization_mock.dart` with lists for 经典案例 and 行程案例.  
   - (Optional) Add repository for submit; otherwise stub in notifier.

4. **State**  
   - Add `providers/trip_customization_provider.dart`: form state (type, destination, phone) + submit action.

5. **UI**  
   - Build **TripCustomizationPage**: scaffold, hero, form card (segment + destination + phone + CTA).  
   - Build **TripCustomizationHero**, **CustomizationTypeSegment**, **DestinationInputTile**, **PhoneInputTile**.  
   - Build **ClassicCaseCard**, **ItineraryCaseCard**, **HorizontalCaseList**; wire mock data.  
   - Connect page to `tripCustomizationFormProvider`; wire CTA to submit (toast or next screen).

6. **Routing**  
   - Point `/custom-travel` to `TripCustomizationPage` (replace placeholder `CustomTravelPage` or alias).

### Phase 3 — Travel Service Search (出行服务)

7. **Domain & data**  
   - Add `domain/trip_type.dart`, `search_form_state.dart`, `passenger_counts.dart`.  
   - Add `data/travel_service_search_mock.dart` (stations, airlines, default values).

8. **State**  
   - Add `providers/travel_service_search_provider.dart`: form state + set trip type, set date/passengers/cabin/airline, clear/submit search.

9. **UI — Main screen**  
   - Build **TravelServiceSearchPage**: app bar, hero, form card.  
   - Build **TravelServiceHero**, **TripTypeTabBar**, **SearchFormCard**, **DepartureArrivalTile**, **SearchInputTile** (x4), **SearchCtaButton**, **FloatingActionGroup**.  
   - Wire form to provider; wire 搜索 to navigate to results or trigger search provider.

10. **UI — Pickers and results**  
    - Build **DatePickerPage** (or bottom sheet); return selected date to provider.  
    - Build **PassengerPickerPage**; return counts to provider.  
    - Build **SearchResultsPage** (minimal list or placeholder); feed from search provider or route params.

11. **Routing**  
    - Add `/travel-service` (and optionally `/travel-service/date`, `/travel-service/passengers`, `/travel-service/results`).  
    - Add entry point from home or app shell (e.g. “出行服务” in grid or menu).

### Phase 4 — Polish and consistency

12. **L10n**  
    - Add strings for both features to `app_zh.arb` / `app_en.arb` and generate localizations.

13. **Accessibility and testing**  
    - Semantic labels, contrast check against DESIGN_LANGUAGE.  
    - Unit tests for notifiers; widget tests for critical tiles/cards if needed.

14. **Docs**  
    - Update README or feature matrix; note “定制旅行” and “出行服务” in `docs/HOME_STYLE_REFERENCE.md` if new patterns are introduced.

---

## 6. Summary

| Item | Decision |
|------|----------|
| **Folder structure** | `lib/features/trip_customization/` and `lib/features/travel_service_search/` with `data`, `domain`, `presentation` (pages, widgets), `providers`. |
| **Main screens** | TripCustomizationPage (one scrollable screen); TravelServiceSearchPage (+ DatePicker, PassengerPicker, SearchResults). |
| **Reusable widgets** | AppSegmentedControl, AppSelectionTile, AppInputField, AppImageCard, AppHeroWithBranding (or hero wrapper), AppFabGroup; reuse AppCard, AppButton, AppGradientBackground. |
| **State** | Riverpod; one Notifier per feature for form state; optional FutureProviders for case lists and search results. |
| **Style** | Follow `docs/HOME_STYLE_REFERENCE.md` and `lib/shared/design_system`; green gradients, rounded cards, consistent spacing and typography. |
| **Implementation order** | Shared widgets → Trip Customization (domain, provider, UI, route) → Travel Service Search (domain, provider, UI, pickers, results, routes) → L10n and polish. |

No UI code has been written; this plan is the single reference for implementing the two modules.
