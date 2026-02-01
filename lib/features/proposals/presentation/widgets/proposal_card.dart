import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/theme/app_colors.dart';

class ProposalCard extends StatelessWidget {
  final Proposal proposal;
  final bool showActions;
  final VoidCallback? onAccept;
  final VoidCallback? onDelete;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final bool acceptDisabled;
  final String? acceptDisabledReason;

  const ProposalCard({
    super.key,
    required this.proposal,
    this.showActions = true,
    this.onAccept,
    this.onDelete,
    this.onView,
    this.onEdit,
    this.onCancel,
    this.acceptDisabled = false,
    this.acceptDisabledReason,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = proposal.status == ProposalStatus.expired;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isExpired ? 1 : 2,
      shadowColor: Colors.black.withValues(alpha: isExpired ? 0.05 : 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isExpired
            ? AppColors.cardBackground.withValues(alpha: 0.6)
            : AppColors.cardBackground,
          border: Border.all(
            color: isExpired
              ? AppColors.mediumGray.withValues(alpha: 0.5)
              : AppColors.lightGray,
            width: 0.5,
          ),
        ),
        child: Opacity(
          opacity: isExpired ? 0.7 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildMatchDetails(),
                const SizedBox(height: 16),
                _buildSkillLevel(),
                if (isExpired) ...[
                  const SizedBox(height: 16),
                  _buildExpiredMessage(),
                ],
                if (proposal.status == ProposalStatus.completed && proposal.scores == null) ...[
                  const SizedBox(height: 16),
                  _buildNoScoresMessage(),
                ],
                if (showActions && (proposal.status == ProposalStatus.open || proposal.status == ProposalStatus.accepted)) ...[
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Creator avatar
        CircleAvatar(
          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
          radius: 24,
          child: Icon(
            Icons.person,
            color: AppColors.primaryGreen,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        
        // Creator info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proposal.creatorName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Looking for a match',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        
        // Status badge
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    Color backgroundColor;

    switch (proposal.status) {
      case ProposalStatus.open:
        statusColor = AppColors.openStatus;
        backgroundColor = AppColors.openStatusLight;
        break;
      case ProposalStatus.accepted:
        statusColor = AppColors.acceptedStatus;
        backgroundColor = AppColors.acceptedStatusLight;
        break;
      case ProposalStatus.expired:
        statusColor = AppColors.expiredStatus;
        backgroundColor = AppColors.expiredStatusLight;
        break;
      case ProposalStatus.completed:
        statusColor = AppColors.completedStatus;
        backgroundColor = AppColors.completedStatusLight;
        break;
      case ProposalStatus.canceled:
        statusColor = AppColors.canceledStatus;
        backgroundColor = AppColors.canceledStatusLight;
        break;
    }

    // Show score instead of "Accepted" when scores exist
    final hasScores = proposal.scores != null;
    final displayText = hasScores
        ? proposal.scores!.matchScore  // e.g., "2-1"
        : proposal.status.displayName.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: hasScores ? AppColors.completedStatusLight : backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasScores) ...[
            Icon(Icons.scoreboard, size: 14, color: AppColors.completedStatus),
            const SizedBox(width: 4),
          ],
          Text(
            displayText,
            style: TextStyle(
              color: hasScores ? AppColors.completedStatus : statusColor,
              fontSize: hasScores ? 14 : 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchDetails() {
    return Column(
      children: [
        // Location
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 18,
              color: AppColors.accentBlue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                proposal.location,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Date and time
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 18,
              color: AppColors.warmOrange,
            ),
            const SizedBox(width: 8),
            Text(
              _formatDateTime(proposal.dateTime),
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        // Show match result if scores exist, otherwise show accepted by
        if (proposal.scores != null && proposal.acceptedBy != null) ...[
          const SizedBox(height: 12),
          _buildMatchResult(),
        ] else if (proposal.acceptedBy != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 18,
                color: AppColors.successGreen,
              ),
              const SizedBox(width: 8),
              Text(
                'Accepted by ${proposal.acceptedBy!.displayName}',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSkillLevel() {
    final skillLevel = proposal.skillLevel;
    return Row(
      children: [
        Icon(
          Icons.group,
          size: 18,
          color: AppColors.softPurple,
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getSkillLevelColor(skillLevel).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getSkillLevelColor(skillLevel).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            skillLevel.displayName,
            style: TextStyle(
              fontSize: 12,
              color: _getSkillLevelColor(skillLevel),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    // Hide delete button if scores have been recorded
    final hasScores = proposal.scores != null;
    final canDelete = onDelete != null && !hasScores;

    // Determine if we should show the Accept button (enabled or disabled)
    final showAcceptButton = (onAccept != null || acceptDisabled) && proposal.status == ProposalStatus.open;

    // Determine if we should show the second button (Accept/Delete)
    final showSecondButton = canDelete || showAcceptButton;

    return Row(
      children: [
        // View button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onView,
            icon: const Icon(Icons.visibility, size: 18),
            label: const Text('View'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentBlue,
              side: BorderSide(color: AppColors.accentBlue.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        if (showSecondButton) ...[
          const SizedBox(width: 12),

          // Accept or Delete button
          Expanded(
            child: canDelete
                ? ElevatedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                : _buildAcceptButton(),
          ),
        ],
      ],
    );
  }

  Widget _buildAcceptButton() {
    final button = ElevatedButton.icon(
      onPressed: acceptDisabled ? null : onAccept,
      icon: const Icon(Icons.sports_tennis, size: 18),
      label: const Text('Accept'),
      style: ElevatedButton.styleFrom(
        backgroundColor: acceptDisabled
            ? AppColors.mediumGray
            : AppColors.primaryGreen,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.mediumGray.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );

    // Wrap with Tooltip if disabled with a reason
    if (acceptDisabled && acceptDisabledReason != null) {
      return Tooltip(
        message: acceptDisabledReason!,
        child: button,
      );
    }

    return button;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final proposalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');
    
    if (proposalDate == today) {
      return 'Today at ${timeFormat.format(dateTime)}';
    } else if (proposalDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow at ${timeFormat.format(dateTime)}';
    } else {
      return '${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}';
    }
  }

  Widget _buildExpiredMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.expiredStatusLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.expiredStatus.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            color: AppColors.expiredStatus,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This match has expired. Scores can no longer be entered.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.expiredStatus,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoScoresMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.mediumGray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sports_tennis_outlined,
            color: AppColors.secondaryText,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No scores entered',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Tooltip(
            message: 'This match did not count towards ranking because no scores were entered by the players involved.',
            child: Icon(
              Icons.info_outline,
              color: AppColors.secondaryText,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSkillLevelColor(SkillLevel skillLevel) {
    switch (skillLevel.bracket) {
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

  Widget _buildMatchResult() {
    final scores = proposal.scores!;
    final creatorWon = scores.creatorGamesWon > scores.opponentGamesWon;
    final winnerName = creatorWon ? proposal.creatorName : proposal.acceptedBy!.displayName;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events,
            size: 20,
            color: AppColors.warmOrange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: AppColors.primaryText),
                children: [
                  TextSpan(
                    text: winnerName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' won  '),
                  TextSpan(
                    text: scores.matchScore,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}