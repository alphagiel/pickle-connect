import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/proposals_providers.dart';
import '../../../../shared/theme/app_colors.dart';

class ProposalFilters extends ConsumerWidget {
  final bool showCreatorFilter;

  const ProposalFilters({
    super.key,
    this.showCreatorFilter = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusFilter = ref.watch(proposalStatusFilterProvider);
    final dateFilter = ref.watch(dateFilterProvider);
    final creatorFilter = ref.watch(creatorFilterProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status Filter
          _buildFilterSection(
            title: 'Status',
            child: Wrap(
              spacing: 8,
              children: ProposalStatusFilter.values.map((filter) {
                final isSelected = statusFilter == filter;
                return FilterChip(
                  label: Text(_getStatusFilterLabel(filter)),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(proposalStatusFilterProvider.notifier).state = filter;
                  },
                  backgroundColor: AppColors.lightGray,
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.onPrimary : AppColors.primaryText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
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
          ),

          const SizedBox(height: 16),

          // Date Sort Filter
          _buildFilterSection(
            title: 'Sort by Date',
            child: Wrap(
              spacing: 8,
              children: DateSortFilter.values.map((filter) {
                final isSelected = dateFilter == filter;
                return FilterChip(
                  label: Text(_getDateFilterLabel(filter)),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(dateFilterProvider.notifier).state = filter;
                  },
                  backgroundColor: AppColors.lightGray,
                  selectedColor: AppColors.accentBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.onPrimary : AppColors.primaryText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  checkmarkColor: AppColors.onPrimary,
                  side: BorderSide(
                    color: isSelected ? AppColors.accentBlue : AppColors.mediumGray,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
          ),

          // Creator Filter (only show on Available tab)
          if (showCreatorFilter) ...[
            const SizedBox(height: 16),
            _buildFilterSection(
              title: 'Filter by Creator',
              child: TextField(
                onChanged: (value) {
                  ref.read(creatorFilterProvider.notifier).state =
                      value.isEmpty ? null : value;
                },
                decoration: InputDecoration(
                  hintText: 'Search by creator name...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.mediumGray),
                  suffixIcon: creatorFilter != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.mediumGray),
                          onPressed: () {
                            ref.read(creatorFilterProvider.notifier).state = null;
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Clear All Filters
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ref.read(proposalStatusFilterProvider.notifier).state = ProposalStatusFilter.all;
                ref.read(dateFilterProvider.notifier).state = DateSortFilter.upcoming;
                ref.read(creatorFilterProvider.notifier).state = null;
              },
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mediumGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  String _getStatusFilterLabel(ProposalStatusFilter filter) {
    switch (filter) {
      case ProposalStatusFilter.all:
        return 'All';
      case ProposalStatusFilter.active:
        return 'Active';
      case ProposalStatusFilter.expired:
        return 'Expired';
    }
  }

  String _getDateFilterLabel(DateSortFilter filter) {
    switch (filter) {
      case DateSortFilter.upcoming:
        return 'Upcoming First';
      case DateSortFilter.recent:
        return 'Recent First';
    }
  }
}