import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/feature/task/domain/usecase/get_department_tasks_usecase.dart';
import 'package:voxflow/feature/task/domain/usecase/update_task_status_usecase.dart';
import 'package:voxflow/feature/task/presentation/state/task_event.dart';
import 'package:voxflow/feature/task/presentation/state/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetDepartmentTasksUseCase getDepartmentTasksUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;

  TaskBloc({
    required this.getDepartmentTasksUseCase,
    required this.updateTaskStatusUseCase,
  }) : super(TaskInitial()) {
    on<LoadDepartmentTasksEvent>(_onLoadDepartmentTasks);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
  }

  Future<void> _onLoadDepartmentTasks(
    LoadDepartmentTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await getDepartmentTasksUseCase.call(status: event.status);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Optionally keep showing the list but show a loading indicator
    // emit(TaskLoading()); 
    // ^ This would clear the list. Better to maybe use a separate stream or just re-emit TaskLoaded with a flag? 
    // For now, simplicity: emit TaskLoading to block interaction or show global spinner.
    // If we want "immediate" update of dashboard, we need to refresh.
    
    emit(TaskLoading());
    final result = await updateTaskStatusUseCase.call(event.taskId, event.status);
    
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (success) {
        // After successful update, reload the list to reflect changes
        add(LoadDepartmentTasksEvent());
      },
    );
  }
}
