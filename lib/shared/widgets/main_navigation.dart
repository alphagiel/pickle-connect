import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../theme/app_colors.dart';
import '../models/feedback.dart';
import '../repositories/feedback_repository.dart';

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
      body: Stack(
        children: [
          child,
          Positioned(
            right: 16,
            bottom: 12,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(24),
              color: AppColors.primaryGreen,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => _showFeedbackModal(context, ref),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  void _showFeedbackModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FeedbackForm(ref: ref),
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

class _FeedbackForm extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _FeedbackForm({required this.ref});

  @override
  ConsumerState<_FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<_FeedbackForm> {
  FeedbackCategory? _selectedCategory;
  final _descriptionController = TextEditingController();
  bool _submitted = false;
  bool _isSubmitting = false;

  bool get _isValid =>
      _selectedCategory != null && _descriptionController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Feedback and Suggestions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your feedback is gold. We take this to heart and will prioritize it '
              'based on need, feasibility and other factors. Once your suggestion is '
              'noted you earn a pioneer badge which can be valuable later on in the '
              'life of the app.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<FeedbackCategory>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                ),
                errorText: _submitted && _selectedCategory == null ? 'Required' : null,
              ),
              items: FeedbackCategory.values
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.displayName),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Please describe your thoughts here...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                ),
                errorText: _submitted && _descriptionController.text.trim().isEmpty
                    ? 'Required'
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValid && !_isSubmitting ? _handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppColors.mediumGray,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() => _submitted = true);
    if (!_isValid) return;

    setState(() => _isSubmitting = true);

    try {
      final userProfile = widget.ref.read(currentUserProfileProvider).valueOrNull;
      final authUser = widget.ref.read(currentUserProvider);

      final feedback = FeedbackEntry(
        userId: authUser?.id ?? '',
        userName: userProfile?.displayName ?? 'Unknown',
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
      );

      await widget.ref.read(feedbackRepositoryProvider).submitFeedback(feedback);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you! Your feedback has been submitted.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }
}
