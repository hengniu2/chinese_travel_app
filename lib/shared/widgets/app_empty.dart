import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 空状态组件
class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    this.message,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  final String? message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message ?? '暂无内容',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(color: kAppPrimaryGreen),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
