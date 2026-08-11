import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/presentation/state/admin_bloc.dart';
import 'package:voxflow/feature/admin/presentation/widget/user_shimmer_loading.dart';
import 'package:voxflow/injection.dart';
import 'package:voxflow/routes/route_names.dart';
import 'package:voxflow/feature/admin/presentation/widget/admin_bottom_navigation.dart';

class AdminDirectoryScreen extends StatelessWidget {
  const AdminDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AdminBloc>()..add(GetUsersEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const CustomText(
            text: 'User Directory',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search users by name or email...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              
              // Filters
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                   String currentDepartment = "All Departments";
                   if (state is AdminLoaded && state.selectedDepartmentId != null && state.selectedDepartmentId != "All") {
                      // Try to find name if ID 
                      final ide = state.selectedDepartmentId!;
                      final match = state.departments.where((element) => element.id.toString() == ide || element.name == ide);
                      if (match.isNotEmpty) {
                        currentDepartment = match.first.name;
                      } else {
                        currentDepartment = ide;
                      }
                   }

                   return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: (state is AdminLoaded && state.selectedDepartmentId != null) ? state.selectedDepartmentId : "All",
                              hint: Text(
                                currentDepartment,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                              isExpanded: true,
                              items: [
                                const DropdownMenuItem(value: "All", child: Text("All Departments")),
                                if (state is AdminLoaded)
                                  ...state.departments.map((dept) => DropdownMenuItem(
                                    value: dept.name,
                                    child: Text(dept.name),
                                  ))
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  context.read<AdminBloc>().add(FilterUsersEvent(val));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.black54),
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<AdminBloc, AdminState>(
                  builder: (context, state) {
                    if (state is AdminLoading) {
                      return const UserShimmerLoading();
                    } else if (state is AdminLoaded) {
                      Widget content;
                      if (state.filteredUsers.isEmpty) {
                        content = RefreshIndicator(
                          onRefresh: () async {
                            context.read<AdminBloc>().add(GetUsersEvent(forceRefresh: true));
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 100),
                              Center(child: Text("No users found")),
                            ],
                          ),
                        );
                      } else {
                        content = RefreshIndicator(
                          onRefresh: () async {
                            context.read<AdminBloc>().add(GetUsersEvent(forceRefresh: true));
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.filteredUsers.length,
                            separatorBuilder: (c, i) => const SizedBox(height: 16),
                            padding: const EdgeInsets.only(bottom: 100), // Space for FAB
                            itemBuilder: (context, index) {
                              final user = state.filteredUsers[index];
                              // Generating dummy email based on name since API doesn't provide it yet
                              final email = user.email.toLowerCase();
                              final isActive = user.isAdminVerified || user.role =="admin"; // Dummy status
                              final department = user.departmentName.isEmpty ? "Staff" : user.departmentName;
                            
                              return _buildUserCard(
                                context: context,
                                user: user,
                                name: user.name,
                                email: email,
                                department: department, 
                                isActive: isActive,
                              );
                            },
                          )
                        );
                      }
                      
                      return Column(
                        children: [
                          if (state.isRefreshingUsers)
                            const LinearProgressIndicator(
                              minHeight: 2,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                            ),
                          Expanded(child: content),
                        ],
                      );
                    } else if (state is AdminError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => context.read<AdminBloc>().add(GetUsersEvent()),
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
        
        // bottomNavigationBar: const AdminBottomNavigation(currentTab: AdminTab.users),
      ),
    );
  }


  Widget _buildUserCard({
    required BuildContext context,
    required UserEntity user,
    required String name,
    required String email,
    required String department,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Stack(
                 children: [
                   CircleAvatar(
                     radius: 30,
                     backgroundColor: Colors.blue.shade50,
                     backgroundImage: const AssetImage('assets/images/user_placeholder.png'), // Ideally network image
                     onBackgroundImageError: (_, __) {},
                     child: name.isNotEmpty ? Text(name[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF4F46E5))) : null,
                   ),
                   Positioned(
                     right: 0,
                     bottom: 0,
                     child: Container(
                       width: 16,
                       height: 16,
                       decoration: BoxDecoration(
                         color: isActive ? Colors.green : Colors.deepOrange,
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.white, width: 2.5),
                       ),
                     ),
                   )
                 ],
               ),
               const SizedBox(width: 16),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                         const Icon(Icons.more_vert, color: Colors.grey, size: 20)
                       ],
                     ),
                     const SizedBox(height: 2),
                     Text(email, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                     const SizedBox(height: 10),
                     Row(
                       children: [
                         Flexible(
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                             decoration: BoxDecoration(
                               color: Colors.grey[100],
                               borderRadius: BorderRadius.circular(6),
                             ),
                             child: Text(
                               department.toUpperCase(),
                               style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                               overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                             ),
                           ),
                         ),
                         const SizedBox(width: 8),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                           decoration: BoxDecoration(
                             color: isActive ? Colors.green.withOpacity(0.1) : Colors.deepOrange.withOpacity(0.1),
                             borderRadius: BorderRadius.circular(6),
                           ),
                           child: Text(
                             isActive ? "ACTIVE" : "INACTIVE", 
                             style: TextStyle(
                               fontSize: 10, 
                               fontWeight: FontWeight.bold, 
                               color: isActive ? Colors.green : Colors.deepOrange
                             )
                           ),
                         ),
                       ],
                     )
                   ],
                 ),
               ),
             ],
           ),
           const SizedBox(height: 16),
           Row(
             children: [
               Expanded(
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF4F46E5),
                     foregroundColor: Colors.white,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                     padding: const EdgeInsets.symmetric(vertical: 12),
                     elevation: 0,
                   ),
                   onPressed: () {
                     context.push(RouteNames.editProfileScreen, extra: user);
                   },
                   child: const Text("EDIT PROFILE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                 ),
               ),
               const SizedBox(width: 12),
               Container(
                 width: 48,
                 height: 44,
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey[300]!),
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: Material(
                   color: Colors.transparent,
                   child: InkWell(
                     borderRadius: BorderRadius.circular(10),
                     onTap: () {},
                     child: const Icon(Icons.vpn_key_outlined, size: 20, color: Colors.grey),
                   ),
                 ),
               )
             ],
           )
        ],
      ),
    );
  }
}
