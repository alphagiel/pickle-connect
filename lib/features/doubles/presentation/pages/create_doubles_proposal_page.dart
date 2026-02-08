import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/providers/doubles_proposals_providers.dart';
import '../../../../shared/providers/users_providers.dart';
import '../../../../shared/repositories/users_repository.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';

const bool kAllowPastProposals = true;

class CreateDoublesProposalPage extends ConsumerStatefulWidget {
  const CreateDoublesProposalPage({super.key});

  @override
  ConsumerState<CreateDoublesProposalPage> createState() => _CreateDoublesProposalPageState();
}

class _CreateDoublesProposalPageState extends ConsumerState<CreateDoublesProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _partnerSearchController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  bool _isLoading = false;
  bool _hasPartner = false;
  User? _selectedPartner;
  String _partnerSearchQuery = '';

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    _partnerSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Create Doubles Match'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _navigateBack(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login_outlined, size: 80, color: AppColors.mediumGray),
              const SizedBox(height: 24),
              const Text('Please log in', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Go to Login'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: AppColors.onPrimary),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Doubles Match'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.group, size: 48, color: AppColors.primaryGreen),
                      SizedBox(height: 12),
                      Text('Create Doubles Match',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                      SizedBox(height: 4),
                      Text('Find partners and opponents for doubles',
                        style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Date & Time
                _buildSectionCard(
                  title: 'When do you want to play?',
                  icon: Icons.schedule,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDateTimeButton(
                          label: 'Date',
                          value: _formatDate(_selectedDate),
                          icon: Icons.calendar_today,
                          onTap: _selectDate,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateTimeButton(
                          label: 'Time',
                          value: _formatTime(_selectedTime),
                          icon: Icons.access_time,
                          onTap: _selectTime,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Location
                _buildSectionCard(
                  title: 'Where do you want to play?',
                  icon: Icons.location_on,
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.primaryText),
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Clayton Tennis Courts, Smithfield Park...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.place_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter a location';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Partner selection
                _buildSectionCard(
                  title: 'Do you have a partner?',
                  icon: Icons.person_add,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('I have a partner',
                          style: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500)),
                        subtitle: Text(_hasPartner
                            ? 'Your partner will receive an invitation'
                            : 'Toggle to invite a specific partner',
                          style: const TextStyle(color: AppColors.secondaryText, fontSize: 13)),
                        value: _hasPartner,
                        activeColor: AppColors.primaryGreen,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _hasPartner = value;
                            if (!value) {
                              _selectedPartner = null;
                              _partnerSearchQuery = '';
                              _partnerSearchController.clear();
                            }
                          });
                        },
                      ),
                      if (_hasPartner) ...[
                        const SizedBox(height: 12),
                        if (_selectedPartner != null) ...[
                          // Show selected partner
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.successGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                                  radius: 20,
                                  child: const Icon(Icons.person, color: AppColors.primaryGreen),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_selectedPartner!.displayName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                                      Text('${_selectedPartner!.skillLevel.displayName} - ${_selectedPartner!.location}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: AppColors.errorRed),
                                  onPressed: () => setState(() {
                                    _selectedPartner = null;
                                    _partnerSearchQuery = '';
                                    _partnerSearchController.clear();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Search for partner
                          TextFormField(
                            controller: _partnerSearchController,
                            style: const TextStyle(color: AppColors.primaryText),
                            decoration: InputDecoration(
                              hintText: 'Search by name...',
                              hintStyle: TextStyle(color: AppColors.secondaryText.withValues(alpha: 0.7)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.mediumGray),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
                            ),
                            onChanged: (value) {
                              setState(() => _partnerSearchQuery = value);
                            },
                          ),
                          if (_partnerSearchQuery.length >= 2)
                            _buildSearchResults()
                          else
                            _buildSkillLevelPlayers(),
                        ],
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Notes
                _buildSectionCard(
                  title: 'Additional Notes (Optional)',
                  icon: Icons.note_outlined,
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.primaryText),
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any specific requests, preferences, or details...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.accentBlue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _hasPartner
                              ? 'Your match will need 2 more opponents to join.'
                              : 'Your match will need 3 more players to join.',
                          style: const TextStyle(fontSize: 13, color: AppColors.accentBlue),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => _navigateBack(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.neutralGray,
                          side: const BorderSide(color: AppColors.mediumGray),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createProposal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary)),
                              )
                            : const Text('Create Doubles Match',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchAsync = ref.watch(searchUsersProvider(_partnerSearchQuery));
    final currentUser = ref.watch(currentUserProvider);

    return searchAsync.when(
      data: (users) {
        // Filter out current user
        final filteredUsers = users.where((u) => u.userId != currentUser?.id).toList();
        if (filteredUsers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No users found', style: TextStyle(color: AppColors.secondaryText)),
          );
        }
        return Container(
          margin: const EdgeInsets.only(top: 8),
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, color: AppColors.primaryGreen),
                ),
                title: Text(user.displayName,
                  style: const TextStyle(color: AppColors.primaryText)),
                subtitle: Text('${user.skillLevel.displayName} - ${user.location}',
                  style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                onTap: () {
                  setState(() {
                    _selectedPartner = user;
                    _partnerSearchQuery = '';
                    _partnerSearchController.clear();
                  });
                },
              );
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Error: $e', style: const TextStyle(color: AppColors.errorRed, fontSize: 12)),
      ),
    );
  }

  Widget _buildSkillLevelPlayers() {
    final currentUser = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (currentUser == null || profile == null) return const SizedBox.shrink();
        return _buildSkillLevelPlayersList(profile, currentUser.id);
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildSkillLevelPlayersList(User profile, String currentUserId) {
    final usersAsync = ref.watch(usersBySkillLevelProvider(profile.skillLevel));

    return usersAsync.when(
      data: (users) {
        final filteredUsers = users.where((u) => u.userId != currentUserId).toList();
        if (filteredUsers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No players found at your skill level', style: TextStyle(color: AppColors.secondaryText)),
          );
        }
        return Container(
          margin: const EdgeInsets.only(top: 8),
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Text('Players at your level (${profile.skillLevel.displayName})',
                  style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                        radius: 16,
                        child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 18),
                      ),
                      title: Text(user.displayName, style: const TextStyle(color: AppColors.primaryText)),
                      subtitle: Text(user.location,
                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      onTap: () {
                        setState(() {
                          _selectedPartner = user;
                          _partnerSearchQuery = '';
                          _partnerSearchController.clear();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray, width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDateTimeButton({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mediumGray),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16, color: AppColors.primaryText, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: kAllowPastProposals ? DateTime.now().subtract(const Duration(days: 30)) : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primaryGreen)),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primaryGreen)),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _createProposal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_hasPartner && _selectedPartner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a partner or toggle off "I have a partner"'), backgroundColor: AppColors.errorRed),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not authenticated');

      final usersRepository = ref.read(usersRepositoryProvider);
      final userProfile = await usersRepository.getUserById(currentUser.id);
      if (userProfile == null) throw Exception('Please complete your profile first');

      final scheduledDateTime = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _selectedTime.hour, _selectedTime.minute,
      );

      // Build doubles players list
      final doublesPlayers = <DoublesPlayer>[
        // Creator is always team 1, confirmed
        DoublesPlayer(
          userId: currentUser.id,
          displayName: userProfile.displayName,
          team: 1,
          status: DoublesPlayerStatus.confirmed,
        ),
      ];

      final playerIds = <String>[currentUser.id];
      int openSlots = 3;

      // Add partner if selected
      if (_hasPartner && _selectedPartner != null) {
        doublesPlayers.add(DoublesPlayer(
          userId: _selectedPartner!.userId,
          displayName: _selectedPartner!.displayName,
          team: 1,
          status: DoublesPlayerStatus.invited,
          invitedBy: currentUser.id,
        ));
        playerIds.add(_selectedPartner!.userId);
        openSlots = 2;
      }

      final proposal = Proposal(
        proposalId: DateTime.now().millisecondsSinceEpoch.toString(),
        creatorId: currentUser.id,
        creatorName: userProfile.displayName,
        skillLevel: userProfile.skillLevel,
        skillBracket: userProfile.skillLevel.bracket,
        location: _locationController.text.trim(),
        dateTime: scheduledDateTime,
        status: ProposalStatus.open,
        scores: null,
        acceptedBy: null,
        scoreConfirmedBy: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        matchType: MatchType.doubles,
        doublesPlayers: doublesPlayers,
        openSlots: openSlots,
        playerIds: playerIds,
      );

      await ref.read(doublesProposalActionsProvider).createDoublesProposal(proposal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doubles match created successfully!'), backgroundColor: AppColors.successGreen),
        );
        context.go('/doubles');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create doubles match: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/doubles');
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final proposalDate = DateTime(date.year, date.month, date.day);
    if (proposalDate == today) return 'Today';
    if (proposalDate == today.add(const Duration(days: 1))) return 'Tomorrow';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
