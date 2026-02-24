import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics.dart';
import '../models/models.dart';
import 'booking_provider.dart';
import 'flight_search_provider.dart';

class PaymentState {
  const PaymentState({
    this.status = PaymentStatus.pending,
    this.method = PaymentMethod.creditCard,
    this.error,
  });

  final PaymentStatus status;
  final PaymentMethod method;
  final String? error;

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentMethod? method,
    String? error,
  }) =>
      PaymentState(
        status: status ?? this.status,
        method: method ?? this.method,
        error: error,
      );
}

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(ref),
);

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier(this._ref) : super(const PaymentState());

  final Ref _ref;

  void setMethod(PaymentMethod method) =>
      state = state.copyWith(method: method);

  Future<bool> processPayment(String orderId) async {
    state = state.copyWith(status: PaymentStatus.processing, error: null);
    try {
      final repo = _ref.read(flightRepositoryProvider);
      final ok = await repo.processPayment(orderId, state.method);
      final analytics = _ref.read(analyticsServiceProvider);
      if (ok) {
        analytics.logEvent(PaymentSuccessEvent(
          orderId: orderId,
          method: state.method.label,
        ));
        state = state.copyWith(status: PaymentStatus.success);
      } else {
        analytics.logEvent(PaymentFailEvent(
          orderId: orderId,
          reason: '支付失败',
        ));
        state = state.copyWith(status: PaymentStatus.failed, error: '支付失败');
      }
      return ok;
    } catch (e) {
      _ref.read(analyticsServiceProvider).logEvent(PaymentFailEvent(
        orderId: orderId,
        reason: e.toString(),
      ));
      state = state.copyWith(
        status: PaymentStatus.failed,
        error: e.toString(),
      );
      return false;
    }
  }

  void reset() => state = const PaymentState();
}
