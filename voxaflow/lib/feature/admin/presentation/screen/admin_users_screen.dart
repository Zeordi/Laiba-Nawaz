import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:voxflow/feature/admin/presentation/state/admin_bloc.dart';
import 'package:voxflow/feature/admin/presentation/widget/user_shimmer_loading.dart';
import 'package:voxflow/injection.dart';
import 'package:voxflow/routes/route_names.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard - Users"),
      ),
      body: BlocProvider(
        create: (context) => locator<AdminBloc>()..add(GetUsersEvent(forceRefresh: false)),
        child: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return const UserShimmerLoading();
            } else if (state is AdminLoaded) {
              if (state.users.isEmpty) {
                 return Column(
                   children: [
                     if (state.isRefreshingUsers) const LinearProgressIndicator(minHeight: 2),
                     Expanded(
                       child: RefreshIndicator(
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
                      ),
                     ),
                   ],
                 );
              }
              return Column(
                children: [
                  if (state.isRefreshingUsers) const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<AdminBloc>().add(GetUsersEvent(forceRefresh: true));
                      },
                      child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.users.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: InkWell(
                        onTap: () {
                          context.push(RouteNames.editProfileScreen, extra: user).then((_) {
                              // Refresh the list when returning from edit screen
                              context.read<AdminBloc>().add(GetUsersEvent(forceRefresh: true));
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(IconsaxPlusBroken.security_user, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(user.role, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            if (user.departmentId.isNotEmpty) ...[
                               const SizedBox(height: 2),
                               Row(
                                children: [
                                  Icon(IconsaxPlusBroken.building, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text("Dept ID: ${user.departmentId}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                ],
                              ),
                            ]
                          ],
                        ),
                        trailing: user.isHead 
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("HEAD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber)),
                            )
                          : null,
                      ),
                    ));
                  },
                ),
              ))
              ],
              );
            } else if (state is AdminError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                         context.read<AdminBloc>().add(GetUsersEvent());
                      },
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
    );
  }
}
