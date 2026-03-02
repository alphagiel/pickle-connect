import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/responsive_center.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules & Guidelines'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: ResponsiveCenter(
        maxWidth: 800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                icon: Icons.handshake,
                iconColor: AppColors.primaryGreen,
                title: 'Sportsmanship',
                items: const [
                  'Be courteous and friendly to all players.',
                  'Respect your opponents, partners, and fellow competitors.',
                  'Win or lose with grace — celebrate good play on both sides.',
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                icon: Icons.verified,
                iconColor: AppColors.accentBlue,
                title: 'Fair Play & Honesty',
                items: const [
                  'Report scores honestly and accurately.',
                  'Make honest line calls — when in doubt, call it in.',
                  'No cheating or manipulating results.',
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                icon: Icons.scoreboard,
                iconColor: AppColors.warmOrange,
                title: 'Recording Scores',
                items: const [
                  'After a match, either player can record the score in the app.',
                  'The other player must confirm the score for it to count.',
                  'If there\'s a dispute, communicate with your opponent to resolve it.',
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                icon: Icons.sports_tennis,
                iconColor: AppColors.softPurple,
                title: 'Match Play',
                items: const [
                  'Play as many matches as you want throughout the season.',
                  'For doubles, mix and match partners freely.',
                  'All players in a match must agree on which game is the "official" one recorded in the app.',
                  'Only one result per matchup is recorded — make sure everyone\'s on the same page.',
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                icon: Icons.emoji_events,
                iconColor: AppColors.darkOrange,
                title: 'Season Finale',
                items: const [
                  'When 8 or more players are in a category, the top 8 qualify for a playoff bracket.',
                  'Playoffs follow a single-elimination bracket format.',
                  'The season champion earns a badge and future perks as a token of appreciation.',
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    return Card(
      elevation: 1,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 10),
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
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 6, color: AppColors.neutralGray),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
