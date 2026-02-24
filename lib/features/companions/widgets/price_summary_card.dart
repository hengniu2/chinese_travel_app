import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';

/// 费用明细卡片：多行（标签 + 金额），最后一行可为总计（加粗/主色）
class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({
    super.key,
    required this.rows,
    this.title,
    this.padding,
    this.borderRadius = 10,
  });

  final List<PriceSummaryRow> rows;
  final String? title;
  final EdgeInsets? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
        ],
        Container(
          width: double.infinity,
          padding: padding ?? EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) SizedBox(height: 8.h),
                _priceRow(rows[i]),
                if (i < rows.length - 1 && rows[i + 1].isTotal)
                  Divider(height: 20.h, color: AppColors.divider),
                if (i < rows.length - 1 && rows[i + 1].isTotal) SizedBox(height: 8.h),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(PriceSummaryRow row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          row.label,
          style: row.isTotal
              ? AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '¥${row.amount.toStringAsFixed(0)}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: row.isTotal ? AppColors.primary : AppColors.textPrimary,
            fontWeight: row.isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class PriceSummaryRow {
  const PriceSummaryRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;
}
