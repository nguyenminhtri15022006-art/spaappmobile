import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../../features/booking/presentation/screens/booking_detail_screen.dart';
import '../../features/booking/presentation/screens/booking_form_screen.dart';
import '../../features/booking/presentation/screens/booking_success_screen.dart';
import '../../features/booking/presentation/screens/my_bookings_screen.dart';
import '../../features/chat/presentation/screens/ai_chat_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/map/presentation/screens/map_placeholder_screen.dart';
import '../../features/nearby/presentation/screens/nearby_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/spa_detail/presentation/screens/branch_selection_screen.dart';
import '../../features/spa_detail/presentation/screens/service_detail_screen.dart';
import '../../features/spa_detail/presentation/screens/spa_detail_screen.dart';
import '../../shared/widgets/main_scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // 5-Tab StatefulShellRoute with indexedStack to preserve each tab state
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Trang chủ
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 2: Gần đây
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/nearby',
              builder: (context, state) => const NearbyScreen(),
            ),
          ],
        ),

        // Tab 3: Lịch hẹn
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my-bookings',
              builder: (context, state) => const MyBookingsScreen(),
            ),
          ],
        ),

        // Tab 4: AI tư vấn
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ai-chat',
              builder: (context, state) => const AiChatScreen(),
            ),
          ],
        ),

        // Tab 5: Cá nhân
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Fullscreen Subroutes that push on top of the Bottom Bar (using rootNavigatorKey)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/search',
      builder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'];
        return SearchScreen(initialCategoryId: categoryId);
      },
    ),

    // Spa Detail & Subroutes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/spa/:spaId',
      builder: (context, state) {
        final spaId = state.pathParameters['spaId'] ?? '';
        final serviceId = state.uri.queryParameters['serviceId'];
        return SpaDetailScreen(
          spaId: spaId,
          initialSelectedServiceId: serviceId,
        );
      },
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'service/:serviceId',
          builder: (context, state) {
            final spaId = state.pathParameters['spaId'] ?? '';
            final serviceId = state.pathParameters['serviceId'] ?? '';
            return ServiceDetailScreen(spaId: spaId, serviceId: serviceId);
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'branch-select',
          builder: (context, state) {
            final spaId = state.pathParameters['spaId'] ?? '';
            final serviceId = state.uri.queryParameters['serviceId'] ?? '';
            return BranchSelectionScreen(
              spaId: spaId,
              serviceId: serviceId,
            );
          },
        ),
      ],
    ),

    // Booking Flow
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/booking',
      builder: (context, state) {
        final spaId = state.uri.queryParameters['spaId'] ?? '';
        final serviceId = state.uri.queryParameters['serviceId'] ?? '';
        final branchId = state.uri.queryParameters['branchId'] ?? '';
        return BookingFormScreen(
          spaId: spaId,
          serviceId: serviceId,
          branchId: branchId,
        );
      },
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'confirm',
          builder: (context, state) {
            final spaId = state.uri.queryParameters['spaId'] ?? '';
            final serviceId = state.uri.queryParameters['serviceId'] ?? '';
            final branchId = state.uri.queryParameters['branchId'] ?? '';
            return BookingConfirmationScreen(
              spaId: spaId,
              serviceId: serviceId,
              branchId: branchId,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'success',
          builder: (context, state) {
            final bookingId = state.uri.queryParameters['bookingId'];
            return BookingSuccessScreen(bookingId: bookingId);
          },
        ),
      ],
    ),

    // Booking Detail
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/my-bookings/:bookingId',
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId'] ?? '';
        return BookingDetailScreen(bookingId: bookingId);
      },
    ),

    // Favorites
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),

    // Notifications
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Map Placeholder
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/map',
      builder: (context, state) => const MapPlaceholderScreen(),
    ),

    // Auth Screens
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/login',
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return LoginScreen(redirect: redirect);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/register',
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return RegisterScreen(redirect: redirect);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);
