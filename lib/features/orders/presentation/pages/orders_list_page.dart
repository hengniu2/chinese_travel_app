import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/order_list_mock.dart';
import '../../domain/order_item.dart';
import '../widgets/order_card.dart';

/// 订单列表页（全部 / 待付款 / 待出行 / 已完成 / 退款）
class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> with SingleTickerProviderStateMixin {
  static const _tabFilters = [
    null,
    OrderStatus.pendingPayment,
    OrderStatus.pendingTrip,
    OrderStatus.completed,
    OrderStatus.refund,
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabFilters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static List<String> _tabLabels(AppLocalizations? l10n) {
    return [
      l10n?.ordersTabAll ?? '全部',
      l10n?.ordersTabUnpaid ?? '待付款',
      l10n?.ordersTabUpcoming ?? '待出行',
      l10n?.ordersTabDone ?? '已完成',
      l10n?.ordersTabRefund ?? '退款',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = _tabLabels(l10n);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.ordersTitle ?? '我的订单'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500, fontSize: 14.sp),
          unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 14.sp),
          tabs: labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabFilters.length, (i) {
          return _OrderListBody(filter: _tabFilters[i]);
        }),
      ),
    );
  }
}

class _OrderListBody extends StatelessWidget {
  const _OrderListBody({this.filter});

  final OrderStatus? filter;

  @override
  Widget build(BuildContext context) {
    final orders = getOrderList(filter);
    if (orders.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64.sp, color: AppColors.textTertiary),
            SizedBox(height: 16.h),
            Text(
              l10n?.orderNoOrders ?? '暂无订单',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () => context.pushNamed('orderDetail', pathParameters: {'id': order.id}),
          onPrimaryAction: () {
            if (order.status == OrderStatus.pendingPayment) {
              final uri = Uri(
                path: '/payment',
                queryParameters: {
                  'orderId': order.id,
                  'amount': order.amount.toStringAsFixed(0),
                  'title': order.title,
                },
              );
              context.push(uri.toString());
            }
          },
        );
      },
    );
  }
}
