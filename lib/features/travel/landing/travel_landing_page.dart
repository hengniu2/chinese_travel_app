import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../models/models.dart';
import '../state/state.dart';

/// Travel Planner landing: hero, mode switch, smart planning form,
/// featured packages, why choose us. Premium product landing.
class TravelLandingPage extends ConsumerStatefulWidget {
  const TravelLandingPage({super.key});

  @override
  ConsumerState<TravelLandingPage> createState() => _TravelLandingPageState();
}

class _TravelLandingPageState extends ConsumerState<TravelLandingPage> {
  bool _isTeamMode = false;
  bool _entranceAnimated = false;

  final _destinationController = TextEditingController();
  final _phoneController = TextEditingController();

  static const _entranceDuration = Duration(milliseconds: 400);
  static const _entranceCurve = Curves.easeOut;
  static const _entranceSlideStart = Offset(0, 0.1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entranceAnimated = true);
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmitLead() {
    final destination = _destinationController.text.trim();
    final phone = _phoneController.text.trim();
    final request = PlannerRequest(
      destination: destination.isEmpty ? null : destination,
      departureCity: null,
      dates: null,
      travelers: null,
      budgetRange: null,
      themes: [],
    );
    ref.read(plannerFormStateProvider.notifier).updateRequest(request);
    context.push('/planner/planner');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final packagesAsync = ref.watch(travelPackageListProvider);

    return Scaffold(
      body: Container(
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
            _wrapEntrance(_buildHeader()),
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: TravelDesignTokens.sectionGap,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        _buildModeSwitch(l10n),
                        const SizedBox(height: 20),
                        _buildPlanningFormCard(l10n),
                        const SizedBox(height: TravelDesignTokens.sectionGap),
                        _wrapEntrance(_buildClassicCasesSection()),
                        const SizedBox(height: 24),
                        _wrapEntrance(_buildItineraryCasesSection()),
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

  Widget _buildHeader() {
    return SizedBox(
      height: _headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB2F56B),
                  Color(0xFF8CE63C),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          // Optional: soft radial circles (cartoon-style decoration)
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '定制旅行',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _headerTag('安心定制'),
                    _headerTag('随心玩'),
                    _headerTag('精心服务'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static const Color _segmentBg = Color(0xFFF2F2F2);

  Widget _buildModeSwitch(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _segmentBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PlannerModeSegment(
              label: l10n.plannerModePersonal,
              subtitle: '亲子·蜜月·好友',
              active: !_isTeamMode,
              onTap: () => setState(() => _isTeamMode = false),
            ),
          ),
          Expanded(
            child: _PlannerModeSegment(
              label: l10n.plannerModeTeam,
              subtitle: '团建·素拓·会务',
              active: _isTeamMode,
              onTap: () => setState(() => _isTeamMode = true),
            ),
          ),
        ],
      ),
    );
  }

  static const Color _fieldBg = Color(0xFFF5F5F5);
  static const Color _ctaGradientStart = Color(0xFFB2F56B);
  static const Color _ctaGradientEnd = Color(0xFF8CE63C);

  Widget _buildPlanningFormCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _leadFormField(
            hint: '我想去...',
            controller: _destinationController,
            icon: Icons.location_on_rounded,
          ),
          const SizedBox(height: 16),
          _leadFormField(
            hint: '请填写手机号，便于联系您',
            controller: _phoneController,
            icon: Icons.phone_android_rounded,
            prefixText: '+86 ',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
          _LeadCtaButton(
            label: '马上为我定制',
            onPressed: _onSubmitLead,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _leadFormField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? prefixText,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[700]),
          const SizedBox(width: 12),
          if (prefixText != null)
            Text(
              prefixText,
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  static const List<_ClassicCaseItem> _classicCases = [
    _ClassicCaseItem(title: '云南大理丽江深度游', badge: '8天7晚', gradient: [Color(0xFF6DD5ED), Color(0xFF2193B0)]),
    _ClassicCaseItem(title: '江南水乡苏州杭州', badge: '5天4晚', gradient: [Color(0xFF11998E), Color(0xFF38EF7D)]),
    _ClassicCaseItem(title: '北京文化经典线', badge: '6天5晚', gradient: [Color(0xFFF2994A), Color(0xFFF2C94C)]),
    _ClassicCaseItem(title: '成都九寨自然奇观', badge: '7天6晚', gradient: [Color(0xFF56AB2F), Color(0xFFA8E063)]),
    _ClassicCaseItem(title: '厦门鼓浪屿文艺行', badge: '4天3晚', gradient: [Color(0xFF667EEA), Color(0xFF764BA2)]),
  ];

  Widget _buildClassicCasesSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '经典案例',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: _classicCases.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = _classicCases[index];
                return _ClassicCaseCard(
                  title: item.title,
                  badge: item.badge,
                  gradient: item.gradient,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static const List<_ItineraryCaseItem> _itineraryCases = [
    _ItineraryCaseItem(title: '杭州西湖灵隐两日', gradient: [Color(0xFF667EEA), Color(0xFF764BA2)]),
    _ItineraryCaseItem(title: '西安兵马俑华山', gradient: [Color(0xFFF2994A), Color(0xFFF2C94C)]),
    _ItineraryCaseItem(title: '桂林阳朔山水线', gradient: [Color(0xFF11998E), Color(0xFF38EF7D)]),
    _ItineraryCaseItem(title: '张家界天门山', gradient: [Color(0xFF56AB2F), Color(0xFFA8E063)]),
  ];

  Widget _buildItineraryCasesSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '行程案例',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: _itineraryCases.length,
            itemBuilder: (context, index) {
              final item = _itineraryCases[index];
              return _ItineraryCaseCard(
                title: item.title,
                gradient: item.gradient,
              );
            },
          ),
        ],
      ),
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
                style: TextStyle(
                  color: TravelDesignTokens.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
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
              style: TravelDesignTokens.titleL(null),
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

/// Lead-gen CTA: green gradient, glow shadow, tap scale.
class _LeadCtaButton extends StatefulWidget {
  const _LeadCtaButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<_LeadCtaButton> createState() => _LeadCtaButtonState();
}

class _LeadCtaButtonState extends State<_LeadCtaButton> {
  bool _pressed = false;

  static const Color _gradientStart = Color(0xFFB2F56B);
  static const Color _gradientEnd = Color(0xFF8CE63C);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_gradientStart, _gradientEnd],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _gradientEnd.withValues(alpha: 0.4),
                offset: const Offset(0, 6),
                blurRadius: 14,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

/// Data for one classic case card.
class _ClassicCaseItem {
  const _ClassicCaseItem({
    required this.title,
    required this.badge,
    required this.gradient,
  });
  final String title;
  final String badge;
  final List<Color> gradient;
}

/// Classic case card: image top with badge, text bottom. Width 170, borderRadius 16.
class _ClassicCaseCard extends StatelessWidget {
  const _ClassicCaseCard({
    required this.title,
    required this.badge,
    required this.gradient,
  });

  final String title;
  final String badge;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.landscape_rounded,
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data for one itinerary case grid card.
class _ItineraryCaseItem {
  const _ItineraryCaseItem({
    required this.title,
    required this.gradient,
  });
  final String title;
  final List<Color> gradient;
}

/// Grid card: image top AspectRatio 4/3, text below. BorderRadius 18, subtle shadow.
class _ItineraryCaseCard extends StatelessWidget {
  const _ItineraryCaseCard({
    required this.title,
    required this.gradient,
  });

  final String title;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.route_rounded,
                      size: 36,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded segmented tab: label + subtitle; selected = white + shadow + bold.
class _PlannerModeSegment extends StatelessWidget {
  const _PlannerModeSegment({
    required this.label,
    required this.subtitle,
    required this.active,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? Colors.black87 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: active ? Colors.black54 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: content,
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
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TravelDesignTokens.titleL(null).copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TravelDesignTokens.caption(AppColors.textTertiary),
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
            style: TravelDesignTokens.body(AppColors.textPrimary).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(
              fontSize: 11,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
