class SportsModel {
  final String id;
  final String title;
  final String type; // Tournament, Match, Tryout
  final String sportName; // Football, Cricket, etc.
  final DateTime dateTime;
  final String venue;
  final String status; // Ongoing, Upcoming, Finished
  final List<String> teamIds;
  final String result; // Score or winning team

  SportsModel({
    required this.id,
    required this.title,
    required this.type,
    required this.sportName,
    required this.dateTime,
    required this.venue,
    this.status = 'Upcoming',
    this.teamIds = const [],
    this.result = '',
  });
}

class SportsTeam {
  final String id;
  final String name;
  final String sport;
  final String captain;
  final String logoUrl;
  final String? colorHex; // Hex string e.g. "FF0000"

  SportsTeam({
    required this.id,
    required this.name,
    required this.sport,
    required this.captain,
    required this.logoUrl,
    this.colorHex,
  });
}
