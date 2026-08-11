import 'package:voxflow/feature/profile/domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.role,
    super.phoneNumber,
    super.department,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String? dept;
    if (json["department_name"] is Map) {
      dept = json["department_name"]["name"];
    } else if (json["department_name"] != null) {
      dept = json["department_name"];
    } else {
      dept = json["department_id"];
    }

    return ProfileModel(
        userId: json["id"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        role: json["role"] ?? "user",
        phoneNumber: json["phone_number"],
        department: dept, 
      );
  }

  Map<String, dynamic> toJson() => {
        "id": userId,
        "name": name,
        "email": email,
        "role": role,
        "phone_number": phoneNumber,
        "department_id": department,
      };

  ProfileEntity toEntity() => ProfileEntity(
        userId: userId,
        name: name,
        email: email,
        role: role,
        phoneNumber: phoneNumber,
        department: department,
      );
}
