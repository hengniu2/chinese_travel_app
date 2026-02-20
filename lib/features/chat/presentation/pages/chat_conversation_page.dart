import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/chat_list_mock.dart';
import '../../data/chat_messages_mock.dart';
import '../../domain/chat_message.dart';
import '../widgets/chat_message_bubble.dart';

/// 中国主流 IM 聊天背景灰
const Color _kChatBackground = Color(0xFFEDEDED);

/// 列表项：时间分隔 或 消息
class _ChatListItem {
  const _ChatListItem({this.timeLabel, this.message});
  final String? timeLabel;
  final ChatMessage? message;
  bool get isTimeSeparator => timeLabel != null;
}

/// 聊天对话页：时间分隔、气泡+头像、订单卡片、输入栏
class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  List<ChatMessage> _messages = [];
  List<_ChatListItem> _listItems = [];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = getChatMessages(widget.chatId);
    _rebuildListItems();
  }

  void _rebuildListItems() {
    final items = <_ChatListItem>[];
    DateTime? prevTime;
    for (final msg in _messages) {
      final t = msg.time;
      final showTime = prevTime == null ||
          _isDifferentDay(prevTime, t) ||
          t.difference(prevTime).inMinutes >= 5;
      if (showTime) {
        items.add(_ChatListItem(timeLabel: _formatTimeLabel(t)));
      }
      items.add(_ChatListItem(message: msg));
      prevTime = t;
    }
    _listItems = items;
  }

  static bool _isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }

  static String _formatTimeLabel(DateTime t) {
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
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _nickname {
    final item = getChatListItem(widget.chatId);
    return item?.nickname ?? '客服';
  }

  String? get _partnerAvatarUrl {
    return getChatListItem(widget.chatId)?.avatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kChatBackground,
      appBar: AppBar(
        title: Text(_nickname),
        backgroundColor: _kChatBackground,
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
              cacheExtent: 200,
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              itemCount: _listItems.length,
              itemBuilder: (context, index) {
                final item = _listItems[index];
                if (item.isTimeSeparator) {
                  return _buildTimeSeparator(item.timeLabel!);
                }
                final msg = item.message!;
                return ChatMessageBubble(
                  message: msg,
                  partnerAvatarUrl: _partnerAvatarUrl,
                  showAvatar: true,
                  onOrderCardTap: msg.orderCard != null
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)?.chatOrderCard(msg.orderCard!.orderId) ??
                                    '订单 ${msg.orderCard!.orderId}',
                              ),
                            ),
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

  Widget _buildTimeSeparator(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h + MediaQuery.of(context).padding.bottom),
      color: _kChatBackground,
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
                  hintText: AppLocalizations.of(context)?.chatInputHint ?? '输入消息',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
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
                  _rebuildListItems();
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
