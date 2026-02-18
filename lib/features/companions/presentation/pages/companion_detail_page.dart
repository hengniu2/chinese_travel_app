import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/companion_detail_mock.dart';
import '../../domain/companion_detail.dart';

/// 陪游详情页
class CompanionDetailPage extends StatefulWidget {
  const CompanionDetailPage({super.key, required this.id});

  final String id;

  @override
  State<CompanionDetailPage> createState() => _CompanionDetailPageState();
}

class _CompanionDetailPageState extends State<CompanionDetailPage> {
  late CompanionDetail _detail;
  int _carouselIndex = 0;
  bool _favorited = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _detail = getCompanionDetail(widget.id);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildCarousel()),
          SliverToBoxAdapter(child: _buildBasicInfo()),
          SliverToBoxAdapter(child: _buildSkillTags()),
          SliverToBoxAdapter(child: _buildServiceDesc()),
          SliverToBoxAdapter(child: _buildPackages()),
          SliverToBoxAdapter(child: _buildCalendar()),
          SliverToBoxAdapter(child: _buildReviews()),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: true,
      backgroundColor: AppColors.backgroundCard,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    final colors = [AppColors.primaryLight, AppColors.primaryLight2, AppColors.surface];
    return SizedBox(
      height: 280.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _carouselIndex = i),
            itemCount: _detail.images.length,
            itemBuilder: (_, i) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: colors[i % colors.length],
                borderRadius: AppRadius.cardRadius,
              ),
              child: Center(
                child: Icon(Icons.image_outlined, size: 64.sp, color: AppColors.textTertiary),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _detail.images.length,
                (i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _carouselIndex == i ? AppColors.primary : AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: AppCard(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, size: 36.sp, color: AppColors.primary),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_detail.name, style: AppTextStyles.headlineSmall),
                  SizedBox(height: 4.h),
                  Text(
                    '${_detail.age}岁 · ${_detail.city}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _detail.bio,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                    maxLines: 2,
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

  Widget _buildSkillTags() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('技能标签', style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _detail.skillTags
                .map((t) => AppTag(label: t, style: AppTagStyle.primaryLight))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDesc() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('服务说明', style: AppTextStyles.headlineSmall),
            SizedBox(height: 12.h),
            Text(
              _detail.serviceDesc,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackages() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('套餐', style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          ..._detail.packages.map(
            (p) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppCard(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          SizedBox(height: 4.h),
                          Text(p.desc, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text(
                      '¥${p.price.toStringAsFixed(0)}${p.unit}',
                      style: AppTextStyles.priceSmall,
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

  Widget _buildCalendar() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('档期日历', style: AppTextStyles.headlineSmall),
                TextButton(
                  onPressed: () {},
                  child: Text('查看全部', style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(
                7,
                (i) => _dayChip('2月${17 + i}日', i == 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayChip(String label, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: AppRadius.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildReviews() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('评价', style: AppTextStyles.headlineSmall),
              TextButton(
                onPressed: () {},
                child: Text('查看全部', style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ..._detail.reviews.map(
            (r) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.surface,
                          child: Icon(Icons.person_outline, size: 18.sp),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.userName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                              Row(
                                children: [
                                  ...List.generate(5, (i) => Icon(i < r.rating.toInt() ? Icons.star : Icons.star_border, size: 14.sp, color: AppColors.warning)),
                                  SizedBox(width: 8.w),
                                  Text(r.date, style: AppTextStyles.label),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(r.content, style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: AppShadow.light,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _bottomIconBtn(Icons.chat_bubble_outline_rounded, '咨询', () {}),
            SizedBox(width: 8.w),
            _bottomIconBtn(
              _favorited ? Icons.favorite : Icons.favorite_border_rounded,
              '收藏',
              () => setState(() => _favorited = !_favorited),
              isActive: _favorited,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                label: '立即预订',
                onPressed: () => context.push('/companions/${widget.id}/order'),
                minHeight: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomIconBtn(IconData icon, String label, VoidCallback onTap, {bool isActive = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24.sp, color: isActive ? AppColors.price : AppColors.textSecondary),
              SizedBox(height: 2.h),
              Text(label, style: AppTextStyles.label.copyWith(color: isActive ? AppColors.price : AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
