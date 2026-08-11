import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxflow/core/utility/check_connectivity.dart';
import 'package:voxflow/feature/auth/data/data_source/auth_data_source.dart';
import 'package:voxflow/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:voxflow/feature/auth/domain/repo/auth_repo.dart';
import 'package:voxflow/feature/auth/domain/use_case/auth_user_case.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/profile/data/data_source/profile_data_source.dart';
import 'package:voxflow/feature/profile/data/repo/profile_repo_impl.dart';
import 'package:voxflow/feature/profile/domain/repo/profile_repo.dart';
import 'package:voxflow/feature/profile/domain/use_case/profile_use_case.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_bloc.dart';
import 'package:voxflow/feature/admin/data/data_source/admin_remote_data_source.dart';
import 'package:voxflow/feature/admin/data/repository/admin_repository_impl.dart';
import 'package:voxflow/feature/admin/domain/repository/admin_repository.dart';
import 'package:voxflow/feature/admin/domain/use_case/get_users_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/get_departments_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/create_department_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/delete_department_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/update_user_department_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/verify_user_use_case.dart';
import 'package:voxflow/feature/admin/presentation/state/admin_bloc.dart';
import 'package:voxflow/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:voxflow/feature/home/data/repository/home_repository_impl.dart';
import 'package:voxflow/feature/home/domain/repository/home_repository.dart';
import 'package:voxflow/feature/home/domain/usecase/get_home_data_usecase.dart';
import 'package:voxflow/feature/home/presentation/state/home_bloc.dart';
import 'package:voxflow/feature/task/data/data_source/task_remote_data_source.dart';
import 'package:voxflow/feature/task/data/repository/task_repository_impl.dart';
import 'package:voxflow/feature/task/domain/repository/task_repository.dart';
import 'package:voxflow/feature/task/domain/usecase/get_department_tasks_usecase.dart';
import 'package:voxflow/feature/task/domain/usecase/update_task_status_usecase.dart';
import 'package:voxflow/feature/task/presentation/state/task_bloc.dart';
import 'package:voxflow/feature/submit_task/data/datasource/submit_task_remote_datasource.dart';
import 'package:voxflow/feature/submit_task/data/repository/submit_task_repository_impl.dart';
import 'package:voxflow/feature/submit_task/domain/repository/submit_task_repository.dart';
import 'package:voxflow/feature/submit_task/domain/usecase/submit_audio_usecase.dart';
import 'package:voxflow/feature/submit_task/domain/usecase/submit_text_usecase.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_bloc.dart';

final locator = GetIt.instance;
Future<void> setUpLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final InternetConnectionChecker connectionChecker =
      InternetConnectionChecker.createInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => connectionChecker);
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: locator()),
  );
  

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://20.48.224.159:8000/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status <= 500;
      },
    ),
  );

  locator.registerSingleton<Dio>(dio);

  // auth registration feature 
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(dio: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(authDataSource: locator(), networkInfo: locator()));
  locator.registerLazySingleton(() => AuthUserCase(authRepo: locator()));
  locator.registerLazySingleton(() => AuthBloc(useCase: locator()));

  // profile registration feature
  locator.registerLazySingleton<ProfileDataSource>(() => ProfileDataSourceImpl(dio: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(dataSource: locator(), networkInfo: locator()));
  locator.registerLazySingleton(() => ProfileUseCase(repository: locator()));
  locator.registerLazySingleton(() => ProfileBloc(useCase: locator()));

  // admin registration feature
  locator.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(dio: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton(() => GetUsersUseCase(repository: locator()));
  locator.registerLazySingleton(() => GetDepartmentsUseCase(repository: locator()));
  locator.registerLazySingleton(() => CreateDepartmentUseCase(repository: locator()));
  locator.registerLazySingleton(() => DeleteDepartmentUseCase(repository: locator()));
  locator.registerLazySingleton(() => UpdateUserDepartmentUseCase(locator()));
  locator.registerLazySingleton(() => VerifyUserUseCase(locator()));
  locator.registerFactory(() => AdminBloc(
    getUsersUseCase: locator(),
    getDepartmentsUseCase: locator(),
    createDepartmentUseCase: locator(),
    deleteDepartmentUseCase: locator(),
    updateUserDepartmentUseCase: locator(),
    verifyUserUseCase: locator(),
  ));

  // home registration feature
  locator.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(dio: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton(() => GetHomeDataUseCase(locator()));
  locator.registerFactory(() => HomeBloc(getHomeDataUseCase: locator()));

  // submit task registration feature
  locator.registerLazySingleton<SubmitTaskRemoteDataSource>(() => SubmitTaskRemoteDataSourceImpl(dio: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<SubmitTaskRepository>(() => SubmitTaskRepositoryImpl(locator()));
  locator.registerLazySingleton(() => SubmitAudioUseCase(locator()));
  locator.registerLazySingleton(() => SubmitTextUseCase(locator()));
  locator.registerFactory(() => SubmitTaskBloc(submitAudio: locator(), submitText: locator()));

  // task registration feature
  locator.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(dio: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton(() => GetDepartmentTasksUseCase(repository: locator()));
  locator.registerLazySingleton(() => UpdateTaskStatusUseCase(repository: locator()));
  locator.registerFactory(() => TaskBloc(
        getDepartmentTasksUseCase: locator(),
        updateTaskStatusUseCase: locator(),
      ));
}