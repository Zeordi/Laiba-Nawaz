import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/home/data/model/home_model.dart';
// import 'package:voxflow/feature/auth/data/model/auth_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, HomeModel>> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  HomeRemoteDataSourceImpl({required this.dio, required this.sharedPreferences});

  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token == null) {
        return Left(UnauthorizedError("No access token found"));
      }

      final response = await dio.get(
        '/v1/home',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Right(HomeModel.fromJson(response.data));
      } else {
        return Left(ServerError(response.data['detail'] ?? "Failed to fetch home data"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Failed to fetch home data"));
      } else {
        return Left(ConnectionError("Network error check your connection"));
      }
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
}
