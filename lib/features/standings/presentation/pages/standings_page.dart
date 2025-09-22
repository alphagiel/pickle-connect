import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/standing.dart';
import '../../../../shared/providers/standings_providers.dart';
import '../../../../shared/theme/app_colors.dart';
import '../widgets/standing_card.dart';
import '../widgets/skill_level_tabs.dart';

class StandingsPage extends ConsumerStatefulWidget {
  const StandingsPage({super.key});

  @override
  ConsumerState<StandingsPage> createState() => _StandingsPageState();
}

class _StandingsPageState extends ConsumerState<StandingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SkillLevel _selectedSkillLevel = SkillLevel.intermediate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
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
      setState(() {
        _selectedSkillLevel = SkillLevel.values[_tabController.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          Tab(text: 'Intermediate'),
                          Tab(text: 'Advanced+'),
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
                _buildStandingsContent(SkillLevel.beginner),
                _buildStandingsContent(SkillLevel.intermediate),
                _buildStandingsContent(SkillLevel.advancedPlus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingsContent(SkillLevel skillLevel) {
    final standingsAsync = ref.watch(standingsProvider(skillLevel));

    return standingsAsync.when(
      data: (standings) {
        if (standings.isEmpty) {
          return _buildEmptyState(skillLevel);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(standingsProvider(skillLevel));
          },
          child: Column(
            children: [
              // Stats summary
              _buildStatsHeader(standings),
              
              // Rankings list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: standings.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: StandingCard(
                        standing: standings[index],
                        rank: index + 1,
                        skillLevel: skillLevel,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString(), skillLevel),
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

  Widget _buildEmptyState(SkillLevel skillLevel) {
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
              'No ${skillLevel.displayName} Players Yet',
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

  Widget _buildErrorState(String error, SkillLevel skillLevel) {
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
                ref.invalidate(standingsProvider(skillLevel));
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