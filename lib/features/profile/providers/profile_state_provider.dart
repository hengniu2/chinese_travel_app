import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chinese_travel_app/features/auth/providers/auth_provider.dart';
import 'package:chinese_travel_app/features/profile/data/profile_ui_state.dart';

/// Mock 个人中心数据（订单/收藏/优惠券/钱包/积分/会员/各状态订单数）
final profileStateProvider = FutureProvider<ProfileUiState>((ref) async {
  final auth = ref.watch(authProvider);
  await Future<void>.delayed(const Duration(milliseconds: 400));
  return ProfileUiState(
    ordersCount: 6,
    favoritesCount: 12,
    couponsCount: 3,
    couponExpiringCount: 1,
    walletBalance: auth.isAuthenticated ? 288.50 : 0,
    travelPoints: auth.isAuthenticated ? 1280 : 0,
    membershipLevel: auth.isAuthenticated ? ProfileMembershipLevel.member : ProfileMembershipLevel.tourist,
    pendingPaymentCount: 2,
    upcomingCount: 2,
    completedCount: 1,
    refundCount: 1,
    messageUnreadCount: auth.isAuthenticated ? 3 : 0,
    isVerified: auth.isAuthenticated,
  );
});
