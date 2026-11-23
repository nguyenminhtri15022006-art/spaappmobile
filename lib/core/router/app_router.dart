import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/spa_detail/presentation/screens/spa_detail_screen.dart';
import '../../features/spa_detail/presentation/screens/branch_selection_screen.dart';
import '../../features/spa_detail/presentation/screens/booking_draft_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
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
        GoRoute(
          path: 'booking',
          builder: (context, state) {
            final spaId = state.uri.queryParameters['spaId'] ?? '';
            final serviceId = state.uri.queryParameters['serviceId'] ?? '';
            final branchId = state.uri.queryParameters['branchId'] ?? '';
            return BookingDraftScreen(
              spaId: spaId,
              serviceId: serviceId,
              branchId: branchId,
            );
          },
        ),
      ],
    ),
  ],
);
