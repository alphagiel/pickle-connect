import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/scheduling/presentation/pages/courts_page.dart';
import '../../features/players/presentation/pages/players_page.dart';
import '../../features/ladder/presentation/pages/ladder_page.dart';
import '../../features/tournaments/presentation/pages/tournaments_page.dart';
import '../../shared/widgets/main_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      
      // Main app routes with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/courts',
            name: 'courts',
            builder: (context, state) => const CourtsPage(),
          ),
          GoRoute(
            path: '/players',
            name: 'players',
            builder: (context, state) => const PlayersPage(),
          ),
          GoRoute(
            path: '/ladder',
            name: 'ladder',
            builder: (context, state) => const LadderPage(),
          ),
          GoRoute(
            path: '/tournaments',
            name: 'tournaments',
            builder: (context, state) => const TournamentsPage(),
          ),
        ],
      ),
    ],
  );
});