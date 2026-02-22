import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import 'profile_sub_page.dart';

class ProfileFlightsPage extends StatelessWidget {
  const ProfileFlightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileFlights ?? '机票';
    return ProfileSubPage(
      title: title,
      child: EmptyState(
        icon: Icon(Icons.flight_rounded, size: 64, color: AppColors.textTertiary),
        message: l10n?.profileFeatureComing(title) ?? '$title coming soon',
      ),
    );
  }
}
