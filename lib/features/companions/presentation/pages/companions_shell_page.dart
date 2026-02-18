import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

/// 陪游列表壳页（入口：进入陪游详情）
class CompanionsShellPage extends StatelessWidget {
  const CompanionsShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n?.tabJoinUs ?? '加入我们')),
      body: ListView(
        padding: AppSpacing.paddingPage,
        children: [
          AppCard(
            onTap: () => context.push('/companions/1'),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: AppRadius.smRadius,
                  ),
                  child: Icon(Icons.person, color: AppColors.primary, size: 32),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('林小游', style: AppTextStyles.headlineSmall),
                      SizedBox(height: 4),
                      Text('杭州 · 摄影跟拍·人文讲解', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
