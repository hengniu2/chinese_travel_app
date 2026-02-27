import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/chat_repository_provider.dart';
import '../../domain/chat_list_item.dart';
import '../../domain/chat_message.dart';
import '../widgets/chat_message_bubble.dart';

/// 列表项：时间分隔 或 消息
class _ChatListItem {
  const _ChatListItem({this.timeLabel, this.message});
  final String? timeLabel;
  final ChatMessage? message;
  bool get isTimeSeparator => timeLabel != null;
}

/// 聊天对话页：卡通风暖色背景、时间分隔、气泡、订单卡片、快捷回复、长按复制（API 数据）
class ChatConversationPage extends ConsumerStatefulWidget {
  const ChatConversationPage({super.key, required this.chatId});

  final String chatId;

  @override
  ConsumerState<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends ConsumerState<ChatConversationPage> with SingleTickerProviderStateMixin {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _partnerTyping = false;
  late AnimationController _typingController;

  static const Color _creamBackground = Color(0xFFFFF8E8);

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _typingController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static List<_ChatListItem> _buildListItems(List<ChatMessage> messages) {
    final items = <_ChatListItem>[];
    DateTime? prevTime;
    for (final msg in messages) {
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
    return items;
  }

  static bool _isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }

  static String _formatTimeLabel(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dt = DateTime(t.year, t.month, t.day);
    final timeStr =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    if (dt == today) return timeStr;
    if (dt == yesterday) return '昨天 $timeStr';
    return '${t.month}月${t.day}日 $timeStr';
  }

  Future<void> _sendText(String text) async {
    if (text.trim().isEmpty) return;
    _inputController.clear();
    try {
      final repo = ref.read(chatRepositoryProvider);
      await repo.sendMessage(widget.chatId, content: text.trim());
      ref.refresh(chatMessagesProvider(widget.chatId));
      if (_scrollController.hasClients) {
        Future.microtask(() {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Send failed: $e')));
      }
    }
  }

  void _onCopyText(String? text) {
    if (text == null || text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.chatCopied ?? '已复制'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Resolve conversation/companion name from chat list; fallback to localized "消息".
  String _companionTitle(AppLocalizations? l10n, List<ChatListItem> chats) {
    final match = chats.where((c) => c.id == widget.chatId).toList();
    final item = match.isEmpty ? null : match.first;
    if (item == null) return l10n?.chatTitle ?? '消息';
    final nickname = item.nickname;
    if (nickname == 'Chat' || nickname == 'Messages') return l10n?.chatTitle ?? nickname;
    return nickname;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncMessages = ref.watch(chatMessagesProvider(widget.chatId));
    final asyncChats = ref.watch(chatListProvider);
    final companionTitle = asyncChats.valueOrNull != null
        ? _companionTitle(l10n, asyncChats.valueOrNull!)
        : (l10n?.chatTitle ?? '消息');
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildConversationBackground(context),
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context, companionTitle: companionTitle),
                _buildSmartTipsStrip(context, l10n),
                Expanded(
                  child: asyncMessages.when(
                    data: (messages) {
                      final listItems = _buildListItems(messages);
                      return ListView.builder(
                        cacheExtent: 200,
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        itemCount: listItems.length + (_partnerTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_partnerTyping && index == listItems.length) {
                            return _buildTypingIndicator();
                          }
                          final item = listItems[index];
                    if (item.isTimeSeparator) {
                      return _buildTimeSeparator(item.timeLabel!);
                    }
                    final msg = item.message!;
                    return ChatMessageBubble(
                      message: msg,
                      partnerAvatarUrl: null,
                      showAvatar: true,
                      onOrderCardTap: msg.orderCard != null
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n?.chatOrderCard(msg.orderCard!.orderId) ??
                                        '订单 ${msg.orderCard!.orderId}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                      onLongPress: msg.type == ChatMessageType.text && msg.text != null
                          ? () => _showCopyDialog(context, msg.text!)
                          : null,
                    );
                  },
                );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => ref.refresh(chatMessagesProvider(widget.chatId)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildQuickReplies(context, l10n),
                _buildInputBar(context, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 对话页背景：柔和奶油色 #FFF8E8，无重绿
  Widget _buildConversationBackground(BuildContext context) {
    return Container(
      color: _creamBackground,
    );
  }

  void _showCopyDialog(BuildContext context, String text) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          boxShadow: AppShadow.heavy,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              ListTile(
                leading: Icon(Icons.copy_rounded, color: AppColors.primary),
                title: Text(l10n?.chatCopy ?? '复制'),
                onTap: () {
                  Navigator.pop(context);
                  _onCopyText(text);
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  /// 对话页顶栏：奶油底 + 返回/伴游头像/昵称或标题/在线状态/更多
  Widget _buildAppBar(BuildContext context, {required String companionTitle}) {
    const double barHeight = 56;
    final topPadding = MediaQuery.of(context).padding.top;
    final totalHeight = barHeight.h + topPadding;
    return Container(
      height: totalHeight,
      decoration: BoxDecoration(
        color: _creamBackground,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: topPadding + 6.h,
          bottom: 6.h,
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
              onPressed: () => context.pop(),
              color: AppColors.textPrimary,
            ),
            _buildPartnerAvatar(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    companionTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '在线',
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_horiz_rounded, size: 24.sp),
              onPressed: () {},
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerAvatar() {
    final size = 40.w;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryPale,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: _avatarPlaceholder(size),
    );
  }

  /// 正在输入... 指示（带点点动画）
  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPartnerAvatar(),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _typingController,
              builder: (context, child) {
                final t = _typingController.value;
                final dots = (1 + (t * 3).floor() % 3);
                return Text(
                  '正在输入${'.' * dots}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(double size) {
    return Center(
      child: Text(
        'C',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTimeSeparator(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryPale.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 0.5,
            ),
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

  /// 智能提示条：黄品牌，无绿
  Widget _buildSmartTipsStrip(BuildContext context, AppLocalizations? l10n) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryPale.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 18.sp, color: AppColors.accentGold),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              l10n?.chatYouCanAsk ?? '您可以问我：行程、订单、退改、天气…',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 快捷回复：旅行场景 + 常用语（马蜂窝/携程风）
  Widget _buildQuickReplies(BuildContext context, AppLocalizations? l10n) {
    final travelReplies = [
      l10n?.chatViewOrder ?? '查看订单',
      l10n?.chatChangeTrip ?? '修改行程',
      l10n?.chatRefundPolicy ?? '退改政策',
      l10n?.chatHumanService ?? '人工客服',
      l10n?.chatSendLocation ?? '发送位置',
    ];
    final commonReplies = [
      l10n?.chatQuickReplyOk ?? '好的',
      l10n?.chatQuickReplyThanks ?? '谢谢',
      l10n?.chatQuickReplyLater ?? '稍后联系',
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryPale.withValues(alpha: 0.2),
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: travelReplies
                  .map(
                    (r) => Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: _quickReplyChip(context, r, isTravel: true),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 6.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: commonReplies
                  .map(
                    (r) => Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: _quickReplyChip(context, r, isTravel: false),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickReplyChip(BuildContext context, String label, {required bool isTravel}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _sendText(label),
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isTravel ? AppColors.card : AppColors.primaryPale.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: isTravel ? AppColors.border : AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: AppShadow.light,
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, AppLocalizations? l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12.w,
        8.h,
        12.w,
        8.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryPale.withValues(alpha: 0.35),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.6), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.image_outlined,
                color: AppColors.textSecondary,
                size: 26.sp,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.7),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _inputController,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: l10n?.chatInputHint ?? '输入消息',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: AppColors.primary,
                size: 28.sp,
              ),
              onPressed: () => _sendText(_inputController.text),
            ),
          ],
        ),
      ),
    );
  }
}
