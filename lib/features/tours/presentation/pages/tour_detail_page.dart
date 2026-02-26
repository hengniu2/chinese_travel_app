import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/tour_repository_provider.dart';
import '../../domain/tour_detail.dart';

/// 旅行团详情页（沉浸式头图、半透明渐变、立体时间轴、分组费用卡、底部悬浮预订栏）
class TourDetailPage extends ConsumerWidget {
  const TourDetailPage({super.key, required this.id});

  final String id;

  static const double _heroHeight = 260;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(tourDetailProvider(id));
    return asyncDetail.when(
      data: (detail) => _TourDetailContent(detail: detail),
      loading: () => Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(title: const Text(''), backgroundColor: Colors.transparent),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('详情')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(err.toString(), textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(tourDetailProvider(id)),
                child: Text(AppLocalizations.of(context)?.commonRetry ?? '重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TourDetailContent extends StatelessWidget {
  const _TourDetailContent({required this.detail});

  static const double _heroHeight = 260;

  final TourDetail detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeroImage(context)),
          SliverToBoxAdapter(child: _buildTitleBlock(context)),
          SliverToBoxAdapter(child: _buildSection(context, '行程时间轴', _buildItinerary(context))),
          SliverToBoxAdapter(child: _buildSection(context, '行程亮点', _buildHighlights(context))),
          SliverToBoxAdapter(child: _buildSection(context, '费用说明', _buildCost(context))),
          SliverToBoxAdapter(child: _buildSection(context, '酒店信息', _buildHotels(context))),
          SliverToBoxAdapter(child: _buildSection(context, '退改政策', _buildPolicy(context))),
          SliverToBoxAdapter(child: _buildSection(context, '用户评价', _buildReviews(context))),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
      bottomNavigationBar: _buildFloatingBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(''),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.share_outlined, size: 20.sp),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.more_horiz_rounded, size: 20.sp),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return SizedBox(
      height: _heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.85),
                  AppColors.primaryDark.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 64.sp,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: DecoratedBox(
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
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${detail.days}天${detail.days - 1}晚',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  '${detail.city}出发',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -24.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: AppShadow.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (detail.subtitle.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                detail.subtitle,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('¥', style: AppTextStyles.priceLarge.copyWith(fontSize: 16.sp)),
                Text(
                  detail.price.toStringAsFixed(0),
                  style: AppTextStyles.priceLarge.copyWith(fontSize: 28.sp),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    '起/人',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  Widget _buildItinerary(BuildContext context) {
    return Column(
      children: List.generate(detail.itinerary.length, (i) {
        final day = detail.itinerary[i];
        final isLast = i == detail.itinerary.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 3,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppShadow.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '第${day.day}天 ${day.title}',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          day.description,
                          style: AppTextStyles.bodyMedium.copyWith(height: 1.55, color: AppColors.textSecondary),
                        ),
                        if (day.meals != null && day.meals!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.restaurant_rounded, size: 16.sp, color: AppColors.primary),
                              SizedBox(width: 6.w),
                              Text(day.meals!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                        if (day.hotel != null && day.hotel!.isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(Icons.hotel_rounded, size: 16.sp, color: AppColors.primary),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  day.hotel!,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (day.attractions != null && day.attractions!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            children: day.attractions!
                                .map((a) => Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryPale,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        a,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primaryDark,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHighlights(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: detail.highlights.asMap().entries.map((e) {
          return Padding(
            padding: EdgeInsets.only(bottom: e.key < detail.highlights.length - 1 ? 12.h : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded, size: 20.sp, color: AppColors.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    e.value,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.5, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCost(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _costGroupCard('费用包含', detail.costIncluded, true),
        SizedBox(height: 14.h),
        _costGroupCard('费用不含', detail.costExcluded, false),
      ],
    );
  }

  Widget _costGroupCard(String title, List<CostItem> items, bool isIncluded) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
            child: Row(
              children: [
                Icon(
                  isIncluded ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 22.sp,
                  color: isIncluded ? AppColors.primary : AppColors.textTertiary,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 16.sp, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
          ...items.asMap().entries.map((entry) {
            final c = entry.value;
            final isLast = entry.key == items.length - 1;
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, isLast ? 16.h : 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.category,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  ...c.items.map(
                    (e) => Padding(
                      padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                      child: Text(
                        '· $e',
                        style: AppTextStyles.bodySmall.copyWith(height: 1.5, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHotels(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: detail.hotels.asMap().entries.map((e) {
          final h = e.value;
          return Padding(
            padding: EdgeInsets.only(bottom: e.key < detail.hotels.length - 1 ? 14.h : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.hotel_rounded, size: 22.sp, color: AppColors.primary),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.name,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      if (h.star != null) ...[
                        SizedBox(height: 4.h),
                        Text('${h.star}钻', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                      ],
                      if (h.roomType != null) Text(h.roomType!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      if (h.note != null) Text(h.note!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPolicy(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      child: Text(
        detail.refundPolicy,
        style: AppTextStyles.bodyMedium.copyWith(height: 1.6, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildReviews(BuildContext context) {
    return Column(
      children: detail.reviews.map((r) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadow.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.primaryPale,
                      child: Icon(Icons.person_rounded, size: 22.sp, color: AppColors.primary),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.userName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(i < r.rating.toInt() ? Icons.star_rounded : Icons.star_border_rounded, size: 14.sp, color: AppColors.accentGold)),
                              SizedBox(width: 8.w),
                              Text(r.date, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  r.content,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFloatingBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: AppShadow.heavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('¥', style: AppTextStyles.priceLarge.copyWith(fontSize: 16.sp)),
            Text(
              detail.price.toStringAsFixed(0),
              style: AppTextStyles.priceLarge.copyWith(fontSize: 26.sp),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                '起/人',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 13.sp),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 160.w,
              child: AppButton(
                label: l10n?.tourBookNow ?? '立即预订',
                onPressed: () => context.push(
                  '/orders/create',
                  extra: {
                    'packageId': detail.id,
                    'packageTitle': detail.title,
                    'unitPrice': detail.price.toInt(),
                  },
                ),
                minHeight: 48,
                expand: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
