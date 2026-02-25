import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/customer_profile_repository.dart';
import '../../data/membership_models.dart';
import '../../data/profile_ui_state.dart';

/// Sample style: one stretched header with background image + profile row inside (avatar, user ID, badge, edit).
const double _kHeaderHeight = 188;
const double _kAvatarSize = 64;
const double _kCardRadius = 16;

/// Profile screen only: AI-generated cartoon header (Chinese travel app, 享梦游 XMY vibe).
const String kProfileHeaderImageAsset = 'assets/header_profile_xmy.png';
/// Default cartoon avatar when no user photo (profile screen).
const String kProfileAvatarDefaultAsset = 'assets/avatar_profile_default.png';

/// Fixed stretched header with profile content inside (like sample). Full width, image + gradient + profile row.
class ProfileHeaderStrip extends StatelessWidget {
  const ProfileHeaderStrip({
    super.key,
    required this.auth,
    this.profileState,
    this.membershipProfile,
    this.customerProfile,
    this.onSettings,
    this.onLogout,
    this.onMore,
  });

  final AuthState auth;
  final ProfileUiState? profileState;
  /// When non-null and isVip, shows golden VIP badge next to username.
  final UserMembershipProfile? membershipProfile;
  /// From API: display name, avatar URL (when logged in).
  final CustomerProfileDto? customerProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;
  final VoidCallback? onMore;

  static Widget _avatarPlaceholder(BuildContext context) {
    return Container(
      color: AppColors.primaryPale,
      child: Center(
        child: Text(
          '享',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: _kHeaderHeight.h,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                kProfileHeaderImageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF8BC34A)),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
            ),
            // Top row: safe area + settings
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + 4.h,
                  left: 8.w,
                  right: 8.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.more_horiz_rounded, size: 24.sp, color: Colors.white),
                      onPressed: onMore ?? () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_outlined, size: 24.sp, color: Colors.white),
                      onPressed: onSettings ?? () {},
                    ),
                  ],
                ),
              ),
            ),
            // Profile row inside header (avatar | user ID + badge | edit button) — flexible to avoid overflow
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: MediaQuery.paddingOf(context).top + 40.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!auth.isAuthenticated) context.push('/auth/login');
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: _kAvatarSize.r,
                              height: _kAvatarSize.r,
                              child: customerProfile?.avatarUrl != null && customerProfile!.avatarUrl.isNotEmpty
                                  ? AppNetworkImage(
                                      imageUrl: customerProfile!.avatarUrl,
                                      fit: BoxFit.cover,
                                      errorWidget: Image.asset(
                                        kProfileAvatarDefaultAsset,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _avatarPlaceholder(context),
                                      ),
                                    )
                                  : Image.asset(
                                      kProfileAvatarDefaultAsset,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _avatarPlaceholder(context),
                                    ),
                            ),
                          ),
                          Container(
                            width: _kAvatarSize.r,
                            height: _kAvatarSize.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 22.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: Icon(Icons.camera_alt_rounded, size: 11.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  auth.isAuthenticated
                                      ? (customerProfile?.displayName != null && customerProfile!.displayName.isNotEmpty
                                            ? customerProfile!.displayName
                                            : (l10n?.profileUserLabel('') ?? '用户'))
                                      : (l10n?.profileLogin ?? '点击登录'),
                                  style: AppTextStyles.header(Colors.white, fontSize: 18.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (membershipProfile != null && membershipProfile!.isVip) ...[
                                SizedBox(width: 8.w),
                                _VipBadge(label: l10n?.vipBadgeLabel ?? 'VIP'),
                              ],
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.emoji_emotions_outlined, size: 12.sp, color: Colors.white),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    profileState != null
                                        ? _membershipLabel(l10n, profileState!.membershipLevel)
                                        : (l10n?.profileMembershipTourist ?? '游客'),
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (auth.isAuthenticated)
                      Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20.r),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            child: Text(
                              l10n?.profileEditProfile ?? '编辑资料',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      )
                    else
                      Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20.r),
                        child: InkWell(
                          onTap: () => context.push('/auth/login'),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            child: Text(
                              l10n?.profileLoginNow ?? '立即登录',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full header section (strip with profile inside). For use when not using fixed header.
class ProfileHeaderSampleSection extends StatelessWidget {
  const ProfileHeaderSampleSection({
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

  @override
  Widget build(BuildContext context) {
    return ProfileHeaderStrip(
      auth: auth,
      profileState: profileState,
      onSettings: onSettings,
      onLogout: onLogout,
    );
  }
}

/// User card only (for scroll content when header is fixed). Overlap height from strip: _kUserCardOverlap.
class ProfileHeaderUserCard extends StatelessWidget {
  const ProfileHeaderUserCard({
    super.key,
    required this.auth,
    this.profileState,
    this.onSettings,
    this.onLogout,
  });

  final AuthState auth;
  final ProfileUiState? profileState;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(_kCardRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (!auth.isAuthenticated) context.push('/auth/login');
        },
        borderRadius: BorderRadius.circular(_kCardRadius.r),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: _kAvatarSize.r,
                  height: _kAvatarSize.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPale,
                    border: Border.all(color: AppColors.border, width: 1),
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
                      : Icon(Icons.person_rounded, size: 28.sp, color: AppColors.primary.withValues(alpha: 0.7)),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.card, width: 1.5),
                    ),
                    child: Icon(Icons.camera_alt_rounded, size: 12.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    auth.isAuthenticated
                        ? (l10n?.profileUserLabel('1394') ?? '用户1394')
                        : (l10n?.profileLogin ?? '点击登录'),
                    style: AppTextStyles.header(AppColors.textPrimary, fontSize: 19.sp),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_emotions_outlined, size: 14.sp, color: AppColors.primary),
                        SizedBox(width: 4.w),
                        Text(
                          profileState != null
                              ? _membershipLabel(l10n, profileState!.membershipLevel)
                              : (l10n?.profileMembershipTourist ?? '游客'),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (auth.isAuthenticated)
              Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                    child: Text(
                      l10n?.profileEditProfile ?? '编辑资料',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
            else
              Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                child: InkWell(
                  onTap: () => context.push('/auth/login'),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                    child: Text(
                      l10n?.profileLoginNow ?? '立即登录',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Golden gradient VIP badge shown next to username.
class _VipBadge extends StatelessWidget {
  const _VipBadge({required this.label});

  final String label;

  static const List<Color> _gradientColors = [
    Color(0xFFFFE082),
    Color(0xFFFFD54F),
    Color(0xFFF9A825),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF9A825).withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF3E2723),
        ),
      ),
    );
  }
}

String _membershipLabel(AppLocalizations? l10n, ProfileMembershipLevel level) {
  switch (level) {
    case ProfileMembershipLevel.tourist:
      return l10n?.profileMembershipTourist ?? '游客';
    case ProfileMembershipLevel.member:
      return l10n?.profileMembershipMember ?? '会员';
    case ProfileMembershipLevel.gold:
      return l10n?.profileMembershipGold ?? '黄金会员';
  }
}
