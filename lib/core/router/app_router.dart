import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/user_agreement_page.dart';
import '../../features/auth/presentation/pages/verify_code_login_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/chat/presentation/pages/chat_conversation_page.dart';
import '../../features/chat/presentation/pages/chat_shell_page.dart';
import '../../features/companions/presentation/pages/companion_detail_page.dart';
import '../../features/companions/presentation/pages/companion_order_page.dart';
import '../../features/companions/presentation/pages/companions_shell_page.dart';
import '../../features/content/presentation/pages/content_shell_page.dart';
import '../../features/content/presentation/pages/forum_article_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/hotels/presentation/pages/hotel_detail_page.dart';
import '../../features/hotels/presentation/pages/hotel_order_page.dart';
import '../../features/hotels/presentation/pages/hotels_shell_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/orders_shell_page.dart';
import '../../features/orders/presentation/pages/payment_page.dart';
import '../../features/profile/presentation/pages/profile_shell_page.dart';
import '../../features/profile/presentation/pages/real_name_verify_page.dart';
import '../../features/tours/presentation/pages/tour_detail_page.dart';
import '../../features/tours/presentation/pages/tour_order_page.dart';
import '../../features/tours/presentation/pages/tours_list_page.dart';
import 'app_shell.dart';

/// 路由名称常量
class RouteNames {
  RouteNames._();
  static const String home = 'home';
  static const String joinUs = 'joinUs';
  static const String planner = 'planner';
  static const String messages = 'messages';
  static const String profile = 'profile';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(Ref ref) {
  final refreshListenable = ref.watch(authRefreshListenableProvider);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    refreshListenable: refreshListenable,
    initialLocation: '/${RouteNames.home}',
    redirect: (context, state) {
      final path = state.uri.path;
      if (path == '/auth' || path == '/auth/') return '/auth/login';
      final auth = ref.read(authProvider);
      if (auth.status == AuthStatus.expired) return '/auth/login';
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteNames.home}',
                name: RouteNames.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeShellPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteNames.joinUs}',
                name: RouteNames.joinUs,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CompanionsShellPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteNames.planner}',
                name: RouteNames.planner,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ContentShellPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteNames.messages}',
                name: RouteNames.messages,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ChatShellPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'chat/:id',
                    name: 'chatConversation',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return NoTransitionPage(
                        child: ChatConversationPage(chatId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteNames.profile}',
                name: RouteNames.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileShellPage(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/auth/verify-code',
        name: 'verifyCode',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: VerifyCodeLoginPage(),
        ),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgotPassword',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: '/auth/agreement',
        name: 'agreement',
        pageBuilder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'user';
          return NoTransitionPage(
            child: UserAgreementPage(type: type),
          );
        },
      ),
      GoRoute(
        path: '/companions/:id',
        name: 'companionDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return NoTransitionPage(
            child: CompanionDetailPage(id: id),
          );
        },
        routes: [
          GoRoute(
            path: 'order',
            name: 'companionOrder',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '1';
              final packageIndex = state.uri.queryParameters['packageIndex'];
              final index = packageIndex != null ? int.tryParse(packageIndex) : null;
              return NoTransitionPage(
                child: CompanionOrderPage(companionId: id, packageIndex: index),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/tours',
        name: 'tours',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ToursListPage(),
        ),
      ),
      GoRoute(
        path: '/tours/:id',
        name: 'tourDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return NoTransitionPage(
            child: TourDetailPage(id: id),
          );
        },
      ),
      GoRoute(
        path: '/tours/:id/order',
        name: 'tourOrder',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return NoTransitionPage(
            child: TourOrderPage(tourId: id),
          );
        },
      ),
      GoRoute(
        path: '/verify-name',
        name: 'realNameVerify',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RealNameVerifyPage(),
        ),
      ),
      GoRoute(
        path: '/article/:id',
        name: 'forumArticle',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return NoTransitionPage(
            child: ForumArticlePage(id: id),
          );
        },
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        pageBuilder: (context, state) {
          final q = state.uri.queryParameters;
          final simulateFail = q['simulateFail'] == '1' || q['simulateFail'] == 'true';
          return NoTransitionPage(
            child: PaymentPage(
              orderId: q['orderId'] ?? '',
              amount: q['amount'] ?? '0',
              title: q['title'],
              simulateFail: simulateFail,
            ),
          );
        },
      ),
      GoRoute(
        path: '/hotels',
        name: 'hotels',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HotelsShellPage(),
        ),
      ),
      GoRoute(
        path: '/hotels/:id',
        name: 'hotelDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return NoTransitionPage(
            child: HotelDetailPage(id: id),
          );
        },
      ),
      GoRoute(
        path: '/hotels/:id/order',
        name: 'hotelOrder',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          final roomIndex = state.uri.queryParameters['roomIndex'];
          final index = roomIndex != null ? int.tryParse(roomIndex) : null;
          return NoTransitionPage(
            child: HotelOrderPage(hotelId: id, roomIndex: index),
          );
        },
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OrdersShellPage(),
        ),
      ),
      GoRoute(
        path: '/orders/:id',
        name: 'orderDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return NoTransitionPage(
            child: OrderDetailPage(id: id),
          );
        },
      ),
    ],
  );
}
