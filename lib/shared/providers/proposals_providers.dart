import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proposal.dart';
import '../models/user.dart';
import '../repositories/proposals_repository.dart';
import '../services/proposal_cleanup_service.dart';

// Provider for open proposals filtered by skill level
final openProposalsProvider = StreamProvider.family<List<Proposal>, SkillLevel>((ref, skillLevel) {
  final repository = ref.watch(proposalsRepositoryProvider);
  final cleanupService = ref.watch(proposalCleanupServiceProvider);

  // Run cleanup before fetching
  cleanupService.runCleanupBeforeFetch();

  return repository.getProposalsForSkillLevel(skillLevel);
});

// Provider for all open proposals
final allOpenProposalsProvider = StreamProvider<List<Proposal>>((ref) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getOpenProposals();
});

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

// Provider for completed matches by skill level (for standings page)
final completedMatchesBySkillLevelProvider = StreamProvider.family<List<Proposal>, SkillLevel>((ref, skillLevel) {
  final repository = ref.watch(proposalsRepositoryProvider);
  return repository.getCompletedProposalsBySkillLevel(skillLevel);
});

// Provider for selected skill level filter
final selectedSkillLevelProvider = StateProvider<SkillLevel>((ref) => SkillLevel.intermediate);

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
final filteredProposalsProvider = Provider.family<AsyncValue<List<Proposal>>, SkillLevel>((ref, skillLevel) {
  final proposalsAsync = ref.watch(openProposalsProvider(skillLevel));
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