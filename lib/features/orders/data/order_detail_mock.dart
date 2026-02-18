import '../domain/order_detail.dart';
import '../domain/order_item.dart';

OrderDetail getOrderDetail(String id) {
  return _mockDetails[id] ?? _mockDetails['o1']!;
}

final Map<String, OrderDetail> _mockDetails = {
  'o1': OrderDetail(
    id: 'o1',
    type: OrderType.tour,
    title: '丽江+泸沽湖5天4晚2-8人小包团',
    subtitle: '丽江奇妙之旅',
    status: OrderStatus.pendingPayment,
    amount: 3760,
    createTime: DateTime(2025, 2, 16, 14, 30),
    travelers: [
      const OrderTraveler(name: '张三', idCard: '330102199001011234', phone: '13800138000'),
      const OrderTraveler(name: '李四', idCard: '330102199205052345', phone: '13800138001'),
    ],
    paymentStatus: false,
    travelDate: DateTime(2025, 3, 15),
    orderNo: 'TO202502161430001',
  ),
  'o2': OrderDetail(
    id: 'o2',
    type: OrderType.hotel,
    title: '丽江古城悦榕庄',
    subtitle: '花园别墅',
    status: OrderStatus.pendingTrip,
    amount: 2680,
    createTime: DateTime(2025, 2, 10, 9, 0),
    travelers: [
      const OrderTraveler(name: '王五', idCard: '310101198803033456', phone: '13900139000'),
    ],
    paymentStatus: true,
    payTime: DateTime(2025, 2, 10, 9, 15),
    checkInDate: DateTime(2025, 3, 20),
    checkOutDate: DateTime(2025, 3, 22),
    orderNo: 'HO202502100900001',
  ),
  'o3': OrderDetail(
    id: 'o3',
    type: OrderType.tour,
    title: '三亚亚龙湾5日自由行',
    status: OrderStatus.completed,
    amount: 2580,
    createTime: DateTime(2025, 1, 5, 11, 20),
    travelers: [
      const OrderTraveler(name: '赵六', idCard: '440103199112124567', phone: '13700137000'),
    ],
    paymentStatus: true,
    payTime: DateTime(2025, 1, 5, 11, 35),
    travelDate: DateTime(2025, 1, 20),
    orderNo: 'TO202501051120001',
  ),
  'o4': OrderDetail(
    id: 'o4',
    type: OrderType.hotel,
    title: '泸沽湖里格半岛酒店',
    subtitle: '湖景大床房',
    status: OrderStatus.completed,
    amount: 680,
    createTime: DateTime(2025, 1, 8, 16, 0),
    travelers: [
      const OrderTraveler(name: '钱七', idCard: '510104198706065678', phone: '13600136000'),
    ],
    paymentStatus: true,
    payTime: DateTime(2025, 1, 8, 16, 10),
    checkInDate: DateTime(2025, 1, 18),
    checkOutDate: DateTime(2025, 1, 20),
    orderNo: 'HO202501081600001',
  ),
  'o5': OrderDetail(
    id: 'o5',
    type: OrderType.tour,
    title: '西双版纳4天3晚跟团游',
    status: OrderStatus.refund,
    amount: 1280,
    createTime: DateTime(2025, 1, 25, 10, 0),
    travelers: [
      const OrderTraveler(name: '孙八', idCard: '330106199408086789', phone: '13500135000'),
    ],
    paymentStatus: true,
    payTime: DateTime(2025, 1, 25, 10, 20),
    travelDate: DateTime(2025, 2, 10),
    orderNo: 'TO202501251000001',
  ),
  'o6': OrderDetail(
    id: 'o6',
    type: OrderType.hotel,
    title: '杭州西湖国宾馆',
    subtitle: '双床景观房',
    status: OrderStatus.pendingPayment,
    amount: 1880,
    createTime: DateTime(2025, 2, 17, 8, 15),
    travelers: [
      const OrderTraveler(name: '周九', idCard: '330108199909097890', phone: '13400134000'),
    ],
    paymentStatus: false,
    checkInDate: DateTime(2025, 3, 1),
    checkOutDate: DateTime(2025, 3, 3),
    orderNo: 'HO202502170815001',
  ),
};
