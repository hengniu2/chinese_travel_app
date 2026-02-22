import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/chat_assets.dart';
import '../../data/chat_list_mock.dart';
import '../../data/chat_messages_mock.dart';
import '../../domain/chat_message.dart';
import '../widgets/chat_message_bubble.dart';

/// 列表项：时间分隔 或 消息
class _ChatListItem {
  const _ChatListItem({this.timeLabel, this.message});
  final String? timeLabel;
  final ChatMessage? message;
  bool get isTimeSeparator => timeLabel != null;
}

/// 聊天对话页：卡通风暖色背景、时间分隔、气泡、订单卡片、快捷回复、长按复制
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
    final timeStr =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
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

  void _sendText(String text) {
    if (text.trim().isEmpty) return;
    _inputController.clear();
    setState(() {
      _messages = [
        ..._messages,
        ChatMessage(
          id: 'new_${DateTime.now().millisecondsSinceEpoch}',
          type: ChatMessageType.text,
          isFromMe: true,
          time: DateTime.now(),
          text: text.trim(),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                _buildAppBar(context),
                _buildSmartTipsStrip(context, l10n),
                Expanded(
                  child: ListView.builder(
                  cacheExtent: 200,
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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

  /// 对话页背景：与列表页区分 — 浅灰蓝渐变 + 柔和圆点图案（聊天气泡感）
  Widget _buildConversationBackground(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF0F4F8),
                Color(0xFFE8EEF4),
                Color(0xFFE2E8EE),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _ConversationDotPatternPainter(),
          ),
        ),
      ],
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

  /// 对话页顶栏：拉伸到顶部（含状态栏区域），卡通头图 + 渐变遮罩 + 返回/头像/标题
  Widget _buildAppBar(BuildContext context) {
    const double barHeight = 56;
    final topPadding = MediaQuery.of(context).padding.top;
    final totalHeight = barHeight.h + topPadding;
    return SizedBox(
      height: totalHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              kChatHeaderImageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _appBarFallback(),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.homeSectionGreen.withValues(alpha: 0.85),
                    AppColors.primaryPale.withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              top: topPadding + 8.h,
              bottom: 8.h,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 22.sp),
                  onPressed: () => context.pop(),
                  color: AppColors.textPrimary,
                ),
                _buildPartnerAvatar(),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    _nickname,
                    style: GoogleFonts.zcoolKuaiLe(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  Widget _appBarFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.homeSectionGreen,
            AppColors.primaryPale,
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
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: _partnerAvatarUrl != null && _partnerAvatarUrl!.isNotEmpty
          ? ClipOval(
              child: AppNetworkImage(
                imageUrl: _partnerAvatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorWidget: _avatarPlaceholder(size),
              ),
            )
          : _avatarPlaceholder(size),
    );
  }

  Widget _avatarPlaceholder(double size) {
    return Center(
      child: Text(
        _nickname.isNotEmpty ? _nickname.substring(0, 1) : '?',
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
      padding: EdgeInsets.symmetric(vertical: 16.h),
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

  /// 马蜂窝/携程风：您可以问我… 智能提示条
  Widget _buildSmartTipsStrip(BuildContext context, AppLocalizations? l10n) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryPale.withValues(alpha: 0.7),
            AppColors.homeSectionGreen.withValues(alpha: 0.5),
          ],
        ),
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
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 8.h),
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
        color: AppColors.primaryPale.withValues(alpha: 0.3),
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
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
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: AppShadow.light,
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

/// 对话页专用：柔和圆点图案（与列表页暖色头图背景区分）
class _ConversationDotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 28;
    const double radius = 1.2;
    final paint = Paint()
      ..color = const Color(0xFFB0BEC5).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
