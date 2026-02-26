import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/user_agreement_page.dart';
import '../../features/auth/presentation/pages/verify_code_login_page.dart';
import '../../features/auth/presentation/pages/verify_phone_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/chat/presentation/pages/chat_conversation_page.dart';
import '../../features/chat/presentation/pages/chat_shell_page.dart';
import '../../features/companions/models/companion_order.dart';
import '../../features/companions/views/booking_page.dart';
import '../../features/companions/views/companion_detail_page.dart';
import '../../features/companions/views/companion_list_page.dart';
import '../../features/companions/views/order_confirmation_page.dart';
import '../../features/content/presentation/pages/content_shell_page.dart';
import '../../features/content/presentation/pages/forum_article_page.dart';
import '../../features/travel/booking/booking_addons_page.dart';
import '../../features/travel/booking/booking_confirmation_page.dart';
import '../../features/travel/booking/booking_payment_page.dart';
import '../../features/travel/booking/booking_review_page.dart';
import '../../features/travel/booking/booking_select_date_page.dart';
import '../../features/travel/booking/booking_travelers_page.dart';
import '../../features/travel/detail/travel_detail_page.dart';
import '../../features/travel/discovery/travel_discovery_page.dart';
import '../../features/travel/landing/travel_landing_page.dart';
import '../../features/travel/planner/ai_itinerary_result_page.dart';
import '../../features/travel/planner/planner_result_page.dart';
import '../../features/travel/planner/travel_planner_page.dart';
import '../../features/home/presentation/pages/activity_detail_page.dart';
import '../../features/home/presentation/pages/blog_detail_page.dart';
import '../../features/home/presentation/pages/card_gift_page.dart';
import '../../features/home/presentation/pages/custom_travel_page.dart';
import '../../features/home/presentation/pages/family_travel_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/home/presentation/pages/small_group_page.dart';
import '../../features/home/presentation/pages/social_travel_page.dart';
import '../../features/home/presentation/pages/notes_page.dart';
import '../../features/home/presentation/pages/surrounding_activities_page.dart';
import '../../features/home/presentation/pages/seed_list_page.dart';
import '../../features/home/presentation/pages/child_activity_list_page.dart';
import '../../features/home/presentation/pages/nearby_activity_list_page.dart';
import '../../features/hotel/pages/hotel_detail_page.dart';
import '../../features/hotel/pages/hotel_shell_page.dart';
import '../../features/hotels/presentation/pages/hotel_booking_confirm_page.dart';
import '../../features/hotels/presentation/pages/hotel_booking_guest_page.dart';
import '../../features/hotels/presentation/pages/hotel_booking_payment_page.dart';
import '../../features/hotels/presentation/pages/hotel_booking_success_page.dart';
import '../../features/hotels/presentation/pages/hotel_compare_page.dart';
import '../../features/hotels/presentation/pages/hotel_map_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/order_create_page.dart';
import '../../features/orders/presentation/pages/orders_shell_page.dart';
import '../../features/orders/presentation/pages/payment_page.dart';
import '../../features/profile/presentation/pages/profile_shell_page.dart';
import '../../features/profile/presentation/pages/real_name_verify_page.dart';
import '../../features/profile/presentation/pages/sub/profile_addresses_page.dart';
import '../../features/profile/presentation/pages/sub/profile_clear_cache_page.dart';
import '../../features/profile/presentation/pages/sub/profile_coupons_page.dart';
import '../../features/profile/presentation/pages/sub/profile_course_orders_page.dart';
import '../../features/profile/presentation/pages/sub/profile_data_stats_page.dart';
import '../../features/profile/presentation/pages/sub/profile_feedback_page.dart';
import '../../features/profile/presentation/pages/sub/profile_flight_orders_page.dart';
import '../../features/profile/presentation/pages/sub/profile_flights_page.dart';
import '../../features/profile/presentation/pages/sub/profile_frequent_travelers_page.dart';
import '../../features/profile/presentation/pages/sub/profile_hotel_orders_page.dart';
import '../../features/profile/presentation/pages/sub/profile_hotels_page.dart';
import '../../features/profile/presentation/pages/sub/profile_invoice_page.dart';
import '../../features/profile/presentation/pages/sub/profile_invite_friends_page.dart';
import '../../features/profile/presentation/pages/sub/membership_center_page.dart';
import '../../features/profile/presentation/pages/sub/profile_my_friends_page.dart';
import '../../features/profile/presentation/pages/sub/profile_prizes_page.dart';
import '../../features/profile/presentation/pages/sub/profile_referrer_page.dart';
import '../../features/profile/presentation/pages/sub/profile_travel_collection_page.dart';
import '../../features/tours/presentation/pages/tour_detail_page.dart';
import '../../features/tours/presentation/pages/tour_order_page.dart';
import '../../features/tours/presentation/pages/tours_list_page.dart';
import '../../features/travel_service/presentation/pages/flight_result_page.dart';
import '../../features/travel_service/presentation/pages/multi_trip_result_page.dart';
import '../../features/travel_service/presentation/pages/round_trip_result_page.dart';
import '../../features/travel_service/presentation/pages/travel_service_page.dart';
import '../../features/travel_service/theme/luxury_travel_theme.dart';
import '../../shared/widgets/app_error_page.dart';
import '../../shared/widgets/app_network_error_page.dart';
import 'app_shell.dart';
import 'page_transitions.dart';

/// 路由名称常量
class RouteNames {
  RouteNames._();
  static const String home = 'home';
  static const String joinUs = 'joinUs';
  static const String planner = 'planner';
  static const String travelService = 'travel-service';
  static const String flightResult = 'flightResult';
  static const String roundTripResult = 'roundTripResult';
  static const String multiTripResult = 'multiTripResult';
  static const String messages = 'messages';
  static const String orders = 'orders';
  static const String profile = 'profile';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Unique keys per shell branch to avoid HeroControllerScope key reservation conflicts.
final GlobalKey<NavigatorState> _shellHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final GlobalKey<NavigatorState> _shellTravelServiceKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTravelService');
final GlobalKey<NavigatorState> _shellJoinUsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellJoinUs',
);
final GlobalKey<NavigatorState> _shellPlannerKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellPlanner',
);
final GlobalKey<NavigatorState> _shellMessagesKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellMessages',
);
final GlobalKey<NavigatorState> _shellProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

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
        // Branch index must match AppShell tab order: 0 Home, 1 Travel Planner, 2 Travel Service, 3 Companion, 4 Chat, 5 Profile
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellHomeKey,
            routes: [
              GoRoute(
                path: '/${RouteNames.home}',
                name: RouteNames.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeShellPage()),
                routes: [
                  GoRoute(
                    path: 'seed-list',
                    name: 'seedList',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const SeedListPage()),
                  ),
                  GoRoute(
                    path: 'child-activity-list',
                    name: 'childActivityList',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ChildActivityListPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'nearby-activity-list',
                    name: 'nearbyActivityList',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const NearbyActivityListPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellPlannerKey,
            routes: [
              GoRoute(
                path: '/${RouteNames.planner}',
                name: RouteNames.planner,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TravelLandingPage()),
                routes: [
                  GoRoute(
                    path: 'discovery',
                    name: 'travelDiscovery',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const TravelDiscoveryPage()),
                  ),
                  GoRoute(
                    path: 'detail/:id',
                    name: 'travelDetail',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id'] ?? '1';
                      return slideTransitionPage(
                        child: TravelDetailPage(packageId: id),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'booking',
                        name: 'travelBooking',
                        pageBuilder: (context, state) {
                          final id = state.pathParameters['id'] ?? '1';
                          return slideTransitionPage(
                            child: BookingSelectDatePage(packageId: id),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'date',
                            pageBuilder: (context, state) {
                              final id = state.pathParameters['id'] ?? '1';
                              return slideTransitionPage(
                                child: BookingSelectDatePage(packageId: id),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'travelers',
                            pageBuilder: (context, state) {
                              final id = state.pathParameters['id'] ?? '1';
                              return slideTransitionPage(
                                child: BookingTravelersPage(packageId: id),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'addons',
                            pageBuilder: (context, state) {
                              final id = state.pathParameters['id'] ?? '1';
                              return slideTransitionPage(
                                child: BookingAddOnsPage(packageId: id),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'review',
                            pageBuilder: (context, state) {
                              final id = state.pathParameters['id'] ?? '1';
                              return slideTransitionPage(
                                child: BookingReviewPage(packageId: id),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'payment',
                            pageBuilder: (context, state) {
                              final id = state.pathParameters['id'] ?? '1';
                              return slideTransitionPage(
                                child: BookingPaymentPage(packageId: id),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'confirmation',
                            pageBuilder: (context, state) {
                              final id = state.pathParameters['id'] ?? '1';
                              return slideTransitionPage(
                                child: BookingConfirmationPage(packageId: id),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'planner',
                    name: 'travelPlanner',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const TravelPlannerPage()),
                    routes: [
                      GoRoute(
                        path: 'result',
                        name: 'plannerResult',
                        pageBuilder: (_, __) => slideTransitionPage(
                          child: const PlannerResultPage(),
                        ),
                      ),
                      GoRoute(
                        path: 'ai-result',
                        name: 'plannerAiResult',
                        pageBuilder: (_, __) => slideTransitionPage(
                          child: const AiItineraryResultPage(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellTravelServiceKey,
            routes: [
              GoRoute(
                path: '/${RouteNames.travelService}',
                name: RouteNames.travelService,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: Theme(
                    data: LuxuryTravelTheme.theme,
                    child: const TravelServicePage(),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'flight-result',
                    name: RouteNames.flightResult,
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: Theme(
                        data: LuxuryTravelTheme.theme,
                        child: const FlightResultPage(),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'round-trip-result',
                    name: RouteNames.roundTripResult,
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: Theme(
                        data: LuxuryTravelTheme.theme,
                        child: const RoundTripResultPage(),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'multi-trip-result',
                    name: RouteNames.multiTripResult,
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: Theme(
                        data: LuxuryTravelTheme.theme,
                        child: const MultiTripResultPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellJoinUsKey,
            routes: [
              GoRoute(
                path: '/${RouteNames.joinUs}',
                name: RouteNames.joinUs,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CompanionListPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellMessagesKey,
            routes: [
              GoRoute(
                path: '/${RouteNames.messages}',
                name: RouteNames.messages,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ChatShellPage()),
                routes: [
                  GoRoute(
                    path: 'chat/:id',
                    name: 'chatConversation',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return slideTransitionPage(
                        child: ChatConversationPage(chatId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellProfileKey,
            routes: [
              GoRoute(
                path: '/${RouteNames.profile}',
                name: RouteNames.profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfileShellPage()),
                routes: [
                  GoRoute(
                    path: 'my-friends',
                    name: 'profileMyFriends',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileMyFriendsPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'coupons',
                    name: 'profileCoupons',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfileCouponsPage()),
                  ),
                  GoRoute(
                    path: 'membership',
                    name: 'profileMembership',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const MembershipCenterPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'hotels',
                    name: 'profileHotels',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfileHotelsPage()),
                  ),
                  GoRoute(
                    path: 'flights',
                    name: 'profileFlights',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfileFlightsPage()),
                  ),
                  GoRoute(
                    path: 'invoice',
                    name: 'profileInvoice',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfileInvoicePage()),
                  ),
                  GoRoute(
                    path: 'invite-friends',
                    name: 'profileInviteFriends',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileInviteFriendsPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'course-orders',
                    name: 'profileCourseOrders',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileCourseOrdersPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'flight-orders',
                    name: 'profileFlightOrders',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileFlightOrdersPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'hotel-orders',
                    name: 'profileHotelOrders',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileHotelOrdersPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'prizes',
                    name: 'profilePrizes',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfilePrizesPage()),
                  ),
                  GoRoute(
                    path: 'referrer',
                    name: 'profileReferrer',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfileReferrerPage()),
                  ),
                  GoRoute(
                    path: 'feedback',
                    name: 'profileFeedback',
                    pageBuilder: (_, __) =>
                        slideTransitionPage(child: const ProfileFeedbackPage()),
                  ),
                  GoRoute(
                    path: 'travel-collection',
                    name: 'profileTravelCollection',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileTravelCollectionPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'data-stats',
                    name: 'profileDataStats',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileDataStatsPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'clear-cache',
                    name: 'profileClearCache',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileClearCachePage(),
                    ),
                  ),
                  GoRoute(
                    path: 'frequent-travelers',
                    name: 'profileFrequentTravelers',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileFrequentTravelersPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'addresses',
                    name: 'profileAddresses',
                    pageBuilder: (_, __) => slideTransitionPage(
                      child: const ProfileAddressesPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/${RouteNames.orders}',
        name: RouteNames.orders,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: OrdersShellPage()),
      ),
      GoRoute(
        path: '/orders/create',
        name: 'orderCreate',
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is Map) {
            return slideTransitionPage(
              child: OrderCreatePage(
                packageId: extra['packageId']?.toString(),
                packageTitle: extra['packageTitle']?.toString(),
                unitPrice: (extra['unitPrice'] as num?)?.toInt(),
              ),
            );
          }
          return slideTransitionPage(child: const OrderCreatePage());
        },
      ),
      GoRoute(
        path: '/orders/:id',
        name: 'orderDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return slideTransitionPage(child: OrderDetailPage(id: id));
        },
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const LoginPage()),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const RegisterPage()),
      ),
      GoRoute(
        path: '/auth/verify-phone',
        name: 'verifyPhone',
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const VerifyPhonePage()),
      ),
      GoRoute(
        path: '/auth/verify-code',
        name: 'verifyCode',
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const VerifyCodeLoginPage()),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgotPassword',
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const ForgotPasswordPage()),
      ),
      GoRoute(
        path: '/auth/agreement',
        name: 'agreement',
        pageBuilder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'user';
          return slideTransitionPage(child: UserAgreementPage(type: type));
        },
      ),
      GoRoute(
        path: '/social-travel',
        name: 'socialTravel',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const SocialTravelPage()),
      ),
      GoRoute(
        path: '/family-travel',
        name: 'familyTravel',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const FamilyTravelPage()),
      ),
      GoRoute(
        path: '/custom-travel',
        name: 'customTravel',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const CustomTravelPage()),
      ),
      GoRoute(
        path: '/small-group',
        name: 'smallGroup',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const SmallGroupPage()),
      ),
      GoRoute(
        path: '/surrounding-activities',
        name: 'surroundingActivities',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const SurroundingActivitiesPage()),
      ),
      GoRoute(
        path: '/card-gift',
        name: 'cardGift',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const CardGiftPage()),
      ),
      GoRoute(
        path: '/notes',
        name: 'notes',
        pageBuilder: (_, __) => slideTransitionPage(child: const NotesPage()),
      ),
      GoRoute(
        path: '/blog/:id',
        name: 'blogDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return slideTransitionPage(child: BlogDetailPage(id: id));
        },
      ),
      GoRoute(
        path: '/activity/:id',
        name: 'activityDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return slideTransitionPage(child: ActivityDetailPage(id: id));
        },
      ),
      GoRoute(
        path: '/companions/:id',
        name: 'companionDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return companionDetailTransitionPage(
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
              final index = packageIndex != null
                  ? int.tryParse(packageIndex)
                  : null;
              return slideTransitionPage(
                child: CompanionBookingPage(
                  companionId: id,
                  packageIndex: index,
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'confirm',
                name: 'companionOrderConfirm',
                pageBuilder: (context, state) {
                  final payload = state.extra as CompanionOrderConfirmPayload?;
                  if (payload == null) {
                    return slideTransitionPage(
                      child: CompanionBookingPage(
                        companionId: state.pathParameters['id'] ?? '1',
                      ),
                    );
                  }
                  return slideTransitionPage(
                    child: CompanionOrderConfirmPage(payload: payload),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/tours',
        name: 'tours',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ToursListPage()),
      ),
      GoRoute(
        path: '/tours/:id',
        name: 'tourDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slideTransitionPage(child: TourDetailPage(id: id));
        },
      ),
      GoRoute(
        path: '/tours/:id/order',
        name: 'tourOrder',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slideTransitionPage(child: TourOrderPage(tourId: id));
        },
      ),
      GoRoute(
        path: '/verify-name',
        name: 'realNameVerify',
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const RealNameVerifyPage()),
      ),
      GoRoute(
        path: '/article/:id',
        name: 'forumArticle',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return slideTransitionPage(child: ForumArticlePage(id: id));
        },
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        pageBuilder: (context, state) {
          final q = state.uri.queryParameters;
          final simulateFail =
              q['simulateFail'] == '1' || q['simulateFail'] == 'true';
          return slideTransitionPage(
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
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HotelShellPage()),
      ),
      GoRoute(
        path: '/hotels/compare',
        name: 'hotelCompare',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const HotelComparePage()),
      ),
      GoRoute(
        path: '/hotels/map',
        name: 'hotelMap',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const HotelMapPage()),
      ),
      GoRoute(
        path: '/hotels/:id',
        name: 'hotelDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slideTransitionPage(child: HotelDetailPage(id: id));
        },
      ),
      GoRoute(
        path: '/hotels/:id/order',
        name: 'hotelOrder',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          final roomIndex = state.uri.queryParameters['roomIndex'];
          final index = roomIndex != null ? int.tryParse(roomIndex) : null;
          return slideTransitionPage(
            child: HotelBookingConfirmPage(hotelId: id, roomIndex: index),
          );
        },
      ),
      GoRoute(
        path: '/hotels/booking/guest',
        name: 'hotelBookingGuest',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const HotelBookingGuestPage()),
      ),
      GoRoute(
        path: '/hotels/booking/payment',
        name: 'hotelBookingPayment',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const HotelBookingPaymentPage()),
      ),
      GoRoute(
        path: '/hotels/booking/success',
        name: 'hotelBookingSuccess',
        pageBuilder: (_, __) =>
            slideTransitionPage(child: const HotelBookingSuccessPage()),
      ),
      GoRoute(
        path: '/error',
        name: 'error',
        pageBuilder: (context, state) {
          final msg = state.uri.queryParameters['message'];
          return fadeTransitionPage(
            child: AppErrorPage(
              message: msg,
              onRetry: () => context.go('/${RouteNames.home}'),
            ),
          );
        },
      ),
      GoRoute(
        path: '/network-error',
        name: 'networkError',
        pageBuilder: (context, state) {
          final msg = state.uri.queryParameters['message'];
          return fadeTransitionPage(
            child: AppNetworkErrorPage(
              message: msg,
              onRetry: () => context.pop(),
            ),
          );
        },
      ),
    ],
  );
}
