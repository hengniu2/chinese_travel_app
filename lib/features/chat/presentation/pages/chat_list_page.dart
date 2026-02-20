import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/chat_list_item.dart';
import '../../data/chat_list_mock.dart';
import '../widgets/chat_list_item_tile.dart';

/// 聊天列表页：头像、昵称、最后消息、未读数
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<ChatListItem> _chats;

  @override
  void initState() {
    super.initState();
    _chats = getChatList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.chatTitle ?? '消息'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: _chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 64.sp, color: AppColors.textTertiary),
                  SizedBox(height: 16.h),
                  Text(
                    l10n?.chatNoMessages ?? '暂无消息',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.separated(
              cacheExtent: 150,
              itemCount: _chats.length,
              separatorBuilder: (_, __) => const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final item = _chats[index];
                return ChatListItemTile(
                  item: item,
                  onTap: () => context.push('/messages/chat/${item.id}'),
                );
              },
            ),
    );
  }
}
