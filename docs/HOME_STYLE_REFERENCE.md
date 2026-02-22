# Home Screen Style Reference · 首页样式规范

**Purpose:** This document is the **canonical reference** for the Chinese travel app visual style. All new screens and components should align with these values. The Home screen is the source of truth.

**Design system base:** `lib/shared/design_system` and `docs/DESIGN_LANGUAGE.md`.

---

## 1. Layout & structure

### Page scaffold
| Item | Value | Notes |
|------|--------|------|
| Scaffold background | `AppColors.warmBackground` | `#FFF5EE` |
| Body | `Column`: header (fixed height) + `Expanded(CustomScrollView)` | No bottom nav in home content |
| Scroll end spacing | `SizedBox(height: 20)` | Below last section |

### Section order (top to bottom)
1. **Header** (hero) – fixed height
2. **Content card** – white, grid entries
3. **Section Green** – recommendation (种草官)
4. **Section Yellow** – 亲子活动
5. **Section Blue** – 周边活动
6. Bottom spacing: **20**

---

## 2. Spacing & padding (numeric values)

### Home-specific constants (from `home_shell_page.dart`)
| Constant | Value (dp) | Usage |
|----------|------------|--------|
| `_kSectionPadH` | **12** | Section horizontal padding (left/right) |
| `_kSectionPadV` | **10** | Section vertical padding (top/bottom) |
| `_kCardGap` | **8** | Gap between cards in a row; right padding of horizontal lists |
| `_kGridRowGap` | **4** | Gap between the two rows of the 10-entry grid |
| Content card padding | `LTRB(12, 12, 12, 10)` | Top uses `_kSectionPadV * 1.2` |

### Header
| Item | Value | Notes |
|------|--------|------|
| Header height | **260** dp | Fixed |
| Search bar inset bottom | **16** | From bottom of header |
| Search bar inset horizontal | **16** | Left/right |
| Search pill height | **36** | |
| Search pill horizontal padding | **10** | Inside pill |
| Search pill radius | **12** | |
| Divider in search | `width: 1`, `height: 14` | Between location and search |
| Inline gaps (icon–text, etc.) | **6** | e.g. `SizedBox(width: 6)` |

### Section borders
| Item | Value |
|------|--------|
| Section top border | `Border(top: BorderSide(color: AppColors.border, width: 0.5))` |

### Grid (10-entry content card)
| Item | Value |
|------|--------|
| Grid item horizontal padding | **2** each side (`symmetric(horizontal: 2)`) |
| Gap between icon and label | **4** (`SizedBox(height: 4)`) |

### Section title row
| Item | Value |
|------|--------|
| Icon–title gap | **6** |
| Title–“More” link gap | (Expanded in between) |
| Section title to content | **8** for recommendation row; **10** for 亲子活动 |

### Cards (person / family / around)
| Item | Value |
|------|--------|
| Gap between cards in row | **8** |
| Horizontal list right padding | **12** (`_kSectionPadH`) |
| Person card internal image padding | **6** all sides |
| Person card bottom row padding | `LTRB(8, 0, 8, 8)` |
| Family poster bottom area padding | `LTRB(10, 8, 10, 10)` |
| Type C card bottom padding | `LTRB(10, 24.h, 10, 10)` |
| Badge position (poster) | `left: 8, top: 8` or `right: 8, top: 8` |
| In-card vertical gap (e.g. title–subtitle) | **4** |

---

## 3. Radius & borders

| Component | Radius (dp) | Code reference |
|-----------|-------------|-----------------|
| Section / content card | N/A (no radius on section containers) | |
| Search pill | **12** | `_kHeaderSearchPillRadius` |
| Card (generic) | **8** | `_kCardRadius`, `_kPosterCardRadius` |
| Grid icon container | **10** | `BorderRadius.circular(10)` |
| Poster badge / tag (e.g. 推荐, 热门) | **6** | `BorderRadius.circular(6)` |
| Chip (e.g. “有趣的一天”, “2~8人”) | **999** (pill) | `BorderRadius.circular(999)` |
| Person card image clip | **8** | `ClipRRect(borderRadius: 8)` |

---

## 4. Colors (semantic usage on Home)

### Backgrounds
| Area | Color | Token |
|------|--------|--------|
| Page | Warm cream | `AppColors.warmBackground` |
| Content card (grid) | White | `AppColors.homeSearchCapsule` |
| Section 1 (推荐) | Light green | `AppColors.homeSectionGreen` |
| Section 2 (亲子活动) | Light yellow | `AppColors.homeSectionYellow` |
| Section 3 (周边活动) | Gradient | `homeSectionBlueStart` → `homeSectionBlueEnd` (top→bottom) |
| Search pill | White | `AppColors.homeSearchCapsule` |

### Text
| Use | Color | Token |
|-----|--------|--------|
| Primary title / body | Dark | `AppColors.textPrimary` |
| Secondary (location, hint) | Gray | `AppColors.textSecondary` / `AppColors.textTertiary` |
| “More” / link | Green | `AppColors.primary` |
| On dark overlay (poster) | White | `Colors.white`, `Colors.white.withValues(alpha: 0.92)` etc. |

### Icons (by context)
| Context | Icon | Size | Color |
|---------|------|------|--------|
| Search bar location | `Icons.location_on_rounded` | 16 | `AppColors.textSecondary` |
| Search bar search | `Icons.search_rounded` | 18 | `AppColors.textTertiary` |
| Section 推荐 title | `Icons.eco_rounded` | 18.sp | `AppColors.primary` |
| Section 亲子活动 title | `Icons.child_care_rounded` | 18.sp | `AppColors.accentGold` |
| Section 周边活动 title | `Icons.explore_rounded` | 18.sp | `AppColors.accentWarm` |
| Person card (name row) | `Icons.location_on_rounded` | 12.sp | `AppColors.textTertiary` |
| Grid entries | (per entry) | 24.sp | Per-entry `item.color` |

### Grid entry icon colors (and section semantics)
| Entry | Color token |
|-------|-------------|
| 社交旅行 | `AppColors.tagGreen` |
| 亲子旅行 | `AppColors.accentGold` |
| 定制旅行 | `AppColors.accentCool` |
| 小包团 | `AppColors.primary` |
| 精选线路 | `AppColors.tagGreen` |
| 酒店 | `AppColors.accentGold` |
| 我的订单 | `AppColors.accentCool` |
| 周边活动 | `AppColors.accentWarm` |
| 亲子活动 | `AppColors.accentGold` |
| 游玩笔记 | `AppColors.accentCool` |

### Chips & badges
| Use | Background | Text |
|-----|------------|------|
| “有趣的一天” | `AppColors.homeChipGreen` | White, overline 10.sp w600 |
| “热门” (Type C card) | `AppColors.homeChipRed` | White, overline 11.sp w700 |
| Grid badge (e.g. “2~8人”) | `AppColors.homeChipRed` | White, overline 8.sp w600 |
| Poster badge (推荐/热门) warm | `AppColors.homeChipRed.withValues(alpha: 0.95)` | White, 10.sp w800 |
| Poster badge cool | `AppColors.primary.withValues(alpha: 0.95)` | White, 10.sp w800 |
| City tag on poster (e.g. 武汉市) | `AppColors.accentGold.withValues(alpha: 0.95)` | White, overline 10.sp w700 |

### Opacity usage (withValues)
| Use | Alpha |
|-----|--------|
| Grid icon container fill | 0.18 (color.withValues(alpha: 0.18)) |
| Grid icon container border | 0.35 |
| Poster gradient (mid) | 0.5 (black) |
| Poster gradient (bottom) | 0.82 (black) |
| Type C bottom overlay | 0.75 (black) |
| Search bar shadow | 0.08 (black) |
| Poster card shadow | 0.06 (black) |
| Badge shadow | 0.2 (black) |
| Card elevated shadow | See `AppShadow.cardElevated` (0.045, 0.07, 0.04) |

---

## 5. Typography (Home-specific overrides)

Base styles from `AppTextStyles`; Home uses these overrides:

| Context | Style | Notes |
|---------|--------|--------|
| Search location | bodyMedium, 12, w600, textPrimary | |
| Search hint | bodyMedium, 11, textTertiary | |
| Section title (推荐) | headlineSmall, 15.sp, w700, textPrimary | |
| Section title (亲子) | **GoogleFonts.zcoolKuaiLe**, 16.sp, w800, textPrimary, height 1.25 | |
| Section title (周边) | headlineSmall, 15.sp, w700, textPrimary | |
| “更多>” / “查看更多” / “查看全部>” | caption, 11.sp or 12.sp, primary, w600 | |
| Grid label | caption, 10.sp, textPrimary, w700 | |
| Grid badge | overline, 8.sp, white, w600 | |
| Person name | caption, 12.sp, textPrimary, w600 | |
| Poster title (family) | zcoolKuaiLe, 14.sp, w800, white, height 1.2 | |
| Poster subtitle | caption, 11.sp, white 0.92, w500 | |
| Poster city tag | overline, 10.sp, white, w700 | |
| Type C card title | titleSmall, 14.sp, white, w700 | |
| Type C card date line | caption, 11.sp, white 0.9, w500 | |
| Chip “有趣的一天” | overline, 10.sp, white, w600 | |
| Poster badge text | 10.sp, white, w800 | |

---

## 6. Icons (sizes and style)

- **Header / search:** 16 (location), 18 (search) – no `.sp`.
- **Section titles:** 18.sp, color by section (primary / accentGold / accentWarm).
- **Grid:** 24.sp, color from item.
- **Person card:** 12.sp, textTertiary.
- Use **rounded** variants where available (e.g. `Icons.location_on_rounded`).

---

## 7. Images

### General (AppNetworkImage)
| Property | Default / usage |
|----------|------------------|
| fit | `BoxFit.cover` |
| fadeInDuration | `Duration(milliseconds: 300)` for cards; header 400 |
| alignment | `Alignment.center`; header partial image uses `Alignment(1.0, 0.5)` for right-aligned crop |

### Header
| Property | Value |
|----------|--------|
| Size | fill (Stack), height 260 |
| Fit | cover |
| No radius on full-bleed background | |

### Person card (Type B)
| Property | Value |
|----------|--------|
| Height | 88.h |
| Width | double.infinity (within padded area) |
| Clip radius | 8 |
| Container padding | 6 |

### Family poster (vertical card)
| Property | Value |
|----------|--------|
| Card size | 112.w × 164.h |
| Image height ratio | 0.62 of card height |
| Bottom area ratio | 0.38 |
| Border radius | 8 |
| Image | cover, full width of card |

### Type C (around activity)
| Property | Value |
|----------|--------|
| Card size | width: 48% of screen (`MediaQuery.sizeOf(context).width * 0.48`), height: 152.h |
| Image | cover, full card |
| Radius | 8 |

### Gradients on images
- **Family poster bottom:** LinearGradient top→bottom, transparent → black 0.5 → black 0.82, stops [0, 0.4, 1].
- **Type C bottom:** transparent → black 0.75.

---

## 8. Shadows

| Component | Shadow | Token / value |
|-----------|--------|----------------|
| Search pill | Single: offset (0,2), blur 8, alpha 0.08 | Inline BoxShadow |
| Grid (no shadow on icon box) | — | |
| Person card | cardElevated | `AppShadow.cardElevated` |
| Family poster card | Single: (0,2), blur 8, alpha 0.06 | Inline |
| Type C card | cardElevated | `AppShadow.cardElevated` |
| Poster badge | (0,1), blur 3, alpha 0.2 | Inline |

---

## 9. Interactive states

### Tap scale (tappable cards, grid items)
| Property | Value |
|----------|--------|
| Animation duration | 100 ms |
| Scale down | 0.97 |
| Curve | Curves.easeInOut |
| Trigger | pointer down/up/cancel; tap for action |

### Section entrance animation
| Property | Value |
|----------|--------|
| Page opacity | 0→1, 400 ms, easeOutCubic |
| Page slide | offset Y 6%→0, 400 ms, easeOutCubic |
| Content stagger | index-based start/end, opacity + translate Y 8→0, 600 ms controller, easeOutCubic |

---

## 10. Component dimensions (summary)

| Component | Width | Height | Notes |
|-----------|--------|--------|--------|
| Header | full | 260 | |
| Search pill | full width minus 32 | 36 | |
| Grid icon cell | 44.w | 44.w | Square |
| Person card | Expanded (half row minus gap) | intrinsic | |
| Family poster | 112.w | 164.h | |
| Type C card | 48% screen width | 152.h | |
| Horizontal list right padding | — | — | 12 |

---

## 11. Design system tokens to use elsewhere

When building new screens, prefer in this order:

1. **Colors:** `AppColors.*` (see `app_colors.dart` and section 4 above).
2. **Spacing:** `AppSpacing.*` or the Home constants above if the pattern matches (e.g. section pad 12/10, card gap 8).
3. **Radius:** `AppRadius.*` or 8 for cards, 6 for small tags, 999 for pills.
4. **Shadow:** `AppShadow.light`, `AppShadow.cardElevated` (cards that need elevation).
5. **Text:** `AppTextStyles.*` with `.copyWith(fontSize: X.sp, color: ..., fontWeight: ...)` when needed.
6. **Icons:** Rounded style, 18.sp for section titles, 24.sp for grid, 12.sp for list secondary.

---

## 12. Fonts

- **Default:** Theme / AppTextStyles (system or theme font).
- **Decorative (section title / poster title):** `GoogleFonts.zcoolKuaiLe()` – used for “亲子活动” and family poster titles (16.sp / 14.sp, w800).

---

*Document generated from `lib/features/home/presentation/pages/home_shell_page.dart` and design system. Update this file when Home style changes so the rest of the app stays in sync.*
