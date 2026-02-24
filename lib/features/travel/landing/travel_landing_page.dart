import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../data/travel_assets.dart';
import '../models/models.dart';
import '../state/state.dart';
import '../widgets/case_showcase_section.dart';
import '../widgets/custom_travel_section.dart';
import '../widgets/travel_landing_premium_sections.dart';

/// Travel Planner landing: hero, mode switch, smart planning form,
/// featured packages, why choose us. Premium product landing.
class TravelLandingPage extends ConsumerStatefulWidget {
  const TravelLandingPage({super.key});

  @override
  ConsumerState<TravelLandingPage> createState() => _TravelLandingPageState();
}

class _TravelLandingPageState extends ConsumerState<TravelLandingPage> {
  bool _entranceAnimated = false;

  static const _entranceDuration = Duration(milliseconds: 400);
  static const _entranceCurve = Curves.easeOut;
  static const _entranceSlideStart = Offset(0, 0.08);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entranceAnimated = true);
    });
  }

  void _onCustomTravelSubmit({
    String? destination,
    required bool isTeam,
    required double budgetMin,
    required double budgetMax,
    required List<String> themes,
  }) {
    final request = PlannerRequest(
      destination: destination,
      departureCity: null,
      dates: null,
      travelers: null,
      budgetRange: PriceRange(min: budgetMin, max: budgetMax),
      themes: themes,
    );
    ref.read(plannerFormStateProvider.notifier).updateRequest(request);
    context.push('/planner/planner');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _buildScaffold(context, l10n);
  }

  Widget _buildScaffold(BuildContext context, AppLocalizations l10n) {
    final packagesAsync = ref.watch(travelPackageListProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFDF5),
                  Color(0xFFF7F9FC),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _wrapEntrance(_buildHeader(l10n)),
                Expanded(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            _wrapEntrance(CustomTravelSection(
                              onSubmit: _onCustomTravelSubmit,
                            )),
                            const SizedBox(height: TravelDesignTokens.sectionGap),
                            _wrapEntrance(AiSmartRecommendationSection(
                              items: _aiRecommendationItems,
                              onItemTap: (_) {},
                            )),
                            const SizedBox(height: TravelDesignTokens.sectionGap),
                            _wrapEntrance(const LimitedTimeDealsBanner()),
                            const SizedBox(height: TravelDesignTokens.sectionGap),
                            _wrapEntrance(_buildCaseShowcaseSection(
                              title: '经典案例',
                              items: _classicCaseItems,
                            )),
                            const SizedBox(height: 24),
                            _wrapEntrance(_buildCaseShowcaseSection(
                              title: '行程案例',
                              items: _itineraryCaseItems,
                            )),
                            const SizedBox(height: TravelDesignTokens.sectionGap),
                            _wrapEntrance(_buildFeaturedSection(context, l10n, packagesAsync)),
                            const SizedBox(height: TravelDesignTokens.sectionGap),
                            _wrapEntrance(_buildWhyChooseUs(l10n)),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapEntrance(Widget child) {
    return AnimatedOpacity(
      opacity: _entranceAnimated ? 1 : 0,
      duration: _entranceDuration,
      curve: _entranceCurve,
      child: AnimatedSlide(
        offset: _entranceAnimated ? Offset.zero : _entranceSlideStart,
        duration: _entranceDuration,
        curve: _entranceCurve,
        child: child,
      ),
    );
  }

  static const double _headerHeight = 240;

  Widget _buildHeader(AppLocalizations l10n) {
    return SizedBox(
      height: _headerHeight,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              kPlannerHeaderImageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFB2F56B),
              ),
            ),
            // Gradient overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.15),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            // Title at top
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  l10n.plannerLandingHeroTitle,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontSize: 28,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }

  /// AI recommendation list (personalized horizontal list).
  static final List<CaseCardItem> _aiRecommendationItems = [
    CaseCardItem(
      destinationName: '杭州西湖两日',
      subtitle: '根据你的偏好推荐',
      durationBadge: '2天1晚',
      price: 699,
      starRating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?w=400',
      gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    ),
    CaseCardItem(
      destinationName: '成都美食之旅',
      subtitle: '人气线路 · 高分好评',
      durationBadge: '3天2晚',
      price: 1280,
      starRating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      gradient: [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
    ),
    CaseCardItem(
      destinationName: '云南大理',
      subtitle: '苍山洱海 · 适合放松',
      durationBadge: '4天3晚',
      price: 2180,
      starRating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1547981609-4b6bfe67ca0b?w=400',
      gradient: [const Color(0xFF6DD5ED), const Color(0xFF2193B0)],
    ),
  ];

  static final List<CaseCardItem> _classicCaseItems = [
    CaseCardItem(
      destinationName: '云南大理丽江深度游',
      subtitle: '苍山洱海·古城风情',
      durationBadge: '8天7晚',
      price: 3680,
      starRating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1547981609-4b6bfe67ca0b?w=400',
      gradient: [const Color(0xFF6DD5ED), const Color(0xFF2193B0)],
    ),
    CaseCardItem(
      destinationName: '江南水乡苏州杭州',
      subtitle: '西湖·园林·古镇',
      durationBadge: '5天4晚',
      price: 2580,
      starRating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?w=400',
      gradient: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    ),
    CaseCardItem(
      destinationName: '北京文化经典线',
      subtitle: '故宫·长城·胡同',
      durationBadge: '6天5晚',
      price: 2980,
      starRating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=400',
      gradient: [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
    ),
    CaseCardItem(
      destinationName: '成都九寨自然奇观',
      subtitle: '熊猫·九寨沟·美食',
      durationBadge: '7天6晚',
      price: 4280,
      starRating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      gradient: [const Color(0xFF56AB2F), const Color(0xFFA8E063)],
    ),
    CaseCardItem(
      destinationName: '厦门鼓浪屿文艺行',
      subtitle: '海岛·文艺·慢生活',
      durationBadge: '4天3晚',
      price: 1880,
      starRating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=400',
      gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    ),
  ];

  static final List<CaseCardItem> _itineraryCaseItems = [
    CaseCardItem(
      destinationName: '杭州西湖灵隐两日',
      subtitle: '西湖十景·灵隐寺',
      durationBadge: '2天1晚',
      price: 680,
      starRating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?w=400',
      gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    ),
    CaseCardItem(
      destinationName: '西安兵马俑华山',
      subtitle: '世界遗产·奇险华山',
      durationBadge: '3天2晚',
      price: 1280,
      starRating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1590559899731-a382839e5549?w=400',
      gradient: [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
    ),
    CaseCardItem(
      destinationName: '桂林阳朔山水线',
      subtitle: '漓江·遇龙河·西街',
      durationBadge: '2天1晚',
      price: 580,
      starRating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=400',
      gradient: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    ),
    CaseCardItem(
      destinationName: '张家界天门山',
      subtitle: '玻璃栈道·天门洞',
      durationBadge: '2天1晚',
      price: 880,
      starRating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      gradient: [const Color(0xFF56AB2F), const Color(0xFFA8E063)],
    ),
  ];

  Widget _buildCaseShowcaseSection({
    required String title,
    required List<CaseCardItem> items,
  }) {
    return CaseShowcaseSection(
      title: title,
      items: items,
      onCardTap: (_) {},
    );
  }

  Widget _buildFeaturedSection(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<TravelPackage>> packagesAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: l10n.plannerFeaturedTitle,
            trailing: TextButton(
              onPressed: () => context.push('/planner/discovery'),
              child: Text(
                l10n.plannerFeaturedSeeAll,
                style: TravelTypography.label(TravelDesignTokens.primary, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          packagesAsync.when(
            data: (packages) {
              if (packages.isEmpty) {
                return EmptyState(
                  message: l10n.plannerFeaturedEmpty,
                  actionLabel: l10n.plannerFeaturedEmptyAction,
                  onAction: () => context.push('/planner/discovery'),
                );
              }
              return SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  itemCount: packages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final p = packages[index];
                    return _FeaturedPackageCard(
                      title: p.title,
                      subtitle: p.subtitle,
                      durationDays: p.durationDays,
                      price: p.price,
                      onTap: () => context.push('/planner/detail/${p.id}'),
                    );
                  },
                ),
              );
            },
            loading: () => SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, __) => const SizedBox(
                  width: 160,
                  child: TravelSkeletonWrap(child: TravelSkeletonCard()),
                ),
              ),
            ),
            error: (e, st) => EmptyState(
              message: l10n.plannerFeaturedEmpty,
              actionLabel: l10n.plannerFeaturedEmptyAction,
              onAction: () => context.push('/planner/discovery'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUs(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              l10n.plannerWhyChooseUs,
              style: TravelTypography.sectionTitle(AppColors.textPrimary),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _WhyBlock(
                  icon: Icons.shield_rounded,
                  title: l10n.plannerWhySafety,
                  description: l10n.plannerWhySafetyDesc,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _WhyBlock(
                  icon: Icons.cancel_schedule_send_rounded,
                  title: l10n.plannerWhyFlexible,
                  description: l10n.plannerWhyFlexibleDesc,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _WhyBlock(
                  icon: Icons.groups_rounded,
                  title: l10n.plannerWhyLocal,
                  description: l10n.plannerWhyLocalDesc,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class _FeaturedPackageCard extends StatelessWidget {
  const _FeaturedPackageCard({
    required this.title,
    required this.subtitle,
    this.durationDays,
    required this.price,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final int? durationDays;
  final double price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              TravelDesignTokens.primary.withValues(alpha: 0.2),
                              TravelDesignTokens.accentLimeEnd.withValues(alpha: 0.25),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: TravelDesignTokens.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (durationDays != null)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF176),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '${durationDays}D',
                          style: TravelTypography.label(const Color(0xFF424242), fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TravelTypography.hint(AppColors.textTertiary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              PriceTag(price: price, unit: '起', size: PriceTagSize.small),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhyBlock extends StatelessWidget {
  const _WhyBlock({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF9C4),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 28,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TravelTypography.content(AppColors.textPrimary, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TravelTypography.hint(AppColors.textTertiary, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
