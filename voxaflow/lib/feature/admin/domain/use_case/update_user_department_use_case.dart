import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class UpdateUserDepartmentUseCase {
  final AdminRepository repository;

  UpdateUserDepartmentUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, String departmentId) {
    return repository.updateUserDepartment(userId, departmentId);
  }
}
