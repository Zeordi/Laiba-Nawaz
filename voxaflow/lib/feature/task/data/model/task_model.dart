import 'package:voxflow/feature/task/domain/entity/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.originalText,
    required super.departmentId,
    required super.departmentName,
    required super.priority,
    required super.status,
    required super.detailValue,
    required super.tags,
    required super.confidentialityPercent,
    required super.createdBy,
    required super.createdByName,
    required super.createdAt,
    super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      originalText: json['original_text'] ?? '',
      departmentId: json['department_id'] ?? '',
      departmentName: json['department_name'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      detailValue: json['detail_value'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      confidentialityPercent: (json['confidentiality_percent'] as num?)?.toDouble() ?? 0.0,
      createdBy: json['created_by'] ?? '',
      createdByName: json['created_by_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
    );
  }
}
