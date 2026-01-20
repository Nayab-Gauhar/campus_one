enum UserRole { student, clubAdmin, superAdmin }

extension UserRoleExtension on UserRole {
  String toJson() {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.clubAdmin:
        return 'clubAdmin';
      case UserRole.superAdmin:
        return 'superAdmin';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'student':
        return UserRole.student;
      case 'clubAdmin':
        return UserRole.clubAdmin;
      case 'superAdmin':
        return UserRole.superAdmin;
      default:
        return UserRole.student;
    }
  }
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? college;
  final UserRole role;
  final List<String> joinedSocieties;
  final List<String> registeredEvents;
  final List<String> followedTeamIds;
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

  UserModel copyWith({
    String? name,
    String? college,
    List<String>? joinedSocieties,
    List<String>? registeredEvents,
    List<String>? followedTeamIds,
    int? points,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      college: college ?? this.college,
      role: role,
      joinedSocieties: joinedSocieties ?? this.joinedSocieties,
      registeredEvents: registeredEvents ?? this.registeredEvents,
      followedTeamIds: followedTeamIds ?? this.followedTeamIds,
      points: points ?? this.points,
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'college': college,
    'role': role.toJson(),
    'joinedSocieties': joinedSocieties,
    'registeredEvents': registeredEvents,
    'followedTeamIds': followedTeamIds,
    'points': points,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    college: json['college'] as String?,
    role: UserRoleExtension.fromString(json['role'] as String),
    joinedSocieties: (json['joinedSocieties'] as List<dynamic>?)?.cast<String>() ?? [],
    registeredEvents: (json['registeredEvents'] as List<dynamic>?)?.cast<String>() ?? [],
    followedTeamIds: (json['followedTeamIds'] as List<dynamic>?)?.cast<String>() ?? [],
    points: json['points'] as int? ?? 0,
  );
}
