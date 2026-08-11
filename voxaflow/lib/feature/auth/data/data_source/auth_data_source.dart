


import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/auth/data/model/auth_model.dart';
import 'package:voxflow/feature/auth/domain/entity/auth_entity.dart';

abstract class AuthDataSource {
  Future<Either<Failure, AuthEntity>> logInUser(
    String email,
    String password
  );
  Future<Either<Failure, bool>> logOutUser();
  Future<Either<Failure, AuthEntity>> isUserLogin();
  Future<Either<Failure, bool>> signUpUser(
    String name,
    String email,
    String password,
    String departmentId
  );
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> confirmOTP(String email, String otp);
  Future<Either<Failure, bool>> resendVerificationCode(String email);
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword);
}

class AuthDataSourceImpl extends AuthDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  AuthDataSourceImpl({
    required this.dio,
    required this.sharedPreferences
  });
  
  @override
  Future<Either<Failure, AuthEntity>> isUserLogin() async {
    try {
      final jsonString = sharedPreferences.getString('user_data');
      if (jsonString != null) {
        final authModel = AuthModel.fromJson(jsonDecode(jsonString));
        return Right(authModel.toEntity());
      } else {
        return Left(UnauthorizedError("User not logged in"));
      }
    } catch (e) {
      return Left(ServerError("Cache Error: ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Failure, AuthEntity>> logInUser(String email, String password) async {
    try {
      print("sarted");
      final response = await dio.post(
        '/v1/auth/login',
        data: {
          "email": email,
          "password": password
        },
      );
      print("sarted");
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data;
        final userMap = data['user'] as Map<String, dynamic>;
        
        userMap['email'] = email;
        
        if (userMap.containsKey('created_at') && !userMap.containsKey('createdAt')) {
          userMap['createdAt'] = userMap['created_at'];
        }

        final authModel = AuthModel.fromJson(userMap);
        
        await sharedPreferences.setString('access_token', data['access_token']);
        await sharedPreferences.setString('refresh_token', data['refresh_token']);
        await sharedPreferences.setString('user_data', jsonEncode(userMap));

        return Right(authModel.toEntity());
      } else {
        return Left(ServerError(response.data['detail'] ?? "Login failed"));
      }
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Login failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      print(e);
      return Left(ServerError(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> logOutUser() async {
    try {
      await sharedPreferences.remove('access_token');
      await sharedPreferences.remove('refresh_token');
      await sharedPreferences.remove('user_data');
      return const Right(true);
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> signUpUser(String name, String email, String password, String departmentId) async {
    try {
      final response = await dio.post(
        '/v1/auth/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "department_id": departmentId
        },
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Registration failed"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Registration failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        '/v1/auth/forget-password',
        data: {
          "email": email
        },
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Request failed"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Request failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmOTP(String email, String otp) async {
    try {
      print("started");
      final response = await dio.post(
        '/v1/auth/verify-email',
        data: {
          "email": email,
          "otp": otp
        },
      );
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Verification failed"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Verification failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resendVerificationCode(String email) async {
    try {
      final response = await dio.post(
        '/v1/auth/resend-verification-code',
        data: {
          "email": email
        },
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Resend failed"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Resend failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword) async {
    try {
      print(email);
      final response = await dio.post(
        '/v1/auth/reset-password',
        data: {
          "email": email,
          "password": newPassword
        },
      );
      print(response.data);
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ServerError(response.data['detail'] ?? "Reset password failed"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Reset password failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
}