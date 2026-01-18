import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/proposals/presentation/pages/proposals_page.dart';
import '../../features/proposals/presentation/pages/create_proposal_page.dart';
import '../../features/proposals/presentation/pages/edit_proposal_page.dart';
import '../../features/proposals/presentation/pages/proposal_details_page.dart';
import '../../features/standings/presentation/pages/standings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../shared/widgets/main_navigation.dart';
import '../../shared/models/proposal.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final currentUser = ref.read(currentUserProvider);
      final isAuthenticated = currentUser != null;

      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/signup';

      // If user is not authenticated and trying to access protected routes
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If user is authenticated and trying to access auth routes
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      // No redirect needed
      return null;
    },
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
      
      // Edit proposal route (standalone, no shell)
      GoRoute(
        path: '/edit-proposal',
        name: 'edit-proposal',
        builder: (context, state) {
          final proposal = state.extra as Proposal?;
          if (proposal == null) {
            return const ProposalsPage();
          }
          return EditProposalPage(proposal: proposal);
        },
      ),
      
      // Proposal details route (standalone, no shell)
      GoRoute(
        path: '/proposal-details',
        name: 'proposal-details',
        builder: (context, state) {
          final proposal = state.extra as Proposal?;
          if (proposal == null) {
            return const ProposalsPage();
          }
          return ProposalDetailsPage(proposal: proposal);
        },
      ),

      // Edit profile route (standalone, no shell)
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
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