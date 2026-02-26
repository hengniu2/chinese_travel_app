import '../domain/order_detail.dart';
import '../domain/order_item.dart';
import 'order_repository.dart';

/// Maps backend order status to UI OrderStatus
OrderStatus orderStatusFromApi(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING':
      return OrderStatus.pendingPayment;
    case 'PAID':
    case 'CONFIRMED':
      return OrderStatus.pendingTrip;
    case 'FULFILLED':
      return OrderStatus.completed;
    case 'CANCELLED':
    case 'REFUNDED':
      return OrderStatus.refund;
    default:
      return OrderStatus.pendingPayment;
  }
}

OrderType orderTypeFromItemType(String itemType) {
  switch (itemType.toUpperCase()) {
    case 'HOTEL':
      return OrderType.hotel;
    case 'PACKAGE':
    default:
      return OrderType.tour;
  }
}

/// Map ApiOrderDto to list item
OrderItem orderItemFromApi(ApiOrderDto dto) {
  final type = dto.items.isNotEmpty
      ? orderTypeFromItemType(dto.items.first.itemType)
      : OrderType.tour;
  final title = dto.items.isNotEmpty && (dto.items.first.title ?? '').isNotEmpty
      ? dto.items.first.title!
      : 'Order #${dto.id.substring(dto.id.length > 8 ? dto.id.length - 8 : 0)}';
  return OrderItem(
    id: dto.id,
    type: type,
    title: title,
    subtitle: dto.items.length > 1 ? '${dto.items.length} items' : null,
    status: orderStatusFromApi(dto.status),
    amount: dto.totalAmount,
    createTime: dto.createdAt,
  );
}

/// Map ApiOrderDto to detail (travelers not from API, empty)
OrderDetail orderDetailFromApi(ApiOrderDto dto) {
  final type = dto.items.isNotEmpty
      ? orderTypeFromItemType(dto.items.first.itemType)
      : OrderType.tour;
  final title = dto.items.isNotEmpty && (dto.items.first.title ?? '').isNotEmpty
      ? dto.items.first.title!
      : 'Order #${dto.id}';
  final paid = (dto.paymentStatus.toUpperCase()) == 'PAID';
  return OrderDetail(
    id: dto.id,
    type: type,
    title: title,
    subtitle: dto.items.length > 1 ? '${dto.items.length} items' : null,
    status: orderStatusFromApi(dto.status),
    amount: dto.totalAmount,
    createTime: dto.createdAt,
    travelers: const [], // backend does not return travelers in order
    paymentStatus: paid,
    payTime: null, // backend order model may not expose pay time in list/detail
    orderNo: dto.id,
  );
}
