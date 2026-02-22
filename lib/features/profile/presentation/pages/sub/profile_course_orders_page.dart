import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import 'profile_sub_page.dart';

class ProfileCourseOrdersPage extends StatelessWidget {
  const ProfileCourseOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileCourseOrders ?? '课程订单';
    return ProfileSubPage(
      title: title,
      child: EmptyState(
        icon: Icon(Icons.menu_book_rounded, size: 64, color: AppColors.textTertiary),
        message: l10n?.profileFeatureComing(title) ?? '$title coming soon',
      ),
    );
  }
}
