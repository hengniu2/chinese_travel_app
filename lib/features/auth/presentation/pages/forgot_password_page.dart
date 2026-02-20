import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/app_button.dart';
import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/design_system/app_text_styles.dart';
import '../../../../shared/design_system/app_top_bar.dart';
import '../widgets/auth_code_button.dart';
import '../widgets/auth_input_field.dart';
import '../../providers/auth_provider.dart';

/// 忘记密码页
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 11) {
      setState(() => _error = '请输入正确手机号');
      return;
    }
    setState(() => _error = null);
    try {
      await ref.read(authProvider.notifier).sendCode(phone);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.authVerifyCodeSent ?? '验证码已发送')));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    if (phone.length < 11) {
      setState(() => _error = '请输入正确手机号');
      return;
    }
    if (code.length < 4) {
      setState(() => _error = '请输入验证码');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = '密码至少 6 位');
      return;
    }
    if (password != confirm) {
      setState(() => _error = '两次密码不一致');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      await ref.read(authProvider.notifier).resetPassword(phone, code, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.authPasswordResetSuccess ?? '密码已重置，请登录')));
        context.pop();
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: AppLocalizations.of(context)?.authForgotPasswordPageTitle ?? '忘记密码',
        onLeadingTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Text(AppLocalizations.of(context)?.authResetPassword ?? '重置密码', style: AppTextStyles.headlineLarge),
              SizedBox(height: 8.h),
              Text(AppLocalizations.of(context)?.authResetPasswordSubtitle ?? '通过手机验证码重置登录密码', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              SizedBox(height: 32.h),
              AuthInputField(
                controller: _phoneController,
                label: AppLocalizations.of(context)?.authPhone ?? '手机号',
                hint: '${AppLocalizations.of(context)?.authPhone ?? '手机号'}',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_android_outlined, size: 22, color: AppColors.textTertiary),
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AuthInputField(
                      controller: _codeController,
                      label: AppLocalizations.of(context)?.authVerifyCode ?? '验证码',
                      hint: '${AppLocalizations.of(context)?.authVerifyCode ?? '验证码'}',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: AuthCodeButton(onPressed: _sendCode, enabled: _phoneController.text.trim().length >= 11),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              AuthInputField(
                controller: _passwordController,
                label: AppLocalizations.of(context)?.authNewPassword ?? '新密码',
                hint: '${AppLocalizations.of(context)?.authNewPassword ?? '新密码'}',
                obscureText: true,
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 22, color: AppColors.textTertiary),
              ),
              SizedBox(height: AppSpacing.lg.h),
              AuthInputField(
                controller: _confirmController,
                label: AppLocalizations.of(context)?.authConfirmNewPassword ?? '确认新密码',
                hint: '${AppLocalizations.of(context)?.authConfirmNewPassword ?? '确认新密码'}',
                obscureText: true,
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 22, color: AppColors.textTertiary),
              ),
              if (_error != null) ...[
                SizedBox(height: 12.h),
                Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
              ],
              SizedBox(height: 28.h),
              AppButton(
                label: AppLocalizations.of(context)?.authConfirmReset ?? '确认重置',
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
