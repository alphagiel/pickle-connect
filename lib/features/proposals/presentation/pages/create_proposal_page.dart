import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../shared/repositories/users_repository.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';

// TODO: Set to false for production - allows creating proposals for current/past times
const bool kAllowPastProposals = true;

class CreateProposalPage extends ConsumerStatefulWidget {
  const CreateProposalPage({super.key});

  @override
  ConsumerState<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends ConsumerState<CreateProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  List<SkillLevel> _selectedSkillLevels = [SkillLevel.intermediate];
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    print('Current user in CreateProposalPage: $currentUser');
    // Show login state if user is not authenticated
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Create Match Proposal'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.login_outlined,
                size: 80,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: 24),
              const Text(
                'Please log in',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You need to be logged in to create match proposals',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Go to Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Match Proposal'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
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
                      Icon(
                        Icons.sports_tennis,
                        size: 48,
                        color: AppColors.primaryGreen,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Find Your Perfect Match',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Create a proposal and connect with players',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                
                // Date & Time Section
                _buildSectionCard(
                  title: 'When do you want to play?',
                  icon: Icons.schedule,
                  child: Column(
                    children: [
                      Row(
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
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Location Section
                _buildSectionCard(
                  title: 'Where do you want to play?',
                  icon: Icons.location_on,
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.primaryText),
                    controller: _locationController,  
                    decoration: InputDecoration(
                      hintText: 'e.g., Clayton Tennis Courts, Smithfield Park...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.place_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Skill Levels Section
                _buildSectionCard(
                  title: 'What skill levels are you open to?',
                  icon: Icons.group,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select all that apply:',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: SkillLevel.values.map((skillLevel) {
                          final isSelected = _selectedSkillLevels.contains(skillLevel);
                          return FilterChip(
                            label: Text(
                              skillLevel.displayName,
                              style: TextStyle(
                                color: isSelected ? AppColors.onPrimary : AppColors.primaryText,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSkillLevels.add(skillLevel);
                                } else {
                                  _selectedSkillLevels.remove(skillLevel);
                                }
                              });
                            },
                            backgroundColor: AppColors.lightGray,
                            selectedColor: AppColors.primaryGreen,
                            checkmarkColor: AppColors.onPrimary,
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryGreen : AppColors.mediumGray,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_selectedSkillLevels.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Please select at least one skill level',
                            style: TextStyle(
                              color: AppColors.errorRed,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Additional Notes Section
                _buildSectionCard(
                  title: 'Additional Notes (Optional)',
                  icon: Icons.note_outlined,
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.primaryText),
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any specific requests, preferences, or details...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.neutralGray,
                          side: const BorderSide(color: AppColors.mediumGray),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                                ),
                              )
                            : const Text(
                                'Create Proposal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                  fontSize: 18,
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
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Check if selected time is in the past for today
      final selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        picked.hour,
        picked.minute,
      );

      final now = DateTime.now();
      if (!kAllowPastProposals && selectedDateTime.isBefore(now)) {
        // Show error for past time
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot schedule a match in the past'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }

      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _createProposal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSkillLevels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one skill level'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get user profile from Firestore
      final usersRepository = ref.read(usersRepositoryProvider);
      final userProfile = await usersRepository.getUserById(currentUser.id);

      print('=== User Profile Debug ===');
      print('Current user ID: ${currentUser.id}');
      print('Current user displayName: ${currentUser.displayName}');
      print('User profile from Firestore: $userProfile');
      print('User profile displayName: ${userProfile?.displayName}');

      // // Show debug info in UI via snackbar
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const Text('User Debug Info:', style: TextStyle(fontWeight: FontWeight.bold)),
      //           Text('Firebase Display Name: ${currentUser.displayName ?? "NULL"}'),
      //           Text('Firestore Display Name: ${userProfile?.displayName ?? "NULL"}'),
      //           Text('Final Creator Name: ${userProfile?.displayName ?? currentUser.displayName ?? "Unknown User"}'),
      //         ],
      //       ),
      //       backgroundColor: AppColors.accentBlue,
      //       duration: const Duration(seconds: 5),
      //     ),
      //   );
      // }

      final creatorName = userProfile?.displayName ?? currentUser.displayName ?? 'Unknown User';

      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      print('=== Creating proposal object ===');
      print('Current user ID: ${currentUser.id}');
      print('Creator name: $creatorName');
      print('Selected skill levels: $_selectedSkillLevels');
      print('Location: ${_locationController.text.trim()}');
      print('Scheduled date time: $scheduledDateTime');
      
      final proposal = Proposal(
        proposalId: DateTime.now().millisecondsSinceEpoch.toString(),
        creatorId: currentUser.id,
        creatorName: creatorName,
        skillLevels: _selectedSkillLevels,
        location: _locationController.text.trim(),
        dateTime: scheduledDateTime,
        status: ProposalStatus.open,
        scores: null,
        acceptedBy: null,
        scoreConfirmedBy: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      print('Created proposal object: $proposal');

      await ref.read(proposalActionsProvider).createProposal(proposal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Match proposal created successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        // Navigate to home after successful creation
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create proposal: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final proposalDate = DateTime(date.year, date.month, date.day);
    
    if (proposalDate == today) {
      return 'Today';
    } else if (proposalDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}