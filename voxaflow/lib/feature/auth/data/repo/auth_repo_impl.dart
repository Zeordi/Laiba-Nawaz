

import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/check_connectivity.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/auth/data/data_source/auth_data_source.dart';
import 'package:voxflow/feature/auth/domain/entity/auth_entity.dart';
import 'package:voxflow/feature/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthDataSource authDataSource;
  final NetworkInfo networkInfo;
  AuthRepoImpl({
    required this.authDataSource,
    required this.networkInfo
  });
  @override
  Future<Either<Failure, AuthEntity>> isUserLogin() async{
    return await authDataSource.isUserLogin();
  }

  @override
  Future<Either<Failure, AuthEntity>> logInUser(String email, String password) async{
      if(await networkInfo.isConnected){
        return await authDataSource.logInUser(email, password);
      }
      return Left(ConnectionError("No Internet Connection"));
  }

  @override
  Future<Either<Failure, bool>> logOutUser() async{
    return await authDataSource.logOutUser();
  }

  @override
  Future<Either<Failure, bool>> signUpUser(String name, String email, String password, String departmentId) async{
      if(await networkInfo.isConnected){
        return await authDataSource.signUpUser(name, email, password, departmentId);
      }
      return Left(ConnectionError("No Internet Connection"));
  }
  
  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async{
    if(await networkInfo.isConnected){
      return await authDataSource.forgotPassword(email);
    }
    return Left(ConnectionError("No Internet Connection"));
  }
  
  @override
  Future<Either<Failure, bool>> confirmOTP(String email, String otp) async{
    if(await networkInfo.isConnected){
      return await authDataSource.confirmOTP(email, otp);
    }
    return Left(ConnectionError("No Internet Connection"));
  }

  @override
  Future<Either<Failure, bool>> resendVerificationCode(String email) async {
    if(await networkInfo.isConnected){
      return await authDataSource.resendVerificationCode(email);
    }
    return Left(ConnectionError("No Internet Connection"));
  }
  
  @override
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword) async{
    if(await networkInfo.isConnected){
      return await authDataSource.resetPassword(email, newPassword);
    }
    return Left(ConnectionError("No Internet Connection"));
  }

}