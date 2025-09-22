import 'package:flutter/material.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/theme/app_colors.dart';

class SkillLevelTabs extends StatelessWidget {
  final TabController controller;
  final Function(SkillLevel) onSkillLevelChanged;

  const SkillLevelTabs({
    super.key,
    required this.controller,
    required this.onSkillLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.accentBlue,
        unselectedLabelColor: AppColors.onPrimary.withValues(alpha: 0.8),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        onTap: (index) {
          onSkillLevelChanged(SkillLevel.values[index]);
        },
        tabs: SkillLevel.values.map((skillLevel) {
          return Tab(
            text: skillLevel.displayName,
          );
        }).toList(),
      ),
    );
  }
}