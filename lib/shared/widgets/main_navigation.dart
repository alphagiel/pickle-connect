import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../theme/app_colors.dart';
import '../models/user.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickle Connect'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          _buildProfileSection(context, ref),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.cardBackground,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.neutralGray,
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.sports_tennis_outlined, size: 26),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.sports_tennis, size: 26),
              ),
              label: 'Proposals',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.leaderboard_outlined, size: 26),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.leaderboard, size: 26),
              ),
              label: 'Standings',
            ),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith('/proposals')) return 0;
    if (location.startsWith('/standings')) return 1;
    
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/proposals');
        break;
      case 1:
        GoRouter.of(context).go('/standings');
        break;
    }
  }

  Widget _buildProfileSection(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final userProfile = userProfileAsync.valueOrNull;
    final displayName = userProfile?.displayName ?? 'User';

    // Get first name only for greeting
    final firstName = displayName.split(' ').first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hi $firstName!',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.account_circle),
          offset: const Offset(0, 45),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {
                // Close menu first, then navigate
                Future.delayed(Duration.zero, () {
                  if (context.mounted) {
                    GoRouter.of(context).push('/edit-profile');
                  }
                });
              },
            ),
            PopupMenuItem(
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _handleLogout(context, ref),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      // Sign out from Firebase Auth
      await ref.read(authNotifierProvider.notifier).signOut();

      if (context.mounted) {
        // Navigate to login page
        GoRouter.of(context).go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }
}