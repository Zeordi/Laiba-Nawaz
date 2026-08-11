class UserEntity {
  final String id;
  final String name;
  final String email;
  final String departmentId;
  final String departmentName;
  final String role;
  final bool isHead;
  final bool isAdminVerified;
  final String? createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.departmentId,
    required this.departmentName,
    required this.role,
    required this.isHead,
    this.isAdminVerified = false,
    this.createdAt,
  });
}
