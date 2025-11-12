import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../shared/repositories/users_repository.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';
import '../widgets/proposal_card.dart';
import '../widgets/skill_level_filter.dart';
import '../widgets/proposal_filters.dart';

class ProposalsPage extends ConsumerStatefulWidget {
  const ProposalsPage({super.key});

  @override
  ConsumerState<ProposalsPage> createState() => _ProposalsPageState();
}

class _ProposalsPageState extends ConsumerState<ProposalsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes to update filter visibility
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final selectedSkillLevel = ref.watch(selectedSkillLevelProvider);

    // Show login state if user is not authenticated
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Match Proposals'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login_outlined,
                size: 80,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: 24),
              const Text(
                'Please log in',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You need to be logged in to view match proposals',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Go to Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header section with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryGreen, AppColors.darkGreen],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and buttons
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Match Proposals',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Find and create pickleball matches',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Filter button
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _showFilters = !_showFilters;
                              });
                            },
                            icon: Icon(
                              _showFilters ? Icons.filter_list_off : Icons.filter_list,
                              color: AppColors.onPrimary,
                              size: 24,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        // Add button
                        FloatingActionButton(
                          onPressed: _navigateToCreateProposal,
                          heroTag: "create_proposal",
                          backgroundColor: AppColors.onPrimary,
                          foregroundColor: AppColors.primaryGreen,
                          child: const Icon(Icons.add, size: 28),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Skill level filter
                    const SkillLevelFilter(),
                    
                    const SizedBox(height: 16),
                    
                    // Tab bar
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.transparent,
                        labelColor: AppColors.primaryGreen,
                        unselectedLabelColor: const Color.fromARGB(255, 221, 222, 221).withValues(alpha: 0.7),
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                        tabs: const [
                          Tab(text: 'Available'),
                          Tab(text: 'My Proposals'),
                        ],
                      ),
                    ),

                    // Filters (collapsible)
                    if (_showFilters) ...[
                      const SizedBox(height: 16),
                      ProposalFilters(
                        showCreatorFilter: _tabController.index == 0, // Only show on Available tab
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableProposals(selectedSkillLevel),
                _buildMyProposals(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableProposals(SkillLevel skillLevel) {
    final proposalsAsync = ref.watch(filteredProposalsProvider(skillLevel));

    return proposalsAsync.when(
      data: (proposals) {
        if (proposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No matches available',
            subtitle: 'Be the first to create a match proposal!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(openProposalsProvider(skillLevel));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              final currentUser = ref.watch(currentUserProvider);
              final isOwnProposal = currentUser?.id == proposal.creatorId;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProposalCard(
                  proposal: proposal,
                  showActions: true,
                  onAccept: isOwnProposal ? null : () => _acceptProposal(proposal),
                  onDelete: isOwnProposal ? () => _deleteProposal(proposal) : null,
                  onView: () => _viewProposal(proposal),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildMyProposals() {
    // Get current user ID from auth
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) {
      return _buildEmptyState(
        icon: Icons.login_outlined,
        title: 'Please log in',
        subtitle: 'You need to be logged in to view your proposals',
      );
    }

    final proposalsAsync = ref.watch(filteredUserProposalsProvider(currentUser.id));

    return proposalsAsync.when(
      data: (proposals) {
        if (proposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.sports_tennis_outlined,
            title: 'No proposals yet',
            subtitle: 'Create your first match proposal to get started!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userProposalsProvider(currentUser.id));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProposalCard(
                  proposal: proposal,
                  showActions: true,
                  onDelete: () => _deleteProposal(proposal),
                  onView: () => _viewProposal(proposal),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.mediumGray,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToCreateProposal,
              icon: const Icon(Icons.add),
              label: const Text('Create Proposal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                final selectedSkillLevel = ref.read(selectedSkillLevelProvider);
                ref.invalidate(openProposalsProvider(selectedSkillLevel));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateProposal() {
    context.go('/create-proposal');
  }

  void _acceptProposal(Proposal proposal) async {
    try {
      // Get current user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get user profile from Firestore
      final usersRepository = ref.read(usersRepositoryProvider);
      final userProfile = await usersRepository.getUserById(currentUser.id);

      print('=== Accept Proposal User Debug ===');
      print('Current user ID: ${currentUser.id}');
      print('Current user displayName: ${currentUser.displayName}');
      print('User profile from Firestore: $userProfile');
      print('User profile displayName: ${userProfile?.displayName}');

      final userName = userProfile?.displayName ?? currentUser.displayName ?? 'Unknown User';

      await ref.read(proposalActionsProvider).acceptProposal(
        proposal.proposalId,
        currentUser.id,
        userName,
      );

      // Invalidate the providers to refresh the streams
      final selectedSkillLevel = ref.read(selectedSkillLevelProvider);
      ref.invalidate(openProposalsProvider(selectedSkillLevel));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Accepted match with ${proposal.creatorName}!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      print('Accept proposal error: $e');
      print('Error type: ${e.runtimeType}');

      // Provide more specific error messages
      String errorMessage = 'Failed to accept proposal';
      if (e.toString().contains('permission')) {
        errorMessage = 'Permission denied. Please check if you are logged in.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('firestore')) {
        errorMessage = 'Firestore error. Please try again later.';
      } else {
        errorMessage = 'Failed to accept proposal: ${e.toString()}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  void _deleteProposal(Proposal proposal) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Proposal'),
        content: Text('Are you sure you want to delete this match proposal? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(proposalActionsProvider).deleteProposal(proposal.proposalId);

        // Invalidate the providers to refresh the streams
        final selectedSkillLevel = ref.read(selectedSkillLevelProvider);
        ref.invalidate(openProposalsProvider(selectedSkillLevel));
        ref.invalidate(filteredProposalsProvider(selectedSkillLevel));

        final currentUser = ref.read(currentUserProvider);
        if (currentUser != null) {
          ref.invalidate(userProposalsProvider(currentUser.id));
          ref.invalidate(filteredUserProposalsProvider(currentUser.id));
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Proposal deleted successfully'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      } catch (e) {
        print('Delete proposal error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting proposal: ${e.toString()}'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      }
    }
  }

  void _viewProposal(Proposal proposal) {
    // TODO: Navigate to proposal details page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proposal details coming soon!'),
        backgroundColor: AppColors.accentBlue,
      ),
    );
  }
}