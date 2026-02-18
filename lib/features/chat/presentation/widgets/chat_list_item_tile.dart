import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/chat_list_item.dart';

/// 聊天列表项：头像、昵称、最后消息、未读数
class ChatListItemTile extends StatelessWidget {
  const ChatListItemTile({
    super.key,
    required this.item,
    this.onTap,
  });

  final ChatListItem item;
  final VoidCallback? onTap;

  static String _formatTime(DateTime? t) {
    if (t == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dt = DateTime(t.year, t.month, t.day);
    final timeStr = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    if (dt == today) return timeStr;
    if (dt == yesterday) return '昨天 $timeStr';
    return '${t.month}月${t.day}日 $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
          ),
          child: Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.nickname,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.lastTime != null)
                          Text(
                            _formatTime(item.lastTime),
                            style: AppTextStyles.label.copyWith(color: AppColors.textTertiary, fontSize: 12.sp),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.lastMessage,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: item.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                              fontWeight: item.unreadCount > 0 ? FontWeight.w500 : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.unreadCount > 0) ...[
                          SizedBox(width: 8.w),
                          _buildUnreadBadge(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: item.avatarUrl != null && item.avatarUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                item.avatarUrl!,
                fit: BoxFit.cover,
                width: 48.w,
                height: 48.w,
                errorBuilder: (_, __, ___) => _avatarPlaceholder(),
              ),
            )
          : _avatarPlaceholder(),
    );
  }

  Widget _avatarPlaceholder() {
    return Center(
      child: Text(
        item.nickname.isNotEmpty ? item.nickname.substring(0, 1) : '?',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildUnreadBadge() {
    final text = item.unreadCount > 99 ? '99+' : '${item.unreadCount}';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      constraints: BoxConstraints(minWidth: 18.w),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
