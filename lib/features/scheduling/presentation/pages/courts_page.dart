import 'package:flutter/material.dart';
import '../../../../dummy-data/dummy-data.dart';

class CourtsPage extends StatefulWidget {
  const CourtsPage({super.key});

  @override
  State<CourtsPage> createState() => _CourtsPageState();
}

class _CourtsPageState extends State<CourtsPage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PickleBall Meetups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add meetup feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Carousel Section
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemCount: 2, // Singles and Doubles
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: _selectedIndex == index ? 0 : 8,
                  ),
                  child: _buildCarouselCard(index),
                );
              },
            ),
          ),
          
          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              2,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _selectedIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Selected table section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildSelectedMeetupsTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselCard(int index) {
    final bool isSingles = index == 0;
    final String title = isSingles ? 'Singles Meetups' : 'Doubles Meetups';
    final IconData icon = isSingles ? Icons.person : Icons.people;
    final List<PlayerProposal> proposals = isSingles ? dummySinglesProposals : dummyDoublesProposals;
    final bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSingles
                    ? [
                        Colors.blue[400]!,
                        Colors.blue[600]!,
                      ]
                    : [
                        Colors.green[400]!,
                        Colors.green[600]!,
                      ],
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.overlay,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    child: CustomPaint(
                      painter: TennisPatternPainter(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon - only show if there's enough space
                      if (!isSelected || MediaQuery.of(context).size.height > 600) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      
                      // Title
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSelected ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: isSelected ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Participant count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${proposals.length}',
                          style: TextStyle(
                            color: isSingles ? Colors.blue[700] : Colors.green[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      // Arrow only for selected and if space available
                      if (isSelected && MediaQuery.of(context).size.height > 600) ...[
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Selection indicator
                if (isSelected)
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: isSingles ? Colors.blue[600] : Colors.green[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedMeetupsTable() {
    final bool isSingles = _selectedIndex == 0;
    final String title = isSingles ? 'Singles Meetups' : 'Doubles Meetups';
    final List<PlayerProposal> proposals = isSingles ? dummySinglesProposals : dummyDoublesProposals;
    final IconData icon = isSingles ? Icons.person : Icons.people;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildMeetupsSection(
        context,
        title,
        proposals,
        icon,
      ),
    );
  }

  Widget _buildMeetupsSection(
    BuildContext context,
    String title,
    List<PlayerProposal> proposals,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (proposals.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No ${title.toLowerCase()} scheduled',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text('Player', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                  rows: proposals.map((proposal) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          proposal.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      DataCell(Text(proposal.date)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: proposal.active == 'Active' 
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: proposal.active == 'Active' 
                                  ? Colors.green
                                  : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            proposal.active,
                            style: TextStyle(
                              color: proposal.active == 'Active' 
                                  ? Colors.green[700]
                                  : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(proposal.location),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('View ${proposal.name} meetup details')),
                                );
                              },
                              tooltip: 'View Details',
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Edit ${proposal.name} meetup')),
                                );
                              },
                              tooltip: 'Edit Meetup',
                            ),
                            IconButton(
                              icon: const Icon(Icons.group_add, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Join ${proposal.name} meetup')),
                                );
                              },
                              tooltip: 'Join Meetup',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for tennis-themed background pattern
class TennisPatternPainter extends CustomPainter {
  final Color color;

  TennisPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw tennis ball pattern
    final double spacing = 60;
    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        // Tennis ball circle
        canvas.drawCircle(
          Offset(x, y),
          6,
          paint,
        );
        
        // Tennis ball curved lines
        final path = Path();
        path.moveTo(x - 6, y);
        path.quadraticBezierTo(x, y - 3, x + 6, y);
        path.moveTo(x - 6, y);
        path.quadraticBezierTo(x, y + 3, x + 6, y);
        
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}