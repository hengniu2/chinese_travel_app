/// 聊天列表项
class ChatListItem {
  const ChatListItem({
    required this.id,
    required this.nickname,
    required this.lastMessage,
    required this.unreadCount,
    this.avatarUrl,
    this.lastTime,
  });

  final String id;
  final String nickname;
  final String lastMessage;
  final int unreadCount;
  final String? avatarUrl;
  final DateTime? lastTime;
}
