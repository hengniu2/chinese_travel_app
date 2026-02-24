import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

/// 活动详情 - 简单子页：图 + 标题 + 标签，从亲子/周边活动进入
class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    final baseId = id?.split('_').first ?? '';
    final familyMatch = kHomeFamilyActivities.where((e) => e.id == baseId).toList();
    final familyItem = familyMatch.isNotEmpty ? familyMatch.first : null;
    final aroundMatch = kHomeAroundActivities.where((e) => e.id == baseId).toList();
    final aroundItem = aroundMatch.isNotEmpty ? aroundMatch.first : null;

    final String title;
    final String subtitle;
    final String imageUrl;
    final String tag;

    if (familyItem != null) {
      title = familyItem.title;
      subtitle = familyItem.subtitle;
      imageUrl = familyItem.imageUrl;
      tag = familyItem.tag;
    } else if (aroundItem != null) {
      title = aroundItem.title;
      subtitle = aroundItem.location;
      imageUrl = aroundItem.imageUrl;
      tag = aroundItem.date;
    } else {
      title = '活动详情';
      subtitle = '';
      imageUrl = '';
      tag = '';
    }

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Text('活动详情', style: AppTextStyles.header(AppColors.textPrimary, fontSize: 18.sp)),
        backgroundColor: AppColors.warmBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: imageUrl.isEmpty
          ? Center(
              child: Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textSecondary),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: AppNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tag.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(tag, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                          ),
                        if (tag.isNotEmpty) SizedBox(height: 10.h),
                        Text(
                          title,
                          style: AppTextStyles.header(AppColors.textPrimary, fontSize: 20.sp),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Text(
                            subtitle,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
