import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_bloc.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_event.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_state.dart';
import 'package:voxflow/feature/profile/presentation/ui/widget/profile_widgets.dart';
import 'package:voxflow/routes/route_names.dart';
// import 'package:voxflow/feature/admin/presentation/widget/admin_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;

  const ProfileScreen({super.key, this.showBackButton = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
           // Also clear AuthBloc if needed, or rely on routing
           context.read<AuthBloc>().add(LogOutUser()); // Ensure AuthBloc is also synced
           context.go(RouteNames.loginScreen);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          String name = "Sarah Jenkins";
          String email = "sarah.jenkins@voiceai.corp";
          String department = "Customer Support";
          String role = "Senior Customer Specialist";
          bool isAdmin = false;

          if (state is ProfileLoaded) {
            name = state.profile.name;
            email = state.profile.email;
            
            if(state.profile.department != null) department = state.profile.department!;
            role = state.profile.role;
            if (role.toLowerCase().contains("admin")) isAdmin = true;
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            // bottomNavigationBar: isAdmin 
            //     ? const AdminBottomNavigation(currentTab: AdminTab.profile) 
            //     : null,
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ProfileError) {
                    return Center(child: Text(state.message)); // Simple error UI
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: findWidth(screenWidth, 20),
                      vertical: findHeight(screenHeight, 10),
                    ),
                    child: Column(
                      children: [
                        // Custom AppBar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (widget.showBackButton && !isAdmin)
                                ? GestureDetector(
                                    onTap: () {
                                      if (context.canPop()) {
                                        context.pop();
                                      }
                                    },
                                    child: Icon(Icons.arrow_back, size: findFontSize(screenWidth, 24), color: AppColors.textHeadline),
                                  )
                                : SizedBox(width: findWidth(screenWidth, 24)), // Maintain spacing
                        CustomText(
                          text: "My Profile",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 20),
                          fontWeight: FontWeight.w700,
                        ),
                        Icon(Icons.settings, color: AppColors.primary, size: findFontSize(screenWidth, 24)),
                      ],
                    ),
                    SizedBox(height: findHeight(screenHeight, 20)),

                    // Profile Card
                    ProfileHeaderCard(name: name, role: role),
                    SizedBox(height: findHeight(screenHeight, 24)),

                    // Personal Information Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Personal Information",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 18),
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SizedBox(height: findHeight(screenHeight, 16)),

                    // Form Fields
                    ProfileInfoField(
                      label: "Full Name",
                      value: name,
                      icon: Icons.work_outline,
                    ),
                    SizedBox(height: findHeight(screenHeight, 16)),
                    ProfileInfoField(
                      label: "Work Email",
                      value: email,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: findHeight(screenHeight, 16)),
                    ProfileInfoField(
                      label: "Department",
                      value: department,
                      icon: Icons.business,
                      isDropdown: true, // Maybe disable if not editable yet
                    ),
                    SizedBox(height: findHeight(screenHeight, 24)),

                    // Settings Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ProfileMenuOption(
                            label: "Privacy & Security",
                            icon: Icons.lock_outline,
                            iconColor: const Color(0xFF7B1FA2), // Purple
                            iconBgColor: const Color(0xFFF3E5F5), // Light Purple
                            textColor: AppColors.textHeadline,
                            onTap: () {},
                          ),
                          Divider(color: AppColors.divider.withOpacity(0.5), height: 1, indent: 64, endIndent: 20),
                          ProfileMenuOption(
                            label: "Log Out",
                            icon: Icons.logout,
                            iconColor: const Color(0xFFC62010), // Red
                            iconBgColor: const Color(0xFFFFEBEE), // Light Red
                            textColor: const Color(0xFFC62010), // Red text
                            onTap: () {
                              print("Logging out");
                              context.read<ProfileBloc>().add(LogOutProfileEvent());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: findHeight(screenHeight, 24)),

                    // Footer
                    const CustomText(
                      text: "App Version 1.0.0",
                      color: AppColors.textPlaceholder,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: findHeight(screenHeight, 20)),
                  ],
                ),
              );
            }
          ),
        ),
      );
        },
      ),
    );
  }
}
