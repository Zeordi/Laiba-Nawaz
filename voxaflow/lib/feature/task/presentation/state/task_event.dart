abstract class TaskEvent {}

class LoadDepartmentTasksEvent extends TaskEvent {
  final String status;
  LoadDepartmentTasksEvent({this.status = "All"});
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final String status;

  UpdateTaskStatusEvent({required this.taskId, required this.status});
}
