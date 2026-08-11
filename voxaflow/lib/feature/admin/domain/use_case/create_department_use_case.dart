import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class CreateDepartmentUseCase {
  final AdminRepository repository;

  CreateDepartmentUseCase({required this.repository});

  Future<Either<Failure, void>> call(String name) {
    return repository.createDepartment(name);
  }
}
