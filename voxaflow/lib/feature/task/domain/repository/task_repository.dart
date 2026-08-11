import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getDepartmentTasks({String status = "All"});
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status);
}
