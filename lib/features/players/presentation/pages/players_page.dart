import 'package:flutter/material.dart';

class PlayersPage extends StatelessWidget {
  const PlayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // TODO: Navigate to invite player
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search players...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          // Skill divisions tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSkillChip('All', true),
                  const SizedBox(width: 8),
                  _buildSkillChip('Beginner', false),
                  const SizedBox(width: 8),
                  _buildSkillChip('Intermediate', false),
                  const SizedBox(width: 8),
                  _buildSkillChip('Advanced', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Players list
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Mock data
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        _getInitials(index),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(_getPlayerName(index)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rating: ${_getPlayerRating(index)}'),
                        Text('Division: ${_getPlayerDivision(index)}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'invite',
                          child: Text('Invite to Match'),
                        ),
                        const PopupMenuItem(
                          value: 'profile',
                          child: Text('View Profile'),
                        ),
                      ],
                      onSelected: (value) {
                        // TODO: Handle menu actions
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement filtering
      },
    );
  }

  String _getInitials(int index) {
    final names = ['JD', 'SM', 'AB', 'CD', 'EF', 'GH', 'IJ', 'KL'];
    return names[index % names.length];
  }

  String _getPlayerName(int index) {
    final names = [
      'John Doe', 'Sarah Miller', 'Alex Brown', 'Chris Davis',
      'Emma Foster', 'Gary Hill', 'Isabella Jones', 'Kevin Lee'
    ];
    return names[index % names.length];
  }

  String _getPlayerRating(int index) {
    final ratings = ['4.0', '3.5', '4.5', '3.0', '5.0', '3.5', '4.0', '4.5'];
    return ratings[index % ratings.length];
  }

  String _getPlayerDivision(int index) {
    final divisions = ['Intermediate', 'Beginner', 'Advanced', 'Beginner', 'Advanced', 'Beginner', 'Intermediate', 'Advanced'];
    return divisions[index % divisions.length];
  }
}