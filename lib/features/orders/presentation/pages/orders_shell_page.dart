import 'package:flutter/material.dart';

import 'orders_list_page.dart';

/// 订单壳页（展示订单列表）
class OrdersShellPage extends StatelessWidget {
  const OrdersShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrdersListPage();
  }
}
