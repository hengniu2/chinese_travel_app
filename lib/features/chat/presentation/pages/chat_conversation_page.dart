import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/chat_list_mock.dart';
import '../../data/chat_messages_mock.dart';
import '../../domain/chat_message.dart';
import '../widgets/chat_message_bubble.dart';

/// 聊天对话页：文本、图片、订单卡片
class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  late List<ChatMessage> _messages;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = getChatMessages(widget.chatId);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _nickname {
    final item = getChatListItem(widget.chatId);
    return item?.nickname ?? '客服';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_nickname),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatMessageBubble(
                  message: msg,
                  onOrderCardTap: msg.orderCard != null
                      ? () {
                          // 可跳转订单详情 context.push('/orders/${msg.orderCard!.orderId}')
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('订单 ${msg.orderCard!.orderId}')),
                          );
                        }
                      : null,
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h + MediaQuery.of(context).padding.bottom),
      color: AppColors.backgroundCard,
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 26.sp),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _inputController,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: '输入消息',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
                style: AppTextStyles.bodyMedium,
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(Icons.send_rounded, color: AppColors.primary, size: 28.sp),
              onPressed: () {
                final text = _inputController.text.trim();
                if (text.isEmpty) return;
                _inputController.clear();
                setState(() {
                  _messages = [
                    ..._messages,
                    ChatMessage(
                      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                      type: ChatMessageType.text,
                      isFromMe: true,
                      time: DateTime.now(),
                      text: text,
                    ),
                  ];
                });
                Future.microtask(() {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
