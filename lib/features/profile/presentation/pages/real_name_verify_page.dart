import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';

/// 实名认证页：姓名、身份证
class RealNameVerifyPage extends StatefulWidget {
  const RealNameVerifyPage({super.key});

  @override
  State<RealNameVerifyPage> createState() => _RealNameVerifyPageState();
}

class _RealNameVerifyPageState extends State<RealNameVerifyPage> {
  final _nameController = TextEditingController();
  final _idCardController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  bool _validate(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = l10n?.realNameVerifyNameRequired ?? '请填写姓名');
      return false;
    }
    final id = _idCardController.text.trim();
    if (id.length < 15) {
      setState(() => _error = l10n?.realNameVerifyIdCardInvalid ?? '请填写正确的身份证号');
      return false;
    }
    setState(() => _error = null);
    return true;
  }

  Future<void> _submit() async {
    if (!_validate(context)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _submitting = false);
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.realNameVerifySuccess ?? '实名认证提交成功')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.realNameVerifyTitle ?? '实名认证'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.realNameVerifyHint ?? '请填写您的真实姓名与身份证号，用于实名认证',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: 24.h),
            AuthInputField(
              controller: _nameController,
              label: l10n?.realNameVerifyName ?? '姓名',
              hint: l10n?.realNameVerifyNameHint ?? '请输入真实姓名',
            ),
            SizedBox(height: 16.h),
            AuthInputField(
              controller: _idCardController,
              label: l10n?.realNameVerifyIdCard ?? '身份证',
              hint: l10n?.realNameVerifyIdCardHint ?? '请输入身份证号',
              keyboardType: TextInputType.text,
              maxLength: 18,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9Xx]'))],
            ),
            if (_error != null) ...[
              SizedBox(height: 12.h),
              Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ],
            SizedBox(height: 32.h),
            AppButton(
              label: l10n?.realNameVerifySubmit ?? '提交认证',
              loading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
