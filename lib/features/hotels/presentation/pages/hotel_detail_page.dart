import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/hotel_detail_mock.dart';
import '../../domain/hotel_detail.dart';

/// 酒店详情页：房型列表、库存状态、取消政策、设施、评价
class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key, required this.id});

  final String id;

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  late HotelDetail _detail;

  @override
  void initState() {
    super.initState();
    _detail = getHotelDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_detail.name, overflow: TextOverflow.ellipsis, maxLines: 1),
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
          SliverToBoxAdapter(child: _buildSection('房型列表', _buildRooms())),
          SliverToBoxAdapter(child: _buildSection('取消政策', _buildPolicy())),
          SliverToBoxAdapter(child: _buildSection('设施', _buildFacilities())),
          SliverToBoxAdapter(child: _buildSection('评价', _buildReviews())),
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
              ...List.generate(_detail.star, (_) => Icon(Icons.star_rounded, size: 18.sp, color: AppColors.warning)),
              if (_detail.score != null) ...[
                SizedBox(width: 8.w),
                Text('${_detail.score}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('分', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Text(_detail.address, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          if (_detail.tags.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: _detail.tags.map((t) => AppTag(label: t, style: AppTagStyle.primaryLight)).toList(),
            ),
          ],
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

  Widget _buildRooms() {
    return Column(
      children: List.generate(_detail.rooms.length, (index) {
        final r = _detail.rooms[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(r.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    _stockChip(r.stockStatus, r.remainingCount),
                  ],
                ),
                if (r.bedInfo != null || r.area != null) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      if (r.bedInfo != null) Text(r.bedInfo!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      if (r.bedInfo != null && r.area != null) Text(' · ', style: AppTextStyles.bodySmall),
                      if (r.area != null) Text(r.area!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      if (r.breakfast != null) ...[
                        Text(' · ${r.breakfast!}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                      ],
                    ],
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Row(
                      children: [
                        Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp)),
                        Text(r.price.toStringAsFixed(0), style: AppTextStyles.price.copyWith(fontSize: 20.sp)),
                        Text(' 起', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                      ],
                    ),
                    if (r.stockStatus != RoomStockStatus.soldOut)
                      TextButton(
                        onPressed: () => context.push('/hotels/${_detail.id}/order?roomIndex=$index'),
                        child: const Text('预订'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _stockChip(RoomStockStatus status, int? remaining) {
    String label;
    Color bg;
    Color fg;
    switch (status) {
      case RoomStockStatus.available:
        label = '可订';
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        break;
      case RoomStockStatus.limited:
        label = remaining != null ? '仅剩$remaining间' : '紧张';
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
        break;
      case RoomStockStatus.soldOut:
        label = '售罄';
        bg = AppColors.surface;
        fg = AppColors.textTertiary;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.smRadius,
      ),
      child: Text(label, style: AppTextStyles.label.copyWith(color: fg, fontSize: 12.sp)),
    );
  }

  Widget _buildPolicy() {
    return AppCard(
      child: Text(
        _detail.cancellationPolicy,
        style: AppTextStyles.bodyMedium.copyWith(height: 1.6, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildFacilities() {
    return AppCard(
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: _detail.facilities.map((f) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 18.sp, color: AppColors.primary),
            SizedBox(width: 6.w),
            Text(f, style: AppTextStyles.bodyMedium),
          ],
        )).toList(),
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
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.surface,
                    child: Icon(Icons.person, size: 20.sp, color: AppColors.textTertiary),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.userName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(
                                  i < r.rating.toInt() ? Icons.star_rounded : Icons.star_border_rounded,
                                  size: 14.sp,
                                  color: AppColors.warning,
                                )),
                            SizedBox(width: 8.w),
                            Text(r.date, style: AppTextStyles.label),
                            if (r.roomName != null) ...[
                              SizedBox(width: 8.w),
                              Text(r.roomName!, style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                            ],
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
    final prices = _detail.rooms.map((r) => r.price).toList();
    final minPrice = prices.isEmpty ? 0.0 : prices.reduce((a, b) => a < b ? a : b);
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(color: AppColors.backgroundCard, boxShadow: AppShadow.light),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text('¥${minPrice.toStringAsFixed(0)}', style: AppTextStyles.price.copyWith(fontSize: 20.sp)),
            Text(' 起', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
            const Spacer(),
            SizedBox(
              width: 120.w,
              child: AppButton(
                label: l10n?.hotelBook ?? '预订',
                onPressed: () => context.push('/hotels/${_detail.id}/order'),
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
