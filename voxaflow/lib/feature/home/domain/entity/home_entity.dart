import 'package:voxflow/feature/task/domain/entity/task_entity.dart';

class HomeEntity {
  final int totalTasks;
  final int pendingTasks;
  final int approvedTasks;
  final int rejectedTasks;
  final List<TaskEntity> listOfPendingTasks;
  final int totalDepartmentsMembers;

  HomeEntity({
    required this.totalTasks,
    required this.pendingTasks,
    required this.approvedTasks,
    required this.rejectedTasks,
    required this.listOfPendingTasks,
    required this.totalDepartmentsMembers,
  });
}
