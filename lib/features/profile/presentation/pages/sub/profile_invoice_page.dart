import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import 'profile_sub_page.dart';

class ProfileInvoicePage extends StatelessWidget {
  const ProfileInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileIssueInvoice ?? l10n?.profileInvoice ?? '开发票';
    return ProfileSubPage(
      title: title,
      child: EmptyState(
        icon: Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textTertiary),
        message: l10n?.profileFeatureComing(title) ?? '$title coming soon',
      ),
    );
  }
}
