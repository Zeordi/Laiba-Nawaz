import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String name,
    required String email,
    required String departmentId,
    required String departmentName,
    required String role,
    required bool isHead,
    bool isAdminVerified = false,
    String? createdAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          departmentId: departmentId,
          departmentName: departmentName,
          role: role,
          isHead: isHead,
          isAdminVerified: isAdminVerified,
          createdAt: createdAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      departmentId: json['department_id'] ?? '',
      departmentName: json['department_name'] ?? '',
      role: json['role'] ?? '',
      isHead: json['is_head'] ?? false,
      isAdminVerified: json['is_admin_verified'] ?? false,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department_id': departmentId,
      'department_name': departmentName,
      'role': role,
      'is_head': isHead,
      'is_admin_verified': isAdminVerified,
      'created_at': createdAt,
    };
  }
}
