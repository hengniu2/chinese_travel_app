import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../shared/design_system/app_button.dart';
import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/design_system/app_text_styles.dart';
import '../../../../shared/design_system/app_top_bar.dart';
import '../widgets/auth_agreement_checkbox.dart';
import '../widgets/auth_input_field.dart';
import '../../providers/auth_provider.dart';

/// 登录页（手机号+密码，可切换验证码登录）
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreed = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_agreed) {
      setState(() => _error = '请先阅读并同意用户协议和隐私政策');
      return;
    }
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (phone.length < 11) {
      setState(() => _error = '请输入正确手机号');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = '密码至少 6 位');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      await ref.read(authProvider.notifier).loginByPassword(phone, password);
      if (mounted) context.go('/${RouteNames.home}');
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
        title: '登录',
        onLeadingTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Text('欢迎回来', style: AppTextStyles.headlineLarge),
              SizedBox(height: 8.h),
              Text('登录享梦游，发现更多旅行', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              SizedBox(height: 32.h),
              AuthInputField(
                controller: _phoneController,
                label: '手机号',
                hint: '请输入手机号',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_android_outlined, size: 22, color: AppColors.textTertiary),
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: AppSpacing.lg.h),
              AuthInputField(
                controller: _passwordController,
                label: '密码',
                hint: '请输入密码（至少 6 位）',
                obscureText: true,
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 22, color: AppColors.textTertiary),
              ),
              if (_error != null) ...[
                SizedBox(height: 12.h),
                Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
              ],
              SizedBox(height: 20.h),
              AuthAgreementCheckbox(
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v),
                onAgreementTap: () => context.push('/auth/agreement?type=user'),
                onPrivacyTap: () => context.push('/auth/agreement?type=privacy'),
              ),
              SizedBox(height: 28.h),
              AppButton(
                label: '登录',
                loading: _loading,
                onPressed: _submit,
              ),
              SizedBox(height: 16.h),
              Center(
                child: TextButton(
                  onPressed: () => context.push('/auth/verify-code'),
                  child: Text('验证码登录', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => context.push('/auth/forgot-password'),
                  child: Text('忘记密码？', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('还没有账号？', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.push('/auth/register'),
                    child: Text('立即注册', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
