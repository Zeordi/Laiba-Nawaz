import 'package:voxflow/feature/submit_task/domain/entity/submit_task_entity.dart';
import 'package:voxflow/feature/submit_task/domain/repository/submit_task_repository.dart';
import 'package:voxflow/feature/submit_task/data/datasource/submit_task_remote_datasource.dart';

class SubmitTaskRepositoryImpl implements SubmitTaskRepository {
  final SubmitTaskRemoteDataSource remote;
  SubmitTaskRepositoryImpl(this.remote);

  @override
  Future<SubmitTaskEntity> submitAudio({required String audioPath}) {
    return remote.submitAudio(audioPath: audioPath);
  }

  @override
  Future<SubmitTaskEntity> submitText({required String text}) {
    return remote.submitText(text: text);
  }
}
