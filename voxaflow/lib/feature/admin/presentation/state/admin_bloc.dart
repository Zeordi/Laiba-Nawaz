import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/core/utility/failure.dart';
import 'package:voxflow/feature/admin/domain/entity/department_entity.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/domain/use_case/get_departments_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/get_users_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/create_department_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/delete_department_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/update_user_department_use_case.dart';
import 'package:voxflow/feature/admin/domain/use_case/verify_user_use_case.dart';

// Events
abstract class AdminEvent {}

class GetUsersEvent extends AdminEvent {
  final bool forceRefresh;
  GetUsersEvent({this.forceRefresh = false});
}

class GetDepartmentsEvent extends AdminEvent {
  final bool forceRefresh;
  GetDepartmentsEvent({this.forceRefresh = false});
}

class CreateDepartmentEvent extends AdminEvent {
  final String name;
  CreateDepartmentEvent(this.name);
}

class DeleteDepartmentEvent extends AdminEvent {
  final String id;
  DeleteDepartmentEvent(this.id);
}

class FilterUsersEvent extends AdminEvent {
  final String departmentId;
  FilterUsersEvent(this.departmentId);
}

class UpdateUserDepartmentEvent extends AdminEvent {
  final String userId;
  final String departmentId;
  UpdateUserDepartmentEvent({required this.userId, required this.departmentId});
}

class VerifyUserEvent extends AdminEvent {
  final String userId;
  VerifyUserEvent(this.userId);
}

// States
abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final List<DepartmentEntity> departments;
  final String? selectedDepartmentId;

  // Background operation states
  final bool isAddingDepartment;
  final String? addDepartmentError;
  final bool? addDepartmentSuccess;

  final bool isDeletingDepartment;
  final String? deleteDepartmentError;
  final bool? deleteDepartmentSuccess;

  // Update User state
  final bool isUpdatingUser;
  final String? updateUserError;
  final bool? updateUserSuccess;

  // Verify User state
  final bool isVerifyingUser;
  final String? verifyUserError;
  final bool? verifyUserSuccess;

  // Refresh Users state
  final bool isRefreshingUsers;
  // Refresh Departments state
  final bool isRefreshingDepartments;

  AdminLoaded({
    required this.users,
    this.departments = const [],
    List<UserEntity>? filteredUsers,
    this.selectedDepartmentId,
    this.isAddingDepartment = false,
    this.addDepartmentError,
    this.addDepartmentSuccess,
    this.isDeletingDepartment = false,
    this.deleteDepartmentError,
    this.deleteDepartmentSuccess,
    this.isUpdatingUser = false,
    this.updateUserError,
    this.updateUserSuccess,
    this.isVerifyingUser = false,
    this.verifyUserError,
    this.verifyUserSuccess,
    this.isRefreshingUsers = false,
    this.isRefreshingDepartments = false,
  }) : filteredUsers = filteredUsers ?? users;

  AdminLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    List<DepartmentEntity>? departments,
    String? selectedDepartmentId,
    bool? isAddingDepartment,
    String? addDepartmentError,
    bool? addDepartmentSuccess,
    bool? isDeletingDepartment,
    String? deleteDepartmentError,
    bool? deleteDepartmentSuccess,
    bool? isUpdatingUser,
    String? updateUserError,
    bool? updateUserSuccess,
    bool? isVerifyingUser,
    String? verifyUserError,
    bool? verifyUserSuccess,
    bool? isRefreshingUsers,
    bool? isRefreshingDepartments,
  }) {
    return AdminLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      departments: departments ?? this.departments,
      selectedDepartmentId: selectedDepartmentId ?? this.selectedDepartmentId,
      isAddingDepartment: isAddingDepartment ?? this.isAddingDepartment,
      addDepartmentError: addDepartmentError ?? this.addDepartmentError,
      addDepartmentSuccess: addDepartmentSuccess ?? this.addDepartmentSuccess,
      isDeletingDepartment: isDeletingDepartment ?? this.isDeletingDepartment,
      deleteDepartmentError:
          deleteDepartmentError ?? this.deleteDepartmentError,
      deleteDepartmentSuccess:
          deleteDepartmentSuccess ?? this.deleteDepartmentSuccess,
      isUpdatingUser: isUpdatingUser ?? this.isUpdatingUser,
      updateUserError: updateUserError ?? this.updateUserError,
      updateUserSuccess: updateUserSuccess ?? this.updateUserSuccess,
      isVerifyingUser: isVerifyingUser ?? this.isVerifyingUser,
      verifyUserError: verifyUserError ?? this.verifyUserError,
      verifyUserSuccess: verifyUserSuccess ?? this.verifyUserSuccess,
      isRefreshingUsers: isRefreshingUsers ?? this.isRefreshingUsers,
      isRefreshingDepartments: isRefreshingDepartments ?? this.isRefreshingDepartments,
    );
  }
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

// Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetUsersUseCase getUsersUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final CreateDepartmentUseCase createDepartmentUseCase;
  final DeleteDepartmentUseCase deleteDepartmentUseCase;
  final UpdateUserDepartmentUseCase updateUserDepartmentUseCase;
  final VerifyUserUseCase verifyUserUseCase;

  AdminBloc({
    required this.getUsersUseCase,
    required this.getDepartmentsUseCase,
    required this.createDepartmentUseCase,
    required this.deleteDepartmentUseCase,
    required this.updateUserDepartmentUseCase,
    required this.verifyUserUseCase,
  }) : super(AdminInitial()) {
    on<GetUsersEvent>(_onGetUsers);
    on<GetDepartmentsEvent>(_onGetDepartments);
    on<CreateDepartmentEvent>(_onCreateDepartment);
    on<DeleteDepartmentEvent>(_onDeleteDepartment);
    on<FilterUsersEvent>(_onFilterUsers);
    on<UpdateUserDepartmentEvent>(_onUpdateUserDepartment);
    on<VerifyUserEvent>(_onVerifyUser);
  }

  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    bool isBackground = false;
    List<DepartmentEntity> currentDepartments = [];

    if (state is AdminLoaded) {
      isBackground = true;
      final current = state as AdminLoaded;
      currentDepartments = current.departments;
      emit(current.copyWith(isRefreshingUsers: true));
    } else {
      emit(AdminLoading());
    }

    final result = await getUsersUseCase(forceRefresh: event.forceRefresh);

    // We also need to fetch departments when fetching users to populate dropdown
    final deptResult = await getDepartmentsUseCase(
      forceRefresh: false,
    ); // Departments likely cached

    List<DepartmentEntity> departments = [];
    deptResult.fold((l) {
      if (isBackground) departments = currentDepartments;
    }, (r) => departments = r);

    result.fold(
      (failure) {
        if (isBackground) {
          emit((state as AdminLoaded).copyWith(isRefreshingUsers: false));
        } else {
          emit(AdminError(_mapFailureToMessage(failure)));
        }
      },
      (users) {
        if (isBackground) {
          final current = state as AdminLoaded;
          List<UserEntity> filtered;

          if (current.selectedDepartmentId != null &&
              current.selectedDepartmentId != "All" &&
              current.selectedDepartmentId!.isNotEmpty) {
            filtered =
                users
                    .where(
                      (user) =>
                          user.departmentId == current.selectedDepartmentId ||
                          user.departmentName == current.selectedDepartmentId,
                    )
                    .toList();
          } else {
            filtered = users;
          }

          emit(
            current.copyWith(
              users: users,
              filteredUsers: filtered,
              departments: departments,
              isRefreshingUsers: false,
            ),
          );
        } else {
          emit(AdminLoaded(users: users, departments: departments));
        }
      },
    );
  }

  Future<void> _onGetDepartments(
    GetDepartmentsEvent event,
    Emitter<AdminState> emit,
  ) async {
    // If we have users already, we preserve them. If not, we start with empty users.
    bool isBackground = false;
    List<UserEntity> currentUsers = [];

    if (state is AdminLoaded) {
      isBackground = true;
      final current = state as AdminLoaded;
      currentUsers = current.users;
      emit(current.copyWith(isRefreshingDepartments: true));
    } else {
      emit(AdminLoading());
    }

    final result = await getDepartmentsUseCase(
      forceRefresh: event.forceRefresh,
    );
    result.fold(
      (failure) {
        if (isBackground) {
           emit((state as AdminLoaded).copyWith(isRefreshingDepartments: false)); 
        } else {
           emit(AdminError(_mapFailureToMessage(failure)));
        }
      }, 
      (departments) {
      if (state is AdminLoaded) {
        final current = state as AdminLoaded;
        emit(
          current.copyWith(
            departments: departments,
            isRefreshingDepartments: false,
          ),
        );
      } else {
        emit(AdminLoaded(users: currentUsers, departments: departments));
      }
    });
  }

  Future<void> _onCreateDepartment(
    CreateDepartmentEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is AdminLoaded) {
      final currentState = state as AdminLoaded;
      emit(
        AdminLoaded(
          users: currentState.users,
          filteredUsers: currentState.filteredUsers,
          departments: currentState.departments,
          selectedDepartmentId: currentState.selectedDepartmentId,
          isAddingDepartment: true,
        ),
      );
    } else {
      emit(AdminLoading());
    }

    final result = await createDepartmentUseCase(event.name);

    result.fold(
      (failure) {
        if (state is AdminLoaded) {
          final currentState = state as AdminLoaded;
          emit(
            AdminLoaded(
              users: currentState.users,
              filteredUsers: currentState.filteredUsers,
              departments: currentState.departments,
              selectedDepartmentId: currentState.selectedDepartmentId,
              isAddingDepartment: false,
              addDepartmentError: _mapFailureToMessage(failure),
              addDepartmentSuccess: false,
            ),
          );
        } else {
          emit(AdminError(_mapFailureToMessage(failure)));
        }
      },
      (_) {
        if (state is AdminLoaded) {
          final currentState = state as AdminLoaded;
          emit(
            AdminLoaded(
              users: currentState.users,
              filteredUsers: currentState.filteredUsers,
              departments: currentState.departments,
              selectedDepartmentId: currentState.selectedDepartmentId,
              isAddingDepartment: false,
              addDepartmentSuccess: true,
            ),
          );
          add(GetDepartmentsEvent(forceRefresh: true));
        } else {
          add(GetDepartmentsEvent(forceRefresh: true));
        }
      },
    );
  }

  Future<void> _onDeleteDepartment(
    DeleteDepartmentEvent event,
    Emitter<AdminState> emit,
  ) async {
    List<DepartmentEntity> originalDepartments = [];
    if (state is AdminLoaded) {
      final currentState = state as AdminLoaded;
      originalDepartments = List.from(currentState.departments);

      // Optimistic Update: Remove immediately
      final updatedList =
          currentState.departments.where((d) => d.id != event.id).toList();
      emit(
        currentState.copyWith(
          departments: updatedList,
          isDeletingDepartment: true,
        ),
      );
    }

    final result = await deleteDepartmentUseCase(event.id);

    result.fold(
      (failure) {
        if (state is AdminLoaded) {
          final currentState = state as AdminLoaded;
          // Revert changes on failure
          emit(
            currentState.copyWith(
              departments: originalDepartments,
              isDeletingDepartment: false,
              deleteDepartmentError: _mapFailureToMessage(failure),
              deleteDepartmentSuccess: false,
            ),
          );
        }
      },
      (_) {
        if (state is AdminLoaded) {
          final currentState = state as AdminLoaded;
          emit(
            currentState.copyWith(
              isDeletingDepartment: false,
              deleteDepartmentSuccess: true,
            ),
          );
          // List is already updated optimistically, but verifying with server is good practice eventually
          // add(GetDepartmentsEvent(forceRefresh: true)); // We can skip this or do it silently to stay in sync
        } else {
          add(GetDepartmentsEvent(forceRefresh: true));
        }
      },
    );
  }

  void _onFilterUsers(FilterUsersEvent event, Emitter<AdminState> emit) {
    if (state is AdminLoaded) {
      final currentState = state as AdminLoaded;
      List<UserEntity> filtered;

      if (event.departmentId == "All" || event.departmentId.isEmpty) {
        filtered = currentState.users;
      } else {
        filtered =
            currentState.users
                .where(
                  (user) =>
                      user.departmentId == event.departmentId ||
                      user.departmentName == event.departmentId,
                )
                .toList();
      }

      emit(
        currentState.copyWith(
          filteredUsers: filtered,
          selectedDepartmentId: event.departmentId,
        ),
      );
    }
  }

  Future<void> _onUpdateUserDepartment(
    UpdateUserDepartmentEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is AdminLoaded) {
      final currentState = state as AdminLoaded;

      // Initial Loading State
      emit(
        currentState.copyWith(
          isUpdatingUser: true,
          updateUserError: null,
          updateUserSuccess: null,
        ),
      );

      final result = await updateUserDepartmentUseCase(
        event.userId,
        event.departmentId,
      );

      result.fold(
        (failure) {
          emit(
            currentState.copyWith(
              isUpdatingUser: false,
              updateUserError: _mapFailureToMessage(failure),
              updateUserSuccess: false,
            ),
          );
        },
        (_) {
          emit(
            currentState.copyWith(
              isUpdatingUser: false,
              updateUserSuccess: true,
            ),
          );
          add(
            GetUsersEvent(forceRefresh: true),
          ); // Refresh user list to reflect changes
        },
      );
    }
  }

  Future<void> _onVerifyUser(
    VerifyUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is AdminLoaded) {
      final currentState = state as AdminLoaded;
      emit(
        currentState.copyWith(
          isVerifyingUser: true,
          verifyUserError: null,
          verifyUserSuccess: null,
        ),
      );

      final result = await verifyUserUseCase(event.userId);

      result.fold(
        (failure) {
          emit(
            currentState.copyWith(
              isVerifyingUser: false,
              verifyUserError: _mapFailureToMessage(failure),
              verifyUserSuccess: false,
            ),
          );
        },
        (_) {
          emit(
            currentState.copyWith(
              isVerifyingUser: false,
              verifyUserSuccess: true,
            ),
          );
          add(
            GetUsersEvent(forceRefresh: true),
          ); // Refresh user list to reflect changes
        },
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerError) {
      return failure.message;
    } else if (failure is ConnectionError) {
      return failure.message;
    } else if (failure is UnauthorizedError) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
