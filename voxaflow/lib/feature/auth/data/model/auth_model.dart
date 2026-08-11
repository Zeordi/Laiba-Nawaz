import 'package:voxflow/feature/auth/domain/entity/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.role,
    super.departmentName,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    userId: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt: json["createdAt"],
    role: json["role"] ?? "user", // Default to user if not present
    departmentName: json["department"] != null ? json["department"]["name"] : json["department_name"],
  );

  AuthEntity toEntity() => AuthEntity(
    userId: userId,
    name: name,
    email: email,
    createdAt: createdAt,
    role: role,
    departmentName: departmentName,
  );
}
