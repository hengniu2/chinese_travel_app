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
import '../widgets/auth_code_button.dart';
import '../widgets/auth_input_field.dart';
import '../../providers/auth_provider.dart';

/// 注册页
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreed = false;
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('验证码已发送')));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _submit() async {
    if (!_agreed) {
      setState(() => _error = '请先阅读并同意用户协议和隐私政策');
      return;
    }
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
      await ref.read(authProvider.notifier).register(phone, code, password);
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
        title: '注册',
        onLeadingTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Text('创建账号', style: AppTextStyles.headlineLarge),
              SizedBox(height: 8.h),
              Text('注册享梦游，开启绿色旅行', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AuthInputField(
                      controller: _codeController,
                      label: '验证码',
                      hint: '请输入验证码',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: AuthCodeButton(
                      onPressed: _sendCode,
                      enabled: _phoneController.text.trim().length >= 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              AuthInputField(
                controller: _passwordController,
                label: '设置密码',
                hint: '请设置密码（至少 6 位）',
                obscureText: true,
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 22, color: AppColors.textTertiary),
              ),
              SizedBox(height: AppSpacing.lg.h),
              AuthInputField(
                controller: _confirmController,
                label: '确认密码',
                hint: '请再次输入密码',
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
                label: '注册',
                loading: _loading,
                onPressed: _submit,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('已有账号？', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text('去登录', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
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
