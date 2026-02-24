import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import '../data/travel_assets.dart';
import '../models/planner_request.dart';
import '../services/planner_service.dart';
import '../state/state.dart';
import '../widgets/ai_branding.dart';
import '../widgets/user_reviews_section.dart';
import '../widgets/vip_membership_card.dart';

/// AI 行程生成结果页 — premium itinerary result with hero, timeline, price breakdown.
class AiItineraryResultPage extends ConsumerStatefulWidget {
  const AiItineraryResultPage({super.key});

  @override
  ConsumerState<AiItineraryResultPage> createState() => _AiItineraryResultPageState();
}

class _UpgradeItem {
  const _UpgradeItem(this.label, this.price);
  final String label;
  final int price;
}

class _AiItineraryResultPageState extends ConsumerState<AiItineraryResultPage> {
  CustomItineraryDraft? _draft;
  bool _loading = true;
  final Set<int> _selectedUpgrades = {};
  static const _upgrades = [
    _UpgradeItem('升级五星酒店', 800),
    _UpgradeItem('私人接送机', 300),
    _UpgradeItem('专属摄影师', 1200),
    _UpgradeItem('特色晚宴体验', 500),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDraft());
  }

  Future<void> _loadDraft() async {
    final result = ref.read(currentPlannerResultProvider);
    if (result?.customItineraryDraft != null) {
      setState(() {
        _draft = result!.customItineraryDraft;
        _loading = false;
      });
      return;
    }
    final service = ref.read(plannerServiceProvider);
    final draft = await service.generateCustomItinerary(result?.request ?? const PlannerRequest());
    if (mounted) {
      setState(() {
        _draft = draft;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(currentPlannerResultProvider);
    final request = result?.request ?? const PlannerRequest();
    final dest = request.destination ?? '目的地';
    final days = _computeDays(request);
    final tags = request.themes.isNotEmpty ? request.themes : ['亲子', '海岛', '轻奢'];

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.warmBackground,
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildHero(context, dest, days, tags),
                SliverToBoxAdapter(child: _buildContent(context, request, dest, days, tags)),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          _buildStickyCta(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        onPressed: () => context.pop(),
      ),
    );
  }

  int _computeDays(PlannerRequest request) {
    if (request.dates != null) {
      return request.dates!.end.difference(request.dates!.start).inDays + 1;
    }
    return 7;
  }

  Widget _buildHero(BuildContext context, String dest, int days, List<String> tags) {
    final nights = (days - 1).clamp(1, 30);
    final gradient = _heroGradientForDestination(dest);

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Hero(
            tag: 'ai_itinerary_hero',
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    kPlannerHeaderImageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                  Container(
                    decoration: BoxDecoration(
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
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '为你定制的 $days天${nights}晚 ${dest}之旅',
                  style: TravelTypography.sectionTitle(Colors.white, fontSize: 18)
                      .copyWith(fontWeight: FontWeight.w600, shadows: [
                    Shadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2)),
                  ]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.take(5).map((t) => _TagChip(label: t)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _heroGradientForDestination(String dest) {
    const map = {
      '日本': [Color(0xFF667EEA), Color(0xFF764BA2)],
      '泰国': [Color(0xFF11998E), Color(0xFF38EF7D)],
      '云南': [Color(0xFF6DD5ED), Color(0xFF2193B0)],
      '成都': [Color(0xFFF2994A), Color(0xFFF2C94C)],
      '北京': [Color(0xFFE53935), Color(0xFFFF7043)],
      '杭州': [Color(0xFF43A047), Color(0xFF66BB6A)],
    };
    for (final e in map.entries) {
      if (dest.contains(e.key)) return e.value;
    }
    return [const Color(0xFF7CB87C), const Color(0xFFB8E06C)];
  }

  static Color _sectionColor(int index) {
    const colors = [
      AppColors.homeSectionGreen,
      AppColors.homeSectionYellow,
      AppColors.homeSectionBlueStart,
      Color(0xFFFFF3E0),
      Color(0xFFF3E5F5),
      Color(0xFFE0F2F1),
      AppColors.homeSectionGreen,
    ];
    return colors[index % colors.length];
  }

  Widget _wrapInSection(int index, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: _sectionColor(index),
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: child,
    );
  }

  Widget _buildContent(
    BuildContext context,
    PlannerRequest request,
    String dest,
    int days,
    List<String> tags,
  ) {
    final itineraryDays = _draft?.days ?? List.generate(days, (i) => CustomItineraryDayDraft(
      dayNumber: i + 1,
      title: '第${i + 1}天',
      description: '行程安排（AI 智能规划）',
    ));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _wrapInSection(0, _buildTimelineCard(itineraryDays)),
          _wrapInSection(1, UserReviewsSection()),
          _wrapInSection(2, _buildHotelCard()),
          _wrapInSection(3, _buildFlightCard(request)),
          _wrapInSection(4, _buildUpgradesSection(request)),
          _wrapInSection(5, _buildPriceBreakdown(request)),
          _wrapInSection(6, Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VipMembershipCard(onUpgrade: () {}),
              const SizedBox(height: 12),
              Center(child: AiBranding(iconSize: 12, fontSize: 10)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(List<CustomItineraryDayDraft> days) {
    return _LayeredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: '行程预览', icon: Icons.route_rounded),
          const SizedBox(height: 8),
          ...days.asMap().entries.map((e) {
            final i = e.key;
            final d = e.value;
            return _CollapsibleDay(
              dayNumber: d.dayNumber ?? i + 1,
              title: d.title ?? '第${i + 1}天',
              description: d.description,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHotelCard() {
    return _LayeredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: '酒店推荐', icon: Icons.hotel_rounded),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.hotel, color: TravelDesignTokens.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('精选酒店 · 待确认', style: TravelTypography.content(AppColors.textPrimary, fontSize: 14)),
                    Text('根据行程智能匹配', style: TravelTypography.hint(AppColors.textTertiary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(PlannerRequest request) {
    final dep = request.departureCity ?? '出发地';
    final dest = request.destination ?? '目的地';

    return _LayeredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: '航班推荐', icon: Icons.flight_rounded),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.flight_takeoff, color: TravelDesignTokens.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$dep → $dest', style: TravelTypography.content(AppColors.textPrimary, fontSize: 14)),
                    Text('往返航班 · 待确认', style: TravelTypography.hint(AppColors.textTertiary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradesSection(PlannerRequest request) {
    return _LayeredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: '行程升级推荐', icon: Icons.workspace_premium_rounded),
          const SizedBox(height: 10),
          ..._upgrades.asMap().entries.map((e) {
            final i = e.key;
            final u = e.value;
            final selected = _selectedUpgrades.contains(i);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.label, style: TravelTypography.content(AppColors.textPrimary, fontSize: 14)),
                        Text('+¥${u.price}', style: TravelTypography.hint(AppColors.price, fontSize: 12)),
                      ],
                    ),
                  ),
                  _ElasticSwitch(
                    value: selected,
                    onChanged: (v) => setState(() {
                      if (v) _selectedUpgrades.add(i);
                      else _selectedUpgrades.remove(i);
                    }),
                    activeTrackColor: TravelDesignTokens.primary.withValues(alpha: 0.5),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  int get _upgradesTotal =>
      _selectedUpgrades.fold(0, (sum, i) => sum + _upgrades[i].price);

  Widget _buildPriceBreakdown(PlannerRequest request) {
    final budget = request.budgetRange;
    final min = budget?.min ?? 8000;
    final max = budget?.max ?? 15000;
    final baseTotal = ((min + max) / 2).round();
    final totalWithUpgrades = baseTotal + _upgradesTotal;
    final travelers = request.travelers ?? 2;
    final perPerson = (totalWithUpgrades / travelers).round();

    return _LayeredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: '费用预估', icon: Icons.account_balance_wallet_rounded),
          const SizedBox(height: 10),
          _PriceRow(label: '机票', value: '¥${(baseTotal * 0.4).round()}', hint: '往返含税'),
          const SizedBox(height: 6),
          _PriceRow(label: '酒店', value: '¥${(baseTotal * 0.35).round()}', hint: '${travelers}人${_computeDays(request) - 1}晚'),
          const SizedBox(height: 6),
          _PriceRow(label: '当地玩乐', value: '¥${(baseTotal * 0.25).round()}', hint: '门票·体验'),
          if (_selectedUpgrades.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...(_selectedUpgrades.toList()..sort()).map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _PriceRow(
                label: _upgrades[i].label,
                value: '+¥${_upgrades[i].price}',
              ),
            )),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: TravelDesignTokens.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('预估总价', style: TravelTypography.content(AppColors.textPrimary, fontSize: 14).copyWith(fontWeight: FontWeight.w600)),
                _AnimatedPrice(value: totalWithUpgrades),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _AnimatedPerPerson(value: perPerson),
        ],
      ),
    );
  }

  Widget _buildStickyCta(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: TravelDesignTokens.primary,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('立即锁定行程', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(plannerFormStateProvider.notifier).updateRequest(
                    ref.read(currentPlannerResultProvider)?.request ?? const PlannerRequest(),
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: TravelDesignTokens.primary,
                  side: BorderSide(color: TravelDesignTokens.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('修改偏好', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared widgets ────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TravelTypography.hint(Colors.white, fontSize: 12)),
    );
  }
}

/// Switch with a subtle elastic scale animation on toggle (smooth, premium feel).
class _ElasticSwitch extends StatefulWidget {
  const _ElasticSwitch({
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeTrackColor;

  @override
  State<_ElasticSwitch> createState() => _ElasticSwitchState();
}

class _ElasticSwitchState extends State<_ElasticSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  static const _duration = Duration(milliseconds: 280);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _duration, vsync: this);
    _scale = Tween<double>(begin: 1, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ElasticSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.forward(from: 0).then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Switch.adaptive(
        value: widget.value,
        onChanged: widget.onChanged,
        activeTrackColor: widget.activeTrackColor,
      ),
    );
  }
}

class _LayeredCard extends StatelessWidget {
  const _LayeredCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TravelDesignTokens.primary),
        const SizedBox(width: 6),
        Text(title, style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 15)),
      ],
    );
  }
}

class _CollapsibleDay extends StatefulWidget {
  const _CollapsibleDay({
    required this.dayNumber,
    required this.title,
    this.description,
  });

  final int dayNumber;
  final String title;
  final String? description;

  @override
  State<_CollapsibleDay> createState() => _CollapsibleDayState();
}

class _CollapsibleDayState extends State<_CollapsibleDay> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCF8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          AppTapScale(
            onTap: () => setState(() => _expanded = !_expanded),
            pressedScale: 0.98,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: TravelDesignTokens.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${widget.dayNumber}',
                      style: TravelTypography.content(TravelDesignTokens.primary, fontSize: 12)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TravelTypography.content(AppColors.textPrimary, fontSize: 14),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          ),
          if (_expanded && widget.description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 12, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.description!,
                  style: TravelTypography.hint(AppColors.textSecondary, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedPrice extends StatefulWidget {
  const _AnimatedPrice({required this.value});

  final int value;

  @override
  State<_AnimatedPrice> createState() => _AnimatedPriceState();
}

class _AnimatedPriceState extends State<_AnimatedPrice> {
  int _fromValue = 0;
  bool _initialized = false;

  @override
  void didUpdateWidget(_AnimatedPrice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _fromValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = _initialized
        ? const Duration(milliseconds: 350)
        : Duration.zero;
    _initialized = true;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _fromValue.toDouble(), end: widget.value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '¥${value.round()} 起',
          style: TravelTypography.content(AppColors.price, fontSize: 18)
              .copyWith(fontWeight: FontWeight.w700),
        );
      },
    );
  }
}

class _AnimatedPerPerson extends StatefulWidget {
  const _AnimatedPerPerson({required this.value});

  final int value;

  @override
  State<_AnimatedPerPerson> createState() => _AnimatedPerPersonState();
}

class _AnimatedPerPersonState extends State<_AnimatedPerPerson> {
  int _fromValue = 0;
  bool _initialized = false;

  @override
  void didUpdateWidget(_AnimatedPerPerson oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _fromValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = _initialized
        ? const Duration(milliseconds: 350)
        : Duration.zero;
    _initialized = true;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _fromValue.toDouble(), end: widget.value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '人均约 ¥${value.round()}',
          style: TravelTypography.hint(AppColors.textTertiary, fontSize: 12),
        );
      },
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.hint});

  final String label;
  final String value;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(label, style: TravelTypography.content(AppColors.textPrimary, fontSize: 13)),
            if (hint != null) ...[
              const SizedBox(width: 6),
              Text('($hint)', style: TravelTypography.hint(AppColors.textTertiary, fontSize: 11)),
            ],
          ],
        ),
        Text(value, style: TravelTypography.content(AppColors.textPrimary, fontSize: 13).copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
