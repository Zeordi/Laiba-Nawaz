import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/home/domain/entity/home_entity.dart';
import 'package:voxflow/feature/home/domain/repository/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository homeRepository;

  GetHomeDataUseCase(this.homeRepository);

  Future<Either<Failure, HomeEntity>> call() {
    return homeRepository.getHomeData();
  }
}
