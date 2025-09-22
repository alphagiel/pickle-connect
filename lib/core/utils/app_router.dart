import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/proposals/presentation/pages/proposals_page.dart';
import '../../features/proposals/presentation/pages/create_proposal_page.dart';
import '../../features/standings/presentation/pages/standings_page.dart';
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
      
      // Create proposal route (standalone, no shell)
      GoRoute(
        path: '/create-proposal',
        name: 'create-proposal',
        builder: (context, state) => const CreateProposalPage(),
      ),
      
      // Main app routes with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const ProposalsPage(),
          ),
          GoRoute(
            path: '/proposals',
            name: 'proposals',
            builder: (context, state) => const ProposalsPage(),
          ),
          GoRoute(
            path: '/standings',
            name: 'standings',
            builder: (context, state) => const StandingsPage(),
          ),
        ],
      ),
    ],
  );
});