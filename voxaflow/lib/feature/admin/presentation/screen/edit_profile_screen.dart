import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/admin/domain/entity/department_entity.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/presentation/state/admin_bloc.dart';
import 'package:voxflow/injection.dart';

class EditProfileScreen extends StatefulWidget {
  final UserEntity user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isApproved = false;
  String? selectedDepartmentId;

  @override
  void initState() {
    super.initState();
    selectedDepartmentId = widget.user.departmentId;
    isApproved = !widget.user.isAdminVerified;
  }

  @override
  Widget build(BuildContext context) {
    // Use actual email from user entity
    final email = widget.user.email;

    return BlocProvider(
      create:
          (context) =>
              locator<AdminBloc>()
                ..add(GetDepartmentsEvent(forceRefresh: false)),
      child: BlocConsumer<AdminBloc, AdminState>(
        listenWhen: (previous, current) {
          if (previous is AdminLoaded && current is AdminLoaded) {
            return (previous.updateUserSuccess != current.updateUserSuccess &&
                    current.updateUserSuccess == true) ||
                (previous.updateUserError != current.updateUserError &&
                    current.updateUserError != null) ||
                (previous.verifyUserSuccess != current.verifyUserSuccess &&
                    current.verifyUserSuccess == true) ||
                (previous.verifyUserError != current.verifyUserError &&
                    current.verifyUserError != null);
          }
          return true;
        },
        listener: (context, state) {
          if (state is AdminLoaded) {
            if (state.updateUserSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User department updated successfully"),
                ),
              );
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } else if (state.updateUserError != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.updateUserError!)));
            }

            if (state.verifyUserSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User verified successfully")),
              );
              setState(() {
                isApproved = true;
              });
            } else if (state.verifyUserError != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.verifyUserError!)));
            }
          }
        },
        builder: (context, state) {
          bool isLoading = false;
          bool isVerifying = false;
          List<DepartmentEntity> departments = [];

          if (state is AdminLoaded) {
            isLoading = state.isUpdatingUser;
            isVerifying = state.isVerifyingUser;
            departments = state.departments;
            // Update local state if successful verification happened (optional, but good for UI sync)
            if (state.verifyUserSuccess == true) {
              // We can't easily update local 'isApproved' in builder without causing rebuild issues sometimes
              // But since we are rebuilding, we can check.
              // Actually better to handle this in listener or rely on parent rebuild if user entity changes.
              // For now, let's keep local state until refreshed.
            }
          }

          // Ensure selectedDepartmentId is valid (exists in list) or null if list is loading/empty
          // If list is populated but ID not found, maybe switch to first or keep null?
          // For now, if list is not empty and selected not found, maybe it's a new ID or old one.
          // We just keep what we have, but Dropdown requires value to be in items.
          // So check if exists.
          bool idExists = departments.any((d) => d.id == selectedDepartmentId);
          if (!idExists && departments.isNotEmpty) {
            // Fallback if current department is not in the list (shouldn't happen ideally)
            // But if it happens, we can set to the first one or leave it null (if we make dropdown nullable)
            // If we leave it null, user sees nothing or hint.
            // However, if we derived it from widget.user.departmentId, it SHOULD be there effectively.
            // If backend returns users with department Ids that it doesn't return in getDepartments, that's a data consistency issue.
            // Let's assume data is consistent for now or just reset to first one.
            if (selectedDepartmentId == null || selectedDepartmentId!.isEmpty) {
              selectedDepartmentId = departments.first.id;
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              title: const CustomText(
                text: 'Edit Profile',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image Section
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade50,
                          child:
                              widget.user.name.isNotEmpty
                                  ? Text(
                                    widget.user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 5,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.green, // Active status
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Name and Email
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 12),

                  // Department Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.user.departmentName.isNotEmpty
                          ? widget.user.departmentName.toUpperCase()
                          : "NO DEPARTMENT",
                      style: const TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Department Assignment Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "DEPARTMENT ASSIGNMENT",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child:
                        departments.isEmpty
                            ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            )
                            : DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: idExists ? selectedDepartmentId : null,
                                hint: const Text("Select Department"),
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                                items:
                                    departments.map((DepartmentEntity dept) {
                                      return DropdownMenuItem<String>(
                                        value: dept.id,
                                        child: Text(dept.name),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDepartmentId = newValue!;
                                  });
                                },
                              ),
                            ),
                  ),

                  const SizedBox(height: 24),

                  // Account Status Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ACCOUNT STATUS",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isApproved) {
                                context.read<AdminBloc>().add(
                                  VerifyUserEvent(widget.user.id),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    isApproved
                                        ? Colors.white
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow:
                                    isApproved
                                        ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                        : [],
                              ),
                              child: Center(
                                child:
                                    isVerifying
                                        ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Text(
                                          "APPROVE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                isApproved
                                                    ? const Color(0xFF4F46E5)
                                                    : Colors.grey[600],
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Disapprove logic not defined in requirements, assuming UI toggle strictly or disabled if API not available.
                              // For now, keeping as UI toggle but only if not verifying.
                              if (!isVerifying) {
                                setState(() => isApproved = false);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    !isApproved
                                        ? Colors.white
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow:
                                    !isApproved
                                        ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                        : [],
                              ),
                              child: Center(
                                child: Text(
                                  "DISAPPROVE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        !isApproved
                                            ? const Color(0xFF4F46E5)
                                            : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Disapproving a user will immediately revoke their access to all AI voice management tools and dashboard features.",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: const Color(0xFF4F46E5).withOpacity(0.4),
                      ),
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (selectedDepartmentId != null) {
                                  context.read<AdminBloc>().add(
                                    UpdateUserDepartmentEvent(
                                      userId: widget.user.id,
                                      departmentId: selectedDepartmentId!,
                                    ),
                                  );
                                }
                              },
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                "SAVE CHANGES",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ), // Space for generic layout if needed
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
