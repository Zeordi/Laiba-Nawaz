import 'package:voxflow/feature/submit_task/domain/entity/submit_task_entity.dart';

abstract class SubmitTaskRepository {
  Future<SubmitTaskEntity> submitAudio({required String audioPath});
  Future<SubmitTaskEntity> submitText({required String text});
}
