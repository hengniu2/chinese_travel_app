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

/// 验证码登录页
class VerifyCodeLoginPage extends ConsumerStatefulWidget {
  const VerifyCodeLoginPage({super.key});

  @override
  ConsumerState<VerifyCodeLoginPage> createState() => _VerifyCodeLoginPageState();
}

class _VerifyCodeLoginPageState extends ConsumerState<VerifyCodeLoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
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
    if (phone.length < 11) {
      setState(() => _error = '请输入正确手机号');
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
      await ref.read(authProvider.notifier).loginByCode(phone, code);
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
        title: '验证码登录',
        onLeadingTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Text('验证码登录', style: AppTextStyles.headlineLarge),
              SizedBox(height: 8.h),
              Text('未注册手机号验证后将自动创建账号', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
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
                  onPressed: () => context.pop(),
                  child: Text('使用密码登录', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
