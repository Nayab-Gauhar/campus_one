enum UserRole { student, clubAdmin, superAdmin }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? college;
  final UserRole role;
  final List<String> joinedSocieties;
  final List<String> registeredEvents;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.college,
    required this.role,
    this.joinedSocieties = const [],
    this.registeredEvents = const [],
  });

  UserModel copyWith({
    String? name,
    List<String>? joinedSocieties,
    List<String>? registeredEvents,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      college: college,
      role: role,
      joinedSocieties: joinedSocieties ?? this.joinedSocieties,
      registeredEvents: registeredEvents ?? this.registeredEvents,
    );
  }
}
