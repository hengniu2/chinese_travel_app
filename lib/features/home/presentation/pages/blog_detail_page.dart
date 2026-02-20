import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';

/// 人物/种草官详情 - 占位页
class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWarmWhite,
      appBar: AppBar(
        title: const Text('种草官'),
        backgroundColor: AppColors.surfaceWarmWhite,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Text(
          id != null ? '详情 $id' : '详情',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
