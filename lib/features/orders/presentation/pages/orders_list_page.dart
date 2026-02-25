import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/order_repository_provider.dart';
import '../../domain/order_item.dart';
import '../widgets/order_card.dart';

// ─── 订单列表页规范：白顶栏、标签下划线、浅底、卡片 12dp 圆角、12dp 间距 ─────
const double _kTabIndicatorHeight = 3;
const double _kCardMarginBottom = 12;
const double _kTabsToContentGap = 16;
const double _kPagePaddingH = 16;

/// 我的订单 · 白顶栏、Tab 下划线、浅背景、现代卡片列表（API 数据）
class OrdersListPage extends ConsumerStatefulWidget {
  const OrdersListPage({super.key});

  @override
  ConsumerState<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends ConsumerState<OrdersListPage>
    with SingleTickerProviderStateMixin {
  static const _tabFilters = [
    null,
    OrderStatus.pendingPayment,
    OrderStatus.pendingTrip,
    OrderStatus.completed,
    OrderStatus.refund,
  ];

  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabFilters.length, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  static List<String> _tabLabels(AppLocalizations? l10n) {
    return [
      l10n?.ordersTabAll ?? 'All',
      l10n?.ordersTabUnpaid ?? 'Unpaid',
      l10n?.ordersTabUpcoming ?? 'Upcoming',
      l10n?.ordersTabDone ?? 'Done',
      l10n?.ordersTabRefund ?? 'Refund',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = _tabLabels(l10n);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n?.ordersTitle ?? 'My Orders',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, size: 22.sp, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _OrdersTabBar(
            controller: _tabController,
            labels: labels,
            onTap: (i) {
              _tabController.animateTo(i);
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
              );
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) {
                if (_tabController.index != i) _tabController.animateTo(i);
              },
              itemCount: _tabFilters.length,
              itemBuilder: (context, index) {
                return _OrderListBody(filter: _tabFilters[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 自定义 Tab 栏：选中绿字+下划线，未选 #666
class _OrdersTabBar extends StatelessWidget {
  const _OrdersTabBar({
    required this.controller,
    required this.labels,
    required this.onTap,
  });

  final TabController controller;
  final List<String> labels;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TabBar(
              controller: controller,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0xFF666666),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: _kTabIndicatorHeight,
                ),
              ),
              labelStyle: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF666666),
                fontSize: 14.sp,
              ),
              tabs: List.generate(
                labels.length,
                (i) => Tab(text: labels[i]),
              ),
              onTap: onTap,
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

class _OrderListBody extends ConsumerWidget {
  const _OrderListBody({this.filter});

  final OrderStatus? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrders = ref.watch(ordersListProvider);

    return asyncOrders.when(
      data: (allOrders) {
        final orders = filter == null
            ? allOrders
            : allOrders.where((o) => o.status == filter).toList();
        if (orders.isEmpty) {
          return _EmptyState(filter: filter);
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(ordersListProvider.future),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
              _kPagePaddingH.w,
              _kTabsToContentGap.h,
              _kPagePaddingH.w,
              24.h,
            ),
            cacheExtent: 400,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Padding(
                padding: EdgeInsets.only(bottom: _kCardMarginBottom.h),
                child: OrderCard(
                  order: order,
                  onTap: () => context.pushNamed(
                    'orderDetail',
                    pathParameters: {'id': order.id},
                  ),
                  onPrimaryAction: () {
                    if (order.status == OrderStatus.pendingPayment) {
                      context.push(
                        '/payment?orderId=${order.id}&amount=${order.amount.toStringAsFixed(0)}&title=${Uri.encodeComponent(order.title)}',
                      );
                    } else {
                      context.pushNamed(
                        'orderDetail',
                        pathParameters: {'id': order.id},
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                e.toString(),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => ref.refresh(ordersListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 空态：插画占位 + 标题 + 描述
class _EmptyState extends StatelessWidget {
  const _EmptyState({this.filter});

  final OrderStatus? filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryPale.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 56.sp,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              l10n?.orderNoOrders ?? 'No orders yet',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              l10n?.orderNoOrdersDescription ?? 'Your travel orders will appear here',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
