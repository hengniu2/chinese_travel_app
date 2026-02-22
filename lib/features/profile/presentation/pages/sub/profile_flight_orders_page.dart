import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import 'profile_sub_page.dart';

class ProfileFlightOrdersPage extends StatelessWidget {
  const ProfileFlightOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileFlightOrders ?? '机票订单';
    return ProfileSubPage(
      title: title,
      child: EmptyState(
        icon: Icon(Icons.flight_rounded, size: 64, color: AppColors.textTertiary),
        message: l10n?.profileFeatureComing(title) ?? '$title coming soon',
        actionLabel: l10n?.profileAllOrders ?? '全部订单',
        onAction: () => context.push('/orders'),
      ),
    );
  }
}
