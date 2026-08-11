import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_button.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';
import 'package:voxflow/feature/task/presentation/state/task_bloc.dart';
import 'package:voxflow/feature/task/presentation/state/task_event.dart';
import 'package:voxflow/feature/task/presentation/state/task_state.dart';
import 'package:voxflow/feature/task/presentation/ui/widget/item_details_widgets.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskEntity task;
  final bool isReadOnly;

  const TaskDetailScreen({
    super.key, 
    required this.task,
    this.isReadOnly = false,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  String? _loadingAction;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoaded) {
          // On successful update, go back to previous screen
          context.read<TaskBloc>().add(LoadDepartmentTasksEvent(status: "All"));
          context.pop();
        } else if (state is TaskError) {
          setState(() {
            _loadingAction = null;
          });
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: findWidth(screenWidth, 20),
              vertical: findHeight(screenHeight, 10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: AppColors.textHeadline,
                      ),
                    ),
                    CustomText(
                      text: "Task #${widget.task.id.substring(0, 4)}...",
                      color: AppColors.textHeadline,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textFamily: 'Manrope', // Assuming font
                    ),
                    const Icon(Icons.more_horiz, color: AppColors.textHeadline),
                  ],
                ),
                SizedBox(height: findHeight(screenHeight, 20)),

                // Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTag(
                          text: widget.task.status.toUpperCase(),
                          color: const Color(0xFFFFF4E5),
                          textColor: const Color(0xFFFF9800),
                        ),
                        SizedBox(width: findWidth(screenWidth, 10)),
                        _buildTag(
                          text: widget.task.priority.toUpperCase(),
                          color: const Color(0xFFEEE5FF),
                          textColor: const Color(0xFF7B1FA2),
                        ),
                      ],
                    ),
                    CustomText(
                      text: DateFormat('MMM dd, hh:mm a').format(
                        DateTime.tryParse(widget.task.createdAt) ?? DateTime.now(),
                      ),
                      color: AppColors.textDefault,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: findHeight(screenHeight, 20)),

                // Audio Player
                AudioPlayerWidget(
                  name: widget.task.createdByName,
                  role: "Author",
                  textToSpeak: widget.task.originalText,
                ),
                SizedBox(height: findHeight(screenHeight, 20)),

                // Info Cards
                Row(
                  children: [
                    Expanded(
                      child: InfoCardWidget(
                        label: "SOURCE",
                        value: "Voice Memo",
                        icon: Icons.mic,
                      ),
                    ),
                    SizedBox(width: findWidth(screenWidth, 20)),
                    Expanded(
                      child: InfoCardWidget(
                        label: "CONFIDENCE",
                        value: "${widget.task.confidentialityPercent}%",
                        icon: Icons.verified_user,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: findHeight(screenHeight, 20)),

                // Transcription
                TranscriptionWidget(
                  text: widget.task.originalText,
                  keywords: widget.task.tags,
                ),

                SizedBox(height: findHeight(screenHeight, 30)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: widget.isReadOnly 
          ? null 
          : Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: findWidth(screenWidth, 20),
            vertical: findHeight(screenHeight, 20),
          ),
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              final isRejectLoading = taskState is TaskLoading && _loadingAction == 'reject';
              final isCompleteLoading = taskState is TaskLoading && _loadingAction == 'complete';
              final isAnyLoading = taskState is TaskLoading;

              return Row(
                      children: [
                        SizedBox(
                          height: findHeight(screenHeight, 60),
                          child: CustomButton(
                            isEnable: !isAnyLoading || isRejectLoading,
                            isLoading: isRejectLoading,
                            loadingText: "Updating...",
                            width: findWidth(screenWidth, 150),
                            horizontalPudding: 0,
                            verticalPudding: findHeight(screenHeight, 16),
                            fillColor: Colors.white,
                            borderColor: AppColors.border,
                            radius: 12,
                            onTap: () {
                              setState(() {
                                _loadingAction = 'reject';
                              });
                              context.read<TaskBloc>().add(
                                UpdateTaskStatusEvent(
                                  taskId: widget.task.id,
                                  status: "rejected",
                                ),
                              );
                            },
                            child: Center(
                              child: const CustomText(
                                text: "Reject",
                                color: AppColors.textHeadline,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: findWidth(screenWidth, 16)),
                        SizedBox(
                          height: findHeight(screenHeight, 60),
                          child: CustomButton(
                            isEnable: !isAnyLoading || isCompleteLoading,
                            isLoading: isCompleteLoading,
                            loadingText: "Updating...",
                            width: findWidth(screenWidth, 150),
                            horizontalPudding: 0,
                            verticalPudding: findHeight(screenHeight, 16),
                            fillColor: AppColors.primary,
                            borderColor: AppColors.primary,
                            radius: 12,
                            onTap: () {
                              setState(() {
                                _loadingAction = 'complete';
                              });
                              context.read<TaskBloc>().add(
                                UpdateTaskStatusEvent(
                                  taskId: widget.task.id,
                                  status: "completed",
                                ),
                              );
                            },
                            child: Center(
                              child: const CustomText(
                                text: "Complete",
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTag({
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomText(
        text: text,
        color: textColor,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
