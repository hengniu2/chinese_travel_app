import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../auth/data/authenticated_dio.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/chat_list_item.dart';
import '../domain/chat_message.dart';
import 'chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return ChatRepository(dio);
});

/// Current user id (from GET /api/auth/me). Used for chat isFromMe.
final currentUserIdProvider = FutureProvider<String?>((ref) async {
  if (!ref.read(authProvider).isAuthenticated) return null;
  try {
    final dio = ref.read(authenticatedDioProvider);
    final res = await dio.get<Map<String, dynamic>>('${AppConstants.apiPathPrefix}/auth/me');
    final data = res.data?['data'];
    if (data is! Map<String, dynamic>) return null;
    final account = data['account'];
    if (account is Map) return (account['id'] ?? account['_id'])?.toString();
    return null;
  } catch (_) {
    return null;
  }
});

/// Chat list from API (conversations).
final chatListProvider = FutureProvider<List<ChatListItem>>((ref) async {
  if (!ref.read(authProvider).isAuthenticated) return [];
  try {
    final repo = ref.read(chatRepositoryProvider);
    final res = await repo.listConversations(page: 1, pageSize: 50);
    return res.items.map((c) => ChatListItem(
      id: c.id,
      nickname: 'Chat',
      lastMessage: '',
      unreadCount: 0,
      lastTime: c.updatedAt,
    )).toList();
  } catch (_) {
    return [];
  }
});

/// Messages for a conversation. Refreshed after send.
final chatMessagesProvider = FutureProvider.family<List<ChatMessage>, String>((ref, conversationId) async {
  if (!ref.read(authProvider).isAuthenticated || conversationId.isEmpty) return [];
  final userId = await ref.watch(currentUserIdProvider.future);
  try {
    final repo = ref.read(chatRepositoryProvider);
    final list = await repo.listMessages(conversationId, limit: 100);
    return list.map((m) => ChatMessage(
      id: m.id,
      type: ChatMessageType.text,
      isFromMe: userId != null && m.senderId == userId,
      time: m.createdAt ?? DateTime.now(),
      text: m.content,
    )).toList();
  } catch (_) {
    return [];
  }
});
