import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/providers/doubles_proposals_providers.dart';
import '../../../../shared/repositories/users_repository.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';

class DoublesProposalDetailsPage extends ConsumerWidget {
  final Proposal proposal;

  const DoublesProposalDetailsPage({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isCreator = currentUser?.id == proposal.creatorId;
    final isPlayer = proposal.playerIds.contains(currentUser?.id);
    final confirmedPlayer = proposal.doublesPlayers
        .where((p) => p.userId == currentUser?.id && p.status == DoublesPlayerStatus.confirmed)
        .firstOrNull;
    final invitedPlayer = proposal.doublesPlayers
        .where((p) => p.userId == currentUser?.id && p.status == DoublesPlayerStatus.invited)
        .firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Doubles Match Details'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/doubles');
            }
          },
        ),
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
                    'Doubles Match',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onPrimary),
                  ),
                  if (proposal.openSlots > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${proposal.openSlots} open slot${proposal.openSlots > 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 16, color: AppColors.onPrimary.withValues(alpha: 0.9)),
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Information
                  _buildSection(
                    title: 'Match Information',
                    icon: Icons.info_outline,
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.location_on, AppColors.accentBlue, 'Location', proposal.location),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.calendar_today, AppColors.warmOrange, 'Date', DateFormat('EEEE, MMMM d, y').format(proposal.dateTime)),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.access_time, AppColors.warmOrange, 'Time', DateFormat('h:mm a').format(proposal.dateTime)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Team 1
                  _buildSection(
                    title: 'Team 1',
                    icon: Icons.group,
                    child: _buildTeamPlayers(proposal, 1),
                  ),

                  const SizedBox(height: 24),

                  // Team 2
                  _buildSection(
                    title: 'Team 2',
                    icon: Icons.group,
                    child: _buildTeamPlayers(proposal, 2),
                  ),

                  // Pending Requests (creator only)
                  if (isCreator && proposal.pendingRequests.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Join Requests (${proposal.pendingRequests.length})',
                      icon: Icons.person_add,
                      child: Column(
                        children: proposal.pendingRequests.map((player) {
                          return _buildJoinRequestCard(context, ref, player);
                        }).toList(),
                      ),
                    ),
                  ],

                  // Pending Invites (for invited user)
                  if (invitedPlayer != null) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Partner Invitation',
                      icon: Icons.mail_outline,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warmOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.warmOrange.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${proposal.creatorName} invited you as a doubles partner!',
                              style: const TextStyle(fontSize: 14, color: AppColors.primaryText, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _declineInvite(context, ref),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.errorRed,
                                      side: const BorderSide(color: AppColors.errorRed),
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _acceptInvite(context, ref),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.successGreen,
                                      foregroundColor: AppColors.onPrimary,
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Scores section (when lobby is filled and match has happened)
                  if (proposal.isFilled &&
                      (proposal.status == ProposalStatus.accepted ||
                       proposal.status == ProposalStatus.completed)) ...[
                    const SizedBox(height: 24),
                    _buildScoresSection(context, ref, currentUser, isPlayer),
                  ],

                  const SizedBox(height: 40),

                  // Action buttons
                  // Request to Join (non-members, open proposals with slots)
                  if (!isPlayer &&
                      proposal.status == ProposalStatus.open &&
                      proposal.openSlots > 0 &&
                      currentUser != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _requestJoin(context, ref, currentUser),
                        icon: const Icon(Icons.group_add),
                        label: const Text('Request to Join'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                  // Leave (confirmed non-creator players)
                  if (confirmedPlayer != null && !isCreator && proposal.status == ProposalStatus.open)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _leaveProposal(context, ref),
                          icon: const Icon(Icons.exit_to_app),
                          label: const Text('Leave Match'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.warmOrange,
                            side: const BorderSide(color: AppColors.warmOrange),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),

                  // Cancel (creator only)
                  if (isCreator && proposal.scores == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _cancelProposal(context, ref),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Cancel Match'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.errorRed,
                            side: const BorderSide(color: AppColors.errorRed),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamPlayers(Proposal proposal, int teamNumber) {
    final teamPlayers = proposal.doublesPlayers
        .where((p) => p.team == teamNumber)
        .toList();
    final emptySlots = 2 - teamPlayers.where((p) => p.status == DoublesPlayerStatus.confirmed).length;
    final teamColor = teamNumber == 1 ? AppColors.primaryGreen : AppColors.accentBlue;

    return Column(
      children: [
        ...teamPlayers.map((p) => _buildPlayerSlot(p, teamColor)),
        ...List.generate(
          emptySlots,
          (_) => _buildEmptySlot(teamColor),
        ),
      ],
    );
  }

  Widget _buildPlayerSlot(DoublesPlayer player, Color teamColor) {
    final statusColor = player.status == DoublesPlayerStatus.confirmed
        ? AppColors.successGreen
        : player.status == DoublesPlayerStatus.invited
            ? AppColors.warmOrange
            : AppColors.accentBlue;
    final statusText = player.status == DoublesPlayerStatus.confirmed
        ? 'Confirmed'
        : player.status == DoublesPlayerStatus.invited
            ? 'Invited'
            : 'Requested';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: teamColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: teamColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: teamColor.withValues(alpha: 0.1),
            radius: 20,
            child: Text(
              player.displayName.isNotEmpty ? player.displayName[0].toUpperCase() : '?',
              style: TextStyle(fontWeight: FontWeight.bold, color: teamColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(Color teamColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.mediumGray.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mediumGray.withValues(alpha: 0.3), style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.mediumGray.withValues(alpha: 0.1),
            radius: 20,
            child: const Icon(Icons.person_add, color: AppColors.mediumGray, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Open slot', style: TextStyle(color: AppColors.secondaryText, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildJoinRequestCard(BuildContext context, WidgetRef ref, DoublesPlayer player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.accentBlue.withValues(alpha: 0.1),
            radius: 20,
            child: Text(
              player.displayName.isNotEmpty ? player.displayName[0].toUpperCase() : '?',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(player.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText)),
          ),
          // Approve to Team 1
          if (proposal.team1.length < 2)
            IconButton(
              onPressed: () => _approvePlayer(context, ref, player.userId, 1),
              icon: const Icon(Icons.check_circle, color: AppColors.primaryGreen),
              tooltip: 'Add to Team 1',
            ),
          // Approve to Team 2
          if (proposal.team2.length < 2)
            IconButton(
              onPressed: () => _approvePlayer(context, ref, player.userId, 2),
              icon: const Icon(Icons.check_circle_outline, color: AppColors.accentBlue),
              tooltip: 'Add to Team 2',
            ),
          // Decline
          IconButton(
            onPressed: () => _declinePlayer(context, ref, player.userId),
            icon: const Icon(Icons.cancel, color: AppColors.errorRed),
            tooltip: 'Decline',
          ),
        ],
      ),
    );
  }

  Widget _buildScoresSection(BuildContext context, WidgetRef ref, dynamic currentUser, bool isPlayer) {
    final hasScores = proposal.scores != null;

    // For doubles: team confirmation
    final team1Confirmed = proposal.scoreConfirmedBy.any((id) =>
      proposal.team1.any((p) => p.userId == id));
    final team2Confirmed = proposal.scoreConfirmedBy.any((id) =>
      proposal.team2.any((p) => p.userId == id));
    final bothTeamsConfirmed = team1Confirmed && team2Confirmed;
    final userConfirmed = proposal.scoreConfirmedBy.contains(currentUser?.id);

    return _buildSection(
      title: 'Match Scores',
      icon: Icons.scoreboard,
      child: Column(
        children: [
          if (!hasScores) ...[
            if (isPlayer && proposal.status != ProposalStatus.completed)
              Column(
                children: [
                  const Text('No scores recorded yet', style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRecordScoresDialog(context, ref),
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
            else
              const Text('No scores recorded', style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
          ] else ...[
            _buildScoreDisplay(),
            const SizedBox(height: 16),
            if (bothTeamsConfirmed || proposal.status == ProposalStatus.completed)
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
                    Text('Scores confirmed by both teams',
                      style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            else if (userConfirmed)
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
                    Text('Waiting for other team to confirm',
                      style: TextStyle(color: AppColors.warmOrange, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            else if (isPlayer)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rejectScores(context, ref),
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
                      onPressed: () => _confirmScores(context, ref, currentUser?.id),
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
      ),
    );
  }

  Widget _buildScoreDisplay() {
    final scores = proposal.scores!;
    final team1Won = scores.creatorGamesWon > scores.opponentGamesWon;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Team 1', style: TextStyle(fontSize: 13, color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('${scores.creatorGamesWon}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: team1Won ? AppColors.successGreen : AppColors.primaryGreen)),
                    if (team1Won) const Text('WINNER', style: TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text('-', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: AppColors.mediumGray)),
              Expanded(
                child: Column(
                  children: [
                    const Text('Team 2', style: TextStyle(fontSize: 13, color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('${scores.opponentGamesWon}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: !team1Won ? AppColors.successGreen : AppColors.accentBlue)),
                    if (!team1Won) const Text('WINNER', style: TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Game Scores', style: TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...scores.games.asMap().entries.map((entry) {
            final index = entry.key;
            final game = entry.value;
            final team1WonGame = game.creatorScore > game.opponentScore;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Game ${index + 1}: ', style: const TextStyle(fontSize: 14, color: AppColors.secondaryText)),
                  Text('${game.creatorScore}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: team1WonGame ? AppColors.successGreen : AppColors.primaryText)),
                  Text(' - ', style: TextStyle(fontSize: 16, color: AppColors.mediumGray)),
                  Text('${game.opponentScore}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: !team1WonGame ? AppColors.successGreen : AppColors.primaryText)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ProposalStatus status) {
    Color statusColor;
    switch (status) {
      case ProposalStatus.open: statusColor = AppColors.openStatus; break;
      case ProposalStatus.accepted: statusColor = AppColors.acceptedStatus; break;
      case ProposalStatus.expired: statusColor = AppColors.expiredStatus; break;
      case ProposalStatus.completed: statusColor = AppColors.completedStatus; break;
      case ProposalStatus.canceled: statusColor = AppColors.canceledStatus; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: AppColors.onPrimary, borderRadius: BorderRadius.circular(20)),
      child: Text(status.displayName.toUpperCase(),
        style: TextStyle(color: statusColor, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray, width: 0.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, Color iconColor, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 16, color: AppColors.primaryText, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // Actions
  void _requestJoin(BuildContext context, WidgetRef ref, dynamic currentUser) async {
    try {
      final usersRepository = ref.read(usersRepositoryProvider);
      final userProfile = await usersRepository.getUserById(currentUser.id);
      final player = DoublesPlayer(
        userId: currentUser.id,
        displayName: userProfile?.displayName ?? 'Unknown',
        status: DoublesPlayerStatus.requested,
      );
      await ref.read(doublesProposalActionsProvider).requestJoin(proposal.proposalId, player);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Join request sent!'), backgroundColor: AppColors.successGreen));
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  void _approvePlayer(BuildContext context, WidgetRef ref, String userId, int team) async {
    try {
      await ref.read(doublesProposalActionsProvider).approvePlayer(proposal.proposalId, userId, team);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Player approved to Team $team!'), backgroundColor: AppColors.successGreen));
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  void _declinePlayer(BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref.read(doublesProposalActionsProvider).declinePlayer(proposal.proposalId, userId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Player declined'), backgroundColor: AppColors.warmOrange));
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  void _leaveProposal(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Match'),
        content: const Text('Are you sure you want to leave this doubles match?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.warmOrange),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        final currentUser = ref.read(currentUserProvider);
        await ref.read(doublesProposalActionsProvider).leaveProposal(proposal.proposalId, currentUser!.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You left the match'), backgroundColor: AppColors.warmOrange));
          context.go('/doubles');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
        }
      }
    }
  }

  void _acceptInvite(BuildContext context, WidgetRef ref) async {
    try {
      final currentUser = ref.read(currentUserProvider);
      await ref.read(doublesProposalActionsProvider).confirmPartnerInvite(proposal.proposalId, currentUser!.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partner invite accepted!'), backgroundColor: AppColors.successGreen));
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  void _declineInvite(BuildContext context, WidgetRef ref) async {
    try {
      final currentUser = ref.read(currentUserProvider);
      await ref.read(doublesProposalActionsProvider).leaveProposal(proposal.proposalId, currentUser!.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invite declined'), backgroundColor: AppColors.warmOrange));
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  void _cancelProposal(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Doubles Match'),
        content: const Text('Are you sure you want to cancel this doubles match?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Cancel Match'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(doublesProposalActionsProvider).deleteProposal(proposal.proposalId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doubles match cancelled'), backgroundColor: AppColors.successGreen));
          context.go('/doubles');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
        }
      }
    }
  }

  void _showRecordScoresDialog(BuildContext pageContext, WidgetRef ref) {
    final controllers = List.generate(3, (_) => [TextEditingController(), TextEditingController()]);

    int getScore(TextEditingController c) => int.tryParse(c.text) ?? 0;
    bool isGameDecided(List<TextEditingController> game) {
      final c = getScore(game[0]);
      final o = getScore(game[1]);
      return (c > 0 || o > 0) && c != o;
    }
    int getTeam1Won(List<List<TextEditingController>> ctrls) =>
        ctrls.where((g) => isGameDecided(g) && getScore(g[0]) > getScore(g[1])).length;
    int getTeam2Won(List<List<TextEditingController>> ctrls) =>
        ctrls.where((g) => isGameDecided(g) && getScore(g[1]) > getScore(g[0])).length;
    bool isMatchComplete(List<List<TextEditingController>> ctrls) =>
        getTeam1Won(ctrls) >= 2 || getTeam2Won(ctrls) >= 2;

    showDialog(
      context: pageContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final t1Won = getTeam1Won(controllers);
          final t2Won = getTeam2Won(controllers);
          final complete = isMatchComplete(controllers);

          return AlertDialog(
            title: const Text('Record Match Scores'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter scores for each game (Best of 3)', style: TextStyle(color: AppColors.secondaryText, fontSize: 14)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 70),
                      Expanded(child: Text('Team 1', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryGreen), textAlign: TextAlign.center)),
                      const SizedBox(width: 16),
                      Expanded(child: Text('Team 2', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.accentBlue), textAlign: TextAlign.center)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(3, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildGameScoreInputRow(i + 1, controllers[i][0], controllers[i][1], () => setState(() {})),
                  )),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: complete ? AppColors.successGreen.withValues(alpha: 0.1) : AppColors.warmOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Match: ', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('$t1Won - $t2Won', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: complete ? AppColors.successGreen : AppColors.warmOrange)),
                        if (complete) ...[const SizedBox(width: 8), Icon(Icons.check_circle, color: AppColors.successGreen, size: 22)],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  for (final game in controllers) { game[0].dispose(); game[1].dispose(); }
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: complete
                    ? () async {
                        final games = controllers
                            .map((g) => {'creatorScore': getScore(g[0]), 'opponentScore': getScore(g[1])})
                            .where((g) => (g['creatorScore']! > 0 || g['opponentScore']! > 0))
                            .toList();
                        for (final game in controllers) { game[0].dispose(); game[1].dispose(); }
                        Navigator.of(dialogContext).pop();
                        await _saveScores(pageContext, ref, games);
                      }
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: AppColors.onPrimary),
                child: const Text('Save Scores'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGameScoreInputRow(int gameNumber, TextEditingController c1, TextEditingController c2, VoidCallback onChanged) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text('Game $gameNumber', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
        Expanded(
          child: TextField(
            controller: c1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 2,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
            decoration: InputDecoration(
              hintText: '0', counterText: '',
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.primaryGreen, width: 2)),
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('-', style: TextStyle(fontSize: 20, color: AppColors.mediumGray))),
        Expanded(
          child: TextField(
            controller: c2,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 2,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
            decoration: InputDecoration(
              hintText: '0', counterText: '',
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.accentBlue, width: 2)),
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
      ],
    );
  }

  Future<void> _saveScores(BuildContext context, WidgetRef ref, List<Map<String, int>> games) async {
    try {
      await ref.read(doublesProposalActionsProvider).updateScores(proposal.proposalId, games);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scores recorded!'), backgroundColor: AppColors.successGreen));
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  Future<void> _confirmScores(BuildContext context, WidgetRef ref, String? userId) async {
    if (userId == null) return;
    try {
      await ref.read(doublesProposalActionsProvider).confirmScores(proposal.proposalId, userId);

      // Check if both teams confirmed (current team + other team)
      final updatedConfirmBy = [...proposal.scoreConfirmedBy, userId];
      final team1Confirmed = updatedConfirmBy.any((id) => proposal.team1.any((p) => p.userId == id));
      final team2Confirmed = updatedConfirmBy.any((id) => proposal.team2.any((p) => p.userId == id));

      if (team1Confirmed && team2Confirmed) {
        await ref.read(doublesProposalActionsProvider).completeMatch(proposal.proposalId);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(team1Confirmed && team2Confirmed
                ? 'Match completed! Scores confirmed by both teams.'
                : 'Scores confirmed! Waiting for other team.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        context.go('/doubles');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
      }
    }
  }

  Future<void> _rejectScores(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Scores'),
        content: const Text('Are you sure? Scores will be cleared and can be re-entered.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
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
        await ref.read(doublesProposalActionsProvider).clearScores(proposal.proposalId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Scores rejected'), backgroundColor: AppColors.warmOrange));
          context.go('/doubles');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed));
        }
      }
    }
  }
}
