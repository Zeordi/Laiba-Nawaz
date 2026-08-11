import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/feature/submit_task/domain/entity/submit_task_entity.dart';

abstract class SubmitTaskRemoteDataSource {
  Future<SubmitTaskEntity> submitAudio({required String audioPath});
  Future<SubmitTaskEntity> submitText({required String text});
}

class SubmitTaskRemoteDataSourceImpl implements SubmitTaskRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  SubmitTaskRemoteDataSourceImpl({required this.dio, required this.sharedPreferences});

  @override
  Future<SubmitTaskEntity> submitAudio({required String audioPath}) async {
    // TODO: integrate API call
    return SubmitTaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      audioPath: audioPath,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<SubmitTaskEntity> submitText({required String text}) async {
    try {
      final token = sharedPreferences.getString("access_token") ?? '';
      
      final response = await dio.post(
        '/v1/tasks',
        data: {
          "ai_summarized_text": text
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
         // Assuming response data matches or can be ignored for now since we just need success
         // If response returns the task, we can map it. For now, returning dummy based on success.
          return SubmitTaskEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            transcript: text,
            createdAt: DateTime.now(),
          );
      } else {
        throw Exception('Failed to submit task: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to submit task: $e');
    }
  }
}
