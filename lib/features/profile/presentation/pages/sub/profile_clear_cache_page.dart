import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import 'profile_sub_page.dart';

class ProfileClearCachePage extends StatefulWidget {
  const ProfileClearCachePage({super.key});

  @override
  State<ProfileClearCachePage> createState() => _ProfileClearCachePageState();
}

class _ProfileClearCachePageState extends State<ProfileClearCachePage> {
  String _cacheSize = '12.6 MB';
  bool _cleared = false;

  void _clearCache() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n?.profileClearCacheDo ?? '清除缓存'),
          content: const Text('确定要清除缓存吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n?.commonCancel ?? '取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _cacheSize = '0 MB';
                  _cleared = true;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n?.profileClearCacheDone ?? '已清除'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(l10n?.commonConfirm ?? '确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileClearCache ?? '清除缓存';

    return ProfileSubPage(
      title: title,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.cleaning_services_rounded, color: AppColors.primary, size: 26.sp),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      l10n?.profileClearCacheSize(_cacheSize) ?? '缓存大小：$_cacheSize',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: _cleared ? null : _clearCache,
                icon: Icon(
                  _cleared ? Icons.check_rounded : Icons.delete_outline_rounded,
                  size: 22.sp,
                  color: _cleared ? AppColors.textTertiary : Colors.white,
                ),
                label: Text(
                  _cleared
                      ? (l10n?.profileClearCacheDone ?? '已清除')
                      : (l10n?.profileClearCacheDo ?? '清除缓存'),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _cleared ? AppColors.textTertiary : Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cleared ? AppColors.textTertiary.withValues(alpha: 0.3) : AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.textTertiary.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
