import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';

class ProposalDetailsPage extends ConsumerWidget {
  final Proposal proposal;

  const ProposalDetailsPage({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.id == proposal.creatorId;
    final canEdit = isOwner && proposal.status == ProposalStatus.open;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Match Details'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        actions: [
          // Edit button (only for owner and open proposals)
          if (canEdit)
            IconButton(
              onPressed: () => context.go('/edit-proposal', extra: proposal),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Proposal',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryGreen, AppColors.darkGreen],
                ),
              ),
              child: Column(
                children: [
                  _buildStatusBadge(proposal.status),
                  const SizedBox(height: 16),
                  const Text(
                    'Pickleball Match',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Information
                  _DetailSection(
                    title: 'Match Information',
                    icon: Icons.info_outline,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.location_on,
                          iconColor: AppColors.accentBlue,
                          label: 'Location',
                          value: proposal.location,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.calendar_today,
                          iconColor: AppColors.warmOrange,
                          label: 'Date',
                          value: DateFormat('EEEE, MMMM d, y').format(proposal.dateTime),
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.access_time,
                          iconColor: AppColors.warmOrange,
                          label: 'Time',
                          value: DateFormat('h:mm a').format(proposal.dateTime),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Skill Levels
                  _DetailSection(
                    title: 'Skill Levels',
                    icon: Icons.group,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: proposal.skillLevels.map((skillLevel) {
                        final color = _getSkillLevelColor(skillLevel);
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: Text(
                            skillLevel.displayName,
                            style: TextStyle(
                              fontSize: 14,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Organizer
                  _DetailSection(
                    title: 'Organizer',
                    icon: Icons.person,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                          radius: 28,
                          child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 28),
                        ),
                        const SizedBox(width: 16),
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
                              const SizedBox(height: 4),
                              const Text(
                                'Match Creator',
                                style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Opponent (if accepted)
                  if (proposal.acceptedBy != null) ...[
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Opponent',
                      icon: Icons.check_circle,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.successGreen.withValues(alpha: 0.1),
                            radius: 28,
                            child: const Icon(Icons.person, color: AppColors.successGreen, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  proposal.acceptedBy!.displayName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Accepted Match',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.successGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Status
                  _DetailSection(
                    title: 'Status',
                    icon: Icons.info,
                    child: _StatusInfo(status: proposal.status),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Action buttons for owner
                  if (isOwner) ...[
                    if (canEdit)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/edit-proposal', extra: proposal),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Proposal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteDialog(context, ref, proposal),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete Proposal'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.errorRed,
                          side: const BorderSide(color: AppColors.errorRed),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ProposalStatus status) {
    Color statusColor;
    
    switch (status) {
      case ProposalStatus.open:
        statusColor = AppColors.openStatus;
        break;
      case ProposalStatus.accepted:
        statusColor = AppColors.acceptedStatus;
        break;
      case ProposalStatus.expired:
        statusColor = AppColors.expiredStatus;
        break;
      case ProposalStatus.completed:
        statusColor = AppColors.completedStatus;
        break;
      case ProposalStatus.canceled:
        statusColor = AppColors.canceledStatus;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.displayName.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Proposal proposal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Proposal'),
        content: const Text('Are you sure you want to delete this match proposal? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(proposalActionsProvider).deleteProposal(proposal.proposalId);
        ref.invalidate(openProposalsProvider);
        ref.invalidate(userProposalsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proposal deleted successfully'),
              backgroundColor: AppColors.successGreen,
            ),
          );
          context.go('/');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      }
    }
  }
}

// Helper widgets
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusInfo extends StatelessWidget {
  final ProposalStatus status;

  const _StatusInfo({required this.status});

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case ProposalStatus.open:
        statusText = 'This match is open and available for players to accept.';
        statusColor = AppColors.openStatus;
        statusIcon = Icons.check_circle_outline;
        break;
      case ProposalStatus.accepted:
        statusText = 'This match has been accepted and is scheduled.';
        statusColor = AppColors.acceptedStatus;
        statusIcon = Icons.event_available;
        break;
      case ProposalStatus.expired:
        statusText = 'This match has expired and is no longer available.';
        statusColor = AppColors.expiredStatus;
        statusIcon = Icons.schedule;
        break;
      case ProposalStatus.completed:
        statusText = 'This match has been completed.';
        statusColor = AppColors.completedStatus;
        statusIcon = Icons.check_circle;
        break;
      case ProposalStatus.canceled:
        statusText = 'This match has been canceled.';
        statusColor = AppColors.canceledStatus;
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 14,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
