/// 聊天消息类型
enum ChatMessageType {
  text,
  image,
  orderCard,
}

/// 订单卡片内容（消息内嵌）
class ChatOrderCard {
  const ChatOrderCard({
    required this.orderId,
    required this.title,
    required this.amount,
    required this.statusText,
    this.subtitle,
  });

  final String orderId;
  final String title;
  final String? subtitle;
  final double amount;
  final String statusText;
}

/// 单条聊天消息
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.type,
    required this.isFromMe,
    required this.time,
    this.text,
    this.imageUrl,
    this.orderCard,
  });

  final String id;
  final ChatMessageType type;
  final bool isFromMe;
  final DateTime time;
  final String? text;
  final String? imageUrl;
  final ChatOrderCard? orderCard;
}

