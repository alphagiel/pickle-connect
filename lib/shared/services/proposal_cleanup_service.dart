import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/proposals_repository.dart';

final proposalCleanupServiceProvider = Provider<ProposalCleanupService>((ref) {
  return ProposalCleanupService(ref.read(proposalsRepositoryProvider));
});

class ProposalCleanupService {
  final ProposalsRepository _repository;

  ProposalCleanupService(this._repository);

  /// Run cleanup on app startup
  Future<void> runStartupCleanup() async {
    try {
      await _repository.runCleanup();
    } catch (e) {
      print('Error during startup cleanup: $e');
    }
  }

  /// Run cleanup before fetching proposals
  Future<void> runCleanupBeforeFetch() async {
    try {
      await _repository.runCleanup();
    } catch (e) {
      print('Error during pre-fetch cleanup: $e');
    }
  }
}