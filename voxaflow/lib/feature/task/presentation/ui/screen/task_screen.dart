import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';
import 'package:voxflow/feature/task/presentation/state/task_bloc.dart';
import 'package:voxflow/feature/task/presentation/state/task_event.dart';
import 'package:voxflow/feature/task/presentation/state/task_state.dart';
import 'package:voxflow/feature/task/presentation/ui/widget/task_header.dart';
import 'package:voxflow/feature/task/presentation/ui/widget/task_card.dart';
import 'package:voxflow/feature/task/presentation/ui/widget/task_filter_list.dart';
import 'package:voxflow/routes/route_names.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _selectedFilter = "All";
  List<TaskEntity> _allTask = [];
  List<TaskEntity> _complitedTask = [];
  List<TaskEntity> _pendingTask = [];
  List<TaskEntity> _rejectedTask = [];
  List<TaskEntity> _myTask = [];


  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadDepartmentTasksEvent(status: _selectedFilter));
  }

  void _showDepartmentFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Divider(color: AppColors.border),
              _buildDepartmentItem(screenWidth, "HR"),
              _buildDepartmentItem(screenWidth, "Finance"),
              _buildDepartmentItem(screenWidth, "Operations"),
              _buildDepartmentItem(screenWidth, "IT"),
              _buildDepartmentItem(screenWidth, "Marketing"),
              SizedBox(height: findWidth(screenWidth, 20)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDepartmentItem(double screenWidth, String name) {
    return ListTile(
      title: CustomText(
        text: name,
        fontSize: findFontSize(screenWidth, 16),
        color: AppColors.textDefault,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.start,
      ),
      onTap: () {
        // Handle department selection logic here
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background, // Light grey background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: findWidth(screenWidth, 20),
            vertical: findHeight(screenHeight, 10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                onFilterTap: _showDepartmentFilter,
                onSearchTap: () {
                  // Handle search tap
                },
              ),
              SizedBox(height: findHeight(screenHeight, 30)),
              
              // Filter Chips
              TaskFilterList(
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  context.read<TaskBloc>().add(LoadDepartmentTasksEvent(status: filter));
                },
              ),
              SizedBox(height: findHeight(screenHeight, 20)),
              // Task List
              Expanded(
                child: BlocConsumer<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is TaskLoaded) {
                      setState(() {
                         switch (_selectedFilter) {
                          case "All":
                            _allTask = state.tasks;
                            break;
                          case "Pending":
                            _pendingTask = state.tasks;
                            break;
                          case "Completed":
                            _complitedTask = state.tasks;
                            break;
                          case "Rejected":
                            _rejectedTask = state.tasks;
                            break;
                          case "My-Task":
                            _myTask = state.tasks;
                            break;
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    List<TaskEntity> currentTasks = [];
                    switch (_selectedFilter) {
                      case "All":
                        currentTasks = _allTask;
                        break;
                      case "Pending":
                        currentTasks = _pendingTask;
                        break;
                      case "Completed":
                        currentTasks = _complitedTask;
                        break;
                      case "Rejected":
                        currentTasks = _rejectedTask;
                        break;
                      case "My-Task":
                        currentTasks = _myTask;
                        break;
                    }

                    if (state is TaskLoaded) {
                       currentTasks = state.tasks;
                    }

                    if (state is TaskLoading && currentTasks.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskError && currentTasks.isEmpty) {
                      return Center(child: Text(state.message));
                    }
                    
                    // Show existing data if available, with loading indicator on top if loading
                    return Stack(
                      children: [
                        if (currentTasks.isEmpty)
                          RefreshIndicator(
                            onRefresh: () async {
                              context.read<TaskBloc>().add(LoadDepartmentTasksEvent(status: _selectedFilter));
                              await Future.delayed(const Duration(seconds: 1));
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: const Center(child: Text("No tasks found")),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          RefreshIndicator(
                            onRefresh: () async {
                              context.read<TaskBloc>().add(LoadDepartmentTasksEvent(status: _selectedFilter));
                              await Future.delayed(const Duration(seconds: 1));
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: currentTasks.length,
                              separatorBuilder: (c, i) => SizedBox(height: findHeight(screenHeight, 16)),
                              itemBuilder: (context, index) {
                                final task = currentTasks[index];
                                Color tagColor = const Color(0xFF1976D2); // Default Blue
                                Color tagBgColor = const Color(0xFFE3F2FD);
                                
                                if (task.departmentName.contains("Finance")) {
                                   tagColor = const Color(0xFF7B1FA2);
                                   tagBgColor = const Color(0xFFF3E5F5);
                                } else if (task.departmentName.contains("Operations")) {
                                   tagColor = const Color(0xFF00796B);
                                   tagBgColor = const Color(0xFFE0F2F1);
                                }
                                
                                DateTime? date;
                                try {
                                  date = DateTime.parse(task.createdAt);
                                } catch (_) {}
                                
                                String timeStr = date != null 
                                    ? "${date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}"
                                    : "";
      
                                return TaskCard(
                                    onTap: () => context.push(
                                      RouteNames.taskDetailScreen, 
                                      extra: {
                                        'task': task,
                                        'isReadOnly': _selectedFilter == "My-Task" || _selectedFilter == "My Task",
                                      }
                                    ),
                                  tag: task.departmentName,
                                  tagColor: tagColor,
                                  tagBgColor: tagBgColor,
                                  time: timeStr,
                                  title: task.originalText,
                                  confidence: "${task.confidentialityPercent}% Confidence",
                                  confidenceIcon: Icons.auto_awesome,
                                  confidenceColor: AppColors.success,
                                );
                              },
                            ),
                          ),
                        
                        if (state is TaskLoading) 
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              color: AppColors.primary,
                              backgroundColor: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.mic, color: Colors.white, size: 28),
      ),
    );
  }
}

