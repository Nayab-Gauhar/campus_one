enum UserRole { student, clubAdmin, superAdmin }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? college;
  final UserRole role;
  final List<String> joinedSocieties;
  final List<String> registeredEvents;
  final int points;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.college,
    required this.role,
    this.joinedSocieties = const [],
    this.registeredEvents = const [],
    this.followedTeamIds = const [],
    this.points = 0,
  });

  final List<String> followedTeamIds;

  UserModel copyWith({
    String? name,
    List<String>? joinedSocieties,
    List<String>? registeredEvents,
    List<String>? followedTeamIds,
    int? points,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      college: college,
      role: role,
      joinedSocieties: joinedSocieties ?? this.joinedSocieties,
      registeredEvents: registeredEvents ?? this.registeredEvents,
      followedTeamIds: followedTeamIds ?? this.followedTeamIds,
      points: points ?? this.points,
    );
  }
}
