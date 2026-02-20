import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'app_error.dart';

/// 全屏错误页：图标 + 文案 + 重试
class AppErrorPage extends StatelessWidget {
  const AppErrorPage({
    super.key,
    this.title,
    this.message,
    this.onRetry,
  });

  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AppError(
          message: message ?? '加载失败，请重试',
          onRetry: onRetry,
        ),
      ),
    );
  }
}
