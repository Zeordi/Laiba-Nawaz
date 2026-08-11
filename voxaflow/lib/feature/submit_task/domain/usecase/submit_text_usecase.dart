import 'package:voxflow/feature/submit_task/domain/entity/submit_task_entity.dart';
import 'package:voxflow/feature/submit_task/domain/repository/submit_task_repository.dart';

class SubmitTextUseCase {
  final SubmitTaskRepository repository;
  SubmitTextUseCase(this.repository);
  Future<SubmitTaskEntity> call(String text) => repository.submitText(text: text);
}
