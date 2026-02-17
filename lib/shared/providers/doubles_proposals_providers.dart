import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proposal.dart';
import '../repositories/proposals_repository.dart';
import '../../core/utils/stream_retry.dart';
import 'proposals_providers.dart' show ProposalFilterParams;

/// Open doubles proposals for a skill bracket and zone
final openDoublesProposalsProvider = StreamProvider.family<List<Proposal>, ProposalFilterParams>((ref, params) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return retryStream(() => repository.getDoublesProposalsForBracketAndZone(params.bracket, params.zone));
});

/// User's doubles proposals (any status where user is a playerIds member)
final userDoublesProposalsProvider = StreamProvider.family<List<Proposal>, String>((ref, userId) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return retryStream(() => repository.getUserDoublesProposals(userId));
});

/// Completed doubles proposals for a user
final completedDoublesProposalsProvider = StreamProvider.family<List<Proposal>, String>((ref, userId) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return retryStream(() => repository.getCompletedDoublesProposals(userId));
});

/// Filter providers for doubles (reuse enums from proposals_providers)
final doublesStatusFilterProvider = StateProvider<DoublesStatusFilter>((ref) => DoublesStatusFilter.all);

enum DoublesStatusFilter { all, active, completed }

/// Filtered doubles proposals
final filteredDoublesProposalsProvider = Provider.family<AsyncValue<List<Proposal>>, ProposalFilterParams>((ref, params) {
  final proposalsAsync = ref.watch(openDoublesProposalsProvider(params));
  final statusFilter = ref.watch(doublesStatusFilterProvider);

  return proposalsAsync.when(
    data: (proposals) {
      var filtered = proposals;
      switch (statusFilter) {
        case DoublesStatusFilter.active:
          filtered = filtered.where((p) => p.status == ProposalStatus.open).toList();
          break;
        case DoublesStatusFilter.completed:
          filtered = filtered.where((p) => p.status == ProposalStatus.completed).toList();
          break;
        case DoublesStatusFilter.all:
          break;
      }
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Actions provider for doubles proposals
final doublesProposalActionsProvider = Provider<DoublesProposalActions>((ref) {
  return DoublesProposalActions(ref.read(proposalsRepositoryProvider));
});

class DoublesProposalActions {
  final ProposalsRepository _repository;

  DoublesProposalActions(this._repository);

  Future<void> createDoublesProposal(Proposal proposal) async {
    await _repository.createProposal(proposal);
  }

  Future<void> requestJoin(String proposalId, DoublesPlayer player) async {
    await _repository.requestJoinDoubles(proposalId, player);
  }

  Future<void> approvePlayer(String proposalId, String userId, int team) async {
    await _repository.approveDoublesPlayer(proposalId, userId, team);
  }

  Future<void> declinePlayer(String proposalId, String userId) async {
    await _repository.declineDoublesPlayer(proposalId, userId);
  }

  Future<void> leaveProposal(String proposalId, String userId) async {
    await _repository.leaveDoublesProposal(proposalId, userId);
  }

  Future<void> confirmPartnerInvite(String proposalId, String userId) async {
    await _repository.confirmPartnerInvite(proposalId, userId);
  }

  Future<void> updateScores(String proposalId, List<Map<String, int>> games) async {
    await _repository.updateScores(proposalId, games);
  }

  Future<void> confirmScores(String proposalId, String userId) async {
    await _repository.confirmScores(proposalId, userId);
  }

  Future<void> completeMatch(String proposalId) async {
    await _repository.completeMatch(proposalId);
  }

  Future<void> cancelProposal(String proposalId) async {
    await _repository.cancelProposal(proposalId);
  }

  Future<void> deleteProposal(String proposalId) async {
    await _repository.deleteProposal(proposalId);
  }

  Future<void> clearScores(String proposalId) async {
    await _repository.clearScores(proposalId);
  }
}
