import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class DeleteDepartmentUseCase {
  final AdminRepository repository;

  DeleteDepartmentUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteDepartment(id);
  }
}
