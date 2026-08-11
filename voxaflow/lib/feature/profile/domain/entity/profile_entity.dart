class ProfileEntity {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? department;

  ProfileEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.department,
  });
}
