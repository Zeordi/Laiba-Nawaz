import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class VerifyUserUseCase {
  final AdminRepository repository;

  VerifyUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.verifyUser(userId);
  }
}
