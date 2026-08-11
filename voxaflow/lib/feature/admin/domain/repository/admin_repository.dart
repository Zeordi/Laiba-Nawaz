import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/domain/entity/department_entity.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({bool forceRefresh = false});
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments({bool forceRefresh = false});
  Future<Either<Failure, void>> createDepartment(String name);
  Future<Either<Failure, void>> deleteDepartment(String id);
  Future<Either<Failure, void>> updateUserDepartment(String userId, String departmentId);
  Future<Either<Failure, void>> verifyUser(String userId);
}
