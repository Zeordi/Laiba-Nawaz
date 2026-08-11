import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/task/data/data_source/task_remote_data_source.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';
import 'package:voxflow/feature/task/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TaskEntity>>> getDepartmentTasks({String status = "All"}) async {
    final result = await remoteDataSource.getDepartmentTasks(status: status);
    return result.map((tasks) => tasks); // TaskModel is a TaskEntity
  }

  @override
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status) async {
    return await remoteDataSource.updateTaskStatus(taskId, status);
  }
}
