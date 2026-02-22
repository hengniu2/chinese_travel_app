# Travel Planner — Global Design System

Unified design system for the Travel Planner module. Use these tokens and components for consistent styling before redesigning screens.

---

## Brand identity

| Token | Value | Usage |
|-------|--------|--------|
| **Primary** | `#22C55E` (modern travel green) | Buttons, links, key icons |
| **Accent** | Soft lime gradient (`#84CC16` → `#BEF264`) | Accent highlights |
| **Background** | `#F8FAF9` | Page background |
| **Card** | `#FFFFFF` | Card surface |

---

## Radius system

- **Small:** 8 dp — cards, chips, tags  
- **Medium:** 12 dp — buttons, inputs  
- **Large:** 16 dp — use rarely  

No excessive 24 dp rounding.

---

## Typography

| Role | Size | Weight |
|------|------|--------|
| **Title XL** | 22–24 sp | Bold |
| **Title L** | 18–20 sp | Semi-bold |
| **Body** | 14–16 sp | Regular |
| **Caption** | 12–13 sp | Regular |

Clear hierarchy. Use `TravelDesignTokens.titleXL()`, `.titleL()`, `.body()`, `.caption()`.

---

## Shadow system

- **Level 1** — Soft, subtle (cards, list items).  
- **Level 2** — Medium (elevated cards, primary button).  

Avoid heavy shadow. Use `TravelDesignTokens.shadowLevel1` / `shadowLevel2`.

---

## Standard padding

| Context | Value |
|---------|--------|
| Screen horizontal | 16 dp |
| Card inner | 16 dp |
| Between sections | 24 dp |

`TravelDesignTokens.screenHorizontal`, `cardPadding`, `sectionGap`.

---

## Reusable components

| Component | Purpose |
|-----------|---------|
| **TravelCard** | White card, 8 dp radius, level-1 shadow, 16 dp padding, optional tap |
| **SectionHeader** | Title L + optional trailing action |
| **TravelFilterChip** | Filter chip; selected = primary green |
| **PriceTag** | Price + optional unit / original price |
| **TagPill** | Small pill (e.g. 热卖, 品质团) |
| **TravelStatusBadge** | Status label + semantic color (success / warning / error / neutral) |
| **TravelPrimaryButton** | Primary CTA, green fill, 12 dp radius |
| **TravelOutlineButton** | Outline button, primary border |
| **EmptyState** | Icon + message + optional action |
| **TravelSkeletonLoader** / **TravelSkeletonCard** | Loading placeholder |
| **ItineraryTimeline** | Timeline with dot + line + content blocks |
| **CostListBlock** | Cost breakdown block (title + bullet list) |

All live in `lib/shared/design_system/` and are exported from `design_system.dart`.

---

## Usage

```dart
import 'package:chinese_travel_app/shared/design_system/design_system.dart';

// Tokens
TravelDesignTokens.primary
TravelDesignTokens.background
TravelDesignTokens.borderRadiusSmall
TravelDesignTokens.paddingCard
TravelDesignTokens.shadowLevel1
TravelDesignTokens.titleL(null)

// Components
TravelCard(child: ...)
SectionHeader(title: 'Section')
TravelFilterChip(label: 'Filter', selected: true)
PriceTag(price: 3280, unit: '起')
TagPill(label: '热卖')
TravelStatusBadge(label: 'Confirmed', variant: TravelStatusBadgeVariant.success)
TravelPrimaryButton(label: 'Book', onPressed: () {})
TravelOutlineButton(label: 'Cancel', onPressed: () {})
EmptyState(message: 'No packages', actionLabel: 'Browse', onAction: () {})
TravelSkeletonCard()
ItineraryTimeline(items: [...])
CostListBlock(title: 'Included', items: [...])
```

Apply this system globally, then move to Planner Landing redesign.
