import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'booking_provider.dart';
import 'flight_search_provider.dart';

class OrderState {
  const OrderState({
    this.orderId,
    this.order,
    this.isLoading = false,
    this.error,
  });

  final String? orderId;
  final FlightOrder? order;
  final bool isLoading;
  final String? error;

  OrderState copyWith({
    String? orderId,
    FlightOrder? order,
    bool? isLoading,
    String? error,
  }) =>
      OrderState(
        orderId: orderId ?? this.orderId,
        order: order ?? this.order,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ref),
);

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier(this._ref) : super(const OrderState());

  final Ref _ref;

  Future<String?> createOrder() async {
    final booking = _ref.read(flightBookingProvider);
    if (booking == null) {
      state = state.copyWith(error: '请先选择航班');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(flightRepositoryProvider);
      final orderId = await repo.createOrder(booking);
      state = state.copyWith(
        orderId: orderId,
        isLoading: false,
      );
      return orderId;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<void> fetchOrder(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(flightRepositoryProvider);
      final order = await repo.getOrder(orderId);
      state = state.copyWith(order: order, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() => state = const OrderState();
}
