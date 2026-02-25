import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/authenticated_dio.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/order_detail.dart';
import '../domain/order_item.dart';
import 'order_mappers.dart';
import 'order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return OrderRepository(dio);
});

/// My orders from API. Invalidated when auth changes.
final ordersListProvider = FutureProvider<List<OrderItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final repo = ref.read(orderRepositoryProvider);
  final res = await repo.list(page: 1, pageSize: 100);
  return res.items.map(orderItemFromApi).toList();
});

/// Single order detail by id.
final orderDetailProvider = FutureProvider.family<OrderDetail?, String>((ref, id) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated || id.isEmpty) return null;
  try {
    final repo = ref.read(orderRepositoryProvider);
    final dto = await repo.get(id);
    return orderDetailFromApi(dto);
  } catch (_) {
    return null;
  }
});
