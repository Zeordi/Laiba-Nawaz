import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:voxflow/feature/home/domain/entity/home_entity.dart';
import 'package:voxflow/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeEntity>> getHomeData() async {
    final result = await remoteDataSource.getHomeData();
    return result.map((homeModel) => homeModel); // Model extends Entity
  }
}
