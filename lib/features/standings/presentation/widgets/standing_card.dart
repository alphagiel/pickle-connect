import 'package:flutter/material.dart';
import '../../../../shared/models/standing.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/theme/app_colors.dart';

class StandingCard extends StatelessWidget {
  final Standing standing;
  final int rank;
  final SkillBracket bracket;

  const StandingCard({
    super.key,
    required this.standing,
    required this.rank,
    required this.bracket,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.cardBackground,
          border: Border.all(
            color: _getRankColor().withValues(alpha: 0.2),
            width: rank <= 3 ? 1.5 : 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildRankBadge(),
              const SizedBox(width: 16),
              _buildPlayerAvatar(),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPlayerInfo(),
              ),
              _buildStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    Color rankColor = _getRankColor();
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: rankColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: rankColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: rank <= 3 
            ? Icon(
                _getRankIcon(),
                color: rankColor,
                size: 24,
              )
            : Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
      ),
    );
  }

  Widget _buildPlayerAvatar() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: _getSkillLevelColor().withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        color: _getSkillLevelColor(),
        size: 28,
      ),
    );
  }

  Widget _buildPlayerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          standing.displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${standing.matchesWon}W • ${standing.matchesLost}L',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildWinRateBar(),
      ],
    );
  }

  Widget _buildWinRateBar() {
    final winRate = standing.winRate;
    final winRateColor = _getWinRateColor(winRate);

    return Row(
      children: [
        Text(
          '${(winRate * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: winRateColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: winRate.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: winRateColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${standing.rankingPoints} pts',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.accentBlue,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${standing.matchesPlayed} matches',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Color _getRankColor() {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.neutralGray;
    }
  }

  IconData _getRankIcon() {
    switch (rank) {
      case 1:
        return Icons.emoji_events; // Trophy
      case 2:
        return Icons.military_tech; // Medal
      case 3:
        return Icons.workspace_premium; // Award
      default:
        return Icons.circle;
    }
  }

  Color _getSkillLevelColor() {
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

  Color _getWinRateColor(double winRate) {
    if (winRate >= 0.7) {
      return AppColors.successGreen;
    } else if (winRate >= 0.5) {
      return AppColors.warmOrange;
    } else {
      return AppColors.errorRed;
    }
  }
}