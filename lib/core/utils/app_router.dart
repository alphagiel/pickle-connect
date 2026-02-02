import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/proposals/presentation/pages/proposals_page.dart';
import '../../features/proposals/presentation/pages/create_proposal_page.dart';
import '../../features/proposals/presentation/pages/edit_proposal_page.dart';
import '../../features/proposals/presentation/pages/proposal_details_page.dart';
import '../../features/standings/presentation/pages/standings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../shared/widgets/main_navigation.dart';
import '../../shared/models/proposal.dart';
import '../../shared/providers/proposals_providers.dart';
import '../../shared/repositories/proposals_repository.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final currentUser = ref.read(currentUserProvider);
      final isAuthenticated = currentUser != null;

      final isAuthRoute = state.uri.path == '/login' ||
          state.uri.path == '/signup' ||
          state.uri.path == '/reset-password';

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
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          if (token == null || token.isEmpty) {
            return const LoginPage();
          }
          return ResetPasswordPage(token: token);
        },
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

      // Deep link route for proposals (from email notifications)
      GoRoute(
        path: '/proposal/:proposalId',
        name: 'proposal-deep-link',
        builder: (context, state) {
          final proposalId = state.pathParameters['proposalId'];
          if (proposalId == null) {
            return const ProposalsPage();
          }
          return _ProposalDeepLinkPage(proposalId: proposalId);
        },
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

/// Page that loads a proposal by ID and navigates to the details page
class _ProposalDeepLinkPage extends ConsumerWidget {
  final String proposalId;

  const _ProposalDeepLinkPage({required this.proposalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalAsync = ref.watch(proposalByIdProvider(proposalId));

    return proposalAsync.when(
      data: (proposal) {
        if (proposal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Proposal Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'This proposal could not be found.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
          );
        }
        return ProposalDetailsPage(proposal: proposal);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading proposal: $error'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}