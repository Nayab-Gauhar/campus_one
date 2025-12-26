enum EventCategory { 
  sports, 
  cultural, 
  technical, 
  academic, 
  workshop,
  hackathon,
  seminar
}

enum EventStatus {
  draft,
  published,
  live,
  completed
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime registrationDeadline;
  final String location;
  final String organizerId; // Society ID
  final String organizerName;
  final EventCategory category;
  final String imageUrl;
  final int maxParticipants;
  final List<String> participantIds;
  final EventStatus status;
  
  // New "Why Join" fields
  final List<String> skillsToLearn;
  final String targetAudience;
  final String prerequisites;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.registrationDeadline,
    required this.location,
    required this.organizerId,
    required this.organizerName,
    required this.category,
    required this.imageUrl,
    this.maxParticipants = 100,
    this.participantIds = const [],
    this.skillsToLearn = const [],
    this.targetAudience = 'All students',
    this.prerequisites = 'None',
    this.status = EventStatus.published,
  });

  bool get isFull => participantIds.length >= maxParticipants;
  bool get isRegistrationClosed => DateTime.now().isAfter(registrationDeadline);

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? registrationDeadline,
    String? location,
    String? organizerId,
    String? organizerName,
    EventCategory? category,
    String? imageUrl,
    int? maxParticipants,
    List<String>? participantIds,
    List<String>? skillsToLearn,
    String? targetAudience,
    String? prerequisites,
    EventStatus? status,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      location: location ?? this.location,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participantIds: participantIds ?? this.participantIds,
      skillsToLearn: skillsToLearn ?? this.skillsToLearn,
      targetAudience: targetAudience ?? this.targetAudience,
      prerequisites: prerequisites ?? this.prerequisites,
      status: status ?? this.status,
    );
  }
}
