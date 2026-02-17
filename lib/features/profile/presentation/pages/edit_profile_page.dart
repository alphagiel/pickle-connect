import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/repositories/users_repository.dart';
import '../../../../shared/repositories/proposals_repository.dart';
import '../../../../shared/repositories/standings_repository.dart';
import '../../../../shared/repositories/doubles_standings_repository.dart';
import '../../../../shared/models/zone.dart';
import '../../../../shared/providers/zones_providers.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/responsive_center.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _locationController = TextEditingController();
  SkillLevel? _selectedSkillLevel;
  String? _selectedZoneId;
  String? _originalZoneId;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initializeForm(User? userProfile) {
    if (!_isInitialized && userProfile != null) {
      _displayNameController.text = userProfile.displayName;
      _locationController.text = userProfile.location;
      _selectedSkillLevel = userProfile.skillLevel;
      _selectedZoneId = userProfile.zone;
      _originalZoneId = userProfile.zone;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: userProfileAsync.when(
        data: (userProfile) {
          _initializeForm(userProfile);

          return SingleChildScrollView(
            child: ResponsiveCenter(
              maxWidth: 600,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Profile avatar
                      Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Display Name field
                  TextFormField(
                    controller: _displayNameController,
                    style: const TextStyle(color: AppColors.primaryText),
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      labelStyle: const TextStyle(color: AppColors.secondaryText),
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.neutralGray),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your display name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Skill Level dropdown
                  DropdownButtonFormField<SkillLevel>(
                    value: _selectedSkillLevel,
                    style: const TextStyle(color: AppColors.primaryText, fontSize: 16),
                    dropdownColor: AppColors.cardBackground,
                    decoration: InputDecoration(
                      labelText: 'Skill Level',
                      labelStyle: const TextStyle(color: AppColors.secondaryText),
                      prefixIcon: const Icon(Icons.trending_up, color: AppColors.neutralGray),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                    ),
                    items: SkillLevel.values.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSkillLevel = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your skill level';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Zone dropdown
                  Builder(
                    builder: (context) {
                      final zonesAsync = ref.watch(activeZonesProvider);
                      return zonesAsync.when(
                        data: (zones) {
                          // Ensure selected zone is valid
                          final validZoneIds = zones.map((z) => z.id).toSet();
                          final currentZoneId = validZoneIds.contains(_selectedZoneId)
                              ? _selectedZoneId
                              : (zones.isNotEmpty ? zones.first.id : null);

                          return DropdownButtonFormField<String>(
                            value: currentZoneId,
                            style: const TextStyle(color: AppColors.primaryText, fontSize: 16),
                            dropdownColor: AppColors.cardBackground,
                            decoration: InputDecoration(
                              labelText: 'Zone',
                              labelStyle: const TextStyle(color: AppColors.secondaryText),
                              prefixIcon: const Icon(Icons.location_on, color: AppColors.neutralGray),
                              filled: true,
                              fillColor: AppColors.cardBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.mediumGray),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
                              ),
                            ),
                            items: zones.map((zone) {
                              return DropdownMenuItem<String>(
                                value: zone.id,
                                child: Row(
                                  children: [
                                    Expanded(child: Text(zone.displayName)),
                                    Tooltip(
                                      message: zone.description,
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedZoneId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your zone';
                              }
                              return null;
                            },
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => const Text('Failed to load zones'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Location field
                  TextFormField(
                    controller: _locationController,
                    style: const TextStyle(color: AppColors.primaryText),
                    decoration: InputDecoration(
                      labelText: 'Preferred Location',
                      labelStyle: const TextStyle(color: AppColors.secondaryText),
                      prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.neutralGray),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your preferred location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                      // Save button
                      ElevatedButton(
                        onPressed: _isLoading ? null : () => _saveProfile(userProfile),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: AppColors.mediumGray,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                userProfile == null ? 'Create Profile' : 'Save Changes',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),

                      const SizedBox(height: 48),

                      // Danger Zone
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Danger Zone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.errorRed,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Permanently delete your account and all associated data. This action cannot be undone.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _showDeleteAccountDialog(userProfile),
                                icon: const Icon(Icons.delete_forever),
                                label: const Text('Delete Account'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.errorRed,
                                  side: const BorderSide(color: AppColors.errorRed),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  style: const TextStyle(color: AppColors.secondaryText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(User? userProfile) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will permanently delete your account, cancel your open proposals, '
                'and anonymize your name in match history. This cannot be undone.',
                style: TextStyle(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your password to confirm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteAccount(passwordController.text, userProfile);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(String password, User? userProfile) async {
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = ref.read(currentUserProvider);

      if (currentUser == null) {
        throw Exception('No user signed in.');
      }

      final userId = currentUser.id;
      final bracket = userProfile?.skillBracket ?? userProfile?.skillLevel.bracket;

      // Step 1: Re-authenticate
      await authRepository.reauthenticateWithPassword(password);

      // Step 2: Cancel open proposals
      final proposalsRepository = ref.read(proposalsRepositoryProvider);
      await proposalsRepository.cancelAllOpenProposalsForUser(userId);

      // Step 3: Anonymize in completed proposals
      await proposalsRepository.anonymizeUserInProposals(userId);

      // Step 4: Anonymize in standings
      if (bracket != null) {
        final zone = userProfile?.zone ?? 'east_triangle';
        final standingsRepository = ref.read(standingsRepositoryProvider);
        final doublesStandingsRepository = ref.read(doublesStandingsRepositoryProvider);
        await standingsRepository.anonymizeUserInStandings(userId, bracket, zone: zone);
        await doublesStandingsRepository.anonymizeUserInStandings(userId, bracket, zone: zone);
      }

      // Step 5: Delete Firestore user profile
      final usersRepository = ref.read(usersRepositoryProvider);
      await usersRepository.deleteUser(userId);

      // Step 6: Delete Firebase Auth account (last — once done, user loses access)
      await authRepository.deleteFirebaseAuthAccount();

      // Step 7: Navigate to login
      if (mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account has been deleted.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: ${e.message}'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile(User? currentProfile) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final usersRepository = ref.read(usersRepositoryProvider);
      final currentUser = ref.read(currentUserProvider);

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final userId = currentProfile?.userId ?? currentUser.id;

      final newDisplayName = _displayNameController.text.trim();

      if (currentProfile != null) {
        // Update existing profile
        final updates = <String, dynamic>{
          'displayName': newDisplayName,
          'skillLevel': _selectedSkillLevel!.displayName,
          'location': _locationController.text.trim(),
          'zone': _selectedZoneId ?? 'east_triangle',
        };
        await usersRepository.updateUser(userId, updates);

        // If zone changed, remove user from old zone standings (rankings reset)
        if (_originalZoneId != null && _selectedZoneId != _originalZoneId) {
          final standingsRepository = ref.read(standingsRepositoryProvider);
          final doublesStandingsRepository = ref.read(doublesStandingsRepositoryProvider);
          final bracket = currentProfile.skillBracket;
          await standingsRepository.removeUserFromStandings(userId, bracket, zone: _originalZoneId!);
          // Also remove from doubles standings in old zone
          try {
            final doublesDoc = await doublesStandingsRepository.getUserStanding(userId, bracket, zone: _originalZoneId!);
            if (doublesDoc != null) {
              await doublesStandingsRepository.anonymizeUserInStandings(userId, bracket, zone: _originalZoneId!);
            }
          } catch (_) {}
        }

        // If display name changed, update it in all user's proposals
        if (currentProfile.displayName != newDisplayName) {
          final proposalsRepository = ref.read(proposalsRepositoryProvider);
          await proposalsRepository.updateUserNameInProposals(userId, newDisplayName);
        }
      } else {
        // Create new profile
        final newUser = User(
          userId: userId,
          displayName: newDisplayName,
          email: currentUser.email ?? '',
          skillLevel: _selectedSkillLevel!,
          skillBracket: _selectedSkillLevel!.bracket,
          location: _locationController.text.trim(),
          zone: _selectedZoneId ?? 'east_triangle',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await usersRepository.saveUser(newUser);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentProfile != null
                ? 'Profile updated successfully!'
                : 'Profile created successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
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
}
