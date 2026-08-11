import 'package:voxflow/feature/submit_task/domain/entity/submit_task_entity.dart';
import 'package:voxflow/feature/submit_task/domain/repository/submit_task_repository.dart';

class SubmitAudioUseCase {
  final SubmitTaskRepository repository;
  SubmitAudioUseCase(this.repository);
  Future<SubmitTaskEntity> call(String path) => repository.submitAudio(audioPath: path);
}
