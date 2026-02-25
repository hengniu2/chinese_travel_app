import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/app_button.dart';
import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/design_system/app_text_styles.dart';
import '../../../../shared/design_system/app_top_bar.dart';
import '../widgets/auth_code_button.dart';
import '../widgets/auth_input_field.dart';
import '../../providers/auth_provider.dart';

/// 手机验证页（注册成功后进入）：发送/重发验证码 → 验证 → 跳转登录
class VerifyPhonePage extends ConsumerStatefulWidget {
  const VerifyPhonePage({super.key});

  @override
  ConsumerState<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends ConsumerState<VerifyPhonePage> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  String get _phone {
    return GoRouterState.of(context).uri.queryParameters['phone'] ?? '';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phone;
    if (phone.length < 11) {
      setState(() => _error = '手机号无效');
      return;
    }
    setState(() => _error = null);
    try {
      await ref.read(authProvider.notifier).sendCode(phone);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.authVerifyCodeSent ?? '验证码已发送')),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _verify() async {
    final phone = _phone;
    final code = _codeController.text.trim();
    if (phone.length < 11) {
      setState(() => _error = '手机号无效');
      return;
    }
    if (code.length < 4) {
      setState(() => _error = '请输入验证码');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      await ref.read(authProvider.notifier).verifyPhoneOnly(phone, code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.authPhoneVerified ?? '验证成功，请使用密码登录')),
        );
        context.go('/auth/login?phone=${Uri.encodeComponent(phone)}');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone = _phone;
    if (phone.isEmpty) {
      return Scaffold(
        appBar: AppTopBar(title: l10n?.authVerifyCode ?? '验证手机', onLeadingTap: () => context.pop()),
        body: Center(
          child: Text(
            '缺少手机号，请从注册页进入',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: l10n?.authVerifyCode ?? '验证手机',
        onLeadingTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Text(
                '验证手机号',
                style: AppTextStyles.headlineLarge,
              ),
              SizedBox(height: 8.h),
              Text(
                '我们已向 $phone 发送验证码，请输入收到的 6 位数字',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 32.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AuthInputField(
                      controller: _codeController,
                      label: l10n?.authVerifyCode ?? '验证码',
                      hint: l10n?.authVerifyCode ?? '验证码',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icon(Icons.sms_outlined, size: 22, color: AppColors.textTertiary),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: AuthCodeButton(
                      onPressed: _sendCode,
                      enabled: true,
                      durationSeconds: 30,
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                SizedBox(height: 12.h),
                Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
              ],
              SizedBox(height: 28.h),
              AppButton(
                label: '验证',
                loading: _loading,
                onPressed: _verify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
