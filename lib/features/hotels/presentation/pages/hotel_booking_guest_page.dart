import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';
import '../../domain/booking.dart';
import '../../providers/hotel_booking_provider.dart';

/// Step 2: Add guest information — name, phone, ID number, special request. Validation required.
class HotelBookingGuestPage extends ConsumerStatefulWidget {
  const HotelBookingGuestPage({super.key});

  @override
  ConsumerState<HotelBookingGuestPage> createState() =>
      _HotelBookingGuestPageState();
}

class _HotelBookingGuestPageState extends ConsumerState<HotelBookingGuestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _specialRequestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDraft());
  }

  void _loadDraft() {
    final draft = ref.read(hotelBookingDraftProvider);
    if (draft != null && draft.guests.isNotEmpty) {
      final g = draft.guests.first;
      _nameController.text = g.name;
      _phoneController.text = g.phone;
      _idNumberController.text = g.idNumber;
      _specialRequestController.text = g.specialRequest;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _specialRequestController.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppLocalizations.of(context)?.orderGuestNameError(1) ?? '请填写姓名';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppLocalizations.of(context)?.orderGuestPhoneError(1) ?? '请填写手机号';
    }
    if (v.trim().length < 11) {
      return AppLocalizations.of(context)?.orderGuestPhoneError(1) ?? '请输入正确的手机号';
    }
    return null;
  }

  String? _validateIdNumber(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppLocalizations.of(context)?.orderGuestIdError(1) ?? '请填写身份证号';
    }
    if (v.trim().length < 15) {
      return AppLocalizations.of(context)?.orderGuestIdError(1) ?? '请输入正确的身份证号';
    }
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final draft = ref.read(hotelBookingDraftProvider);
    if (draft == null) {
      context.pop();
      return;
    }
    final guest = HotelBookingGuest(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      idNumber: _idNumberController.text.trim(),
      specialRequest: _specialRequestController.text.trim(),
    );
    ref.read(hotelBookingDraftProvider.notifier).setGuests([guest]);
    context.push('/hotels/booking/payment');
  }

  Widget _buildSpecialRequestField(AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n?.hotelSpecialRequest ?? '特殊要求',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: _specialRequestController,
            maxLines: 3,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n?.hotelSpecialRequestHint ?? '如：提前入住、加枕头等',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(hotelBookingDraftProvider);

    if (draft == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n?.hotelBookingGuestTitle ?? '入住人信息'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n?.hotelNoRooms ?? '请先确认订单',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n?.commonCancel ?? '返回'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.hotelBookingGuestTitle ?? '入住人信息'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n?.orderGuestHint ?? '请填写入住人姓名、身份证、手机号，确保与证件一致',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 20.h),
              AuthInputField(
                controller: _nameController,
                label: l10n?.hotelGuestName ?? '姓名',
                hint: l10n?.hotelGuestName ?? '请输入姓名',
                validator: _validateName,
              ),
              SizedBox(height: 16.h),
              AuthInputField(
                controller: _phoneController,
                label: l10n?.hotelGuestPhone ?? '手机号',
                hint: l10n?.hotelGuestPhone ?? '请输入手机号',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
                validator: _validatePhone,
              ),
              SizedBox(height: 16.h),
              AuthInputField(
                controller: _idNumberController,
                label: l10n?.hotelGuestIdNumber ?? '身份证号',
                hint: l10n?.hotelGuestIdNumber ?? '请输入身份证号',
                validator: _validateIdNumber,
              ),
              SizedBox(height: 16.h),
              _buildSpecialRequestField(l10n),
              SizedBox(height: 32.h),
              AppButton(
                label: l10n?.hotelProceedToPayment ?? '去支付',
                onPressed: _submit,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
