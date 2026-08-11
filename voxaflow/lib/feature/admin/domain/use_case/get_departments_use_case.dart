import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/entity/department_entity.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class GetDepartmentsUseCase {
  final AdminRepository repository;

  GetDepartmentsUseCase({required this.repository});

  Future<Either<Failure, List<DepartmentEntity>>> call({bool forceRefresh = false}) {
    return repository.getDepartments(forceRefresh: forceRefresh);
  }
}
