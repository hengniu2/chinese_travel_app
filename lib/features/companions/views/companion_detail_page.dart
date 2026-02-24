import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../data/companion_detail_mock.dart';
import '../models/companion_detail.dart';

/// 陪游详情页 — 结构：SliverAppBar + 模块化 Sliver 区块 + 底部固定预订栏
class CompanionDetailPage extends StatefulWidget {
  const CompanionDetailPage({super.key, required this.id});

  final String id;

  @override
  State<CompanionDetailPage> createState() => _CompanionDetailPageState();
}

class _CompanionDetailPageState extends State<CompanionDetailPage>
    with SingleTickerProviderStateMixin {
  late CompanionDetail _detail;
  bool _bioExpanded = false;
  late AnimationController _avatarFadeController;
  late Animation<double> _avatarFade;
  late PageController _galleryController;
  int _galleryPage = 0;
  int _selectedDateIndex = 0;

  static const double _expandedHeight = 260;
  static const List<String> _weekdayLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  static const double _galleryHeight = 220;
  static const double _galleryRadius = 20;
  static const double _heroAvatarSize = 100;
  static const double _sectionPaddingH = 16;
  static const double _sectionSpacing = 24;
  static const double _bottomBarHeight = 76;

  /// Light yellow gradient for hero background
  static const Color _heroGradientStart = Color(0xFFFFF4D6);
  static const Color _heroGradientEnd = Color(0xFFFFC83D);

  @override
  void initState() {
    super.initState();
    _detail = getCompanionDetail(widget.id);
    _avatarFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _avatarFade = CurvedAnimation(
      parent: _avatarFadeController,
      curve: Curves.easeOut,
    );
    _galleryController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _avatarFadeController.forward();
    });
  }

  @override
  void dispose() {
    _avatarFadeController.dispose();
    _galleryController.dispose();
    super.dispose();
  }

  /// Effective gallery list: non-empty images, or [avatar] fallback, max 5.
  List<String> get _galleryImages {
    final fromImages = _detail.images.where((e) => e.trim().isNotEmpty).toList();
    if (fromImages.isNotEmpty) return fromImages.take(5).toList();
    if (_detail.avatar.trim().isNotEmpty) return [_detail.avatar];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildGallerySection()),
          SliverToBoxAdapter(child: _buildProfileSection()),
          SliverToBoxAdapter(child: _buildServiceTagsSection()),
          SliverToBoxAdapter(child: _buildAboutSection()),
          SliverToBoxAdapter(child: _buildPricingSection()),
          SliverToBoxAdapter(child: _buildAvailabilitySection()),
          SliverToBoxAdapter(child: _buildTrustSafetySection()),
          SliverToBoxAdapter(child: _buildServiceDetailsSection()),
          SliverToBoxAdapter(child: _buildReviewsPreviewSection()),
          SliverPadding(
            padding: EdgeInsets.only(bottom: _bottomBarHeight.h + MediaQuery.of(context).padding.bottom),
          ),
        ],
      ),
      bottomNavigationBar: _buildStickyBookingBar(),
    );
  }

  /// 1. SliverAppBar — expanded 260, light yellow gradient, soft abstract bg, bottom-aligned hero content
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: _expandedHeight.h,
      pinned: true,
      stretch: true,
      backgroundColor: _heroGradientEnd,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: AppTapScale(
          child: IconButton(
            icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
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
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: AppTapScale(
            child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
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
        stretchModes: [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Soft abstract yellow gradient background (elegant, no heavy image)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_heroGradientStart, _heroGradientEnd],
                ),
              ),
            ),
            // Subtle radial/decoration for warmth (optional soft circles or gradient overlay)
            Positioned(
              top: -80.h,
              right: -60.w,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -40.h,
              left: -40.w,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Foreground content — bottom aligned
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Large circular avatar (100px) — fade-in
                    FadeTransition(
                      opacity: _avatarFade,
                      child: CircleAvatar(
                        radius: (_heroAvatarSize / 2).r,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: (_heroAvatarSize / 2 - 3).r,
                          backgroundColor: AppColors.surface,
                          backgroundImage: _detail.avatar.isNotEmpty
                              ? NetworkImage(_detail.avatar)
                              : null,
                          child: _detail.avatar.isEmpty
                              ? Icon(Icons.person_rounded, size: 48.sp, color: AppColors.textTertiary)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Right column: name, city, rating, online
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Row 1: Name · Age + verified badge
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${_detail.name} · ${_detail.age}岁',
                                    style: AppTextStyles.headlineMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_detail.isVerified) ...[
                                  SizedBox(width: 6.w),
                                  Icon(Icons.verified_rounded, size: 20.sp, color: AppColors.accentCool),
                                ],
                              ],
                            ),
                            SizedBox(height: 6.h),
                            // Row 2: City · X年陪游经验
                            Text(
                              _detail.experienceYears != null
                                  ? '${_detail.city} · ${_detail.experienceYears}年陪游经验'
                                  : _detail.city,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            // Row 3: ⭐ Rating (reviewCount条评价)  已服务 X次
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 16.sp, color: AppColors.accentGold),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    '${(_detail.rating ?? 0).toStringAsFixed(1)} (${_detail.reviewCount ?? _detail.reviews.length}条评价)${_detail.completedOrders != null ? "  已服务 ${_detail.completedOrders}次" : ""}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            // Row 4: Online indicator — green dot + 在线/忙碌
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: _detail.isOnline ? AppColors.primary : AppColors.textTertiary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  _detail.isOnline ? '在线' : '忙碌',
                                  style: AppTextStyles.overline.copyWith(
                                    color: _detail.isOnline ? AppColors.primary : AppColors.textSecondary,
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

  /// Premium gallery — horizontal carousel below SliverAppBar
  Widget _buildGallerySection() {
    final images = _galleryImages;
    final count = images.isEmpty ? 1 : images.length;
    final showBadge = images.isNotEmpty && images != [_detail.avatar];

    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, 16.h, _sectionPaddingH.w, 0),
      child: SizedBox(
        height: _galleryHeight.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_galleryRadius.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _galleryController,
                onPageChanged: (int i) => setState(() => _galleryPage = i),
                itemCount: count,
                itemBuilder: (context, index) {
                  if (images.isEmpty) {
                    return _buildGalleryAvatarFallback();
                  }
                  return _buildGalleryImage(images[index]);
                },
              ),
              if (showBadge)
                Positioned(
                  top: 10.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '真实照片',
                      style: AppTextStyles.overline.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 12.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    count,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: _galleryPage == i ? 18.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _galleryPage == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _buildGalleryAvatarFallback(),
    );
  }

  Widget _buildGalleryAvatarFallback() {
    if (_detail.avatar.trim().isNotEmpty) {
      return Image.network(
        _detail.avatar,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildGalleryPlaceholderBox(),
      );
    }
    return _buildGalleryPlaceholderBox();
  }

  Widget _buildGalleryPlaceholderBox() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_heroGradientStart, _heroGradientEnd],
        ),
      ),
      child: _buildGalleryPlaceholder(),
    );
  }

  Widget _buildGalleryPlaceholder() {
    return Center(
      child: Icon(
        Icons.person_rounded,
        size: 80.sp,
        color: Colors.white.withValues(alpha: 0.7),
      ),
    );
  }

  /// 2. Profile Section
  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, _sectionSpacing.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: AppColors.surface,
                backgroundImage: _detail.avatar.isNotEmpty
                    ? NetworkImage(_detail.avatar)
                    : null,
                child: _detail.avatar.isEmpty
                    ? Icon(Icons.person_rounded, size: 32.sp, color: AppColors.textTertiary)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _detail.name,
                      style: AppTextStyles.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${_detail.city} · ${_detail.age}岁',
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_detail.responseHint != null && _detail.responseHint!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _detail.responseHint!,
                        style: AppTextStyles.overline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 3. Service Capability Section — 服务内容: tags (light yellow) + info rows
  Widget _buildServiceTagsSection() {
    final hasTags = _detail.skillTags.isNotEmpty;
    final hasInfo = (_detail.languages != null && _detail.languages!.isNotEmpty) ||
        (_detail.responseTime != null && _detail.responseTime!.isNotEmpty) ||
        (_detail.acceptRate != null && _detail.acceptRate!.isNotEmpty);
    if (!hasTags && !hasInfo) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, _sectionSpacing.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '服务内容',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          if (hasTags)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _detail.skillTags
                  .map((tag) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPale,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
            ),
          if (hasTags && hasInfo) SizedBox(height: 12.h),
          if (hasInfo)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_detail.languages != null && _detail.languages!.isNotEmpty) ...[
                  _buildServiceInfoRow(Icons.language_rounded, '语言：${_detail.languages!.join(' / ')}'),
                  SizedBox(height: 6.h),
                ],
                if (_detail.responseTime != null && _detail.responseTime!.isNotEmpty) ...[
                  _buildServiceInfoRow(Icons.schedule_rounded, '平均回复：${_detail.responseTime}'),
                  SizedBox(height: 6.h),
                ],
                if (_detail.acceptRate != null && _detail.acceptRate!.isNotEmpty)
                  _buildServiceInfoRow(Icons.percent_rounded, '接单率：${_detail.acceptRate}'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textTertiary),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 4. About Section — 关于我, expandable bio in card
  static const int _bioMaxLinesCollapsed = 4;
  static const Color _aboutTextColor = Color(0xFF2B2B2B);

  Widget _buildAboutSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, 16.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '关于我',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _detail.bio,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _aboutTextColor,
                    height: 1.55,
                    fontSize: 14.sp,
                  ),
                  maxLines: _bioExpanded ? null : _bioMaxLinesCollapsed,
                  overflow: _bioExpanded ? null : TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                  child: Text(
                    _bioExpanded ? '收起' : '展开',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  /// 5. Pricing & Service Details — 服务价格 card
  static const List<String> _includes = ['8小时陪同', '行程规划', '基础摄影'];
  static const List<String> _excludes = ['门票', '交通费', '餐费'];

  Widget _buildPricingSection() {
    final pricePerDay = _detail.packages.isEmpty
        ? 0.0
        : _detail.packages.map((e) => e.price).reduce((a, b) => a < b ? a : b);

    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, 16.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '服务价格',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: ¥298 / 天 — large bold yellow
                Text(
                  '¥${pricePerDay.toStringAsFixed(0)} / 天',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                // Row 2: 包含：• bullets
                Text(
                  '包含：',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                ..._includes.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Row 3: 不包含：• bullets
                Text(
                  '不包含：',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                ..._excludes.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  /// Availability preview — 可预约时间 (next 7 days, horizontal date selector)
  Widget _buildAvailabilitySection() {
    final today = DateTime.now();
    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, 16.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '可预约时间',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 70.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, i) {
                final d = today.add(Duration(days: i));
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
            '本周已预约 3 次',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
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
        width: 60.w,
        height: 70.h,
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

  /// Trust & Safety — 保障服务 (3 items: icon + text, yellow theme, center aligned)
  Widget _buildTrustSafetySection() {
    const items = [
      (icon: Icons.badge_rounded, label: '实名认证'),
      (icon: Icons.shield_rounded, label: '平台担保'),
      (icon: Icons.cancel_outlined, label: '无理由取消'),
    ];
    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, 16.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '保障服务',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final item in items)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 28.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        item.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12.sp,
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
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  /// 6. Service Details Section
  Widget _buildServiceDetailsSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, _sectionSpacing.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '服务说明',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Text(
            _detail.serviceDesc,
            style: AppTextStyles.bodyMedium,
            maxLines: 20,
            overflow: TextOverflow.ellipsis,
          ),
          if (_detail.packages.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              '套餐',
              style: AppTextStyles.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            ..._detail.packages.map(
              (p) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${p.name} · ${p.desc}',
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '¥${p.price.toStringAsFixed(0)}${p.unit}',
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 7. Reviews Preview Section — 用户评价
  Widget _buildReviewsPreviewSection() {
    final rating = _detail.rating ??
        (_detail.reviews.isEmpty ? 0.0 : _detail.reviews.map((e) => e.rating).reduce((a, b) => a + b) / _detail.reviews.length);
    final count = _detail.reviewCount ?? _detail.reviews.length;
    final previewReviews = _detail.reviews.take(2).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(_sectionPaddingH.w, _sectionSpacing.h, _sectionPaddingH.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '用户评价',
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          // Overall rating row: ⭐ 4.9 · Based on X条评价
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(Icons.star_rounded, size: 22.sp, color: AppColors.accentGold),
              SizedBox(width: 4.w),
              Text(
                rating.toStringAsFixed(1),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 8.w),
              Text(
                'Based on ${count}条评价',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (previewReviews.isEmpty)
            Container(
              padding: EdgeInsets.all(16.w),
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
            ...previewReviews.map((r) => _buildReviewCard(r)),
          if (_detail.reviews.isNotEmpty) ...[
            SizedBox(height: 12.h),
            AppTapScale(
              onTap: () {},
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  minimumSize: Size(0, 32.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '查看全部评价 →',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(CompanionReview r) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
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
                onTap: () => context.push('/companions/${widget.id}/order'),
                pressedScale: 0.97,
                child: SizedBox(
                  height: 48.h,
                  width: 160.w,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.push('/companions/${widget.id}/order'),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: AppGradients.brand,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                        ),
                        child: Text(
                          '立即预约',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
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
