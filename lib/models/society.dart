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
  
  // New Transparency fields
  final String whatWeDo;
  final String idealtudentProfile;
  final String timeCommitment; // e.g., "2-4 hours/week"

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
    this.idealtudentProfile = 'Enthusiastic learners',
    this.timeCommitment = 'Flexible',
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
    String? idealtudentProfile,
    String? timeCommitment,
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
      idealtudentProfile: idealtudentProfile ?? this.idealtudentProfile,
      timeCommitment: timeCommitment ?? this.timeCommitment,
    );
  }
}
