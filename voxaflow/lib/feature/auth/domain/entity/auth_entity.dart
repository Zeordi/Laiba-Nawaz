

class AuthEntity {
  final String userId;
  final String name;
  final String email;
  final String createdAt;
  final String role;
  final String? departmentName;

  AuthEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.role,
    this.departmentName,
  });
}