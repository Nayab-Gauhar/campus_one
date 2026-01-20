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
  final int? homeScore;
  final int? awayScore;

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
    this.homeScore,
    this.awayScore,
  });

  SportsModel copyWith({
    String? id,
    String? title,
    String? type,
    String? sportName,
    DateTime? dateTime,
    String? venue,
    String? status,
    List<String>? teamIds,
    String? result,
    int? homeScore,
    int? awayScore,
  }) {
    return SportsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sportName: sportName ?? this.sportName,
      dateTime: dateTime ?? this.dateTime,
      venue: venue ?? this.venue,
      status: status ?? this.status,
      teamIds: teamIds ?? this.teamIds,
      result: result ?? this.result,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
    );
  }
}

class SportsTeam {
  final String id;
  final String name;
  final String sport;
  final String captain;
  final String logoUrl;
  final String? colorHex; // Hex string e.g. "FF0000"

  const SportsTeam({
    required this.id,
    required this.name,
    required this.sport,
    required this.captain,
    required this.logoUrl,
    this.colorHex,
  });
}
