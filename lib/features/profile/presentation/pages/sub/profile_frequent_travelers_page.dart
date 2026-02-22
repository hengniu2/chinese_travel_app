import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/frequent_traveler_model.dart';
import 'profile_sub_page.dart';

/// Mock list; in real app would come from provider/API.
List<FrequentTravelerModel> _mockTravelers = [
  const FrequentTravelerModel(
    id: '1',
    name: '张三',
    phone: '138****1234',
    idNumber: '310***********1234',
    isDefault: true,
  ),
  const FrequentTravelerModel(
    id: '2',
    name: '李四',
    phone: '139****5678',
    idNumber: '310***********5678',
    isDefault: false,
  ),
];

class ProfileFrequentTravelersPage extends StatefulWidget {
  const ProfileFrequentTravelersPage({super.key});

  @override
  State<ProfileFrequentTravelersPage> createState() => _ProfileFrequentTravelersPageState();
}

class _ProfileFrequentTravelersPageState extends State<ProfileFrequentTravelersPage> {
  late List<FrequentTravelerModel> _travelers;

  @override
  void initState() {
    super.initState();
    _travelers = List.from(_mockTravelers);
  }

  void _addTraveler() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddTravelerSheet(
        l10n: l10n,
        onSave: (name, phone, idNumber, isDefault) {
          final newId = DateTime.now().millisecondsSinceEpoch.toString();
          setState(() {
            _travelers.add(FrequentTravelerModel(
              id: newId,
              name: name,
              phone: phone,
              idNumber: idNumber,
              isDefault: isDefault,
            ));
            if (isDefault) {
              _travelers = _travelers
                  .map((t) => FrequentTravelerModel(
                        id: t.id,
                        name: t.name,
                        phone: t.phone,
                        idNumber: t.idNumber,
                        isDefault: t.id == newId,
                      ))
                  .toList();
            }
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileFrequentTravelers ?? '常用出行人';

    return ProfileSubPage(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_travelers.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline_rounded, size: 64.sp, color: AppColors.textTertiary),
                    SizedBox(height: 16.h),
                    Text(
                      l10n?.profileFrequentTravelerEmpty ?? '暂无常用出行人',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 24.h),
                    _buildAddButton(l10n),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: _travelers.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final t = _travelers[index];
                  return _TravelerCard(
                    traveler: t,
                    l10n: l10n,
                    onTap: () {
                      // Edit: could open same sheet with prefill
                    },
                  );
                },
              ),
            ),
          if (_travelers.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h + MediaQuery.paddingOf(context).bottom),
              child: SafeArea(
                top: false,
                child: _buildAddButton(l10n),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(AppLocalizations? l10n) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: _addTraveler,
        icon: Icon(Icons.add_rounded, size: 22.sp, color: AppColors.primary),
        label: Text(
          l10n?.profileFrequentTravelerAdd ?? '添加出行人',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }
}

class _TravelerCard extends StatelessWidget {
  const _TravelerCard({
    required this.traveler,
    required this.l10n,
    this.onTap,
  });

  final FrequentTravelerModel traveler;
  final AppLocalizations? l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12.r),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Center(
                  child: Text(
                    traveler.name.isNotEmpty ? traveler.name[0] : '?',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          traveler.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (traveler.isDefault) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPale,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              l10n?.commonDefault ?? '默认',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      traveler.phone,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      traveler.idNumber,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 22.sp, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTravelerSheet extends StatefulWidget {
  const _AddTravelerSheet({
    required this.l10n,
    required this.onSave,
  });

  final AppLocalizations? l10n;
  final void Function(String name, String phone, String idNumber, bool isDefault) onSave;

  @override
  State<_AddTravelerSheet> createState() => _AddTravelerSheetState();
}

class _AddTravelerSheetState extends State<_AddTravelerSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              l10n?.profileFrequentTravelerAdd ?? '添加出行人',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n?.commonName ?? '姓名',
                hintText: l10n?.realNameVerifyNameHint ?? '请输入姓名',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n?.commonPhone ?? '手机号',
                hintText: '请输入手机号',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _idCtrl,
              decoration: InputDecoration(
                labelText: l10n?.commonIdNumber ?? '证件号',
                hintText: l10n?.realNameVerifyIdCardHint ?? '请输入证件号',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Checkbox(
                  value: _isDefault,
                  onChanged: (v) => setState(() => _isDefault = v ?? false),
                  activeColor: AppColors.primary,
                ),
                Text(
                  l10n?.commonDefault ?? '设为默认出行人',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      side: BorderSide(color: AppColors.border),
                    ),
                    child: Text(l10n?.commonCancel ?? '取消'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nameCtrl.text.trim();
                      final phone = _phoneCtrl.text.trim();
                      final id = _idCtrl.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n?.realNameVerifyNameRequired ?? '请输入姓名'), behavior: SnackBarBehavior.floating),
                        );
                        return;
                      }
                      widget.onSave(name, phone, id, _isDefault);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(l10n?.commonSave ?? '保存'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
