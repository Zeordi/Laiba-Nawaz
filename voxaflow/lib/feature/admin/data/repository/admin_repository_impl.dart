import 'package:dartz/dartz.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/data/data_source/admin_remote_data_source.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/domain/entity/department_entity.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  List<UserEntity>? _cachedUsers;
  List<DepartmentEntity>? _cachedDepartments;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedUsers != null) {
      return Right(_cachedUsers!);
    }
    final result = await remoteDataSource.getUsers();
    return result.map((users) {
      final userEntities = users.map((e) => e as UserEntity).toList();
      _cachedUsers = userEntities;
      return userEntities;
    });
  }

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedDepartments != null) {
      return Right(_cachedDepartments!);
    }
    final result = await remoteDataSource.getDepartments();
    return result.map((departments) {
      final deptEntities = departments.map((e) => e as DepartmentEntity).toList();
      _cachedDepartments = deptEntities;
      return deptEntities;
    });
  }

  @override
  Future<Either<Failure, void>> createDepartment(String name) async {
    final result = await remoteDataSource.createDepartment(name);
    if (result.isRight()) {
       _cachedDepartments = null; // Invalidate cache
    }
    return result;
  }

  @override
  Future<Either<Failure, void>> deleteDepartment(String id) async {
    final result = await remoteDataSource.deleteDepartment(id);
    if (result.isRight()) {
       _cachedDepartments = null; // Invalidate cache
    }
    return result;
  }

  @override
  Future<Either<Failure, void>> updateUserDepartment(String userId, String departmentId) async {
    final result = await remoteDataSource.updateUserDepartment(userId, departmentId);
    if (result.isRight()) {
      _cachedUsers = null; // Invalidate cache
    }
    return result;
  }

  @override
  Future<Either<Failure, void>> verifyUser(String userId) async {
    final result = await remoteDataSource.verifyUser(userId);
    if (result.isRight()) {
      _cachedUsers = null; // Invalidate cache
    }
    return result;
  }
}
