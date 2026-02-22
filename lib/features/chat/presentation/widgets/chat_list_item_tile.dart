import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/chat_assets.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../domain/chat_list_item.dart';

/// 聊天列表项：白卡、18 圆角、软阴影、大头像、渐变未读角标（小红书/马蜂窝风）
class ChatListItemTile extends StatelessWidget {
  const ChatListItemTile({
    super.key,
    required this.item,
  });

  final ChatListItem item;

  static String _formatTime(DateTime? t) {
    if (t == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dt = DateTime(t.year, t.month, t.day);
    final timeStr =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    if (dt == today) return timeStr;
    if (dt == yesterday) return '昨天';
    return '${t.month}/${t.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ChatListColors.card,
        borderRadius: BorderRadius.circular(kChatCardRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
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
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: ChatListColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.lastTime != null)
                      Text(
                        _formatTime(item.lastTime),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: ChatListColors.textPreview,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.lastMessage,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: item.unreadCount > 0
                        ? ChatListColors.textPrimary
                        : ChatListColors.textPreview,
                    fontWeight:
                        item.unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    const double size = 44;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ChatListColors.accent.withValues(alpha: 0.25),
            boxShadow: [
              BoxShadow(
                color: ChatListColors.accent.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: item.avatarUrl != null && item.avatarUrl!.isNotEmpty
              ? ClipOval(
                  child: AppNetworkImage(
                    imageUrl: item.avatarUrl!,
                    width: size.w,
                    height: size.w,
                    fit: BoxFit.cover,
                    errorWidget: _avatarPlaceholder(size),
                  ),
                )
              : _avatarPlaceholder(size),
        ),
        if (item.unreadCount > 0) Positioned(right: -2.w, top: -2.h, child: _buildUnreadBadge()),
      ],
    );
  }

  Widget _avatarPlaceholder(double size) {
    return Center(
      child: Text(
        item.nickname.isNotEmpty ? item.nickname.substring(0, 1) : '?',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: ChatListColors.accent,
        ),
      ),
    );
  }

  Widget _buildUnreadBadge() {
    final text = item.unreadCount > 99 ? '99+' : '${item.unreadCount}';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      constraints: BoxConstraints(minWidth: 20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ChatListColors.unreadBadgeStart,
            ChatListColors.unreadBadgeEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: ChatListColors.unreadBadgeEnd.withValues(alpha: 0.4),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.35),
            offset: const Offset(0, -1),
            blurRadius: 0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
