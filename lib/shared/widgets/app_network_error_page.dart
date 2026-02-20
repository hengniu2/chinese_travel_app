import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// 网络异常页：无网络 / 请求失败时展示
class AppNetworkErrorPage extends StatelessWidget {
  const AppNetworkErrorPage({
    super.key,
    this.message,
    this.onRetry,
  });

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final msg = message ?? '网络异常，请检查网络后重试';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 80,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 24),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 32),
                  AppButton(
                    label: l10n?.commonRetry ?? '重试',
                    onPressed: onRetry,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
