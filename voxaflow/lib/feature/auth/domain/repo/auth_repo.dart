


import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/auth/domain/entity/auth_entity.dart';

abstract class AuthRepo{
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