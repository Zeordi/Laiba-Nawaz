import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/profile/domain/entity/profile_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(String name, String phoneNumber, String department);
  Future<Either<Failure, bool>> logOut();
}
