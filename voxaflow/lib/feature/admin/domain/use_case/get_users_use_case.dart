import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class GetUsersUseCase {
  final AdminRepository repository;

  GetUsersUseCase({required this.repository});

  Future<Either<Failure, List<UserEntity>>> call({bool forceRefresh = false}) {
    return repository.getUsers(forceRefresh: forceRefresh);
  }
}
