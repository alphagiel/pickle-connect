import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/providers/doubles_proposals_providers.dart';
import '../../../../shared/providers/doubles_standings_providers.dart';
import '../../../../shared/models/standing.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../core/utils/season_utils.dart';

class DoublesPage extends ConsumerStatefulWidget {
  const DoublesPage({super.key});

  @override
  ConsumerState<DoublesPage> createState() => _DoublesPageState();
}

class _DoublesPageState extends ConsumerState<DoublesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-tab bar
        Container(
          color: AppColors.primaryGreen,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            tabs: const [
              Tab(text: 'Proposals'),
              Tab(text: 'Rankings'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _DoublesProposalsContent(),
              _DoublesRankingsContent(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Doubles proposals tab content with Available / My Doubles / Completed inner tabs
class _DoublesProposalsContent extends ConsumerStatefulWidget {
  const _DoublesProposalsContent();

  @override
  ConsumerState<_DoublesProposalsContent> createState() => _DoublesProposalsContentState();
}

class _DoublesProposalsContentState extends ConsumerState<_DoublesProposalsContent> with SingleTickerProviderStateMixin {
  late TabController _innerTabController;
  final Map<String, int> _retryAttempts = {};
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    if (currentUser == null) {
      return _buildLoginState(context);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header
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
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Doubles Matches',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Find doubles partners and opponents',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () => context.go('/create-doubles-proposal'),
                          heroTag: "create_doubles_proposal",
                          backgroundColor: AppColors.onPrimary,
                          foregroundColor: AppColors.primaryGreen,
                          child: const Icon(Icons.add, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _innerTabController,
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
                          Tab(text: 'My Doubles'),
                          Tab(text: 'Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                        const Text('Please complete your profile',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
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
                  controller: _innerTabController,
                  children: [
                    _buildAvailableDoubles(userProfile.skillLevel.bracket),
                    _buildMyDoubles(currentUser.id),
                    _buildCompletedDoubles(currentUser.id),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen)),
              ),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableDoubles(SkillBracket bracket) {
    final proposalsAsync = ref.watch(openDoublesProposalsProvider(bracket));

    return proposalsAsync.when(
      data: (proposals) {
        _retryAttempts.remove('available_doubles_${bracket.name}');

        if (proposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.group_outlined,
            title: 'No doubles matches available',
            subtitle: 'Be the first to create a doubles match!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(openDoublesProposalsProvider(bracket));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              return _buildDoublesProposalCard(proposal);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen)),
      ),
      error: (error, stack) {
        final retryKey = 'available_doubles_${bracket.name}';
        final attempts = _retryAttempts[retryKey] ?? 0;
        if (error.toString().contains('permission-denied') && attempts < _maxRetries) {
          Future.delayed(_retryDelay, () {
            if (mounted) {
              _retryAttempts[retryKey] = attempts + 1;
              ref.invalidate(openDoublesProposalsProvider(bracket));
            }
          });
          return const Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen)),
          );
        }
        _retryAttempts.remove(retryKey);
        return _buildErrorState(error.toString());
      },
    );
  }

  Widget _buildMyDoubles(String userId) {
    final proposalsAsync = ref.watch(userDoublesProposalsProvider(userId));

    return proposalsAsync.when(
      data: (proposals) {
        final activeProposals = proposals
            .where((p) => p.status == ProposalStatus.open || p.status == ProposalStatus.accepted)
            .toList();

        if (activeProposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.group_outlined,
            title: 'No active doubles matches',
            subtitle: 'Create a doubles proposal or join one!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userDoublesProposalsProvider(userId));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activeProposals.length,
            itemBuilder: (context, index) {
              return _buildDoublesProposalCard(activeProposals[index]);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen)),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildCompletedDoubles(String userId) {
    final proposalsAsync = ref.watch(completedDoublesProposalsProvider(userId));

    return proposalsAsync.when(
      data: (proposals) {
        if (proposals.isEmpty) {
          return _buildEmptyState(
            icon: Icons.emoji_events_outlined,
            title: 'No completed doubles matches',
            subtitle: 'Your completed doubles matches will appear here',
            showCreateButton: false,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(completedDoublesProposalsProvider(userId));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              return _buildDoublesProposalCard(proposals[index]);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen)),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildDoublesProposalCard(Proposal proposal) {
    final confirmedPlayers = proposal.doublesPlayers
        .where((p) => p.status == DoublesPlayerStatus.confirmed)
        .toList();
    final pendingCount = proposal.doublesPlayers
        .where((p) => p.status == DoublesPlayerStatus.requested)
        .length;

    final dateDisplay = '${proposal.dateTime.month}/${proposal.dateTime.day}/${proposal.dateTime.year}';
    final hour = proposal.dateTime.hour;
    final minute = proposal.dateTime.minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeDisplay = '$hour12:$minute $amPm';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/doubles-proposal-details', extra: proposal),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                    radius: 20,
                    child: const Icon(Icons.group, color: AppColors.primaryGreen, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${proposal.creatorName}\'s Doubles',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          '${proposal.skillLevel.displayName} - ${proposal.location}',
                          style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  // Open slots badge
                  if (proposal.openSlots > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warmOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${proposal.openSlots} open',
                        style: const TextStyle(
                          color: AppColors.warmOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Date/time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.secondaryText),
                  const SizedBox(width: 4),
                  Text(dateDisplay, style: const TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 14, color: AppColors.secondaryText),
                  const SizedBox(width: 4),
                  Text(timeDisplay, style: const TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                ],
              ),
              const SizedBox(height: 12),
              // Players info
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 6),
                  Text(
                    '${confirmedPlayers.length}/4 players',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                  ),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$pendingCount pending',
                        style: const TextStyle(fontSize: 11, color: AppColors.accentBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
              // Player avatars row
              if (confirmedPlayers.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: confirmedPlayers.map((p) {
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: p.team == 1 ? AppColors.primaryGreen : AppColors.accentBlue,
                        radius: 10,
                        child: Text(
                          p.displayName.isNotEmpty ? p.displayName[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      label: Text(p.displayName, style: const TextStyle(fontSize: 11)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.login_outlined, size: 80, color: AppColors.mediumGray),
          const SizedBox(height: 24),
          const Text('Please log in',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.login),
            label: const Text('Go to Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.onPrimary,
            ),
          ),
        ],
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
            Icon(icon, size: 80, color: AppColors.mediumGray),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryText), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 16, color: AppColors.secondaryText), textAlign: TextAlign.center),
            if (showCreateButton) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/create-doubles-proposal'),
                icon: const Icon(Icons.add),
                label: const Text('Create Doubles Match'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
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
            const Icon(Icons.error_outline, size: 80, color: AppColors.errorRed),
            const SizedBox(height: 24),
            const Text('Something went wrong',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
            const SizedBox(height: 8),
            Text(error, style: const TextStyle(fontSize: 14, color: AppColors.secondaryText), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Doubles rankings tab content with 5 bracket tabs
class _DoublesRankingsContent extends ConsumerStatefulWidget {
  const _DoublesRankingsContent();

  @override
  ConsumerState<_DoublesRankingsContent> createState() => _DoublesRankingsContentState();
}

class _DoublesRankingsContentState extends ConsumerState<_DoublesRankingsContent> with SingleTickerProviderStateMixin {
  late TabController _bracketTabController;

  @override
  void initState() {
    super.initState();
    _bracketTabController = TabController(length: 5, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _bracketTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.accentBlue, AppColors.darkBlue],
              ),
            ),
            child: SafeArea(
              bottom: false,
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doubles Standings',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.onPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Doubles leaderboards by skill level',
                      style: TextStyle(fontSize: 16, color: AppColors.onPrimary.withValues(alpha: 0.9)),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _bracketTabController,
                        indicator: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: AppColors.accentBlue,
                        unselectedLabelColor: const Color.fromARGB(255, 38, 70, 103).withValues(alpha: 0.7),
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        tabs: const [
                          Tab(text: 'Beginner'),
                          Tab(text: 'Novice'),
                          Tab(text: 'Intermediate'),
                          Tab(text: 'Advanced'),
                          Tab(text: 'Expert'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _bracketTabController,
              children: [
                _buildDoublesStandings(SkillBracket.beginner),
                _buildDoublesStandings(SkillBracket.novice),
                _buildDoublesStandings(SkillBracket.intermediate),
                _buildDoublesStandings(SkillBracket.advanced),
                _buildDoublesStandings(SkillBracket.expert),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoublesStandings(SkillBracket bracket) {
    final standingsAsync = ref.watch(doublesStandingsProvider(bracket));

    return standingsAsync.when(
      data: (standings) {
        if (standings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_outlined, size: 48, color: AppColors.mediumGray),
                  const SizedBox(height: 12),
                  Text(
                    'No ${bracket.displayName} doubles players yet',
                    style: const TextStyle(fontSize: 16, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(doublesStandingsProvider(bracket));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildRankingsTable(standings, bracket),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentBlue)),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: AppColors.errorRed),
              const SizedBox(height: 16),
              Text('Error: $error', style: const TextStyle(color: AppColors.secondaryText)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(doublesStandingsProvider(bracket)),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingsTable(List<Standing> standings, SkillBracket bracket) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                Expanded(flex: 3, child: Text('Player', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                SizedBox(width: 50, child: Text('W', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                SizedBox(width: 50, child: Text('L', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                SizedBox(width: 60, child: Text('Streak', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
              ],
            ),
          ),
          ...standings.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final standing = entry.value;
            final isLast = entry.key == standings.length - 1;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: isLast ? null : Border(bottom: BorderSide(color: AppColors.lightGray, width: 0.5)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 40, child: _buildRankIndicator(rank)),
                  Expanded(
                    flex: 3,
                    child: Text(standing.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primaryText),
                      overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(standing.matchesWon.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.successGreen)),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(standing.matchesLost.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.errorRed)),
                  ),
                  SizedBox(width: 60, child: _buildStreakIndicator(standing.streak)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRankIndicator(int rank) {
    final Color color;
    if (rank <= 3) {
      final colors = [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];
      color = colors[rank - 1];
    } else {
      color = AppColors.neutralGray;
    }
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
      child: Center(child: Text(rank.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color))),
    );
  }

  Widget _buildStreakIndicator(int streak) {
    if (streak == 0) {
      return const Text('-', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.secondaryText));
    }
    final isPositive = streak > 0;
    final color = isPositive ? AppColors.successGreen : AppColors.errorRed;
    final text = isPositive ? '+$streak' : '$streak';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
    );
  }
}
