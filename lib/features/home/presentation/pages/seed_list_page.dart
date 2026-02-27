import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

/// Slight per-card background tint for blog list (art-like, subtle).
Color _blogCardTint(int index) {
  const colors = [
    AppColors.homeSectionGreen,
    AppColors.companionSectionGold,
    AppColors.companionSectionWarm,
    AppColors.companionSectionLavender,
    AppColors.companionSectionGreen,
    AppColors.companionSectionBlue,
  ];
  final c = colors[index % colors.length];
  return c.withValues(alpha: 0.35);
}

/// 凌行天下旅行种草官 · 商业级列表页（中国旅行超级 App 风格）
/// 艺术化 Header / AI 背景 / 分区色 / 粘性标题 / 查看更多
class SeedListPage extends StatefulWidget {
  const SeedListPage({super.key});

  static const double kCardRadius = 12.0;

  @override
  State<SeedListPage> createState() => _SeedListPageState();
}

class _SeedListPageState extends State<SeedListPage>
    with SingleTickerProviderStateMixin {
  static const double _kHeaderHeight = 180.0;
  static const double _kHeaderRadius = 16.0;

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
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _expandList(kHomePeople, 8);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.homeSectionGreen,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        cacheExtent: 300,
        slivers: [
          _buildArtisticHeader(context, topPadding),
          SliverStickyHeader.builder(
            builder: (context, state) => _StickySectionHeader(
              title: '发现更多种草官',
              barColor: AppColors.sectionSeed,
              icon: Icons.eco_rounded,
              isPinned: state.isPinned,
              onSeeMore: () => context.pop(),
            ),
            overlapsContent: false,
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarmWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.sectionSeed.withValues(alpha: 0.12),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        offset: const Offset(0, 1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final person = list[index];
                        return RepaintBoundary(
                          child: _SeedListCard(
                            person: person,
                            index: index,
                            onTap: () => context.push(
                              '/blog/${person.id.split('_').first}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtisticHeader(BuildContext context, double topPadding) {
    return SliverToBoxAdapter(
      child: Container(
        height: _kHeaderHeight + topPadding,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(_kHeaderRadius),
            bottomRight: Radius.circular(_kHeaderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(_kHeaderRadius),
            bottomRight: Radius.circular(_kHeaderRadius),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // AI / 插画背景
              Positioned.fill(
                child: Image.asset(
                  'assets/header_planner_ai.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildGradientFallback(),
                ),
              ),
              // 渐变遮罩（底部过渡）
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.5),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // 顶部导航 + 标题
              Positioned(
                top: topPadding,
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () => context.pop(),
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        AppLocalizations.of(context)?.homeSeedSectionTitle ?? '凌行天下旅行种草官',
                        style: AppTextStyles.header(
                          Colors.white,
                          fontSize: 28,
                        ).copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '发现更多旅行故事与攻略',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 13,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  Widget _buildGradientFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sectionSeed,
            const Color(0xFF43A047),
            const Color(0xFF2E7D32),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  static List<HomePersonItem> _expandList(
    List<HomePersonItem> src,
    int targetCount,
  ) {
    if (src.isEmpty) return [];
    final out = <HomePersonItem>[];
    for (var i = 0; out.length < targetCount; i++) {
      for (final p in src) {
        if (out.length >= targetCount) break;
        out.add(HomePersonItem(
          id: '${p.id}_$i',
          name: p.name,
          avatarUrl: p.avatarUrl,
          subtitle: p.subtitle,
          readCount: p.readCount,
          likeCount: p.likeCount,
        ));
      }
    }
    return out;
  }
}

// ─── 粘性分区标题：色条 + 图标 + 查看更多 ───
class _StickySectionHeader extends StatelessWidget {
  const _StickySectionHeader({
    required this.title,
    required this.barColor,
    required this.icon,
    this.onSeeMore,
    required this.isPinned,
  });

  final String title;
  final Color barColor;
  final IconData icon;
  final VoidCallback? onSeeMore;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isPinned ? AppColors.card : Colors.transparent,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    barColor,
                    barColor.withValues(alpha: 0.75),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onSeeMore != null)
              GestureDetector(
                onTap: onSeeMore,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '查看更多',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.linkCta,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.linkCta,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── 种草官卡片：轻微背景色 / 柔和边框 / 无溢出 ───
class _SeedListCard extends StatelessWidget {
  const _SeedListCard({
    required this.person,
    required this.onTap,
    this.index = 0,
  });

  final HomePersonItem person;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cardTint = _blogCardTint(index);
    return AppTapScale(
      onTap: onTap,
      child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardTint,
              borderRadius: BorderRadius.circular(SeedListPage.kCardRadius),
              border: Border.all(
                color: AppColors.sectionSeed.withValues(alpha: 0.1),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    imageUrl: person.avatarUrl,
                    width: 72.w,
                    height: 72.w,
                    fit: BoxFit.cover,
                    errorWidget: _avatarPlaceholder(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        person.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        person.subtitle ?? '发现更多旅行故事',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (person.readCount != null || person.likeCount != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (person.readCount != null) ...[
                              Icon(
                                Icons.visibility_outlined,
                                size: 12.sp,
                                color: AppColors.textTertiary,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  _formatCount(person.readCount!),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontSize: 10.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            if (person.readCount != null &&
                                person.likeCount != null)
                              SizedBox(width: 10.w),
                            if (person.likeCount != null) ...[
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 12.sp,
                                color: AppColors.textTertiary,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  _formatCount(person.likeCount!),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontSize: 10.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 72.w,
      height: 72.w,
      color: AppColors.sectionSeed.withValues(alpha: 0.2),
      child: Icon(
        Icons.person_rounded,
        size: 32.sp,
        color: AppColors.sectionSeed.withValues(alpha: 0.6),
      ),
    );
  }
}

String _formatCount(int n) {
  if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return n.toString();
}
