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
                  
                  // Skill Level
                  _DetailSection(
                    title: 'Skill Level',
                    icon: Icons.group,
                    child: Builder(
                      builder: (context) {
                        final skillLevel = proposal.skillLevel;
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
                      },
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

                  // Scores section (only for accepted/expired/completed matches with an opponent)
                  if (proposal.acceptedBy != null &&
                      (proposal.status == ProposalStatus.accepted ||
                       proposal.status == ProposalStatus.expired ||
                       proposal.status == ProposalStatus.completed)) ...[
                    const SizedBox(height: 24),
                    _buildScoresSection(context, ref, proposal, currentUser, isOwner),
                  ],

                  const SizedBox(height: 40),

                  // Unaccept button for the user who accepted
                  if (!isOwner &&
                      proposal.status == ProposalStatus.accepted &&
                      proposal.acceptedBy?.userId == currentUser?.id) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showUnacceptDialog(context, ref, proposal),
                        icon: const Icon(Icons.undo),
                        label: const Text('Unaccept Match'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warmOrange,
                          side: const BorderSide(color: AppColors.warmOrange),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

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
                    // Hide delete button if scores have been recorded
                    if (proposal.scores == null) ...[
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

  void _showUnacceptDialog(BuildContext context, WidgetRef ref, Proposal proposal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unaccept Match'),
        content: const Text('Are you sure you want to unaccept this match? The proposal will become available for others to accept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.warmOrange),
            child: const Text('Unaccept'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(proposalActionsProvider).unacceptProposal(proposal.proposalId);
        ref.invalidate(openProposalsProvider);
        ref.invalidate(acceptedProposalsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Match unaccepted successfully'),
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

  Widget _buildScoresSection(BuildContext context, WidgetRef ref, Proposal proposal, dynamic currentUser, bool isOwner) {
    final isAcceptor = proposal.acceptedBy?.userId == currentUser?.id;
    final isParticipant = isOwner || isAcceptor;
    final hasScores = proposal.scores != null;
    final userConfirmed = proposal.scoreConfirmedBy.contains(currentUser?.id);
    final bothConfirmed = proposal.scoreConfirmedBy.length >= 2;

    return _DetailSection(
      title: 'Match Scores',
      icon: Icons.scoreboard,
      child: Column(
        children: [
          if (!hasScores) ...[
            // No scores yet - show record button for participants (if not completed)
            if (isParticipant && proposal.status != ProposalStatus.completed)
              Column(
                children: [
                  Text(
                    'No scores recorded yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRecordScoresDialog(context, ref, proposal),
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Record Scores'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              )
            else if (proposal.status == ProposalStatus.completed)
              // Completed but no scores - show info message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mediumGray.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.mediumGray.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sports_tennis_outlined,
                      color: AppColors.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No scores entered',
                        style: TextStyle(
                          fontSize: 14,
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
                        size: 20,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                'No scores recorded',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),
          ] else ...[
            // Scores exist - show them
            _buildScoreDisplay(proposal),
            const SizedBox(height: 16),

            // Show confirmation status
            if (bothConfirmed || proposal.status == ProposalStatus.completed) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.successGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Scores confirmed by both players',
                      style: TextStyle(
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (userConfirmed) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warmOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warmOrange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, color: AppColors.warmOrange, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Waiting for opponent to confirm',
                      style: TextStyle(
                        color: AppColors.warmOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isParticipant) ...[
              // User hasn't confirmed yet - show confirm/reject buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rejectScores(context, ref, proposal),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: const BorderSide(color: AppColors.errorRed),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmScores(context, ref, proposal, currentUser?.id),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successGreen,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(Proposal proposal) {
    final scores = proposal.scores!;
    final creatorWon = scores.creatorGamesWon > scores.opponentGamesWon;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Match result header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Creator
              Expanded(
                child: Column(
                  children: [
                    Text(
                      proposal.creatorName,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scores.creatorGamesWon}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: creatorWon ? AppColors.successGreen : AppColors.primaryGreen,
                      ),
                    ),
                    if (creatorWon)
                      Text('WINNER', style: TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // VS
              Text(
                '-',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: AppColors.mediumGray),
              ),
              // Opponent
              Expanded(
                child: Column(
                  children: [
                    Text(
                      proposal.acceptedBy!.displayName,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scores.opponentGamesWon}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: !creatorWon ? AppColors.successGreen : AppColors.accentBlue,
                      ),
                    ),
                    if (!creatorWon)
                      Text('WINNER', style: TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          // Individual game scores
          Text('Game Scores', style: TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...scores.games.asMap().entries.map((entry) {
            final index = entry.key;
            final game = entry.value;
            final creatorWonGame = game.creatorScore > game.opponentScore;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game ${index + 1}: ',
                    style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                  ),
                  Text(
                    '${game.creatorScore}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: creatorWonGame ? AppColors.successGreen : AppColors.primaryText,
                    ),
                  ),
                  Text(' - ', style: TextStyle(fontSize: 16, color: AppColors.mediumGray)),
                  Text(
                    '${game.opponentScore}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: !creatorWonGame ? AppColors.successGreen : AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showRecordScoresDialog(BuildContext pageContext, WidgetRef ref, Proposal proposal) {
    // Best of 3 games - use TextEditingControllers for text input
    final controllers = List.generate(3, (_) => [TextEditingController(), TextEditingController()]);

    int _getScore(TextEditingController c) => int.tryParse(c.text) ?? 0;

    // A game is "decided" when at least one player has a score AND scores are different
    // This allows scores like 11-0 to be valid
    bool _isGameDecided(List<TextEditingController> game) {
      final c = _getScore(game[0]);
      final o = _getScore(game[1]);
      final hasScore = c > 0 || o > 0; // At least one score entered (not 0-0)
      return hasScore && c != o;
    }

    int _getCreatorGamesWon(List<List<TextEditingController>> ctrls) {
      int won = 0;
      for (final game in ctrls) {
        if (_isGameDecided(game) && _getScore(game[0]) > _getScore(game[1])) won++;
      }
      return won;
    }

    int _getOpponentGamesWon(List<List<TextEditingController>> ctrls) {
      int won = 0;
      for (final game in ctrls) {
        if (_isGameDecided(game) && _getScore(game[1]) > _getScore(game[0])) won++;
      }
      return won;
    }

    bool _isMatchComplete(List<List<TextEditingController>> ctrls) {
      return _getCreatorGamesWon(ctrls) >= 2 || _getOpponentGamesWon(ctrls) >= 2;
    }

    bool _needsGame3(List<List<TextEditingController>> ctrls) {
      // Game 3 is needed if each player has won 1 game
      return _getCreatorGamesWon(ctrls) == 1 && _getOpponentGamesWon(ctrls) == 1;
    }

    bool _hasGame3Started(List<List<TextEditingController>> ctrls) {
      return _getScore(ctrls[2][0]) > 0 || _getScore(ctrls[2][1]) > 0;
    }

    showDialog(
      context: pageContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final creatorGamesWon = _getCreatorGamesWon(controllers);
          final opponentGamesWon = _getOpponentGamesWon(controllers);
          final matchComplete = _isMatchComplete(controllers);
          final needsGame3 = _needsGame3(controllers);
          final game3Started = _hasGame3Started(controllers);

          return AlertDialog(
            title: const Text('Record Match Scores'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter scores for each game (Best of 3)',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'First to win 2 games wins the match',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  // Header row
                  Row(
                    children: [
                      const SizedBox(width: 70),
                      Expanded(
                        child: Text(
                          proposal.creatorName,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryGreen),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          proposal.acceptedBy!.displayName,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.accentBlue),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Game 1
                  _buildGameScoreInputRow(
                    gameNumber: 1,
                    creatorController: controllers[0][0],
                    opponentController: controllers[0][1],
                    onChanged: () => setState(() {}),
                  ),
                  const SizedBox(height: 12),

                  // Game 2
                  _buildGameScoreInputRow(
                    gameNumber: 2,
                    creatorController: controllers[1][0],
                    opponentController: controllers[1][1],
                    onChanged: () => setState(() {}),
                  ),

                  // Game 3 - always show, never disable to avoid input issues
                  const SizedBox(height: 12),
                  _buildGameScoreInputRow(
                    gameNumber: 3,
                    creatorController: controllers[2][0],
                    opponentController: controllers[2][1],
                    onChanged: () => setState(() {}),
                    isOptional: !needsGame3 && !game3Started,
                    isDisabled: false, // Never disable - let save button validation handle it
                  ),

                  const SizedBox(height: 20),

                  // Match summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: matchComplete
                          ? AppColors.successGreen.withValues(alpha: 0.1)
                          : AppColors.warmOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Match: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              '$creatorGamesWon - $opponentGamesWon',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: matchComplete ? AppColors.successGreen : AppColors.warmOrange,
                              ),
                            ),
                            if (matchComplete) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.check_circle, color: AppColors.successGreen, size: 22),
                            ],
                          ],
                        ),
                        if (!matchComplete)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Enter scores until someone wins 2 games',
                              style: TextStyle(fontSize: 11, color: AppColors.warmOrange),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  for (final game in controllers) {
                    game[0].dispose();
                    game[1].dispose();
                  }
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: matchComplete
                    ? () async {
                        final gameScores = controllers
                            .map((g) => [_getScore(g[0]), _getScore(g[1])])
                            .toList();
                        for (final game in controllers) {
                          game[0].dispose();
                          game[1].dispose();
                        }
                        Navigator.of(dialogContext).pop();
                        await _saveScores(pageContext, ref, proposal, gameScores);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text('Save Scores'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGameScoreInputRow({
    required int gameNumber,
    required TextEditingController creatorController,
    required TextEditingController opponentController,
    required VoidCallback onChanged,
    bool isOptional = false,
    bool isDisabled = false,
  }) {
    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game $gameNumber',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                if (isOptional)
                  Text(
                    '(if needed)',
                    style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
                  ),
              ],
            ),
          ),
          // Creator score input
          Expanded(
            child: TextField(
              key: ValueKey('game${gameNumber}_creator'),
              controller: creatorController,
              enabled: !isDisabled,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 2,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
              decoration: InputDecoration(
                hintText: '0',
                counterText: '', // Hide character counter
                hintStyle: TextStyle(color: AppColors.mediumGray),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
                ),
              ),
              onChanged: (_) => onChanged(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('-', style: TextStyle(fontSize: 20, color: AppColors.mediumGray)),
          ),
          // Opponent score input
          Expanded(
            child: TextField(
              key: ValueKey('game${gameNumber}_opponent'),
              controller: opponentController,
              enabled: !isDisabled,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 2,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
              decoration: InputDecoration(
                hintText: '0',
                counterText: '', // Hide character counter
                hintStyle: TextStyle(color: AppColors.mediumGray),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.accentBlue, width: 2),
                ),
              ),
              onChanged: (_) => onChanged(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveScores(BuildContext context, WidgetRef ref, Proposal proposal, List<List<int>> gameScores) async {
    try {
      // Convert to the format expected by repository
      final games = gameScores
          .where((g) => g[0] > 0 || g[1] > 0) // Only include games that were played
          .map((g) => {'creatorScore': g[0], 'opponentScore': g[1]})
          .toList();

      await ref.read(proposalActionsProvider).updateScores(proposal.proposalId, games);
      ref.invalidate(openProposalsProvider);
      ref.invalidate(userProposalsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scores recorded! Waiting for opponent to confirm.'),
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

  Future<void> _confirmScores(BuildContext context, WidgetRef ref, Proposal proposal, String? userId) async {
    if (userId == null) return;

    try {
      await ref.read(proposalActionsProvider).confirmScores(proposal.proposalId, userId);

      // Check if both players have now confirmed (including the one we just added)
      final updatedConfirmCount = proposal.scoreConfirmedBy.length + 1;
      if (updatedConfirmCount >= 2) {
        await ref.read(proposalActionsProvider).completeMatch(proposal.proposalId);
      }

      ref.invalidate(openProposalsProvider);
      ref.invalidate(userProposalsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updatedConfirmCount >= 2
                ? 'Match completed! Scores confirmed by both players.'
                : 'Scores confirmed! Waiting for opponent.'),
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

  Future<void> _rejectScores(BuildContext context, WidgetRef ref, Proposal proposal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Scores'),
        content: const Text('Are you sure you want to reject these scores? The scores will be cleared and can be re-entered.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Clear scores by setting them to null (we need a new method for this)
        await ref.read(proposalActionsProvider).clearScores(proposal.proposalId);
        ref.invalidate(openProposalsProvider);
        ref.invalidate(userProposalsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Scores rejected. They can now be re-entered.'),
              backgroundColor: AppColors.warmOrange,
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
