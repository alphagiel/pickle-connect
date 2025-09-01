import 'package:flutter/material.dart';

class TournamentsPage extends StatelessWidget {
  const TournamentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create tournament (admin only)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Current tournament banner
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Spring Championship 2024',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Registration closes in 5 days',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Register for tournament
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Tournament status tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('Active', true),
                  const SizedBox(width: 8),
                  _buildStatusChip('Upcoming', false),
                  const SizedBox(width: 8),
                  _buildStatusChip('Completed', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Tournaments list
          Expanded(
            child: ListView.builder(
              itemCount: 8, // Mock data
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getTournamentStatusColor(index),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTournamentIcon(index),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(_getTournamentName(index)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Format: ${_getTournamentFormat(index)}'),
                        Text('Players: ${_getTournamentPlayers(index)}'),
                        Text('Date: ${_getTournamentDate(index)}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTournamentStatusColor(index),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getTournamentStatus(index),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // TODO: Show tournament details
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

  Widget _buildStatusChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement filtering
      },
    );
  }

  String _getTournamentName(int index) {
    final names = [
      'Spring Championship 2024',
      'Summer Classic',
      'Fall Open',
      'Winter Masters',
      'Beginner Tournament',
      'Ladies Championship',
      'Men\'s Singles',
      'Mixed Doubles'
    ];
    return names[index % names.length];
  }

  String _getTournamentFormat(int index) {
    final formats = ['Top 8 Elimination', 'Round Robin', 'Single Elimination', 'Double Elimination'];
    return formats[index % formats.length];
  }

  String _getTournamentPlayers(int index) {
    final players = ['24/32', '16/16', '8/8', '12/16', '6/8', '20/24', '14/16', '10/12'];
    return players[index % players.length];
  }

  String _getTournamentDate(int index) {
    final dates = ['Apr 15-16', 'Jun 22-23', 'Sep 14-15', 'Dec 7-8', 'Mar 10', 'May 25', 'Jul 12', 'Oct 5'];
    return dates[index % dates.length];
  }

  String _getTournamentStatus(int index) {
    final statuses = ['Active', 'Upcoming', 'Completed', 'Registration', 'Cancelled', 'Active', 'Completed', 'Upcoming'];
    return statuses[index % statuses.length];
  }

  Color _getTournamentStatusColor(int index) {
    final status = _getTournamentStatus(index);
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Upcoming':
        return Colors.blue;
      case 'Registration':
        return Colors.orange;
      case 'Completed':
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTournamentIcon(int index) {
    final status = _getTournamentStatus(index);
    switch (status) {
      case 'Active':
        return Icons.play_arrow;
      case 'Upcoming':
        return Icons.schedule;
      case 'Registration':
        return Icons.app_registration;
      case 'Completed':
        return Icons.emoji_events;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.emoji_events;
    }
  }
}