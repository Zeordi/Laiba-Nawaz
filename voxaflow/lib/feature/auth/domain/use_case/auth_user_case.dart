


import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/auth/domain/entity/auth_entity.dart';
import 'package:voxflow/feature/auth/domain/repo/auth_repo.dart';

class AuthUserCase {
  final AuthRepo authRepo;

  AuthUserCase({required this.authRepo});

  Future<Either<Failure, AuthEntity>> logInUser(String email, String password) async {
    return await authRepo.logInUser(email, password);
  }

  Future<Either<Failure, AuthEntity>> isLogin() async {
    return await authRepo.isUserLogin();
  }

  Future<Either<Failure, bool>> signUpUser(String name, String email, String password, String departmentId) async {
    return await authRepo.signUpUser(name, email, password, departmentId);
  }

  Future<Either<Failure, bool>> logOutUser() async {
    return await authRepo.logOutUser();
  }
  Future<Either<Failure, bool>> confirmOTP(String email, String otp) async{
    return await authRepo.confirmOTP(email, otp);
  }

  Future<Either<Failure, bool>> resendVerificationCode(String email) async {
    return await authRepo.resendVerificationCode(email);
  }
  
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    return await authRepo.forgotPassword(email);
  }
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword) async{
    return await authRepo.resetPassword(email, newPassword);
  }

}