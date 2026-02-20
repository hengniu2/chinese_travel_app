import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';

/// 活动详情 - 占位页
class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWarmWhite,
      appBar: AppBar(
        title: const Text('活动详情'),
        backgroundColor: AppColors.surfaceWarmWhite,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Text(
          id != null ? '活动 $id' : '活动详情',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
