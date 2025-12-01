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

  const ProposalCard({
    super.key,
    required this.proposal,
    this.showActions = true,
    this.onAccept,
    this.onDelete,
    this.onView,
    this.onEdit,
    this.onCancel,
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
                _buildSkillLevels(),
                if (isExpired) ...[
                  const SizedBox(height: 16),
                  _buildExpiredMessage(),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        proposal.status.displayName.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
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
        
        // Show accepted by if applicable
        if (proposal.acceptedBy != null) ...[
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

  Widget _buildSkillLevels() {
    return Row(
      children: [
        Icon(
          Icons.group,
          size: 18,
          color: AppColors.softPurple,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: proposal.skillLevels.map((skillLevel) {
              return Container(
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
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    // Determine if we should show the second button (Accept/Delete)
    final showSecondButton = onDelete != null || (onAccept != null && proposal.status == ProposalStatus.open);

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
            child: onDelete != null
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
                : ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.sports_tennis, size: 18),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
          ),
        ],
      ],
    );
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

  Color _getSkillLevelColor(SkillLevel skillLevel) {
    switch (skillLevel) {
      case SkillLevel.beginner:
        return const Color.fromARGB(255, 136, 121, 121);
      case SkillLevel.intermediate:
        return AppColors.intermediateColor;
      case SkillLevel.advancedPlus:
        return AppColors.advancedColor;
    }
  }
}