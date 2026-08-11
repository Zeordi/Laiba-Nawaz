import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';
import 'package:voxflow/feature/task/domain/repository/task_repository.dart';

class GetDepartmentTasksUseCase {
  final TaskRepository repository;

  GetDepartmentTasksUseCase({required this.repository});

  Future<Either<Failure, List<TaskEntity>>> call({String status = "All"}) {
    return repository.getDepartmentTasks(status: status);
  }
}
