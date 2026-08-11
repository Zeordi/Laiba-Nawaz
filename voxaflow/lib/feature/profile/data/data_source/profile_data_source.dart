import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/profile/data/model/profile_model.dart';
import 'package:voxflow/feature/profile/domain/entity/profile_entity.dart';

abstract class ProfileDataSource {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(String name, String phoneNumber, String department);
  Future<Either<Failure, bool>> logOut(); 
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ProfileDataSourceImpl({required this.dio, required this.sharedPreferences});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final jsonString = sharedPreferences.getString('user_data');
      if (jsonString != null) {
        final profileModel = ProfileModel.fromJson(jsonDecode(jsonString));
        // Optionally fetch fresh data from API
        // final response = await dio.get('/v1/auth/me'); // Example endpoint
        // if (response.statusCode == 200) { ... update cache ... }
        return Right(profileModel.toEntity());
      } else {
        return Left(UnauthorizedError("User not logged in"));
      }
    } catch (e) {
      return Left(ServerError("Cache Error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(String name, String phoneNumber, String department) async {
    try {
       // Example update call
       /*
      final response = await dio.put(
        '/v1/users/profile',
        data: {
          "name": name,
          "phone_number": phoneNumber,
          "department_id": department
        },
      );
      if (response.statusCode == 200) {
        // Update local cache
        final data = response.data;
        // Merge with existing or use new
        
        return Right(ProfileModel.fromJson(data).toEntity());
      } else {
         return Left(ServerError("Update failed"));
      }
      */
      
      // For now, simulate success or just return local update if no API
       final jsonString = sharedPreferences.getString('user_data');
       if (jsonString != null) {
         Map<String, dynamic>  userMap = jsonDecode(jsonString);
         userMap['name'] = name;
         userMap['phone_number'] = phoneNumber;
         userMap['department_id'] = department;
         
         await sharedPreferences.setString('user_data', jsonEncode(userMap));
         return Right(ProfileModel.fromJson(userMap).toEntity());
       }
       return Left(ServerError("No user data to update"));

    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerError(e.response?.data['detail'] ?? "Update failed"));
      }
      return Left(ConnectionError("Connection failed"));
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      await sharedPreferences.remove('access_token');
      await sharedPreferences.remove('refresh_token');
      await sharedPreferences.remove('user_data');
      print("removed");
      return const Right(true);
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
}
