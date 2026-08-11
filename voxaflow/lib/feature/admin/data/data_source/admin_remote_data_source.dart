import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/data/model/user_model.dart';
import 'package:voxflow/feature/admin/data/model/department_model.dart';

abstract class AdminRemoteDataSource {
  Future<Either<Failure, List<UserModel>>> getUsers();
  Future<Either<Failure, List<DepartmentModel>>> getDepartments();
  Future<Either<Failure, void>> createDepartment(String name);
  Future<Either<Failure, void>> deleteDepartment(String id);
  Future<Either<Failure, void>> updateUserDepartment(String userId, String departmentId);
  Future<Either<Failure, void>> verifyUser(String userId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  AdminRemoteDataSourceImpl({required this.dio, required this.sharedPreferences});

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.get(
        '/v1/admin/users',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final users = data.map((json) => UserModel.fromJson(json)).toList();
        return Right(users);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to fetch users"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to fetch users"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> getDepartments() async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.get(
        '/v1/admin/department',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final departments = data.map((json) => DepartmentModel.fromJson(json)).toList();
        return Right(departments);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to fetch departments"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to fetch departments"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createDepartment(String name) async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.post(
        '/v1/admin/department',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "name": name,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to create department"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to create department"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDepartment(String id) async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.delete(
        '/v1/admin/department',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "department_id": id,
        },
      );
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to delete department"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to delete department"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserDepartment(String userId, String departmentId) async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.put(
        '/v1/admin/department/change-user-department',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "user_id": userId,
          "new_department_id": departmentId,
        },
      );
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to update user department"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to update user department"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyUser(String userId) async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.put(
        '/v1/admin/verify-user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "user_id": userId,
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to verify user"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to verify user"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
}
