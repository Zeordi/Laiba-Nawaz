import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/check_connectivity.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/profile/data/data_source/profile_data_source.dart';
import 'package:voxflow/feature/profile/domain/entity/profile_entity.dart';
import 'package:voxflow/feature/profile/domain/repo/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  final ProfileDataSource dataSource;
  final NetworkInfo networkInfo;

  ProfileRepoImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    // Check connectivity if fetching from remote, otherwise local
    // For now, getProfile might be local-first
    return await dataSource.getProfile();
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    return await dataSource.logOut();
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(String name, String phoneNumber, String department) async {
    if (await networkInfo.isConnected) {
      return await dataSource.updateProfile(name, phoneNumber, department);
    }
    return Left(ConnectionError("No Internet Connection"));
  }
}
