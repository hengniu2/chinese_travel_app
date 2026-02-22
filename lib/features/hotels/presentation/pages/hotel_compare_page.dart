import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_item.dart';
import '../../providers/hotel_compare_provider.dart';
import '../widgets/hotel_ui_constants.dart';

/// Hotel comparison page: table layout, yellow highlight for best value (lowest price, highest rating, most facilities).
class HotelComparePage extends ConsumerWidget {
  const HotelComparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final list = ref.watch(hotelCompareListProvider);

    if (list.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(l10n?.hotelCompareTitle ?? '酒店对比'),
          backgroundColor: AppColors.backgroundCard,
          foregroundColor: AppColors.textPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.compare_arrows_rounded, size: 64.sp, color: AppColors.textTertiary),
                SizedBox(height: 16.h),
                Text(
                  l10n?.hotelCompareEmpty ?? '请先添加最多3家酒店进行对比',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                AppButton(
                  label: '返回',
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final bestPriceId = _bestPriceId(list);
    final bestRatingId = _bestRatingId(list);
    final mostFacilitiesId = _mostFacilitiesId(list);
    final bestDistanceId = _bestDistanceId(list);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.hotelCompareTitle ?? '酒店对比'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(HotelUIConstants.grid2.w),
                child: Table(
                  border: TableBorder.all(color: AppColors.border, width: 1),
                  columnWidths: {
                    for (var i = 0; i <= list.length; i++)
                      i: i == 0
                          ? const FlexColumnWidth(1.2)
                          : const FlexColumnWidth(1.5),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _headerRow(context, list, ref, l10n),
                    _dataRow(
                      context,
                      l10n?.hotelComparePrice ?? '价格',
                      list,
                      (h) => '¥${h.price.toStringAsFixed(0)}',
                      bestPriceId,
                      isLowerBetter: true,
                    ),
                    _dataRow(
                      context,
                      l10n?.hotelCompareRating ?? '评分',
                      list,
                      (h) => h.score != null ? h.score!.toStringAsFixed(1) : '—',
                      bestRatingId,
                      isLowerBetter: false,
                    ),
                    _dataRow(
                      context,
                      l10n?.hotelCompareDistance ?? '距离',
                      list,
                      (h) => h.distanceKm != null ? '${h.distanceKm!.toStringAsFixed(1)} km' : '—',
                      bestDistanceId,
                      isLowerBetter: true,
                    ),
                    _dataRow(
                      context,
                      l10n?.hotelCompareFacilities ?? '设施',
                      list,
                      (h) => '${h.features.length}项',
                      mostFacilitiesId,
                      isLowerBetter: false,
                    ),
                    _policyRow(context, list, l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _headerRow(
    BuildContext context,
    List<HotelItem> list,
    WidgetRef ref,
    AppLocalizations? l10n,
  ) {
    final theme = Theme.of(context);
    return TableRow(
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Text(
            l10n?.hotelCompareItem ?? '项目',
            style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        ...list.map((h) => _HotelHeaderCell(
              hotel: h,
              onRemove: () => ref.read(hotelCompareListProvider.notifier).remove(h.id),
              onTap: () => context.push('/hotels/${h.id}'),
            )),
      ],
    );
  }

  TableRow _dataRow(
    BuildContext context,
    String label,
    List<HotelItem> list,
    String Function(HotelItem) value,
    String? bestId, {
    required bool isLowerBetter,
  }) {
    return TableRow(
      children: [
        _labelCell(context, label),
        ...list.map((h) => _valueCell(context, value(h), isBest: h.id == bestId)),
      ],
    );
  }

  TableRow _policyRow(BuildContext context, List<HotelItem> list, AppLocalizations? l10n) {
    return TableRow(
      children: [
        _labelCell(context, l10n?.hotelCompareCancellation ?? '取消政策'),
        ...list.map((h) => _valueCell(
              context,
              h.cancellationSummary ?? '—',
              isBest: false,
              maxLines: 2,
            )),
      ],
    );
  }

  Widget _labelCell(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      color: Theme.of(context).colorScheme.surface,
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _valueCell(BuildContext context, String text, {bool isBest = false, int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      color: isBest ? AppColors.primaryPale : Theme.of(context).colorScheme.surface,
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isBest ? AppColors.textPrimary : null,
          fontWeight: isBest ? FontWeight.w700 : null,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String? _bestPriceId(List<HotelItem> list) {
    if (list.isEmpty) return null;
    var best = list.first;
    for (final h in list) {
      if (h.price < best.price) best = h;
    }
    return best.id;
  }

  String? _bestRatingId(List<HotelItem> list) {
    if (list.isEmpty) return null;
    HotelItem? best;
    for (final h in list) {
      if (h.score != null && (best == null || h.score! > (best.score ?? 0))) best = h;
    }
    return best?.id;
  }

  String? _mostFacilitiesId(List<HotelItem> list) {
    if (list.isEmpty) return null;
    var best = list.first;
    for (final h in list) {
      if (h.features.length > best.features.length) best = h;
    }
    return best.id;
  }

  String? _bestDistanceId(List<HotelItem> list) {
    final withDistance = list.where((h) => h.distanceKm != null).toList();
    if (withDistance.isEmpty) return null;
    var best = withDistance.first;
    for (final h in withDistance) {
      if (h.distanceKm! < best.distanceKm!) best = h;
    }
    return best.id;
  }
}

class _HotelHeaderCell extends StatelessWidget {
  const _HotelHeaderCell({
    required this.hotel,
    required this.onRemove,
    required this.onTap,
  });

  final HotelItem hotel;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        constraints: BoxConstraints(minWidth: 120.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    hotel.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 20.sp, color: AppColors.textTertiary),
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            if (hotel.score != null)
              Text(
                '${hotel.score!.toStringAsFixed(1)}分 · ¥${hotel.price.toStringAsFixed(0)}起',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
