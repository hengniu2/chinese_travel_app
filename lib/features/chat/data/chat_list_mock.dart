import '../domain/chat_list_item.dart';

List<ChatListItem> getChatList() {
  return _mockChats;
}

ChatListItem? getChatListItem(String id) {
  try {
    return _mockChats.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
}

final List<ChatListItem> _mockChats = [
  ChatListItem(
    id: 'c1',
    nickname: '丽江小助手',
    lastMessage: '您好，请问出行日期确定了吗？',
    unreadCount: 2,
    lastTime: DateTime(2025, 2, 17, 10, 30),
  ),
  ChatListItem(
    id: 'c2',
    nickname: '悦榕庄客服',
    lastMessage: '您的预订已确认，欢迎入住～',
    unreadCount: 0,
    lastTime: DateTime(2025, 2, 16, 15, 20),
  ),
  ChatListItem(
    id: 'c3',
    nickname: '旅行顾问-小王',
    lastMessage: '[图片]',
    unreadCount: 5,
    lastTime: DateTime(2025, 2, 17, 9, 0),
  ),
  ChatListItem(
    id: 'c4',
    nickname: '泸沽湖专线',
    lastMessage: '明天天气不错，适合环湖哦',
    unreadCount: 0,
    lastTime: DateTime(2025, 2, 15, 18, 45),
  ),
  ChatListItem(
    id: 'c5',
    nickname: '享梦游客服',
    lastMessage: '您的退款申请已受理',
    unreadCount: 1,
    lastTime: DateTime(2025, 2, 17, 11, 0),
  ),
];
