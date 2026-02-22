import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/address_model.dart';
import 'profile_sub_page.dart';

List<AddressModel> _mockAddresses = [
  const AddressModel(
    id: '1',
    receiver: '张三',
    phone: '138****1234',
    region: '上海市浦东新区陆家嘴街道',
    detail: 'XX路XX号XX室',
    isDefault: true,
  ),
  const AddressModel(
    id: '2',
    receiver: '李四',
    phone: '139****5678',
    region: '北京市朝阳区',
    detail: 'XX小区X栋X单元',
    isDefault: false,
  ),
];

class ProfileAddressesPage extends StatefulWidget {
  const ProfileAddressesPage({super.key});

  @override
  State<ProfileAddressesPage> createState() => _ProfileAddressesPageState();
}

class _ProfileAddressesPageState extends State<ProfileAddressesPage> {
  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = List.from(_mockAddresses);
  }

  void _addAddress() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddressSheet(
        l10n: l10n,
        onSave: (receiver, phone, region, detail, isDefault) {
          final newId = DateTime.now().millisecondsSinceEpoch.toString();
          setState(() {
            _addresses.add(AddressModel(
              id: newId,
              receiver: receiver,
              phone: phone,
              region: region,
              detail: detail,
              isDefault: isDefault,
            ));
            if (isDefault) {
              _addresses = _addresses
                  .map((a) => AddressModel(
                        id: a.id,
                        receiver: a.receiver,
                        phone: a.phone,
                        region: a.region,
                        detail: a.detail,
                        isDefault: a.id == newId,
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
    final title = l10n?.profileShippingAddress ?? '收货地址';

    return ProfileSubPage(
      title: title,
      child: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text(
                    l10n?.profileAddressEmpty ?? '暂无收货地址',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 24.h),
                  _addButton(l10n),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: _addresses.length + 1,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index == _addresses.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h + MediaQuery.paddingOf(context).bottom),
                    child: _addButton(l10n),
                  );
                }
                return _AddressCard(
                  address: _addresses[index],
                  l10n: l10n,
                );
              },
            ),
    );
  }

  Widget _addButton(AppLocalizations? l10n) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: _addAddress,
        icon: Icon(Icons.add_rounded, size: 22.sp, color: AppColors.primary),
        label: Text(
          l10n?.profileAddressAdd ?? '添加地址',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
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

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.l10n,
  });

  final AddressModel address;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                address.receiver,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                address.phone,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              if (address.isDefault)
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
          ),
          SizedBox(height: 8.h),
          Text(
            address.fullAddress,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressSheet extends StatefulWidget {
  const _AddressSheet({
    required this.l10n,
    required this.onSave,
  });

  final AppLocalizations? l10n;
  final void Function(String receiver, String phone, String region, String detail, bool isDefault) onSave;

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<_AddressSheet> {
  final _receiverCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _regionCtrl = TextEditingController(text: '上海市浦东新区');
  final _detailCtrl = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _receiverCtrl.dispose();
    _phoneCtrl.dispose();
    _regionCtrl.dispose();
    _detailCtrl.dispose();
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
              l10n?.profileAddressAdd ?? '添加地址',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _receiverCtrl,
              decoration: InputDecoration(
                labelText: l10n?.commonName ?? '收货人',
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _regionCtrl,
              decoration: InputDecoration(
                labelText: l10n?.commonAddress ?? '省市区',
                hintText: '选择省市区',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _detailCtrl,
              decoration: InputDecoration(
                labelText: '详细地址',
                hintText: '街道、门牌号等',
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
                  '${l10n?.commonDefault ?? '默认'}地址',
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
                      final receiver = _receiverCtrl.text.trim();
                      final region = _regionCtrl.text.trim();
                      final detail = _detailCtrl.text.trim();
                      if (receiver.isEmpty || detail.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('请填写收货人和详细地址'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      widget.onSave(
                        receiver,
                        _phoneCtrl.text.trim(),
                        region,
                        detail,
                        _isDefault,
                      );
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
