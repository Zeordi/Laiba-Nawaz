import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/profile/domain/entity/profile_entity.dart';
import 'package:voxflow/feature/profile/domain/repo/profile_repo.dart';

class ProfileUseCase {
  final ProfileRepo repository;

  ProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileEntity>> getProfile() async {
    return await repository.getProfile();
  }

  Future<Either<Failure, ProfileEntity>> updateProfile(String name, String phoneNumber, String department) async {
    return await repository.updateProfile(name, phoneNumber, department);
  }

  Future<Either<Failure, bool>> logOut() async {
    return await repository.logOut();
  }
}
