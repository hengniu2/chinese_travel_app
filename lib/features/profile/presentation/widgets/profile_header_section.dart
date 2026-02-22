import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/profile_ui_state.dart';

const double _kAvatarSize = 80;
const double _kCurveHeight = 24;

/// 卡通头部：软渐变、底部弧线、问候语、装饰小元素、80px 头像、实名/会员、消息/设置
class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    required this.auth,
    required this.profileState,
    this.onSettings,
    this.onLogout,
  });

  final AuthState auth;
  final ProfileUiState? profileState;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  static String _greetingLine(AppLocalizations? l10n) {
    return l10n?.profileGreetingReady ?? 'Ready for a new trip?';
  }

  static String _timeGreeting(AppLocalizations? l10n) {
    if (l10n == null) return 'Hello';
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.profileGreetingMorning;
    if (hour < 18) return l10n.profileGreetingAfternoon;
    return l10n.profileGreetingEvening;
  }

  static String _membershipLabel(AppLocalizations? l10n, ProfileMembershipLevel level) {
    switch (level) {
      case ProfileMembershipLevel.tourist:
        return l10n?.profileMembershipTourist ?? 'Tourist';
      case ProfileMembershipLevel.member:
        return l10n?.profileMembershipMember ?? 'Member';
      case ProfileMembershipLevel.gold:
        return l10n?.profileMembershipGold ?? 'Gold';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ClipPath(
      clipper: _CurvedBottomClipper(curveHeight: _kCurveHeight.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 12.h,
          left: 16.w,
          right: 16.w,
          bottom: 32.h + _kCurveHeight.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientWarmStart,
              AppColors.primaryGradientWarmEnd,
              AppColors.primaryGradientWarmEnd.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradientWarmStart.withValues(alpha: 0.2),
              offset: const Offset(0, 6),
              blurRadius: 20,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 24.w,
              top: 56.h,
              child: Opacity(
                opacity: 0.25,
                child: Icon(Icons.flight_takeoff_rounded, size: 32.sp, color: Colors.white),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 24.sp, color: Colors.white),
                          if (profileState != null && (profileState!.messageUnreadCount ?? 0) > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.price),
                                constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                                child: Text(
                                  '${(profileState!.messageUnreadCount ?? 0) > 99 ? 99 : (profileState!.messageUnreadCount ?? 0)}',
                                  style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () => context.push('/messages'),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_outlined, size: 24.sp, color: Colors.white),
                      onPressed: onSettings ?? () {},
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    if (!auth.isAuthenticated) context.push('/auth/login');
                  },
                  borderRadius: BorderRadius.circular((_kAvatarSize / 2 + 16).r),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'profile_avatar',
                        child: Container(
                          width: _kAvatarSize.r,
                          height: _kAvatarSize.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: auth.isAuthenticated
                              ? Center(
                                  child: Text(
                                    '享',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              : Icon(Icons.person_rounded, size: 40.sp, color: AppColors.primary.withValues(alpha: 0.8)),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.isAuthenticated
                                  ? (l10n?.profileLoggedIn ?? '已登录')
                                  : (l10n?.profileLogin ?? '点击登录'),
                              style: GoogleFonts.notoSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            if (auth.isAuthenticated) ...[
                              SizedBox(height: 4.h),
                              Text(
                                '${_timeGreeting(l10n)}，${_greetingLine(l10n)}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withValues(alpha: 0.92),
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 6.h,
                                children: [
                                  _VerifiedChip(
                                    l10n: l10n,
                                    verified: profileState?.isVerified ?? false,
                                    onTap: () => context.push('/verify-name'),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      _membershipLabel(l10n, profileState?.membershipLevel ?? ProfileMembershipLevel.tourist),
                                      style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (auth.isAuthenticated)
                        TextButton(
                          onPressed: onLogout,
                          style: TextButton.styleFrom(foregroundColor: Colors.white.withValues(alpha: 0.95)),
                          child: Text(l10n?.profileLogout ?? '退出登录'),
                        )
                      else
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            child: InkWell(
                              onTap: () => context.push('/auth/login'),
                              borderRadius: BorderRadius.circular(24.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                child: Text(
                                  l10n?.profileLoginNow ?? '立即登录',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (auth.isAuthenticated) ...[
                  SizedBox(height: 12.h),
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    ),
                    icon: Icon(Icons.edit_rounded, size: 18.sp),
                    label: Text(l10n?.profileEditProfile ?? '编辑资料'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvedBottomClipper extends CustomClipper<Path> {
  _CurvedBottomClipper({this.curveHeight = 24});

  final double curveHeight;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - curveHeight);
    path.quadraticBezierTo(size.width * 0.5, size.height + curveHeight, size.width, size.height - curveHeight);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.l10n, required this.verified, required this.onTap});

  final AppLocalizations? l10n;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          verified ? Icons.verified_rounded : Icons.verified_outlined,
          size: 16.sp,
          color: verified ? Colors.white : Colors.white.withValues(alpha: 0.85),
        ),
        SizedBox(width: 4.w),
        Text(
          verified ? (l10n?.profileVerified ?? '已实名认证') : (l10n?.profileNotVerified ?? '未实名认证'),
          style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.w500),
        ),
      ],
    );
    if (verified) return row;
    return GestureDetector(onTap: onTap, child: row);
  }
}
