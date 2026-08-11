import 'package:voxflow/feature/admin/domain/entity/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  DepartmentModel({
    required super.id,
    required super.name,
    required super.leaderName,
    super.createdAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      leaderName: json['leader_name'] ?? '',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'leader_name': leaderName,
      'created_at': createdAt,
    };
  }
}
