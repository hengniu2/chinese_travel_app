import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// 错误状态组件
class AppError extends StatelessWidget {
  const AppError({
    super.key,
    this.message,
    this.onRetry,
  });

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              message ?? '加载失败，请重试',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)?.commonRetry ?? '重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
