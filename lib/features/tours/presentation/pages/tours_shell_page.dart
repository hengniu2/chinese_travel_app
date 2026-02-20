import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Tours 功能壳页（占位，无业务逻辑）
class ToursShellPage extends StatelessWidget {
  const ToursShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(child: Text(l10n?.plannerTabTours ?? '行程/跟团游')),
    );
  }
}
