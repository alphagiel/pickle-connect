import 'package:flutter/material.dart';

class LadderPage extends StatelessWidget {
  const LadderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ladder Rankings'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Text('Report Match'),
              ),
              const PopupMenuItem(
                value: 'challenge',
                child: Text('Challenge Player'),
              ),
            ],
            onSelected: (value) {
              // TODO: Handle menu actions
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Season info
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Spring 2024 Season',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rankings updated daily based on match results',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Total Players', '124'),
                        _buildStatCard('Matches Played', '342'),
                        _buildStatCard('Your Rank', '#15'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Division tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDivisionChip('All Divisions', true),
                  const SizedBox(width: 8),
                  _buildDivisionChip('Beginner', false),
                  const SizedBox(width: 8),
                  _buildDivisionChip('Intermediate', false),
                  const SizedBox(width: 8),
                  _buildDivisionChip('Advanced', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Rankings list
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Mock data
              itemBuilder: (context, index) {
                final rank = index + 1;
                final isCurrentUser = rank == 15; // Mock current user
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: isCurrentUser 
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : null,
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getRankColor(rank),
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(_getPlayerName(index)),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rating: ${_getPlayerRating(index)}'),
                        Text('W-L: ${_getWinLoss(index)}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getRankTrend(index) > 0 
                              ? Icons.trending_up
                              : _getRankTrend(index) < 0
                                  ? Icons.trending_down
                                  : Icons.trending_flat,
                          color: _getRankTrend(index) > 0 
                              ? Colors.green
                              : _getRankTrend(index) < 0
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                        Text(
                          _getRankTrend(index) > 0 
                              ? '+${_getRankTrend(index)}'
                              : _getRankTrend(index).toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getRankTrend(index) > 0 
                                ? Colors.green
                                : _getRankTrend(index) < 0
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // TODO: Show player profile
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivisionChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement filtering
      },
    );
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) return Colors.amber;
    if (rank <= 10) return Colors.blue;
    return Colors.grey;
  }

  String _getPlayerName(int index) {
    final names = [
      'Michael Johnson', 'Sarah Williams', 'Alex Rodriguez', 'Emily Chen',
      'David Brown', 'Jessica Davis', 'Ryan Miller', 'Amanda Taylor'
    ];
    return names[index % names.length];
  }

  String _getPlayerRating(int index) {
    final ratings = ['4.2', '4.0', '4.5', '3.8', '5.0', '3.5', '4.1', '4.3'];
    return ratings[index % ratings.length];
  }

  String _getWinLoss(int index) {
    final records = ['12-3', '10-5', '15-2', '8-7', '18-1', '6-9', '11-4', '14-3'];
    return records[index % records.length];
  }

  int _getRankTrend(int index) {
    final trends = [2, -1, 0, 3, -2, 1, 0, 4];
    return trends[index % trends.length];
  }
}