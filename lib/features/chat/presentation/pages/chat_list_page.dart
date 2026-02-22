import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../data/chat_assets.dart';
import '../../data/chat_list_mock.dart';
import '../../domain/chat_list_item.dart';
import '../widgets/chat_list_item_tile.dart';

// ─── 消息页 · 小红书/马蜂窝风 暖色中国风 + 可爱插画 ─────────────────────────────
const double _kSectionPadH = 16;
const double _kCardGap = 8;
const double _kSearchPillHeight = 44;
const double _kFloatingSearchOffset = -18;

/// 猜你想问 单条（文案 + icon + chatId）
class _GuessChip {
  const _GuessChip(this.label, this.chatId, this.icon);
  final String label;
  final String chatId;
  final IconData icon;
}

/// 聊天列表页：暖色头图、标题右置、浮动搜索、猜你想问、浮动卡片列表
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late List<ChatListItem> _chats;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _listAnimController;
  late Animation<double> _listOpacity;
  late Animation<Offset> _listSlide;

  @override
  void initState() {
    super.initState();
    _chats = getChatList();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim());
    });
    _listAnimController = AnimationController(
      duration: const Duration(milliseconds: 480),
      vsync: this,
    );
    _listOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _listAnimController, curve: Curves.easeOutCubic),
    );
    _listSlide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _listAnimController, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _listAnimController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  List<ChatListItem> get _filteredChats {
    if (_searchQuery.isEmpty) return _chats;
    final q = _searchQuery.toLowerCase();
    return _chats
        .where((c) =>
            c.nickname.toLowerCase().contains(q) ||
            c.lastMessage.toLowerCase().contains(q))
        .toList();
  }

  void _onGuessChipTap(String chatId) {
    if (chatId.isNotEmpty) {
      context.push('/messages/chat/$chatId');
    } else if (_chats.isNotEmpty) {
      context.push('/messages/chat/${_chats.first.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ChatListColors.backgroundStart,
              ChatListColors.backgroundEnd,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context, l10n, topPadding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _kSectionPadH.w),
              child: _buildSearchPill(context, l10n),
            ),
            SizedBox(height: 14.h),
            _buildGuessYouAsk(context, l10n),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _filteredChats.isEmpty
                      ? _buildEmptyState(context, l10n)
                      : FadeTransition(
                          opacity: _listOpacity,
                          child: SlideTransition(
                            position: _listSlide,
                            child: _buildChatList(context, l10n),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 头图：顶边贴齐、高度约减 30%、薄荷→浅青渐变、插图左侧、标题右侧、小装饰
  Widget _buildHeader(
      BuildContext context, AppLocalizations? l10n, double topPadding) {
    return SizedBox(
      height: kChatHeaderHeight.h + topPadding,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ChatListColors.headerGradientStart,
                    ChatListColors.headerGradientEnd,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              kChatHeaderImageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    ChatListColors.backgroundStart.withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 24.w, top: topPadding + 50.h, child: _decoIcon(Icons.send_rounded, 20)),
          Positioned(left: 48.w, top: topPadding + 75.h, child: _decoIcon(Icons.chat_bubble_outline_rounded, 16)),
          Positioned(right: 100.w, top: topPadding + 45.h, child: _decoIcon(Icons.cloud_outlined, 18)),
          Positioned(
            left: 16.w,
            right: 16.w,
            top: topPadding + 12.h,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: const SizedBox.shrink(),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n?.chatTitle ?? '消息',
                      style: GoogleFonts.zcoolKuaiLe(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A4540),
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n?.chatSubtitle ?? '智能客服 · 随时为您服务',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF2D6B65),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _decoIcon(IconData icon, double size) {
    return Icon(
      icon,
      size: size.sp,
      color: Colors.white.withValues(alpha: 0.45),
    );
  }

  /// 浮动搜索条：白底、16 圆角、轻阴影
  Widget _buildSearchPill(BuildContext context, AppLocalizations? l10n) {
    return Transform.translate(
      offset: Offset(0, _kFloatingSearchOffset.h),
      child: Container(
        height: _kSearchPillHeight.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: ChatListColors.card,
          borderRadius: BorderRadius.circular(kChatSearchPillRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 2),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 22.sp,
              color: ChatListColors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: ChatListColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: l10n?.chatSearchHint ?? '搜索联系人、消息',
                  hintStyle: TextStyle(
                    color: ChatListColors.textPreview,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () => _searchController.clear(),
                child: Icon(
                  Icons.close_rounded,
                  size: 20.sp,
                  color: ChatListColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 猜你想问：胶囊、渐变 pastel、图标、横滑、加大间距
  Widget _buildGuessYouAsk(BuildContext context, AppLocalizations? l10n) {
    final chips = [
      _GuessChip(l10n?.chatConsultTrip ?? '行程咨询', 'c1', Icons.route_rounded),
      _GuessChip(l10n?.chatOrderIssue ?? '订单问题', 'c2', Icons.receipt_long_rounded),
      _GuessChip(l10n?.chatRefundChange ?? '退款改签', 'c5', Icons.swap_horiz_rounded),
      _GuessChip(l10n?.chatTickets ?? '景点门票', 'c3', Icons.confirmation_number_rounded),
      _GuessChip(l10n?.chatHumanService ?? '人工客服', 'c1', Icons.support_agent_rounded),
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(_kSectionPadH.w, 4.h, _kSectionPadH.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 18.sp,
                  color: ChatListColors.secondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  l10n?.chatGuessYouAsk ?? '猜你想问',
                  style: GoogleFonts.zcoolKuaiLe(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: ChatListColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 44.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: chips.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final c = chips[index];
                return TapScale(
                  onTap: () => _onGuessChipTap(c.chatId),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ChatListColors.accent.withValues(alpha: 0.2),
                          ChatListColors.secondary.withValues(alpha: 0.18),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999.r),
                      boxShadow: [
                        BoxShadow(
                          color: ChatListColors.accent.withValues(alpha: 0.12),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon, size: 18.sp, color: ChatListColors.accent),
                        SizedBox(width: 8.w),
                        Text(
                          c.label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: ChatListColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(BuildContext context, AppLocalizations? l10n) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        _kSectionPadH.w,
        8.h,
        _kSectionPadH.w,
        24.h + MediaQuery.of(context).padding.bottom,
      ),
      cacheExtent: 200,
      itemCount: _filteredChats.length,
      itemBuilder: (context, index) {
        final item = _filteredChats[index];
        return Padding(
          padding: EdgeInsets.only(bottom: _kCardGap.h),
          child: TapScale(
            onTap: () => context.push('/messages/chat/${item.id}'),
            child: ChatListItemTile(item: item),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations? l10n) {
    final isSearch = _searchQuery.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ChatListColors.accent.withValues(alpha: 0.25),
                  ChatListColors.secondary.withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ChatListColors.accent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isSearch
                  ? Icons.search_off_rounded
                  : Icons.chat_bubble_outline_rounded,
              size: 56.sp,
              color: ChatListColors.accent,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            isSearch
                ? (l10n?.chatNoSearchResults ?? '未找到相关对话')
                : (l10n?.chatNoMessages ?? '暂无消息'),
            style: TextStyle(
              fontSize: 15.sp,
              color: ChatListColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_chats.isNotEmpty) ...[
            SizedBox(height: 20.h),
            TapScale(
              onTap: () => context.push('/messages/chat/${_chats.first.id}'),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ChatListColors.primary,
                      ChatListColors.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(kChatCardRadius.r),
                  boxShadow: [
                    BoxShadow(
                      color: ChatListColors.primary.withValues(alpha: 0.35),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Text(
                  l10n?.chatStartConsult ?? '开始咨询',
                  style: GoogleFonts.zcoolKuaiLe(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
