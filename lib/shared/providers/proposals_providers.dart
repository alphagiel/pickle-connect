import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proposal.dart';
import '../models/user.dart';
import '../repositories/proposals_repository.dart';
import '../../core/utils/stream_retry.dart';
// NOTE: Cleanup service disabled - should be handled by Cloud Functions
// import '../services/proposal_cleanup_service.dart';

/// Parameters for filtering proposals by bracket and zone
class ProposalFilterParams {
  final SkillBracket bracket;
  final String zone;

  ProposalFilterParams({required this.bracket, required this.zone});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProposalFilterParams &&
          runtimeType == other.runtimeType &&
          bracket == other.bracket &&
          zone == other.zone;

  @override
  int get hashCode => bracket.hashCode ^ zone.hashCode;
}

// Provider for open proposals filtered by skill bracket and zone
// Uses retry logic to handle transient auth token refresh issues
final openProposalsProvider = StreamProvider.family<List<Proposal>, ProposalFilterParams>((ref, params) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return retryStream(() => repository.getProposalsForBracketAndZone(params.bracket, params.zone));
});

// Provider for all open proposals (admin only - bypasses skill level filter)
// NOTE: Not used in normal user flows. Keep for potential admin features.
// final allOpenProposalsProvider = StreamProvider<List<Proposal>>((ref) {
//   final repository = ref.watch(proposalsRepositoryProvider);
//   return repository.getOpenProposals();
// });

// Provider for user's created proposals
final userProposalsProvider = StreamProvider.family<List<Proposal>, String>((ref, userId) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getUserProposals(userId);
});

// Provider for user's accepted proposals
final acceptedProposalsProvider = StreamProvider.family<List<Proposal>, String>((ref, userId) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getAcceptedProposals(userId);
});

// Provider for completed proposals (user involved as creator or acceptor)
final completedProposalsProvider = StreamProvider.family<List<Proposal>, String>((ref, userId) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getCompletedProposals(userId);
});

// Provider for expired proposals (user involved as creator or acceptor)
final expiredProposalsProvider = StreamProvider.family<List<Proposal>, String>((ref, userId) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getExpiredProposals(userId);
});

// Provider for completed matches by skill bracket and zone (for standings page)
// Uses retry logic to handle transient auth token refresh issues
final completedMatchesByBracketProvider = StreamProvider.family<List<Proposal>, ProposalFilterParams>((ref, params) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return retryStream(() => repository.getCompletedProposalsByBracketAndZone(params.bracket, params.zone));
});

// Provider for fetching a single proposal by ID (for deep links)
final proposalByIdProvider = FutureProvider.family<Proposal?, String>((ref, proposalId) async {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getProposalById(proposalId);
});

// Provider for selected skill level filter
final selectedSkillLevelProvider = StateProvider<SkillLevel>((ref) => SkillLevel.level3_5);

// Provider for editing proposal - holds the proposal being edited (null when not editing)
final editingProposalProvider = StateProvider<Proposal?>((ref) => null);

// Enum for proposal status filters
enum ProposalStatusFilter {
  all,
  active,
  expired,
}

// Enum for date sort options
enum DateSortFilter {
  upcoming,
  recent,
}

// Filter providers
final proposalStatusFilterProvider = StateProvider<ProposalStatusFilter>((ref) => ProposalStatusFilter.all);
final dateFilterProvider = StateProvider<DateSortFilter>((ref) => DateSortFilter.upcoming);
final creatorFilterProvider = StateProvider<String?>((ref) => null); // null means no filter

// Filtered proposals provider that applies all filters and sorting
final filteredProposalsProvider = Provider.family<AsyncValue<List<Proposal>>, ProposalFilterParams>((ref, params) {
  final proposalsAsync = ref.watch(openProposalsProvider(params));
  final statusFilter = ref.watch(proposalStatusFilterProvider);
  final dateFilter = ref.watch(dateFilterProvider);
  final creatorFilter = ref.watch(creatorFilterProvider);

  return proposalsAsync.when(
    data: (proposals) {
      var filteredProposals = proposals;

      // Apply status filter
      switch (statusFilter) {
        case ProposalStatusFilter.active:
          filteredProposals = filteredProposals
              .where((p) => p.status == ProposalStatus.open || p.status == ProposalStatus.accepted)
              .toList();
          break;
        case ProposalStatusFilter.expired:
          filteredProposals = filteredProposals
              .where((p) => p.status == ProposalStatus.expired)
              .toList();
          break;
        case ProposalStatusFilter.all:
          // No filtering
          break;
      }

      // Apply creator filter
      if (creatorFilter != null && creatorFilter.isNotEmpty) {
        filteredProposals = filteredProposals
            .where((p) => p.creatorName.toLowerCase().contains(creatorFilter.toLowerCase()))
            .toList();
      }

      // Apply additional date sorting if needed
      if (dateFilter == DateSortFilter.recent) {
        filteredProposals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      }

      return AsyncValue.data(filteredProposals);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Filtered user proposals provider
final filteredUserProposalsProvider = Provider.family<AsyncValue<List<Proposal>>, String>((ref, userId) {
  final proposalsAsync = ref.watch(userProposalsProvider(userId));
  final statusFilter = ref.watch(proposalStatusFilterProvider);
  final dateFilter = ref.watch(dateFilterProvider);

  return proposalsAsync.when(
    data: (proposals) {
      var filteredProposals = proposals;

      // Apply status filter
      switch (statusFilter) {
        case ProposalStatusFilter.active:
          filteredProposals = filteredProposals
              .where((p) => p.status == ProposalStatus.open || p.status == ProposalStatus.accepted)
              .toList();
          break;
        case ProposalStatusFilter.expired:
          filteredProposals = filteredProposals
              .where((p) => p.status == ProposalStatus.expired)
              .toList();
          break;
        case ProposalStatusFilter.all:
          // No filtering
          break;
      }

      // Apply additional date sorting if needed
      if (dateFilter == DateSortFilter.recent) {
        filteredProposals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      }

      return AsyncValue.data(filteredProposals);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Notifier for proposal actions
final proposalActionsProvider = Provider<ProposalActions>((ref) {
  return ProposalActions(ref.read(proposalsRepositoryProvider));
});

class ProposalActions {
  final ProposalsRepository _repository;

  ProposalActions(this._repository);

  Future<void> createProposal(Proposal proposal) async {
    await _repository.createProposal(proposal);
  }

  Future<void> acceptProposal(String proposalId, String userId, String displayName) async {
    await _repository.acceptProposal(proposalId, userId, displayName);
  }

  Future<void> unacceptProposal(String proposalId) async {
    await _repository.unacceptProposal(proposalId);
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

  Future<void> updateProposal(
    String proposalId, {
    SkillLevel? skillLevel,
    String? location,
    DateTime? dateTime,
  }) async {
    await _repository.updateProposal(
      proposalId,
      skillLevel: skillLevel,
      location: location,
      dateTime: dateTime,
    );
  }

  Future<void> clearScores(String proposalId) async {
    await _repository.clearScores(proposalId);
  }
}