import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/standing.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/providers/standings_providers.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../core/utils/season_utils.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';

class StandingsPage extends ConsumerStatefulWidget {
  const StandingsPage({super.key});

  @override
  ConsumerState<StandingsPage> createState() => _StandingsPageState();
}

class _StandingsPageState extends ConsumerState<StandingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    // Show login state if user is not authenticated
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Standings'),
          backgroundColor: AppColors.accentBlue,
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
                'You need to be logged in to view standings',
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
                  backgroundColor: AppColors.accentBlue,
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.accentBlue, AppColors.darkBlue],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Standings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Leaderboards by skill level',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.onPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Skill level tabs
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
                        labelColor: AppColors.accentBlue,
                        unselectedLabelColor: const Color.fromARGB(255, 38, 70, 103).withValues(alpha: 0.7),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStandingsContent(SkillBracket.beginner),
                _buildStandingsContent(SkillBracket.novice),
                _buildStandingsContent(SkillBracket.intermediate),
                _buildStandingsContent(SkillBracket.advanced),
                _buildStandingsContent(SkillBracket.expert),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingsContent(SkillBracket bracket) {
    final standingsAsync = ref.watch(standingsProvider(bracket));
    final matchesAsync = ref.watch(completedMatchesByBracketProvider(bracket));

    // Debug logging
    print('[StandingsPage] Loading standings for bracket: ${bracket.jsonValue}');

    return standingsAsync.when(
      data: (standings) {
        print('[StandingsPage] Received ${standings.length} standings for ${bracket.jsonValue}');
        for (final s in standings) {
          print('[StandingsPage] - ${s.displayName}: W${s.matchesWon} L${s.matchesLost} streak:${s.streak}');
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(standingsProvider(bracket));
            ref.invalidate(completedMatchesByBracketProvider(bracket));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rankings Section
                _buildSectionHeader('Rankings (${bracket.skillRange})', Icons.leaderboard),
                const SizedBox(height: 12),
                if (standings.isEmpty)
                  _buildEmptyRankings(bracket)
                else
                  _buildRankingsTable(standings, bracket),

                const SizedBox(height: 24),

                // Season Matches Section (Accordion)
                _buildMatchesAccordion(bracket, matchesAsync),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString(), bracket),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentBlue, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyRankings(SkillBracket bracket) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.emoji_events_outlined, size: 48, color: AppColors.mediumGray),
            const SizedBox(height: 12),
            Text(
              'No ${bracket.displayName} players yet',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),
          ],
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
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                const Expanded(flex: 3, child: Text('Player', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                const SizedBox(width: 50, child: Text('W', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                const SizedBox(width: 50, child: Text('L', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                const SizedBox(width: 60, child: Text('Streak', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
              ],
            ),
          ),
          // Table rows
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
                  // Rank
                  SizedBox(
                    width: 40,
                    child: _buildRankIndicator(rank),
                  ),
                  // Player name with level pill
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            standing.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.primaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildSkillPill(standing.skillLevel),
                      ],
                    ),
                  ),
                  // Wins
                  SizedBox(
                    width: 50,
                    child: Text(
                      standing.matchesWon.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ),
                  // Losses
                  SizedBox(
                    width: 50,
                    child: Text(
                      standing.matchesLost.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ),
                  // Streak
                  SizedBox(
                    width: 60,
                    child: _buildStreakIndicator(standing.streak),
                  ),
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
      final colors = [
        const Color(0xFFFFD700), // Gold
        const Color(0xFFC0C0C0), // Silver
        const Color(0xFFCD7F32), // Bronze
      ];
      color = colors[rank - 1];
    } else {
      color = AppColors.neutralGray;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildSkillPill(SkillLevel skillLevel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getSkillLevelColor(skillLevel.bracket).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        skillLevel.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getSkillLevelColor(skillLevel.bracket),
        ),
      ),
    );
  }

  Widget _buildStreakIndicator(int streak) {
    if (streak == 0) {
      return const Text(
        '-',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.secondaryText,
        ),
      );
    }

    final isPositive = streak > 0;
    final color = isPositive ? AppColors.successGreen : AppColors.errorRed;
    final text = isPositive ? '+$streak' : '$streak';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: color,
        ),
      ),
    );
  }

  Color _getSkillLevelColor(SkillBracket bracket) {
    switch (bracket) {
      case SkillBracket.beginner:
        return AppColors.beginnerColor;
      case SkillBracket.novice:
        return AppColors.noviceColor;
      case SkillBracket.intermediate:
        return AppColors.intermediateColor;
      case SkillBracket.advanced:
        return AppColors.advancedColor;
      case SkillBracket.expert:
        return AppColors.expertColor;
    }
  }

  Widget _buildMatchesAccordion(SkillBracket bracket, AsyncValue<List<Proposal>> matchesAsync) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      collapsedBackgroundColor: AppColors.cardBackground,
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightGray),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightGray),
      ),
      leading: const Icon(Icons.sports_tennis, color: AppColors.primaryGreen),
      title: Text(
        'Season - ${SeasonUtils.getSeasonDisplay()}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
      subtitle: matchesAsync.when(
        data: (matches) => Text(
          '${matches.length} match${matches.length == 1 ? '' : 'es'}',
          style: const TextStyle(color: AppColors.secondaryText),
        ),
        loading: () => const Text('Loading...', style: TextStyle(color: AppColors.secondaryText)),
        error: (_, __) => const Text('Error loading', style: TextStyle(color: AppColors.errorRed)),
      ),
      children: [
        matchesAsync.when(
          data: (matches) {
            if (matches.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No completed matches yet',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                ),
              );
            }
            return Column(
              children: matches.map((match) => _buildMatchRow(match)).toList(),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error: $error', style: const TextStyle(color: AppColors.errorRed)),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchRow(Proposal match) {
    final scores = match.scores;
    if (scores == null) return const SizedBox.shrink();

    final creatorWon = scores.creatorGamesWon > scores.opponentGamesWon;
    final winnerName = creatorWon ? match.creatorName : match.acceptedBy?.displayName ?? 'Unknown';
    final loserName = creatorWon ? match.acceptedBy?.displayName ?? 'Unknown' : match.creatorName;
    final scoreDisplay = scores.matchScore;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGray, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Winner/Loser info
          Expanded(
            flex: 3,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
                children: [
                  TextSpan(
                    text: winnerName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' def '),
                  TextSpan(text: loserName),
                ],
              ),
            ),
          ),
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              scoreDisplay,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Location
          Expanded(
            flex: 2,
            child: Text(
              match.location,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(List<Standing> standings) {
    if (standings.isEmpty) return const SizedBox.shrink();

    final totalPlayers = standings.length;
    final totalMatches = standings.fold<int>(0, (sum, s) => sum + s.matchesPlayed);
    final avgWinRate = standings.fold<double>(0, (sum, s) => sum + s.winRate) / totalPlayers;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.people,
            label: 'Players',
            value: totalPlayers.toString(),
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            icon: Icons.sports_tennis,
            label: 'Total Matches',
            value: totalMatches.toString(),
            color: AppColors.accentBlue,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            icon: Icons.trending_up,
            label: 'Avg Win Rate',
            value: '${(avgWinRate * 100).toStringAsFixed(0)}%',
            color: AppColors.warmOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(SkillBracket bracket) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 80,
              color: AppColors.mediumGray,
            ),
            const SizedBox(height: 24),
            Text(
              'No ${bracket.displayName} Players Yet',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Standings will appear here after players complete matches at this skill level.',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Switch to proposals tab
                DefaultTabController.of(context)?.animateTo(0);
              },
              icon: const Icon(Icons.sports_tennis),
              label: const Text('Create a Match'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
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

  Widget _buildErrorState(String error, SkillBracket bracket) {
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
                ref.invalidate(standingsProvider(bracket));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
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
}