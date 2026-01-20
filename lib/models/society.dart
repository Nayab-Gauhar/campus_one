class SocietyModel {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String adminId;
  final String category; // Tech, Cultural, Sports, Social
  final Map<String, String> coreTeam; // Role: Name
  final List<String> memberIds;
  final List<String> pendingRequests;
  
  // Transparency fields
  final String whatWeDo;
  final String idealStudentProfile;
  final String timeCommitment; // e.g., "2-4 hours/week"
  final bool isRecruiting;

  SocietyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.adminId,
    required this.category,
    this.coreTeam = const {},
    this.memberIds = const [],
    this.pendingRequests = const [],
    this.whatWeDo = '',
    this.idealStudentProfile = 'Enthusiastic learners',
    this.timeCommitment = 'Flexible',
    this.isRecruiting = false,
  });

  SocietyModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? adminId,
    String? category,
    List<String>? memberIds,
    List<String>? pendingRequests,
    Map<String, String>? coreTeam,
    String? whatWeDo,
    String? idealStudentProfile,
    String? timeCommitment,
    bool? isRecruiting,
  }) {
    return SocietyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      adminId: adminId ?? this.adminId,
      category: category ?? this.category,
      memberIds: memberIds ?? this.memberIds,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      coreTeam: coreTeam ?? this.coreTeam,
      whatWeDo: whatWeDo ?? this.whatWeDo,
      idealStudentProfile: idealStudentProfile ?? this.idealStudentProfile,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      isRecruiting: isRecruiting ?? this.isRecruiting,
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'logoUrl': logoUrl,
    'adminId': adminId,
    'category': category,
    'coreTeam': coreTeam,
    'memberIds': memberIds,
    'pendingRequests': pendingRequests,
    'whatWeDo': whatWeDo,
    'idealStudentProfile': idealStudentProfile,
    'timeCommitment': timeCommitment,
    'isRecruiting': isRecruiting,
  };

  factory SocietyModel.fromJson(Map<String, dynamic> json) => SocietyModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    logoUrl: json['logoUrl'] as String,
    adminId: json['adminId'] as String,
    category: json['category'] as String,
    coreTeam: (json['coreTeam'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
    memberIds: (json['memberIds'] as List<dynamic>?)?.cast<String>() ?? [],
    pendingRequests: (json['pendingRequests'] as List<dynamic>?)?.cast<String>() ?? [],
    whatWeDo: json['whatWeDo'] as String? ?? '',
    idealStudentProfile: json['idealStudentProfile'] as String? ?? 'Enthusiastic learners',
    timeCommitment: json['timeCommitment'] as String? ?? 'Flexible',
    isRecruiting: json['isRecruiting'] as bool? ?? false,
  );
}
