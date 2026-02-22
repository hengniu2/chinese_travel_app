import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/prize_model.dart';
import 'profile_sub_page.dart';

List<PrizeModel> _mockPrizes = [
  const PrizeModel(
    id: '1',
    title: '新人礼包',
    pointsOrDesc: '50 积分 + 优惠券',
    status: PrizeStatus.received,
    date: '2024-01-15',
  ),
  const PrizeModel(
    id: '2',
    title: '春节出行奖',
    pointsOrDesc: '旅行收纳包',
    status: PrizeStatus.pending,
    date: '2024-02-01',
  ),
  const PrizeModel(
    id: '3',
    title: '签到满7天',
    pointsOrDesc: '20 积分',
    status: PrizeStatus.received,
    date: '2024-01-20',
  ),
];

class ProfilePrizesPage extends StatelessWidget {
  const ProfilePrizesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileMyPrizes ?? '我的奖品';

    return ProfileSubPage(
      title: title,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: _mockPrizes.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final prize = _mockPrizes[index];
          return _PrizeCard(
            prize: prize,
            onReceive: prize.status == PrizeStatus.pending
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('领取成功'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}

class _PrizeCard extends StatelessWidget {
  const _PrizeCard({
    required this.prize,
    this.onReceive,
  });

  final PrizeModel prize;
  final VoidCallback? onReceive;

  @override
  Widget build(BuildContext context) {
    final isPending = prize.status == PrizeStatus.pending;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPending ? AppColors.accentGold.withValues(alpha: 0.5) : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 28.sp,
              color: AppColors.accentGold,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prize.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  prize.pointsOrDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  prize.date,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          if (isPending)
            Material(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(16.r),
              child: InkWell(
                onTap: onReceive,
                borderRadius: BorderRadius.circular(16.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  child: Text(
                    '去领取',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '已领取',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
