class TaskEntity {
  final String id;
  final String originalText;
  final String departmentId;
  final String departmentName;
  final String priority;
  final String status;
  final String detailValue;
  final List<String> tags;
  final double confidentialityPercent;
  final String createdBy;
  final String createdByName;
  final String createdAt;
  final String? updatedAt;

  TaskEntity({
    required this.id,
    required this.originalText,
    required this.departmentId,
    required this.departmentName,
    required this.priority,
    required this.status,
    required this.detailValue,
    required this.tags,
    required this.confidentialityPercent,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    this.updatedAt,
  });
}
