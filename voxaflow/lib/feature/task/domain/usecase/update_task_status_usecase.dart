import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/task/domain/repository/task_repository.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository repository;

  UpdateTaskStatusUseCase({required this.repository});

  Future<Either<Failure, void>> call(String taskId, String status) {
    return repository.updateTaskStatus(taskId, status);
  }
}
