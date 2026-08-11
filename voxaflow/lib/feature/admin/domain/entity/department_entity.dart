class DepartmentEntity {
  final String id;
  final String name;
  final String leaderName;
  final String? createdAt;

  DepartmentEntity({
    required this.id,
    required this.name,
    required this.leaderName,
    this.createdAt,
  });
}
