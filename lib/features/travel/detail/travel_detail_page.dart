import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../models/models.dart';
import '../state/state.dart';

/// Package detail: hero carousel, title block, tabs (Overview, Itinerary, Cost, Notice, Reviews), sticky booking bar.
class TravelDetailPage extends ConsumerStatefulWidget {
  const TravelDetailPage({super.key, required this.packageId});

  final String packageId;

  @override
  ConsumerState<TravelDetailPage> createState() => _TravelDetailPageState();
}

class _TravelDetailPageState extends ConsumerState<TravelDetailPage> {
  int _selectedTab = 0;
  int _selectedDayIndex = 0;
  final PageController _heroPageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _heroPageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(selectedPackageIdProvider.notifier).state = widget.packageId;
    final detailAsync = ref.watch(travelPackageDetailProvider(widget.packageId));
    final l10n = AppLocalizations.of(context)!;

    return detailAsync.when(
      data: (package) {
        if (package == null) {
          return Scaffold(
            backgroundColor: TravelDesignTokens.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.textPrimary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Not found')),
          );
        }
        return _buildContent(context, package, l10n);
      },
      loading: () => Scaffold(
        backgroundColor: TravelDesignTokens.background,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: TravelDesignTokens.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TravelPackage package,
    AppLocalizations l10n,
  ) {
    final tabs = [
      l10n.detailTabOverview,
      l10n.detailTabItinerary,
      l10n.detailTabCost,
      l10n.detailTabNotice,
      l10n.detailTabReviews,
    ];

    return Scaffold(
      backgroundColor: TravelDesignTokens.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroCarousel(
                    images: package.heroImages,
                    pageController: _heroPageController,
                    onBack: () => context.pop(),
                    onShare: () {
                      // Share intent placeholder
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TitleBlock(package: package, l10n: l10n),
                ),
                SliverToBoxAdapter(
                  child: _TrustSection(package: package, l10n: l10n),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    tabs: tabs,
                    selectedIndex: _selectedTab,
                    onTap: (i) => setState(() {
                      _selectedTab = i;
                      if (i == 1 && package.itinerary.isNotEmpty) {
                        _selectedDayIndex = 0;
                      }
                    }),
                  ),
                ),
                if (_selectedTab == 1 && package.itinerary.isNotEmpty) ...[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyDaySelectorDelegate(
                      dayCount: package.itinerary.length,
                      selectedIndex: _selectedDayIndex,
                      l10n: l10n,
                      onDaySelected: (i) => setState(() => _selectedDayIndex = i),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.04),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _ItineraryDayImmersiveContent(
                        key: ValueKey<int>(_selectedDayIndex),
                        day: package.itinerary[_selectedDayIndex],
                        l10n: l10n,
                      ),
                    ),
                  ),
                ] else
                  SliverToBoxAdapter(
                    child: _buildTabContent(context, package, l10n),
                  ),
              ],
            ),
          ),
          _StickyBookingBar(
            price: package.price,
            originalPrice: package.originalPrice,
            label: l10n.detailBook,
            onBook: () =>
                context.push('/planner/detail/${widget.packageId}/booking'),
            l10n: l10n,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    TravelPackage package,
    AppLocalizations l10n,
  ) {
    switch (_selectedTab) {
      case 0:
        return _OverviewTab(package: package, l10n: l10n);
      case 1:
        return _ItineraryTab(
          itinerary: package.itinerary,
          selectedDayIndex: _selectedDayIndex,
          onDaySelected: (i) => setState(() => _selectedDayIndex = i),
          l10n: l10n,
        );
      case 2:
        return _CostTab(package: package, l10n: l10n);
      case 3:
        return _NoticeTab(package: package, l10n: l10n);
      case 4:
        return _ReviewsTab(package: package, l10n: l10n);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero carousel
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({
    required this.images,
    required this.pageController,
    required this.onBack,
    required this.onShare,
  });

  final List<String> images;
  final PageController pageController;
  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final list = images.isEmpty
        ? [''] // placeholder
        : images;
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      height: size.width * 0.65,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: list.length,
            itemBuilder: (context, index) {
              if (list[index].isEmpty) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        TravelDesignTokens.primary.withValues(alpha: 0.7),
                        TravelDesignTokens.primary.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                );
              }
              return CachedNetworkImage(
                imageUrl: list[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: TravelDesignTokens.background,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: TravelDesignTokens.background,
                  child: const Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              );
            },
          ),
          // Overlay gradient
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          // Back & Share
          Positioned(
            top: MediaQuery.paddingOf(context).top,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: onBack,
                  ),
                  _CircleIconButton(
                    icon: Icons.share_rounded,
                    onPressed: onShare,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Title block
// ─────────────────────────────────────────────────────────────────────────────

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.package, required this.l10n});

  final TravelPackage package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        20,
        TravelDesignTokens.screenHorizontal,
        16,
      ),
      color: TravelDesignTokens.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.title,
            style: TravelDesignTokens.titleXL(null),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          if (package.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: package.tags
                  .map((t) => TagPill(label: t))
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
          if (package.rating != null) ...[
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 4),
                Text(
                  package.rating!.toStringAsFixed(1),
                  style: TravelDesignTokens.titleL(AppColors.textPrimary),
                ),
                if (package.reviewsCount != null) ...[
                  Text(
                    ' (${l10n.detailReviewsCount(package.reviewsCount!)})',
                    style: TravelDesignTokens.caption(AppColors.textTertiary),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              PriceTag(
                price: package.price,
                unit: l10n.detailPerPerson,
                originalPrice: package.originalPrice,
                size: PriceTagSize.large,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.detailFrom,
                style: TravelDesignTokens.caption(AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trust section: badges, bookings last 7 days, limited stock, review highlight
// ─────────────────────────────────────────────────────────────────────────────

class _TrustSection extends StatelessWidget {
  const _TrustSection({required this.package, required this.l10n});

  final TravelPackage package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final showLimitedStock = package.remainingCapacity != null &&
        package.remainingCapacity! < kLimitedStockThreshold;
    final hasReview = package.reviews.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        12,
        TravelDesignTokens.screenHorizontal,
        16,
      ),
      color: TravelDesignTokens.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrustBadgesRow.fromPackage(
            package: package,
            labelCancellation: l10n.trustCancellationGuarantee,
            labelSecurePayment: l10n.trustSecurePayment,
            labelVerifiedPartner: l10n.trustVerifiedLocalPartner,
            compact: true,
          ),
          if (package.bookingsLast7Days != null && package.bookingsLast7Days! > 0) ...[
            const SizedBox(height: 12),
            BookingsLast7DaysIndicator(
              message: l10n.trustBookingsLast7Days(package.bookingsLast7Days!),
              compact: true,
            ),
          ],
          if (showLimitedStock) ...[
            const SizedBox(height: 10),
            LimitedStockIndicator(
              message: l10n.trustLimitedStock(package.remainingCapacity!),
              compact: true,
            ),
          ],
          if (hasReview) ...[
            const SizedBox(height: 14),
            RealTravelerReviewHighlight(
              review: package.reviews.first,
              sectionTitle: l10n.trustRealTravelerReview,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab bar (sticky, green underline)
// ─────────────────────────────────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: TravelDesignTokens.card,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: TravelDesignTokens.screenHorizontal,
            ),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final selected = i == selectedIndex;
                return InkWell(
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tabs[i],
                          style: TravelDesignTokens.body(
                            selected
                                ? TravelDesignTokens.primary
                                : AppColors.textSecondary,
                          ).copyWith(
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 3,
                          width: selected ? 24 : 0,
                          decoration: BoxDecoration(
                            color: TravelDesignTokens.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(covariant _TabBarDelegate old) {
    return old.selectedIndex != selectedIndex || old.tabs != tabs;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overview tab
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.package, required this.l10n});

  final TravelPackage package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TravelDesignTokens.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: l10n.detailOverviewSubtitle),
          const SizedBox(height: 12),
          Text(
            package.subtitle,
            style: TravelDesignTokens.body(null),
          ),
          const SizedBox(height: 16),
          if (package.durationDays != null)
            Text(
              '${package.durationDays} days · ${package.durationNights ?? package.durationDays! - 1} nights',
              style: TravelDesignTokens.caption(null),
            ),
          if (package.departureCity != null) ...[
            const SizedBox(height: 4),
            Text(
              'Departure: ${package.departureCity}',
              style: TravelDesignTokens.caption(null),
            ),
          ],
          if (package.destinations.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Destinations: ${package.destinations.join(', ')}',
              style: TravelDesignTokens.caption(null),
            ),
          ],
          if (package.groupSize != null) ...[
            const SizedBox(height: 4),
            Text(
              'Group: ${package.groupSize}',
              style: TravelDesignTokens.caption(null),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sticky day selector (sliver delegate for itinerary tab)
// ─────────────────────────────────────────────────────────────────────────────

class _StickyDaySelectorDelegate extends SliverPersistentHeaderDelegate {
  _StickyDaySelectorDelegate({
    required this.dayCount,
    required this.selectedIndex,
    required this.l10n,
    required this.onDaySelected,
  });

  final int dayCount;
  final int selectedIndex;
  final AppLocalizations l10n;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: TravelDesignTokens.card,
      padding: const EdgeInsets.symmetric(
        horizontal: TravelDesignTokens.screenHorizontal,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(dayCount, (i) {
                  final selected = i == selectedIndex;
                  return Padding(
                    padding: EdgeInsets.only(right: i < dayCount - 1 ? 8 : 0),
                    child: _DayChip(
                      label: l10n.detailDay(i + 1),
                      selected: selected,
                      onTap: () => onDaySelected(i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _StickyDaySelectorDelegate old) {
    return old.selectedIndex != selectedIndex ||
        old.dayCount != dayCount;
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? TravelDesignTokens.primary.withValues(alpha: 0.15)
          : TravelDesignTokens.card,
      borderRadius: TravelDesignTokens.borderRadiusSmall,
      child: InkWell(
        onTap: onTap,
        borderRadius: TravelDesignTokens.borderRadiusSmall,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: TravelDesignTokens.borderRadiusSmall,
            border: Border.all(
              color: selected
                  ? TravelDesignTokens.primary
                  : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TravelDesignTokens.body(null).copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? TravelDesignTokens.primary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Immersive day content: hero, badges, expandable blocks, experience moments, map
// ─────────────────────────────────────────────────────────────────────────────

class _ItineraryDayImmersiveContent extends StatefulWidget {
  const _ItineraryDayImmersiveContent({
    super.key,
    required this.day,
    required this.l10n,
  });

  final ItineraryDay day;
  final AppLocalizations l10n;

  @override
  State<_ItineraryDayImmersiveContent> createState() =>
      _ItineraryDayImmersiveContentState();
}

class _ItineraryDayImmersiveContentState
    extends State<_ItineraryDayImmersiveContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();
  }

  @override
  void didUpdateWidget(covariant _ItineraryDayImmersiveContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day.dayNumber != widget.day.dayNumber) {
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final l10n = widget.l10n;
    final heroUrl = day.images.isNotEmpty ? day.images.first : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          TravelDesignTokens.screenHorizontal,
          0,
          TravelDesignTokens.screenHorizontal,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Large hero image per day
            if (heroUrl != null && heroUrl.isNotEmpty)
              _DayHeroImage(imageUrl: heroUrl),
            const SizedBox(height: 20),
            // Title + highlight badges
            Text(
              day.title,
              style: TravelDesignTokens.titleXL(null),
            ),
            if (day.highlights.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: day.highlights.map((h) => _HighlightBadge(label: h)).toList(),
              ),
            ],
            const SizedBox(height: 16),
            // Expandable: main description (experience block)
            _ExpandableExperienceBlock(
              title: l10n.detailDay(day.dayNumber),
              initiallyExpanded: true,
              child: Text(
                day.description,
                style: TravelDesignTokens.body(null),
              ),
            ),
            const SizedBox(height: 16),
            // Experience Moments
            _ExperienceMomentsSection(day: day, l10n: l10n),
            const SizedBox(height: 20),
            // Meals & Hotel (expandable)
            if (day.mealsIncluded != null && day.mealsIncluded!.isNotEmpty)
              _ExpandableExperienceBlock(
                title: l10n.detailMealsIncluded,
                initiallyExpanded: false,
                child: Text(
                  day.mealsIncluded!,
                  style: TravelDesignTokens.body(null),
                ),
              ),
            if (day.mealsIncluded != null &&
                day.mealsIncluded!.isNotEmpty &&
                day.hotelInfo != null &&
                day.hotelInfo!.isNotEmpty)
              const SizedBox(height: 12),
            if (day.hotelInfo != null && day.hotelInfo!.isNotEmpty)
              _ExpandableExperienceBlock(
                title: l10n.detailHotel,
                initiallyExpanded: false,
                child: Text(
                  day.hotelInfo!,
                  style: TravelDesignTokens.body(null),
                ),
              ),
            const SizedBox(height: 24),
            // Map preview section
            _MapPreviewSection(
              mapPreviewUrl: day.mapPreviewUrl,
              dayTitle: day.title,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayHeroImage extends StatelessWidget {
  const _DayHeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width -
        TravelDesignTokens.screenHorizontal * 2;
    final height = width * 0.65;

    return ClipRRect(
      borderRadius: TravelDesignTokens.borderRadiusLarge,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: TravelDesignTokens.background,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: TravelDesignTokens.background,
            child: const Icon(Icons.image_not_supported_outlined, size: 48),
          ),
        ),
      ),
    );
  }
}

class _HighlightBadge extends StatelessWidget {
  const _HighlightBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: TravelDesignTokens.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TravelDesignTokens.primary.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TravelDesignTokens.caption(TravelDesignTokens.primary).copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ExpandableExperienceBlock extends StatefulWidget {
  const _ExpandableExperienceBlock({
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<_ExpandableExperienceBlock> createState() =>
      _ExpandableExperienceBlockState();
}

class _ExpandableExperienceBlockState extends State<_ExpandableExperienceBlock> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: TravelDesignTokens.borderRadiusMedium,
          child: Padding(
            padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TravelDesignTokens.titleL(null),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: widget.child,
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState:
                      _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 250),
                  sizeCurve: Curves.easeOutCubic,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceMomentsSection extends StatelessWidget {
  const _ExperienceMomentsSection({
    required this.day,
    required this.l10n,
  });

  final ItineraryDay day;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final hasEmotional = (day.emotionalDescription != null &&
            day.emotionalDescription!.trim().isNotEmpty) ||
        day.description.isNotEmpty;
    final hasPhoto = day.photographyHighlights.isNotEmpty || day.highlights.isNotEmpty;
    final hasCulture =
        (day.localCultureInsight != null && day.localCultureInsight!.trim().isNotEmpty);

    if (!hasEmotional && !hasPhoto && !hasCulture) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TravelDesignTokens.primary.withValues(alpha: 0.06),
            TravelDesignTokens.primary.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        border: Border.all(
          color: TravelDesignTokens.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 20,
                color: TravelDesignTokens.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.detailExperienceMoments,
                style: TravelDesignTokens.titleL(TravelDesignTokens.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (hasEmotional) ...[
            Text(
              l10n.detailEmotionalHighlight,
              style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day.emotionalDescription?.trim().isNotEmpty == true
                  ? day.emotionalDescription!
                  : day.description,
              style: TravelDesignTokens.body(null).copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
          ],
          if (hasPhoto) ...[
            Text(
              l10n.detailPhotographyHighlights,
              style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: (day.photographyHighlights.isNotEmpty
                      ? day.photographyHighlights
                      : day.highlights)
                  .map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: TravelDesignTokens.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s,
                            style: TravelDesignTokens.caption(null),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 14),
          ],
          if (hasCulture) ...[
            Text(
              l10n.detailLocalCulture,
              style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day.localCultureInsight!,
              style: TravelDesignTokens.body(null),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapPreviewSection extends StatelessWidget {
  const _MapPreviewSection({
    this.mapPreviewUrl,
    required this.dayTitle,
    required this.l10n,
  });

  final String? mapPreviewUrl;
  final String dayTitle;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Deep link to map app or in-app map
          },
          borderRadius: TravelDesignTokens.borderRadiusMedium,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (mapPreviewUrl != null && mapPreviewUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: TravelDesignTokens.borderRadiusMedium,
                  child: CachedNetworkImage(
                    imageUrl: mapPreviewUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, url, error) => _MapPlaceholder(dayTitle: dayTitle),
                  ),
                )
              else
                _MapPlaceholder(dayTitle: dayTitle),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: TravelDesignTokens.borderRadiusMedium,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: Row(
                  children: [
                    Icon(
                      Icons.map_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.detailViewOnMap,
                      style: TravelDesignTokens.body(Colors.white).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.dayTitle});

  final String dayTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TravelDesignTokens.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.map_outlined,
              size: 40,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              dayTitle,
              style: TravelDesignTokens.caption(AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Itinerary tab (fallback when empty; also used for non-immersive)
// ─────────────────────────────────────────────────────────────────────────────

class _ItineraryTab extends StatelessWidget {
  const _ItineraryTab({
    required this.itinerary,
    required this.selectedDayIndex,
    required this.onDaySelected,
    required this.l10n,
  });

  final List<ItineraryDay> itinerary;
  final int selectedDayIndex;
  final ValueChanged<int> onDaySelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (itinerary.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TravelDesignTokens.screenHorizontal),
        child: Text(
          l10n.detailNoItinerary,
          style: TravelDesignTokens.body(AppColors.textTertiary),
        ),
      );
    }

    final day = itinerary[selectedDayIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        16,
        TravelDesignTokens.screenHorizontal,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: itinerary.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == selectedDayIndex;
                return Material(
                  color: selected
                      ? TravelDesignTokens.primary.withValues(alpha: 0.15)
                      : TravelDesignTokens.card,
                  borderRadius: TravelDesignTokens.borderRadiusSmall,
                  child: InkWell(
                    onTap: () => onDaySelected(i),
                    borderRadius: TravelDesignTokens.borderRadiusSmall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.detailDay(i + 1),
                        style: TravelDesignTokens.body(null).copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected
                              ? TravelDesignTokens.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: TravelDesignTokens.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: TravelDesignTokens.shadowLevel1,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 24,
                    margin: const EdgeInsets.only(top: 4),
                    color: const Color(0xFFE5E7EB),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ItineraryDayContent(day: day, l10n: l10n),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ItineraryDayContent extends StatelessWidget {
  const _ItineraryDayContent({required this.day, required this.l10n});

  final ItineraryDay day;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusSmall,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.title,
            style: TravelDesignTokens.titleL(null),
          ),
          if (day.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: TravelDesignTokens.borderRadiusSmall,
              child: CachedNetworkImage(
                imageUrl: day.images.first,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 160,
                  color: TravelDesignTokens.background,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 160,
                  color: TravelDesignTokens.background,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            day.description,
            style: TravelDesignTokens.body(null),
          ),
          if (day.mealsIncluded != null && day.mealsIncluded!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _CollapsibleSection(
              title: l10n.detailMealsIncluded,
              child: Text(
                day.mealsIncluded!,
                style: TravelDesignTokens.body(null),
              ),
            ),
          ],
          if (day.hotelInfo != null && day.hotelInfo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _CollapsibleSection(
              title: l10n.detailHotel,
              child: Text(
                day.hotelInfo!,
                style: TravelDesignTokens.body(null),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  const _CollapsibleSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Text(
                widget.title,
                style: TravelDesignTokens.body(AppColors.textPrimary).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 4),
          widget.child,
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cost tab (included ✓, excluded ✗, optional)
// ─────────────────────────────────────────────────────────────────────────────

class _CostTab extends StatelessWidget {
  const _CostTab({required this.package, required this.l10n});

  final TravelPackage package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final cost = package.costBreakdown;
    if (cost == null) {
      return Padding(
        padding: const EdgeInsets.all(TravelDesignTokens.screenHorizontal),
        child: Text(
          'No cost breakdown available.',
          style: TravelDesignTokens.body(AppColors.textTertiary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        16,
        TravelDesignTokens.screenHorizontal,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CostList(
            title: l10n.detailIncluded,
            items: cost.included,
            icon: Icons.check_circle_rounded,
            color: TravelDesignTokens.primary,
          ),
          const SizedBox(height: TravelDesignTokens.sectionGap),
          _CostList(
            title: l10n.detailExcluded,
            items: cost.excluded,
            icon: Icons.cancel_rounded,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: TravelDesignTokens.sectionGap),
          _CostList(
            title: l10n.detailOptionalUpgrades,
            items: cost.optionalAddOns,
            icon: Icons.add_circle_outline_rounded,
            color: TravelDesignTokens.primary,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CostList extends StatelessWidget {
  const _CostList({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          trailing: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TravelDesignTokens.body(null),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notice tab (Visa, Insurance, Cancellation, Important)
// ─────────────────────────────────────────────────────────────────────────────

class _NoticeTab extends StatelessWidget {
  const _NoticeTab({required this.package, required this.l10n});

  final TravelPackage package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];

    void addSection(String title, String? content) {
      if (content == null || content.isEmpty) return;
      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: TravelDesignTokens.sectionGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: title),
              const SizedBox(height: 8),
              Text(
                content,
                style: TravelDesignTokens.body(null),
              ),
            ],
          ),
        ),
      );
    }

    addSection(l10n.detailNoticeVisa, package.visaInfo);
    addSection(l10n.detailNoticeInsurance, package.insuranceInfo);
    addSection(l10n.detailNoticeCancellation, package.cancellationPolicy);
    addSection(l10n.detailNoticeImportant, package.importantNotes);

    if (sections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TravelDesignTokens.screenHorizontal),
        child: Text(
          'No notice information available.',
          style: TravelDesignTokens.body(AppColors.textTertiary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        16,
        TravelDesignTokens.screenHorizontal,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reviews tab (rating summary + list)
// ─────────────────────────────────────────────────────────────────────────────

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.package, required this.l10n});

  final TravelPackage package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final rating = package.rating;
    final reviews = package.reviews;
    final count = package.reviewsCount ?? reviews.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        16,
        TravelDesignTokens.screenHorizontal,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: l10n.detailReviewsSummary),
          const SizedBox(height: 12),
          if (rating != null)
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 28,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 8),
                Text(
                  rating.toStringAsFixed(1),
                  style: TravelDesignTokens.titleXL(AppColors.textPrimary),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.detailReviewsCount(count),
                  style: TravelDesignTokens.body(AppColors.textTertiary),
                ),
              ],
            ),
          const SizedBox(height: 20),
          if (reviews.isEmpty)
            Text(
              l10n.detailNoReviews,
              style: TravelDesignTokens.body(AppColors.textTertiary),
            )
          else
            ...reviews.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
                  decoration: BoxDecoration(
                    color: TravelDesignTokens.card,
                    borderRadius: TravelDesignTokens.borderRadiusSmall,
                    boxShadow: TravelDesignTokens.shadowLevel1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              r.authorName,
                              style: TravelDesignTokens.body(null).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: AppColors.accentGold,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                r.rating.toStringAsFixed(1),
                                style: TravelDesignTokens.caption(null),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (r.date != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          r.date!,
                          style: TravelDesignTokens.caption(AppColors.textTertiary),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        r.content,
                        style: TravelDesignTokens.body(null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sticky booking bar
// ─────────────────────────────────────────────────────────────────────────────

class _StickyBookingBar extends StatelessWidget {
  const _StickyBookingBar({
    required this.price,
    required this.originalPrice,
    required this.label,
    required this.onBook,
    required this.l10n,
  });

  final double price;
  final double? originalPrice;
  final String label;
  final VoidCallback onBook;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TravelDesignTokens.screenHorizontal,
        12,
        TravelDesignTokens.screenHorizontal,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.detailFrom,
                    style: TravelDesignTokens.caption(AppColors.textTertiary),
                  ),
                  PriceTag(
                    price: price,
                    unit: l10n.detailPerPerson,
                    originalPrice: originalPrice,
                    size: PriceTagSize.medium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            TravelPrimaryButton(
              label: label,
              onPressed: onBook,
              expand: false,
              minHeight: 48,
            ),
          ],
        ),
      ),
    );
  }
}
