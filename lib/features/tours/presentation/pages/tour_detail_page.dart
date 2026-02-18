import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/tour_detail_mock.dart';
import '../../domain/tour_detail.dart';

/// 旅行团详情页
class TourDetailPage extends StatefulWidget {
  const TourDetailPage({super.key, required this.id});

  final String id;

  @override
  State<TourDetailPage> createState() => _TourDetailPageState();
}

class _TourDetailPageState extends State<TourDetailPage> {
  late TourDetail _detail;

  @override
  void initState() {
    super.initState();
    _detail = getTourDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_detail.title, overflow: TextOverflow.ellipsis, maxLines: 1),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_horiz_rounded), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSection('行程时间轴', _buildItinerary())),
          SliverToBoxAdapter(child: _buildSection('行程亮点', _buildHighlights())),
          SliverToBoxAdapter(child: _buildSection('费用说明', _buildCost())),
          SliverToBoxAdapter(child: _buildSection('酒店信息', _buildHotels())),
          SliverToBoxAdapter(child: _buildSection('退改政策', _buildPolicy())),
          SliverToBoxAdapter(child: _buildSection('用户评价', _buildReviews())),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.w),
      color: AppColors.backgroundCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.smRadius,
                ),
                child: Text('${_detail.days}天${_detail.days - 1}晚', style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 12.sp)),
              ),
              SizedBox(width: 8.w),
              Text('${_detail.city}出发', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(_detail.subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp)),
              Text(_detail.price.toStringAsFixed(0), style: AppTextStyles.price.copyWith(fontSize: 24.sp)),
              Text('起', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg.w, AppSpacing.xxl.h, AppSpacing.lg.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildItinerary() {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(_detail.itinerary.length, (i) {
          final day = _detail.itinerary[i];
          final isLast = i == _detail.itinerary.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(width: 2, color: AppColors.divider),
                      ),
                  ],
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('第${day.day}天 ${day.title}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 6.h),
                        Text(day.description, style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
                        if (day.meals != null) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.restaurant_rounded, size: 14.sp, color: AppColors.textTertiary),
                              SizedBox(width: 4.w),
                              Text(day.meals!, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ],
                        if (day.hotel != null && day.hotel!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.hotel_rounded, size: 14.sp, color: AppColors.textTertiary),
                              SizedBox(width: 4.w),
                              Expanded(child: Text(day.hotel!, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                        if (day.attractions != null && day.attractions!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: day.attractions!.map((a) => AppTag(label: a, style: AppTagStyle.primaryLight)).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHighlights() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _detail.highlights.map((h) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_rounded, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(child: Text(h, style: AppTextStyles.bodyMedium.copyWith(height: 1.5))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _costBlock('费用包含', _detail.costIncluded, true),
        SizedBox(height: 16.h),
        _costBlock('费用不含', _detail.costExcluded, false),
      ],
    );
  }

  Widget _costBlock(String title, List<CostItem> items, bool isIncluded) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isIncluded ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 20.sp, color: isIncluded ? AppColors.primary : AppColors.textTertiary),
              SizedBox(width: 8.w),
              Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 15.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          ...items.expand((c) => [
            Text(c.category, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: 4.h),
            ...c.items.map((e) => Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
              child: Text('· $e', style: AppTextStyles.bodySmall.copyWith(height: 1.5)),
            )),
            SizedBox(height: 8.h),
          ]),
        ],
      ),
    );
  }

  Widget _buildHotels() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _detail.hotels.map((h) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.hotel_rounded, size: 20.sp, color: AppColors.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(h.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                    if (h.star != null) Text('${h.star}钻', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                    if (h.roomType != null) Text(h.roomType!, style: AppTextStyles.bodySmall),
                    if (h.note != null) Text(h.note!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildPolicy() {
    return AppCard(
      child: Text(
        _detail.refundPolicy,
        style: AppTextStyles.bodyMedium.copyWith(height: 1.6, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildReviews() {
    return Column(
      children: _detail.reviews.map((r) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 18.r, backgroundColor: AppColors.surface, child: Icon(Icons.person, size: 20.sp, color: AppColors.textTertiary)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.userName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(i < r.rating.toInt() ? Icons.star_rounded : Icons.star_border_rounded, size: 14.sp, color: AppColors.warning)),
                            SizedBox(width: 8.w),
                            Text(r.date, style: AppTextStyles.label),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(r.content, style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(color: AppColors.backgroundCard, boxShadow: AppShadow.light),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text('¥${_detail.price.toStringAsFixed(0)}', style: AppTextStyles.price.copyWith(fontSize: 20.sp)),
            Text(' 起', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
            const Spacer(),
            SizedBox(
              width: 140.w,
              child: AppButton(
                label: l10n?.tourBookNow ?? '立即预订',
                onPressed: () => context.push('/tours/${_detail.id}/order'),
                minHeight: 44,
                expand: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
