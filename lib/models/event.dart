enum EventCategory { 
  sports, 
  cultural, 
  technical, 
  academic, 
  workshop,
  hackathon,
  seminar
}

class PricingBucket {
  final String name;
  final List<String> subEvents;
  final double earlyBirdPrice;
  final double normalPrice;

  const PricingBucket({
    required this.name,
    required this.subEvents,
    required this.earlyBirdPrice,
    required this.normalPrice,
  });
}

class EventAgendaItem {
  final String time;
  final String title;
  final String description;
  
  const EventAgendaItem({required this.time, required this.title, required this.description});
}

enum EventStatus {
  draft,
  published,
  live,
  completed
}

class SubEvent {
  final String id;
  final String title;
  final String description;
  final bool isTeam;
  final int minTeamSize;
  final int maxTeamSize;
  final List<String> requirements;
  final String? judgingCriteria;

  const SubEvent({
    required this.id,
    required this.title,
    required this.description,
    this.isTeam = false,
    this.minTeamSize = 1,
    this.maxTeamSize = 1,
    this.requirements = const [],
    this.judgingCriteria,
  });
}

class EventModel {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final DateTime date;
  final DateTime registrationDeadline;
  final String location;
  final String mode; // Online, Offline, Hybrid
  final String organizerId; // Society ID
  final String organizerName;
  final EventCategory category;
  final String imageUrl;
  final int maxParticipants;
  final List<String> participantIds;
  final EventStatus status;
  
  // High Precision Modeling
  final bool isMultiEvent;
  final List<SubEvent> subEvents;
  final Map<String, String> structuredGuidelines;
  final List<String> takeaways;
  final int maxEventsPerParticipant;
  final bool isWhatsAppMandatory;
  final String certificateType; // E-Certificate, Printed, None
  
  // Why Join fields
  final List<String> skillsToLearn;
  final String targetAudience;
  final String prerequisites;
  
  // High Density Fields
  final List<EventAgendaItem> agenda;
  final List<String> rules;
  final String contactName;
  final String contactNumber;
  final int minTeamSize;
  final int maxTeamSize;
  
  // Registration & Pricing
  final List<PricingBucket> pricingBuckets;
  final bool requiresPayment;
  final DateTime earlyBirdDeadline;

  EventModel({
    required this.id,
    required this.title,
    this.tagline = '',
    required this.description,
    required this.date,
    required this.registrationDeadline,
    required this.location,
    this.mode = 'Offline',
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
    this.agenda = const [],
    this.rules = const [],
    this.contactName = 'Student Coordinator',
    this.contactNumber = '',
    this.minTeamSize = 1,
    this.maxTeamSize = 1,
    this.pricingBuckets = const [],
    this.requiresPayment = false,
    DateTime? earlyBirdDeadline,
    this.isMultiEvent = false,
    this.subEvents = const [],
    this.structuredGuidelines = const {},
    this.takeaways = const [],
    this.maxEventsPerParticipant = 3,
    this.isWhatsAppMandatory = true,
    this.certificateType = 'E-Certificate',
  }) : earlyBirdDeadline = earlyBirdDeadline ?? date.subtract(const Duration(days: 3));

  bool get isFull => participantIds.length >= maxParticipants;
  bool get isRegistrationClosed => DateTime.now().isAfter(registrationDeadline);

  EventModel copyWith({
    String? id,
    String? title,
    String? tagline,
    String? description,
    DateTime? date,
    DateTime? registrationDeadline,
    String? location,
    String? mode,
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
    List<EventAgendaItem>? agenda,
    List<String>? rules,
    String? contactName,
    String? contactNumber,
    int? minTeamSize,
    int? maxTeamSize,
    List<PricingBucket>? pricingBuckets,
    bool? requiresPayment,
    DateTime? earlyBirdDeadline,
    bool? isMultiEvent,
    List<SubEvent>? subEvents,
    Map<String, String>? structuredGuidelines,
    List<String>? takeaways,
    int? maxEventsPerParticipant,
    bool? isWhatsAppMandatory,
    String? certificateType,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      date: date ?? this.date,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      location: location ?? this.location,
      mode: mode ?? this.mode,
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
      agenda: agenda ?? this.agenda,
      rules: rules ?? this.rules,
      contactName: contactName ?? this.contactName,
      contactNumber: contactNumber ?? this.contactNumber,
      minTeamSize: minTeamSize ?? this.minTeamSize,
      maxTeamSize: maxTeamSize ?? this.maxTeamSize,
      pricingBuckets: pricingBuckets ?? this.pricingBuckets,
      requiresPayment: requiresPayment ?? this.requiresPayment,
      earlyBirdDeadline: earlyBirdDeadline ?? this.earlyBirdDeadline,
      isMultiEvent: isMultiEvent ?? this.isMultiEvent,
      subEvents: subEvents ?? this.subEvents,
      structuredGuidelines: structuredGuidelines ?? this.structuredGuidelines,
      takeaways: takeaways ?? this.takeaways,
      maxEventsPerParticipant: maxEventsPerParticipant ?? this.maxEventsPerParticipant,
      isWhatsAppMandatory: isWhatsAppMandatory ?? this.isWhatsAppMandatory,
      certificateType: certificateType ?? this.certificateType,
    );
  }
}
