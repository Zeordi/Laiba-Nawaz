import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/task/data/model/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<Either<Failure, List<TaskModel>>> getDepartmentTasks({String status = "All"});
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  TaskRemoteDataSourceImpl({required this.dio, required this.sharedPreferences});


  Future<Either<Failure, List<TaskModel>>> getMyTask() async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.get(
        '/v1/tasks',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("MyTask Status Code: ${response.statusCode}");
      print("MyTask Data: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> result = response.data['tasks'] ?? [];
        final tasks = result.map((e) => TaskModel.fromJson(e)).toList();
        return Right(tasks);
      } else {
        print("MyTask Error: ${response.data}");
        return Left(ServerError(response.data['detail'] ?? "Failed to fetch tasks"));
      }
    } on DioException catch (e) {
      print("MyTask Dio Error: ${e.message}");
      print("MyTask Dio Response: ${e.response?.data}");
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to fetch tasks"));
      } else {
        return Left(ConnectionError("Network error: ${e.message}"));
      }
    } catch (e) {
      print("MyTask Generic Error: $e");
      return Left(ServerError(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status) async {
    try {
      
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.put(
        '/v1/tasks',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "task_id": taskId,
          "status": status,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to update task status"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to update task status"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      print(e);
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getDepartmentTasks({String status = "All"}) async {
    try {
      print("Filter Status: $status");
      if(status == "My Task" || status == "My-Task"){
        print("fetching my tasks...");
        return await getMyTask();
      }
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

    

      final response = await dio.get(
        '/v1/tasks/department',
       
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // 
      


      if (response.statusCode == 200) {
        final List<dynamic> result = response.data['tasks'] ?? [];
        print(result);
        if(status != "All"){
          result.retainWhere((task) => task['status'] == status.toLowerCase());
        }

        final tasks = result.map((e) => TaskModel.fromJson(e)).toList();
        return Right(tasks);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to fetch tasks"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to fetch tasks"));
      } else {
        return Left(ConnectionError("Network error: ${e.message}"));
      }
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
}
