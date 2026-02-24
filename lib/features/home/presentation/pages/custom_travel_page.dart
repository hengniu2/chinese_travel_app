import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';

/// 定制旅行 — Premium · Fun · Green · Cartoon but professional
class CustomTravelPage extends StatefulWidget {
  const CustomTravelPage({super.key});

  @override
  State<CustomTravelPage> createState() => _CustomTravelPageState();
}

class _CustomTravelPageState extends State<CustomTravelPage> {
  bool _isPersonal = true; // true = 个人定制, false = 团队定制

  static const double _headerHeight = 260;
  static const double _headerRadius = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _buildPersonalTeamSwitch(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _buildFormCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _buildCtaButton(context),
            ),
          ),
          _buildSectionTitle('热门定制路线'),
          _buildHotRoutesSliver(),
          _buildSectionTitle('客户评价'),
          _buildReviewsSliver(),
          _buildSectionTitle('服务流程'),
          _buildServiceStepsSliver(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: Container(
        height: _headerHeight + topPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(_headerRadius),
            bottomRight: Radius.circular(_headerRadius),
          ),
          boxShadow: AppShadow.medium,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(_headerRadius),
            bottomRight: Radius.circular(_headerRadius),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppGradients.customTravelHeader,
                    stops: AppGradients.customTravelHeaderStops,
                  ),
                ),
              ),
              Positioned(right: 24, top: 80, child: _CustomTravelDecoCircle(radius: 40)),
              Positioned(left: 32, bottom: 36, child: _CustomTravelDecoCircle(radius: 24)),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withValues(alpha: 0.15),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '定制旅行',
                              style: AppTextStyles.display.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '专属你的个性化旅程',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ['安心定制', '随心玩', '精心服务']
                                  .map((label) => _headerPill(label))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      _buildHeaderIllustration(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildHeaderIllustration() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.map_rounded,
        size: 48,
        color: Colors.white.withValues(alpha: 0.95),
      ),
    );
  }

  Widget _buildPersonalTeamSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalTeamToggle(
          isPersonal: _isPersonal,
          onChanged: (v) => setState(() => _isPersonal = v),
          personalLabel: '个人定制',
          teamLabel: '团队定制',
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _isPersonal
                ? '个人定制: 亲子·蜜月·好友'
                : '团队定制: 团建·商务·会议',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        children: [
          _FormField(icon: Icons.place_rounded, hint: '我想去...'),
          const SizedBox(height: 8),
          _FormField(icon: Icons.phone_rounded, hint: '手机号'),
          const SizedBox(height: 8),
          _FormField(icon: Icons.account_balance_wallet_rounded, hint: '预算区间'),
          const SizedBox(height: 8),
          _FormField(icon: Icons.groups_rounded, hint: '出行人数'),
        ],
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: AppGradients.customTravelCta,
          stops: AppGradients.customTravelCtaStops,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          ...AppShadow.medium,
          BoxShadow(
            color: const Color(0xFF558B2F).withValues(alpha: 0.4),
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('即将开放定制申请'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: Text(
              '立即定制',
              style: AppTextStyles.label.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHotRoutesSliver() {
    const routes = [
      (title: '云南大理深度游', price: '¥3,280', badge: '热门'),
      (title: '江南水乡三日', price: '¥1,880', badge: null),
      (title: '川西秘境小团', price: '¥4,500', badge: '新品'),
    ];
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryPale.withValues(alpha: 0.4),
              AppColors.background,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(right: 12, top: 20, child: _CustomTravelDecoCircle(radius: 24)),
            Positioned(left: 40, bottom: 12, child: _CustomTravelDecoCircle(radius: 16)),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: routes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final r = routes[i];
                  return _HotRouteCard(
                    title: r.title,
                    price: r.price,
                    badge: r.badge,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildReviewsSliver() {
    const reviews = [
      (name: '张女士', text: '规划师很贴心，行程不赶，孩子玩得特别开心！', stars: 5),
      (name: '李先生', text: '公司团建选的定制路线，大家都很满意，下次还来。', stars: 5),
    ];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryPale.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: reviews
              .map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ReviewCard(
                      name: r.name,
                      text: r.text,
                      stars: r.stars,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildServiceStepsSliver() {
    const steps = [
      (title: '填写需求', subtitle: '目的地、人数、预算、偏好', icon: Icons.edit_note_rounded),
      (title: '专属方案', subtitle: '规划师 1v1 定制行程', icon: Icons.travel_explore_rounded),
      (title: '确认出行', subtitle: '预订支付，安心出发', icon: Icons.check_circle_rounded),
    ];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryPale.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              _ServiceStepRow(
                title: steps[i].title,
                subtitle: steps[i].subtitle,
                icon: steps[i].icon,
                stepNumber: i + 1,
              ),
              if (i < steps.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Container(
                    width: 2,
                    height: 16,
                    color: AppColors.primaryLight.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Segmented tab: active = white elevated, inactive = gray text ───
// ─── Form field: height 52, radius 20, soft gray bg, left icon ───
class _FormField extends StatelessWidget {
  const _FormField({required this.icon, required this.hint});

  final IconData icon;
  final String hint;

  static const double _height = 52;
  static const double _radius = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_radius),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTravelDecoCircle extends StatelessWidget {
  const _CustomTravelDecoCircle({required this.radius});
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
      ),
    );
  }
}

// ─── Hot route card: gradient overlay, title + gradient price, optional badge ───
class _HotRouteCard extends StatelessWidget {
  const _HotRouteCard({
    required this.title,
    required this.price,
    this.badge,
  });

  final String title;
  final String price;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 188,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadow.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.primaryPale,
            child: Icon(
              Icons.image_rounded,
              size: 44,
              color: AppColors.primaryLight.withValues(alpha: 0.6),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badge == '热门' ? AppColors.price : AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: AppGradients.price,
                    stops: AppGradients.priceStops,
                  ).createShader(bounds),
                  child: Text(
                    price,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
}

// ─── Review card: avatar + short review + stars ───
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.text,
    required this.stars,
  });

  final String name;
  final String text;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadow.light,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.surface,
            child: Icon(Icons.person_rounded, color: AppColors.textTertiary, size: 28),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(
                      stars,
                      (_) => Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.accentGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Service step row: icon + number + title + subtitle ───
class _ServiceStepRow extends StatelessWidget {
  const _ServiceStepRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.stepNumber,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryPale,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: AppColors.primaryDark),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
