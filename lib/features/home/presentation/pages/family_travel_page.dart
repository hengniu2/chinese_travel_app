import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';

/// 亲子旅行 - 占位页
class FamilyTravelPage extends StatelessWidget {
  const FamilyTravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWarmWhite,
      appBar: AppBar(
        title: const Text('亲子旅行'),
        backgroundColor: AppColors.surfaceWarmWhite,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Text(
          '亲子旅行',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
