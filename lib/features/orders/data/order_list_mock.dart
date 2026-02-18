import '../domain/order_item.dart';

List<OrderItem> getOrderList(OrderStatus? filter) {
  final list = _mockOrders;
  if (filter == null) return list;
  return list.where((o) => o.status == filter).toList();
}

final List<OrderItem> _mockOrders = [
  OrderItem(
    id: 'o1',
    type: OrderType.tour,
    title: '丽江+泸沽湖5天4晚2-8人小包团',
    subtitle: '丽江奇妙之旅',
    status: OrderStatus.pendingPayment,
    amount: 3760,
    createTime: DateTime(2025, 2, 16, 14, 30),
    travelDate: DateTime(2025, 3, 15),
  ),
  OrderItem(
    id: 'o2',
    type: OrderType.hotel,
    title: '丽江古城悦榕庄',
    subtitle: '花园别墅',
    status: OrderStatus.pendingTrip,
    amount: 2680,
    createTime: DateTime(2025, 2, 10, 9, 0),
    checkInDate: DateTime(2025, 3, 20),
    checkOutDate: DateTime(2025, 3, 22),
  ),
  OrderItem(
    id: 'o3',
    type: OrderType.tour,
    title: '三亚亚龙湾5日自由行',
    status: OrderStatus.completed,
    amount: 2580,
    createTime: DateTime(2025, 1, 5, 11, 20),
    travelDate: DateTime(2025, 1, 20),
  ),
  OrderItem(
    id: 'o4',
    type: OrderType.hotel,
    title: '泸沽湖里格半岛酒店',
    subtitle: '湖景大床房',
    status: OrderStatus.completed,
    amount: 680,
    createTime: DateTime(2025, 1, 8, 16, 0),
    checkInDate: DateTime(2025, 1, 18),
    checkOutDate: DateTime(2025, 1, 20),
  ),
  OrderItem(
    id: 'o5',
    type: OrderType.tour,
    title: '西双版纳4天3晚跟团游',
    status: OrderStatus.refund,
    amount: 1280,
    createTime: DateTime(2025, 1, 25, 10, 0),
    travelDate: DateTime(2025, 2, 10),
  ),
  OrderItem(
    id: 'o6',
    type: OrderType.hotel,
    title: '杭州西湖国宾馆',
    subtitle: '双床景观房',
    status: OrderStatus.pendingPayment,
    amount: 1880,
    createTime: DateTime(2025, 2, 17, 8, 15),
    checkInDate: DateTime(2025, 3, 1),
    checkOutDate: DateTime(2025, 3, 3),
  ),
];
