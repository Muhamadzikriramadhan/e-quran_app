class ProfileEntity {
  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;
  final DateTime? updatedAt;

  ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    this.updatedAt,
  });
}
