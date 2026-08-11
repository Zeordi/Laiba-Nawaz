import 'package:voxflow/feature/home/domain/entity/home_entity.dart';
import 'package:voxflow/feature/task/data/model/task_model.dart';

class HomeModel extends HomeEntity {
  HomeModel({
    required super.totalTasks,
    required super.pendingTasks,
    required super.approvedTasks,
    required super.rejectedTasks,
    required super.listOfPendingTasks,
    required super.totalDepartmentsMembers,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      totalTasks: json['total_tasks'] ?? 0,
      pendingTasks: json['pending_tasks'] ?? 0,
      approvedTasks: json['approved_tasks'] ?? 0,
      rejectedTasks: json['rejected_tasks'] ?? 0,
      listOfPendingTasks: (json['list_of_pending_tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e))
              .toList() ??
          [],
      totalDepartmentsMembers: json['total_departments_members'] ?? 0,
    );
  }
}
