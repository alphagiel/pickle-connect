import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/proposal.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../shared/theme/app_colors.dart';

class EditProposalPage extends ConsumerStatefulWidget {
  final Proposal proposal;

  const EditProposalPage({
    super.key,
    required this.proposal,
  });

  @override
  ConsumerState<EditProposalPage> createState() => _EditProposalPageState();
}

class _EditProposalPageState extends ConsumerState<EditProposalPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _locationController;
  
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with existing proposal data
    _locationController = TextEditingController(text: widget.proposal.location);
    _selectedDate = widget.proposal.dateTime;
    _selectedTime = TimeOfDay(
      hour: widget.proposal.dateTime.hour,
      minute: widget.proposal.dateTime.minute,
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    // Check if user is the creator
    if (currentUser == null || currentUser.id != widget.proposal.creatorId) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Proposal'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.errorRed,
              ),
              const SizedBox(height: 24),
              const Text(
                'Unauthorized',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can only edit your own proposals',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Check if proposal can be edited (only open proposals)
    if (widget.proposal.status != ProposalStatus.open) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Proposal'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: AppColors.warningOrange,
              ),
              const SizedBox(height: 24),
              const Text(
                'Cannot Edit',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Only open proposals can be edited.\nThis proposal is ${widget.proposal.status.displayName}.',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.onPrimary,
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
        title: const Text('Edit Match Proposal'),
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
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 48,
                        color: AppColors.accentBlue,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Update Your Match',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Make changes to your match proposal',
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
                        onPressed: _isLoading ? null : _updateProposal,
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
                                'Update Proposal',
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
      firstDate: DateTime.now(),
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
      if (selectedDateTime.isBefore(now)) {
        // Show error for past time
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot schedule a match in the past'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _updateProposal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await ref.read(proposalActionsProvider).updateProposal(
        widget.proposal.proposalId,
        location: _locationController.text.trim(),
        dateTime: scheduledDateTime,
      );

      // Invalidate providers to refresh the data
      final skillLevel = widget.proposal.skillLevel;
      ref.invalidate(openProposalsProvider(skillLevel));
      ref.invalidate(filteredProposalsProvider(skillLevel));
      
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.invalidate(userProposalsProvider(currentUser.id));
        ref.invalidate(filteredUserProposalsProvider(currentUser.id));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Match proposal updated successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        // Navigate back
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update proposal: $e'),
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
