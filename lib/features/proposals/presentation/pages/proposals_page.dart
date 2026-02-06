import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../shared/repositories/users_repository.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';

class ProposalsPage extends ConsumerStatefulWidget {
  const ProposalsPage({super.key});

  @override
  ConsumerState<ProposalsPage> createState() => _ProposalsPageState();
}

class _ProposalsPageState extends ConsumerState<ProposalsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Track retry attempts for permission-denied errors (race condition on login)
  final Map<String, int> _retryAttempts = {};
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    final userProfileAsync = ref.watch(currentUserProfileProvider);

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

                    // Tab bar
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicator: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.transparent,
                        labelColor: AppColors.primaryGreen,
                        unselectedLabelColor: const Color.fromARGB(255, 221, 222, 221).withValues(alpha: 0.7),
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                        tabs: const [
                          Tab(text: 'Available'),
                          Tab(text: 'My Matches'),
                          Tab(text: 'Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: userProfileAsync.when(
              data: (userProfile) {
                if (userProfile == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_outline, size: 64, color: AppColors.mediumGray),
                        const SizedBox(height: 16),
                        const Text(
                          'Please complete your profile',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Set up your profile to see matches at your skill level',
                          style: TextStyle(color: AppColors.secondaryText),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/edit-profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: AppColors.onPrimary,
                          ),
                          child: const Text('Complete Profile'),
                        ),
                      ],
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAvailableProposals(userProfile.skillLevel.bracket),
                    _buildMyMatches(),
                    _buildCompletedProposals(),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              ),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableProposals(SkillBracket bracket) {
    final proposalsAsync = ref.watch(filteredProposalsProvider(bracket));

    return proposalsAsync.when(
      data: (proposals) {
        // Clear retry counter on success
        _retryAttempts.remove('available_${bracket.name}');

        if (proposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No matches available',
            subtitle: 'Be the first to create a match proposal!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(openProposalsProvider(bracket));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table header
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildHeaderCell('Player', flex: 3),
                      _buildHeaderCell('Location', flex: 2),
                      _buildHeaderCell('Date', flex: 2),
                      _buildHeaderCell('', flex: 1), // View column
                    ],
                  ),
                ),
                // Table rows
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: proposals.asMap().entries.map((entry) {
                      final index = entry.key;
                      final proposal = entry.value;
                      final isLastRow = index == proposals.length - 1;
                      return _buildAvailableRow(
                        proposal,
                        isLastRow: isLastRow,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) {
        // Auto-retry on permission-denied (race condition on login)
        final retryKey = 'available_${bracket.name}';
        final attempts = _retryAttempts[retryKey] ?? 0;

        if (error.toString().contains('permission-denied') && attempts < _maxRetries) {
          Future.delayed(_retryDelay, () {
            if (mounted) {
              _retryAttempts[retryKey] = attempts + 1;
              ref.invalidate(openProposalsProvider(bracket));
            }
          });
          // Show loading while retrying
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          );
        }
        // Reset retry counter on non-permission errors or max retries reached
        _retryAttempts.remove(retryKey);
        return _buildErrorState(error.toString());
      },
    );
  }

  Widget _buildMyMatches() {
    // Get current user ID from auth
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) {
      return _buildEmptyState(
        icon: Icons.login_outlined,
        title: 'Please log in',
        subtitle: 'You need to be logged in to view your matches',
      );
    }

    // Watch both created and accepted proposals
    final createdProposalsAsync = ref.watch(userProposalsProvider(currentUser.id));
    final acceptedProposalsAsync = ref.watch(acceptedProposalsProvider(currentUser.id));

    // Combine both async values
    return createdProposalsAsync.when(
      data: (createdProposals) {
        // Clear retry counter on success
        _retryAttempts.remove('created_${currentUser.id}');

        return acceptedProposalsAsync.when(
          data: (acceptedProposals) {
            // Clear retry counter on success
            _retryAttempts.remove('accepted_${currentUser.id}');

            // Combine and deduplicate (in case of any overlap)
            final allProposals = <String, Proposal>{};
            for (final p in createdProposals) {
              allProposals[p.proposalId] = p;
            }
            for (final p in acceptedProposals) {
              allProposals[p.proposalId] = p;
            }

            // Filter to current season (Winter 2026: Jan 1 - March 31)
            final seasonStart = DateTime(2026, 1, 1);
            final seasonEnd = DateTime(2026, 3, 31, 23, 59, 59);

            // Sort by date (upcoming first, then recent)
            // Only show active matches (open or accepted, not completed/expired/canceled)
            final proposals = allProposals.values
                .where((p) =>
                    (p.status == ProposalStatus.open || p.status == ProposalStatus.accepted) &&
                    p.dateTime.isAfter(seasonStart.subtract(const Duration(days: 1))) &&
                    p.dateTime.isBefore(seasonEnd.add(const Duration(days: 1))))
                .toList()
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

            if (proposals.isEmpty) {
              return _buildEmptyState(
                icon: Icons.sports_tennis_outlined,
                title: 'No matches yet',
                subtitle: 'Create a proposal or accept one to get started!',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(userProposalsProvider(currentUser.id));
                ref.invalidate(acceptedProposalsProvider(currentUser.id));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Table header
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell('Status', flex: 2),
                          _buildHeaderCell('Opponent', flex: 2),
                          _buildHeaderCell('Date', flex: 2),
                          _buildHeaderCell('Time', flex: 2),
                          _buildHeaderCell('Place', flex: 2),
                          _buildHeaderCell('', flex: 1), // View column
                        ],
                      ),
                    ),
                    // Table rows
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGray),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: proposals.asMap().entries.map((entry) {
                          final index = entry.key;
                          final proposal = entry.value;
                          final isLastRow = index == proposals.length - 1;
                          return _buildMyMatchRow(
                            proposal,
                            currentUser.id,
                            isLastRow: isLastRow,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
          error: (error, stack) {
            // Auto-retry on permission-denied (race condition on login)
            final retryKey = 'accepted_${currentUser.id}';
            final attempts = _retryAttempts[retryKey] ?? 0;

            if (error.toString().contains('permission-denied') && attempts < _maxRetries) {
              Future.delayed(_retryDelay, () {
                if (mounted) {
                  _retryAttempts[retryKey] = attempts + 1;
                  ref.invalidate(acceptedProposalsProvider(currentUser.id));
                }
              });
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              );
            }
            _retryAttempts.remove(retryKey);
            return _buildErrorState(error.toString());
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) {
        // Auto-retry on permission-denied (race condition on login)
        final retryKey = 'created_${currentUser.id}';
        final attempts = _retryAttempts[retryKey] ?? 0;

        if (error.toString().contains('permission-denied') && attempts < _maxRetries) {
          Future.delayed(_retryDelay, () {
            if (mounted) {
              _retryAttempts[retryKey] = attempts + 1;
              ref.invalidate(userProposalsProvider(currentUser.id));
            }
          });
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          );
        }
        _retryAttempts.remove(retryKey);
        return _buildErrorState(error.toString());
      },
    );
  }

  Widget _buildCompletedProposals() {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) {
      return _buildEmptyState(
        icon: Icons.login_outlined,
        title: 'Please log in',
        subtitle: 'You need to be logged in to view completed matches',
      );
    }

    final proposalsAsync = ref.watch(completedProposalsProvider(currentUser.id));

    return proposalsAsync.when(
      data: (proposals) {
        // Clear retry counter on success
        _retryAttempts.remove('completed_${currentUser.id}');

        if (proposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.emoji_events_outlined,
            title: 'No completed matches',
            subtitle: 'Your completed matches will appear here',
            showCreateButton: false,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(completedProposalsProvider(currentUser.id));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table header
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildHeaderCell('You', flex: 2),
                      _buildHeaderCell('Opponent', flex: 2),
                      _buildHeaderCell('Score', flex: 1),
                      _buildHeaderCell('Date', flex: 2),
                      _buildHeaderCell('Place', flex: 2),
                      _buildHeaderCell('', flex: 1), // View column
                    ],
                  ),
                ),
                // Table rows
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: proposals.asMap().entries.map((entry) {
                      final index = entry.key;
                      final proposal = entry.value;
                      final isLastRow = index == proposals.length - 1;
                      return _buildCompletedMatchRow(
                        proposal,
                        currentUser.id,
                        isLastRow: isLastRow,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) {
        // Auto-retry on permission-denied (race condition on login)
        final retryKey = 'completed_${currentUser.id}';
        final attempts = _retryAttempts[retryKey] ?? 0;

        if (error.toString().contains('permission-denied') && attempts < _maxRetries) {
          Future.delayed(_retryDelay, () {
            if (mounted) {
              _retryAttempts[retryKey] = attempts + 1;
              ref.invalidate(completedProposalsProvider(currentUser.id));
            }
          });
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          );
        }
        _retryAttempts.remove(retryKey);
        return _buildErrorState(error.toString());
      },
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedMatchRow(Proposal proposal, String currentUserId, {bool isLastRow = false}) {
    final isCreator = currentUserId == proposal.creatorId;
    final userName = isCreator ? proposal.creatorName : (proposal.acceptedBy?.displayName ?? 'Unknown');
    final opponentName = isCreator ? (proposal.acceptedBy?.displayName ?? 'Unknown') : proposal.creatorName;

    // Determine if current user won
    final winner = proposal.scores?.winner;
    final userWon = (isCreator && winner == 'creator') || (!isCreator && winner == 'opponent');

    // Format score from user's perspective
    String scoreDisplay = '-';
    if (proposal.scores != null) {
      final userGamesWon = isCreator
          ? proposal.scores!.creatorGamesWon
          : proposal.scores!.opponentGamesWon;
      final opponentGamesWon = isCreator
          ? proposal.scores!.opponentGamesWon
          : proposal.scores!.creatorGamesWon;
      scoreDisplay = '$userGamesWon-$opponentGamesWon';
    }

    // Format date
    final dateDisplay = '${proposal.dateTime.month}/${proposal.dateTime.day}/${proposal.dateTime.year}';

    // Row background color
    final backgroundColor = userWon
        ? AppColors.successGreen.withValues(alpha: 0.15)
        : Colors.transparent;

    return InkWell(
      onTap: () => _viewProposal(proposal),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: isLastRow
              ? null
              : Border(bottom: BorderSide(color: AppColors.lightGray)),
          borderRadius: isLastRow
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                )
              : null,
        ),
        child: Row(
          children: [
            _buildDataCell(
              userName,
              flex: 2,
              isWinner: userWon,
            ),
            _buildDataCell(
              opponentName,
              flex: 2,
              isWinner: !userWon && winner != null,
            ),
            _buildDataCell(scoreDisplay, flex: 1),
            _buildDataCell(dateDisplay, flex: 2),
            _buildDataCell(
              proposal.location,
              flex: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => _viewProposal(proposal),
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.accentBlue,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyMatchRow(Proposal proposal, String currentUserId, {bool isLastRow = false}) {
    final isCreator = currentUserId == proposal.creatorId;

    // Determine opponent name
    String opponentName;
    if (proposal.status == ProposalStatus.open) {
      opponentName = 'Waiting...';
    } else {
      opponentName = isCreator
          ? (proposal.acceptedBy?.displayName ?? 'Unknown')
          : proposal.creatorName;
    }

    // Format date and time
    final dateDisplay = '${proposal.dateTime.month}/${proposal.dateTime.day}/${proposal.dateTime.year}';
    final hour = proposal.dateTime.hour;
    final minute = proposal.dateTime.minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeDisplay = '$hour12:$minute $amPm';

    // Status display
    final statusText = proposal.status == ProposalStatus.open ? 'Open' : 'Accepted';
    final statusColor = proposal.status == ProposalStatus.open
        ? AppColors.warmOrange
        : AppColors.successGreen;

    return InkWell(
      onTap: () => _viewProposal(proposal),
      child: Container(
        decoration: BoxDecoration(
          border: isLastRow
              ? null
              : Border(bottom: BorderSide(color: AppColors.lightGray)),
          borderRadius: isLastRow
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                )
              : null,
        ),
        child: Row(
          children: [
            // Status
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            _buildDataCell(opponentName, flex: 2),
            _buildDataCell(dateDisplay, flex: 2),
            _buildDataCell(timeDisplay, flex: 2),
            _buildDataCell(
              proposal.location,
              flex: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => _viewProposal(proposal),
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.accentBlue,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableRow(Proposal proposal, {bool isLastRow = false}) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwnProposal = currentUser?.id == proposal.creatorId;

    // Format date
    final dateDisplay = '${proposal.dateTime.month}/${proposal.dateTime.day}/${proposal.dateTime.year}';

    return InkWell(
      onTap: () => _viewProposal(proposal),
      child: Container(
        decoration: BoxDecoration(
          color: isOwnProposal ? AppColors.primaryGreen.withValues(alpha: 0.05) : null,
          border: isLastRow
              ? null
              : Border(bottom: BorderSide(color: AppColors.lightGray)),
          borderRadius: isLastRow
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                )
              : null,
        ),
        child: Row(
          children: [
            // Player column: icon + name + skill level
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    // Player icon
                    CircleAvatar(
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                      radius: 14,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryGreen,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Name and skill level
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            proposal.creatorName,
                            style: TextStyle(
                              color: isOwnProposal ? AppColors.primaryGreen : AppColors.primaryText,
                              fontWeight: isOwnProposal ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            proposal.skillLevel.displayName,
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Location column
            _buildDataCell(
              proposal.location,
              flex: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Date column
            _buildDataCell(dateDisplay, flex: 2),
            // View column
            Expanded(
              flex: 1,
              child: Tooltip(
                message: 'View details',
                child: IconButton(
                  onPressed: () => _viewProposal(proposal),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 20,
                    color: AppColors.accentBlue,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1, bool isWinner = false, TextOverflow? overflow}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          text,
          style: TextStyle(
            color: isWinner ? AppColors.successGreen : AppColors.primaryText,
            fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
          overflow: overflow,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showCreateButton = true,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
            if (showCreateButton) ...[
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
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
                if (userProfile != null) {
                  ref.invalidate(openProposalsProvider(userProfile.skillLevel.bracket));
                }
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

      // Get user profile from Firestore for display name
      final usersRepository = ref.read(usersRepositoryProvider);
      final userProfile = await usersRepository.getUserById(currentUser.id);

      final userName = userProfile?.displayName ?? currentUser.displayName ?? 'Unknown User';

      await ref.read(proposalActionsProvider).acceptProposal(
        proposal.proposalId,
        currentUser.id,
        userName,
      );

      // Invalidate the providers to refresh the streams
      ref.invalidate(openProposalsProvider(proposal.skillBracket));

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
        ref.invalidate(openProposalsProvider(proposal.skillBracket));
        ref.invalidate(filteredProposalsProvider(proposal.skillBracket));

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
    context.go('/proposal-details', extra: proposal);
  }
}