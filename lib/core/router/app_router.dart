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
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/map/presentation/screens/map_placeholder_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/spa_detail/presentation/screens/branch_selection_screen.dart';
import '../../features/spa_detail/presentation/screens/service_detail_screen.dart';
import '../../features/spa_detail/presentation/screens/spa_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // 1. Search Screen (hỗ trợ categoryId từ HomeScreen)
        GoRoute(
          path: 'search',
          builder: (context, state) {
            final categoryId = state.uri.queryParameters['categoryId'];
            return SearchScreen(initialCategoryId: categoryId);
          },
        ),

        // 2. Spa Detail & Service Detail & Branch Selection
        GoRoute(
          path: 'spa/:spaId',
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
              path: 'service/:serviceId',
              builder: (context, state) {
                final spaId = state.pathParameters['spaId'] ?? '';
                final serviceId = state.pathParameters['serviceId'] ?? '';
                return ServiceDetailScreen(spaId: spaId, serviceId: serviceId);
              },
            ),
            GoRoute(
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

        // 3. Booking Flow
        GoRoute(
          path: 'booking',
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
              path: 'success',
              builder: (context, state) {
                final bookingId = state.uri.queryParameters['bookingId'];
                return BookingSuccessScreen(bookingId: bookingId);
              },
            ),
          ],
        ),

        // 4. My Bookings & Booking Detail
        GoRoute(
          path: 'my-bookings',
          builder: (context, state) => const MyBookingsScreen(),
          routes: [
            GoRoute(
              path: ':bookingId',
              builder: (context, state) {
                final bookingId = state.pathParameters['bookingId'] ?? '';
                return BookingDetailScreen(bookingId: bookingId);
              },
            ),
          ],
        ),

        // 5. Favorites
        GoRoute(
          path: 'favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),

        // 6. Notifications
        GoRoute(
          path: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),

        // 7. Map Placeholder
        GoRoute(
          path: 'map',
          builder: (context, state) => const MapPlaceholderScreen(),
        ),

        // 8. Auth Screens
        GoRoute(
          path: 'login',
          builder: (context, state) {
            final redirect = state.uri.queryParameters['redirect'];
            return LoginScreen(redirect: redirect);
          },
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) {
            final redirect = state.uri.queryParameters['redirect'];
            return RegisterScreen(redirect: redirect);
          },
        ),
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
