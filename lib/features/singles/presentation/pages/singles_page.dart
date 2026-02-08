import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../proposals/presentation/pages/proposals_page.dart';
import '../../../standings/presentation/pages/standings_page.dart';

class SinglesPage extends ConsumerStatefulWidget {
  const SinglesPage({super.key});

  @override
  ConsumerState<SinglesPage> createState() => _SinglesPageState();
}

class _SinglesPageState extends ConsumerState<SinglesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-tab bar
        Container(
          color: AppColors.primaryGreen,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            tabs: const [
              Tab(text: 'Proposals'),
              Tab(text: 'Rankings'),
            ],
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              ProposalsPage(),
              StandingsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
