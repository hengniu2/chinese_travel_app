import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_radius.dart';
import '../../../../shared/design_system/app_text_styles.dart';

/// 获取验证码按钮（带倒计时）
class AuthCodeButton extends StatefulWidget {
  const AuthCodeButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    this.durationSeconds = 60,
  });

  final VoidCallback onPressed;
  final bool enabled;
  final int durationSeconds;

  @override
  State<AuthCodeButton> createState() => _AuthCodeButtonState();
}

class _AuthCodeButtonState extends State<AuthCodeButton> {
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (_countdown > 0) return;
    setState(() => _countdown = widget.durationSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown <= 1) {
        _timer?.cancel();
        setState(() => _countdown = 0);
        return;
      }
      setState(() => _countdown--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final canTap = widget.enabled && _countdown == 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canTap
            ? () {
                widget.onPressed();
                _startCountdown();
              }
            : null,
        borderRadius: AppRadius.smRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            _countdown > 0 ? '${_countdown}s 后重发' : '获取验证码',
            style: AppTextStyles.bodySmall.copyWith(
              color: canTap ? AppColors.primary : AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
