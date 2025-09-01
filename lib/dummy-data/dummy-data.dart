// lib/dummy_data.dart
class PlayerProposal {
  final String name;
  final String date;
  final String active;
  final String location;

  PlayerProposal({
    required this.name,
    required this.date,
    required this.active,
    required this.location,
  });
}

final List<PlayerProposal> dummySinglesProposals = [
  PlayerProposal(
    name: 'John',
    date: '8/24/2025',
    active: 'Active',
    location: 'Clayton',
  ),
  PlayerProposal(
    name: 'Mike',
    date: '8/24/2025',
    active: 'Active',
    location: 'Smithfield',
  ),
];

final List<PlayerProposal> dummyDoublesProposals = [
  PlayerProposal(
    name: 'Alice',
    date: '8/25/2025',
    active: 'Active',
    location: 'Clayton',
  ),
  PlayerProposal(
    name: 'Bob',
    date: '8/26/2025',
    active: 'Active',
    location: 'Smithfield',
  ),
];