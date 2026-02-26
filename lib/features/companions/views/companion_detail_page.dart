import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../chat/data/chat_repository_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/companion_detail_provider.dart';
import '../data/companion_list_mock.dart';
import '../models/companion_detail.dart';
import '../models/companion_list_item.dart';
import '../widgets/rating_widget.dart';

IconData _skillTagToIcon(String tag) {
  if (tag.contains('摄影') || tag.contains('跟拍')) return Icons.camera_alt_rounded;
  if (tag.contains('美食')) return Icons.restaurant_rounded;
  if (tag.contains('讲解') || tag.contains('文化')) return Icons.menu_book_rounded;
  if (tag.contains('路线') || tag.contains('规划')) return Icons.route_rounded;
  if (tag.contains('方言') || tag.contains('沟通')) return Icons.translate_rounded;
  if (tag.contains('历史')) return Icons.account_balance_rounded;
  if (tag.contains('园林') || tag.contains('古镇')) return Icons.park_rounded;
  if (tag.contains('夜景')) return Icons.nightlight_rounded;
  return Icons.auto_awesome_rounded;
}

/// 陪游详情页 — 大封面 + 分层区块 + 底部固定预订栏（数据来自 API：companion + rating + reviews + availability）
class CompanionDetailPage extends ConsumerWidget {
  const CompanionDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(companionDetailProvider(id));
    return asyncDetail.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.warmBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16.h),
              Text(
                '加载中...',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.warmBackground,
        appBar: AppBar(backgroundColor: AppColors.surface, title: const Text('陪游详情')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.textTertiary),
                SizedBox(height: 16.h),
                Text(
                  err.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 24.h),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(companionDetailProvider(id)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (detail) => _CompanionDetailContent(detail: detail, companionId: id),
    );
  }
}

class _CompanionDetailContent extends ConsumerStatefulWidget {
  const _CompanionDetailContent({required this.detail, required this.companionId});

  final CompanionDetail detail;
  final String companionId;

  @override
  ConsumerState<_CompanionDetailContent> createState() => _CompanionDetailContentState();
}

class _CompanionDetailContentState extends ConsumerState<_CompanionDetailContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarFadeController;
  late Animation<double> _avatarFade;

  static const double _expandedHeight = 200;
  static const List<String> _weekdayLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  static const double _heroAvatarSize = 64;
  static const double _sectionPaddingH = 14;
  static const double _sectionSpacing = 14;
  static const double _bottomBarHeight = 72;

  static const Color _coverGradientStart = Color(0x00000000);
  static const Color _coverGradientEnd = Color(0xE6000000);

  CompanionDetail get _detail => widget.detail;
  String get _companionId => widget.companionId;

  bool _bioExpanded = false;
  int _selectedDateIndex = 0;
  int _reviewFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _avatarFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _avatarFade = CurvedAnimation(
      parent: _avatarFadeController,
      curve: Curves.easeOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _avatarFadeController.forward();
    });
  }

  @override
  void dispose() {
    _avatarFadeController.dispose();
    super.dispose();
  }

  /// Effective gallery list: non-empty images, or [avatar] fallback, max 5.
  List<String> get _galleryImages {
    final fromImages = _detail.images.where((e) => e.trim().isNotEmpty).toList();
    if (fromImages.isNotEmpty) return fromImages.take(5).toList();
    if (_detail.avatar.trim().isNotEmpty) return [_detail.avatar];
    return [];
  }

  /// Create a chat channel between the current user and this companion, then open it on the Chat tab.
  /// Uses companion's user id from API (detail.id) so the backend can find-or-create the conversation.
  Future<void> _openChatWithCompanion(BuildContext context) async {
    if (!ref.read(authProvider).isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先登录后再发起聊天')),
        );
      }
      return;
    }
    final companionUserId = _detail.id;
    if (companionUserId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法获取陪游信息')),
        );
      }
      return;
    }
    try {
      final repo = ref.read(chatRepositoryProvider);
      final conv = await repo.createConversation(otherUserId: companionUserId);
      if (!mounted) return;
      context.go('/${RouteNames.messages}/chat/${conv.id}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('无法发起聊天: ${e.toString().replaceFirst('Exception: ', '')}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        cacheExtent: 400,
        slivers: [
          _buildCoverSliverAppBar(),
          SliverToBoxAdapter(child: _wrapSection(0, _buildProfileSection())),
          SliverToBoxAdapter(child: _wrapSection(1, _buildSkillSection())),
          SliverToBoxAdapter(child: _wrapSection(2, _buildPackagesTableSection())),
          SliverToBoxAdapter(child: _wrapSection(3, _buildAvailabilitySection())),
          SliverToBoxAdapter(child: _wrapSection(4, _buildAboutSection())),
          SliverToBoxAdapter(child: _wrapSection(5, _buildReviewsSection())),
          SliverToBoxAdapter(child: _wrapSection(6, _buildSimilarCompanionsSection())),
          SliverToBoxAdapter(child: _wrapSection(7, _buildTrustSafetySection())),
          SliverToBoxAdapter(child: _wrapSection(8, _buildServiceDetailsSection())),
          SliverPadding(
            padding: EdgeInsets.only(bottom: _bottomBarHeight.h + MediaQuery.of(context).padding.bottom + 12),
          ),
        ],
      ),
      bottomNavigationBar: _buildStickyBookingBar(),
    );
  }

  static Color _sectionColor(int index) {
    const colors = [
      AppColors.homeSectionGreen,
      AppColors.homeSectionYellow,
      AppColors.homeSectionBlueStart,
      Color(0xFFFFF3E0),
      Color(0xFFF3E5F5),
      Color(0xFFE0F2F1),
      AppColors.companionSectionWarm,
      AppColors.companionSectionLavender,
      AppColors.companionSectionBlue,
    ];
    return colors[index % colors.length];
  }

  Widget _wrapSection(int index, Widget child) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _sectionColor(index),
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      child: child,
    );
  }

  String get _coverImageUrl {
    final imgs = _galleryImages;
    if (imgs.isNotEmpty) return imgs.first;
    return _detail.avatar;
  }

  /// 1. Large cover image with gradient overlay
  Widget _buildCoverSliverAppBar() {
    return SliverAppBar(
      expandedHeight: _expandedHeight.h,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: AppTapScale(
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp, color: AppColors.textPrimary),
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      actions: [
        AppTapScale(
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.chat_bubble_outline_rounded, size: 20.sp, color: AppColors.textPrimary),
            ),
            onPressed: () => _openChatWithCompanion(context),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: AppTapScale(
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.share_rounded, size: 20.sp, color: AppColors.textPrimary),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (_coverImageUrl.isNotEmpty)
              Image.network(
                _coverImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildCoverPlaceholder(),
              )
            else
              _buildCoverPlaceholder(),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_coverGradientStart, _coverGradientEnd],
                ),
              ),
            ),
            // Bottom profile strip
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Hero(
                      tag: 'companion_avatar_$_companionId',
                      child: FadeTransition(
                        opacity: _avatarFade,
                        child: CircleAvatar(
                          radius: (_heroAvatarSize / 2).r,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: (_heroAvatarSize / 2 - 2).r,
                            backgroundColor: AppColors.surface,
                            backgroundImage: _detail.avatar.isNotEmpty
                                ? NetworkImage(_detail.avatar)
                                : (_coverImageUrl.isNotEmpty ? NetworkImage(_coverImageUrl) : null),
                            child: _detail.avatar.isEmpty && _coverImageUrl.isEmpty
                                ? Icon(Icons.person_rounded, size: 40.sp, color: AppColors.textTertiary)
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${_detail.name} · ${_detail.age}岁',
                                    style: AppTextStyles.headlineMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_detail.isVerified) ...[
                                  SizedBox(width: 4.w),
                                  Icon(Icons.verified_rounded, size: 18.sp, color: Colors.white),
                                ],
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _detail.experienceYears != null
                                  ? '${_detail.city} · ${_detail.experienceYears}年经验'
                                  : _detail.city,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 14.sp, color: AppColors.accentGold),
                                SizedBox(width: 4.w),
                                Text(
                                  '${(_detail.rating ?? 0).toStringAsFixed(1)} · ${_detail.reviewCount ?? _detail.reviews.length}条评价',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildCoverPlaceholder() {
    return Container(
      color: AppColors.primaryPale,
      child: Center(
        child: Icon(Icons.person_rounded, size: 80.sp, color: AppColors.primary.withValues(alpha: 0.4)),
      ),
    );
  }

  /// 2. Profile Section — compact meta row
  Widget _buildProfileSection() {
    final hasMeta = (_detail.responseTime != null && _detail.responseTime!.isNotEmpty) ||
        (_detail.acceptRate != null && _detail.acceptRate!.isNotEmpty) ||
        (_detail.languages != null && _detail.languages!.isNotEmpty);
    if (!hasMeta) return const SizedBox.shrink();

    return _buildSection(
      child: Wrap(
        spacing: 8.w,
        runSpacing: 6.h,
        children: [
          if (_detail.responseTime != null && _detail.responseTime!.isNotEmpty)
            _buildMetaChip(Icons.speed_rounded, '平均${_detail.responseTime}回复'),
          if (_detail.acceptRate != null && _detail.acceptRate!.isNotEmpty)
            _buildMetaChip(Icons.percent_rounded, '接单率${_detail.acceptRate}'),
          if (_detail.languages != null && _detail.languages!.isNotEmpty)
            _buildMetaChip(Icons.language_rounded, _detail.languages!.join(' / ')),
        ],
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryPale.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12.sp, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required Widget child, String? title}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, _sectionSpacing.h, _sectionPaddingH.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(fontSize: 15.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
            ],
            child,
          ],
        ),
      ),
    );
  }

  /// 3. Skill Section — 技能标签 with icons
  Widget _buildSkillSection() {
    if (_detail.skillTags.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      title: '技能标签',
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: _detail.skillTags.map((tag) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryPale.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_skillTagToIcon(tag), size: 14.sp, color: AppColors.textSecondary),
                SizedBox(width: 6.w),
                Text(
                  tag,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12.sp, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 7. About Section
  static const int _bioMaxLinesCollapsed = 4;

  Widget _buildAboutSection() {
    return _buildSection(
      title: '关于我',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _detail.bio,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
              fontSize: 13.sp,
            ),
            maxLines: _bioExpanded ? null : _bioMaxLinesCollapsed,
            overflow: _bioExpanded ? null : TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: () => setState(() => _bioExpanded = !_bioExpanded),
            child: Text(
              _bioExpanded ? '收起' : '展开',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Service packages comparison table
  Widget _buildPackagesTableSection() {
    if (_detail.packages.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      title: '套餐对比',
      child: Column(
        children: [
          // Table header
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('套餐', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp))),
                Expanded(flex: 2, child: Text('说明', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp))),
                SizedBox(width: 8.w),
                Text('价格', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp)),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          ..._detail.packages.asMap().entries.map((e) {
            final p = e.value;
            final isLast = e.key == _detail.packages.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5), width: 0.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        p.name,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        p.desc,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11.sp, color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '¥${p.price.toStringAsFixed(0)}${p.unit}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.price,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 6. Availability calendar preview (from API when available)
  Widget _buildAvailabilitySection() {
    final slots = _detail.availabilitySlots;
    final today = DateTime.now();
    final dateCount = slots != null && slots.isNotEmpty
        ? slots.length
        : 7;
    final dates = slots != null && slots.isNotEmpty
        ? slots.map((s) => s.date).toList()
        : List.generate(7, (i) => today.add(Duration(days: i)));
    return _buildSection(
      title: '可预约时间',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 64.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: dateCount,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, i) {
                final d = dates[i];
                final weekday = _weekdayLabels[d.weekday - 1];
                final selected = _selectedDateIndex == i;
                return _buildDateCard(
                  weekday: weekday,
                  dayNum: d.day,
                  selected: selected,
                  onTap: () => setState(() => _selectedDateIndex = i),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            slots != null && slots.isNotEmpty
                ? '${slots.length} 个可预约日期'
                : '暂无档期数据，可联系咨询',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required String weekday,
    required int dayNum,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56.w,
        height: 64.h,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: selected ? null : Border.all(color: AppColors.border, width: 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: AppTextStyles.overline.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              '$dayNum',
              style: AppTextStyles.titleMedium.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Trust & Safety
  Widget _buildTrustSafetySection() {
    const items = [
      (icon: Icons.badge_rounded, label: '实名认证'),
      (icon: Icons.shield_rounded, label: '平台担保'),
      (icon: Icons.cancel_outlined, label: '无理由取消'),
    ];
    return _buildSection(
      title: '保障服务',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final item in items)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 24.sp, color: AppColors.primary),
                  SizedBox(height: 4.h),
                  Text(
                    item.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 11.sp,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  /// Service Details Section
  Widget _buildServiceDetailsSection() {
    return _buildSection(
      title: '服务说明',
      child: Text(
        _detail.serviceDesc,
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 13.sp, height: 1.5),
        maxLines: 20,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 8. Reviews Section with filtering
  List<CompanionReview> get _filteredReviews {
    var list = _detail.reviews;
    switch (_reviewFilterIndex) {
      case 1:
        list = list.where((r) => r.rating >= 4.5).toList(); // 5星
        break;
      case 2:
        list = list.where((r) => r.rating >= 4 && r.rating < 4.5).toList(); // 4星
        break;
      case 3:
        list = list.where((r) => r.hasImage).toList(); // 有图
        break;
      default:
        break;
    }
    return list;
  }

  Widget _buildReviewsSection() {
    final rating = _detail.rating ??
        (_detail.reviews.isEmpty ? 0.0 : _detail.reviews.map((e) => e.rating).reduce((a, b) => a + b) / _detail.reviews.length);
    final count = _detail.reviewCount ?? _detail.reviews.length;
    final filtered = _filteredReviews;

    return _buildSection(
      title: '用户评价',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(Icons.star_rounded, size: 20.sp, color: AppColors.accentGold),
              SizedBox(width: 4.w),
              Text(
                rating.toStringAsFixed(1),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 6.w),
              Text(
                '共${count}条',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Filter chips
          Row(
            children: [
              _buildReviewFilterChip('全部', 0),
              SizedBox(width: 8.w),
              _buildReviewFilterChip('5星', 1),
              SizedBox(width: 8.w),
              _buildReviewFilterChip('4星', 2),
              SizedBox(width: 8.w),
              _buildReviewFilterChip('有图', 3),
            ],
          ),
          SizedBox(height: 12.h),
          if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  '暂无评价',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          else
            ...filtered.map((r) => _buildReviewCard(r)),
        ],
      ),
    );
  }

  Widget _buildReviewFilterChip(String label, int index) {
    final selected = _reviewFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _reviewFilterIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// 9. Similar companions section
  Widget _buildSimilarCompanionsSection() {
    final similar = getSimilarCompanions(_companionId, _detail.city);
    if (similar.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, _sectionSpacing.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '相似陪游',
            style: AppTextStyles.titleMedium.copyWith(fontSize: 15.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 140.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: similar.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, i) {
                final c = similar[i];
                return _buildSimilarCard(c);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard(CompanionListItem c) {
    return GestureDetector(
      onTap: () => context.push('/companions/${c.id}'),
      child: Container(
        width: 110.w,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                c.avatarUrl,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56.w,
                  height: 56.w,
                  color: AppColors.surface,
                  child: Icon(Icons.person_rounded, size: 28.sp, color: AppColors.textTertiary),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              c.name,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            RatingWidget(
              rating: c.rating,
              iconSize: 10,
              fontSize: 10,
              suffix: '',
              starColor: AppColors.accentGold,
            ),
            SizedBox(height: 2.h),
            Text(
              '¥${c.pricePerDay.toStringAsFixed(0)}/天',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.price,
                fontSize: 11.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(CompanionReview r) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.surface,
              backgroundImage: r.avatar.isNotEmpty ? NetworkImage(r.avatar) : null,
              onBackgroundImageError: r.avatar.isNotEmpty ? (_, __) {} : null,
              child: r.avatar.isEmpty
                  ? Text(
                      r.userName.isNotEmpty ? r.userName.substring(0, 1).toUpperCase() : '?',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row 1: Username + rating stars
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          r.userName,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < r.rating.round().clamp(0, 5) ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 14.sp,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Row 2: Short review text (max 2 lines)
                  Text(
                    r.content,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  // Row 3: Date
                  Text(
                    r.date,
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sticky booking bar (fixed at bottom): white, top shadow, price left, yellow gradient CTA right
  Widget _buildStickyBookingBar() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final pricePerDay = _detail.packages.isEmpty
        ? 0.0
        : _detail.packages.map((e) => e.price).reduce((a, b) => a < b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _bottomBarHeight.h,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Left: ¥298 / 天 + 可议价
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¥${pricePerDay.toStringAsFixed(0)} / 天',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '可议价',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Right: large yellow gradient button — 立即预约 (tap scale)
              AppTapScale(
                onTap: () => context.push('/companions/$_companionId/order'),
                pressedScale: 0.97,
                child: Container(
                  height: 48.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD54F), Color(0xFFFFB300), Color(0xFFFF8F00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8F00).withValues(alpha: 0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '立即预约',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
