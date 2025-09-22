import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../shared/theme/app_colors.dart';

class SkillLevelFilter extends ConsumerWidget {
  const SkillLevelFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSkillLevel = ref.watch(selectedSkillLevelProvider);

    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: SkillLevel.values.map((skillLevel) {
          final isSelected = skillLevel == selectedSkillLevel;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                skillLevel.displayName,
                style: TextStyle(
                  color: isSelected ? AppColors.onPrimary : const Color.fromARGB(255, 104, 102, 102),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(selectedSkillLevelProvider.notifier).state = skillLevel;
                }
              },
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
              selectedColor: AppColors.primaryGreen,
              checkmarkColor: AppColors.onPrimary,
              side: BorderSide(
                color: isSelected ? AppColors.onPrimary :  const Color.fromARGB(255, 189, 175, 175),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}