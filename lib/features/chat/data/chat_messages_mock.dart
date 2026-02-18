import '../domain/chat_message.dart';

List<ChatMessage> getChatMessages(String chatId) {
  return _mockByChat[chatId] ?? _mockByChat['c1']!;
}

final Map<String, List<ChatMessage>> _mockByChat = {
  'c1': [
    ChatMessage(
      id: 'm1',
      type: ChatMessageType.text,
      isFromMe: false,
      time: DateTime(2025, 2, 17, 10, 28),
      text: '您好，请问您的出行日期确定了吗？',
    ),
    ChatMessage(
      id: 'm2',
      type: ChatMessageType.text,
      isFromMe: true,
      time: DateTime(2025, 2, 17, 10, 29),
      text: '暂定3月15号出发',
    ),
    ChatMessage(
      id: 'm3',
      type: ChatMessageType.orderCard,
      isFromMe: true,
      time: DateTime(2025, 2, 17, 10, 30),
      orderCard: ChatOrderCard(
        orderId: 'TO202502161430001',
        title: '丽江+泸沽湖5天4晚2-8人小包团',
        subtitle: '丽江奇妙之旅',
        amount: 3760,
        statusText: '待付款',
      ),
    ),
    ChatMessage(
      id: 'm4',
      type: ChatMessageType.text,
      isFromMe: false,
      time: DateTime(2025, 2, 17, 10, 30),
      text: '好的，这是您的订单，请尽快完成支付哦～',
    ),
    ChatMessage(
      id: 'm5',
      type: ChatMessageType.image,
      isFromMe: false,
      time: DateTime(2025, 2, 17, 10, 31),
      imageUrl: 'https://picsum.photos/seed/chat1/400/300',
    ),
    ChatMessage(
      id: 'm6',
      type: ChatMessageType.text,
      isFromMe: false,
      time: DateTime(2025, 2, 17, 10, 31),
      text: '这是丽江古城的实拍，供您参考',
    ),
  ],
  'c2': [
    ChatMessage(
      id: 'm1',
      type: ChatMessageType.text,
      isFromMe: false,
      time: DateTime(2025, 2, 16, 15, 20),
      text: '您的预订已确认，欢迎入住～',
    ),
    ChatMessage(
      id: 'm2',
      type: ChatMessageType.orderCard,
      isFromMe: false,
      time: DateTime(2025, 2, 16, 15, 20),
      orderCard: ChatOrderCard(
        orderId: 'HO202502100900001',
        title: '丽江古城悦榕庄',
        subtitle: '花园别墅',
        amount: 2680,
        statusText: '待出行',
      ),
    ),
  ],
  'c3': [
    ChatMessage(
      id: 'm1',
      type: ChatMessageType.image,
      isFromMe: false,
      time: DateTime(2025, 2, 17, 9, 0),
      imageUrl: 'https://picsum.photos/seed/tour2/400/300',
    ),
    ChatMessage(
      id: 'm2',
      type: ChatMessageType.text,
      isFromMe: false,
      time: DateTime(2025, 2, 17, 9, 1),
      text: '这条线路最近很火，推荐您看看',
    ),
  ],
};
