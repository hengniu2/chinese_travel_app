import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/friend_model.dart';
import 'profile_sub_page.dart';

List<FriendModel> _mockFriends = [
  const FriendModel(id: '1', name: '小明', travelCount: 3),
  const FriendModel(id: '2', name: '小红', travelCount: 1),
  const FriendModel(id: '3', name: '阿强', travelCount: 5),
  const FriendModel(id: '4', name: '小美', travelCount: 0),
];

class ProfileMyFriendsPage extends StatefulWidget {
  const ProfileMyFriendsPage({super.key});

  @override
  State<ProfileMyFriendsPage> createState() => _ProfileMyFriendsPageState();
}

class _ProfileMyFriendsPageState extends State<ProfileMyFriendsPage> {
  final _searchCtrl = TextEditingController();
  List<FriendModel> _list = List.from(_mockFriends);

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _list = List.from(_mockFriends);
      } else {
        _list = _mockFriends.where((f) => f.name.toLowerCase().contains(q)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileMyFriends ?? '我的朋友';

    return ProfileSubPage(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '搜索好友',
                prefixIcon: Icon(Icons.search_rounded, size: 22.sp, color: AppColors.textTertiary),
                suffixIcon: _searchCtrl.text.trim().isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear_rounded, size: 20.sp, color: AppColors.textTertiary),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
                      ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.6), width: 1.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
          Expanded(
            child: _list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _searchCtrl.text.trim().isEmpty
                              ? Icons.people_outline_rounded
                              : Icons.search_off_rounded,
                          size: 64.sp,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _searchCtrl.text.trim().isEmpty ? '暂无好友' : '未找到匹配的好友',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: _list.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final friend = _list[index];
                      return _FriendCard(
                        friend: friend,
                        onTravelTogether: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('邀请 ${friend.name} 一起出行'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h + MediaQuery.paddingOf(context).bottom),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('添加好友功能开发中'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: Icon(Icons.person_add_rounded, size: 22.sp, color: AppColors.primary),
                  label: Text(
                    '添加好友',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  const _FriendCard({
    required this.friend,
    required this.onTravelTogether,
  });

  final FriendModel friend;
  final VoidCallback onTravelTogether;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                friend.name.isNotEmpty ? friend.name[0] : '?',
                style: TextStyle(
                  fontSize: 20.sp,
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
              children: [
                Text(
                  friend.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (friend.travelCount > 0)
                  Text(
                    '已一起出行 ${friend.travelCount} 次',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20.r),
            child: InkWell(
              onTap: onTravelTogether,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                child: Text(
                  '一起出行',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
