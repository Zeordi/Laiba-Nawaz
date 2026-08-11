import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/feature/admin/presentation/state/admin_bloc.dart';
import 'package:voxflow/injection.dart';
import 'package:voxflow/feature/admin/presentation/widget/admin_bottom_navigation.dart';

class AdminDepartmentsScreen extends StatelessWidget {
  const AdminDepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AdminBloc>()..add(GetDepartmentsEvent()),
      child: BlocListener<AdminBloc, AdminState>(
        listenWhen: (previous, current) {
          if (previous is AdminLoaded && current is AdminLoaded) {
            final changedAddSuccess = previous.addDepartmentSuccess != current.addDepartmentSuccess;
            final changedAddError = previous.addDepartmentError != current.addDepartmentError;
            final changedDeleteSuccess = previous.deleteDepartmentSuccess != current.deleteDepartmentSuccess;
            final changedDeleteError = previous.deleteDepartmentError != current.deleteDepartmentError;
            return changedAddSuccess || changedAddError || changedDeleteSuccess || changedDeleteError;
          }
          return false;
        },
        listener: (context, state) {
          if (state is AdminLoaded) {
            if (state.addDepartmentSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Department added successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state.addDepartmentError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.addDepartmentError!),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state.deleteDepartmentSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Department deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state.deleteDepartmentError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.deleteDepartmentError!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFB), // Light grey background
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ORGANIZATION",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Departments",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search, color: Colors.black54),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.tune, color: Colors.black54),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats Row
                  BlocBuilder<AdminBloc, AdminState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is AdminLoaded) {
                        count = state.departments.length;
                      }
                      return Row(
                        children: [
                          _buildStatChip(
                            label: "$count Departments Active",
                            color: Colors.teal,
                            bgColor: Colors.teal.withOpacity(0.05),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // List
                  Expanded(
                    child: BlocBuilder<AdminBloc, AdminState>(
                      builder: (context, state) {
                        if (state is AdminLoading) {
                          return const Center(child: CircularProgressIndicator()); 
                        } else if (state is AdminLoaded) {
                          return Column(
                            children: [
                              // Loading indicator
                              if (state.isAddingDepartment || state.isRefreshingDepartments) 
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: LinearProgressIndicator(
                                    minHeight: 2,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                                  ),
                                ),

                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    context.read<AdminBloc>().add(GetDepartmentsEvent(forceRefresh: true));
                                  },
                                  child: state.departments.isEmpty && !state.isAddingDepartment
                                      ? ListView(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          children: [
                                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                            const Center(child: Text("No departments found")),
                                          ],
                                        )
                                      : ListView.separated(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          itemCount: state.departments.length,
                                          separatorBuilder: (c, i) => const SizedBox(height: 16),
                                          padding: const EdgeInsets.only(bottom: 100),
                                          itemBuilder: (context, index) {
                                            final dept = state.departments[index];
                                            final icon = _getDepartmentIcon(dept.name);
                                            final color = _getDepartmentColor(index);

                                            return Dismissible(
                                              key: Key(dept.id),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20),
                                        child: const Icon(Icons.delete, color: Colors.white),
                                      ),
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return AlertDialog(
                                              title: const Text("Delete Department"),
                                              content: Text("Are you sure you want to delete ${dept.name}?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(dialogContext).pop(false),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(dialogContext).pop(true),
                                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (direction) {
                                        context.read<AdminBloc>().add(DeleteDepartmentEvent(dept.id));
                                      },
                                      child: _buildDepartmentCard(
                                        name: dept.name,
                                        iconData: icon,
                                        accentColor: color,
                                        onTap: () {
                                          // Navigate to department details if needed
                                        }
                                      ),
                                    );
                                          },
                                        ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is AdminError) {
                          return Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(state.message, style: const TextStyle(color: Colors.red)),
                                 ElevatedButton(
                                   onPressed: () => context.read<AdminBloc>().add(GetDepartmentsEvent()),
                                   child: const Text("Retry"),
                                 )
                               ],
                             ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          floatingActionButton: Builder(
            builder: (ctx) => FloatingActionButton(
              onPressed: () => _showAddDepartmentDialog(ctx),
              backgroundColor: const Color(0xFF4F46E5),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          // bottomNavigationBar: const AdminBottomNavigation(currentTab: AdminTab.departments),
        ),
      ),
    );
  }

  Widget _buildStatChip({required String label, required Color color, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard({
    required String name,
    required IconData iconData,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showAddDepartmentDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Add New Department", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Department Name",
                  hintText: "Enter department name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  // Use the provided context from build method (via closure or finding ancestor)
                  // But 'context' in this method is the one passed to _showAddDepartmentDialog
                  // which is valid for Provider lookup if it's under BlocProvider.
                  // Wait, showDialog context is usually above the widget tree if used with root navigator.
                  // So better to use the 'context' passed to the function which comes from build.
                  context.read<AdminBloc>().add(CreateDepartmentEvent(controller.text.trim()));
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Helpers for Mock Data
  Color _getDepartmentColor(int index) {
    const colors = [Colors.teal, Colors.indigo, Colors.orange, Colors.blue, Colors.pink];
    return colors[index % colors.length];
  }

  IconData _getDepartmentIcon(String name) {
    name = name.toLowerCase();
    if (name.contains("tech") || name.contains("it")) return Icons.memory;
    if (name.contains("hr") || name.contains("human")) return Icons.people_outline;
    if (name.contains("market")) return Icons.campaign;
    if (name.contains("support")) return Icons.headset_mic;
    if (name.contains("finance")) return Icons.attach_money;
    return Icons.business;
  }
}
