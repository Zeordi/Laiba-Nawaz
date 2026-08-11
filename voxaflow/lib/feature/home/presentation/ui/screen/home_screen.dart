import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/home/presentation/state/home_bloc.dart';
import 'package:voxflow/feature/home/presentation/state/home_event.dart';
import 'package:voxflow/feature/home/presentation/state/home_state.dart';
import 'package:voxflow/feature/home/presentation/ui/widget/home_dashboard_widgets.dart';
import 'package:voxflow/routes/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeDataEvent());
    // Ensure auth state is loaded if not already
    final authState = context.read<AuthBloc>().state;
    if (authState is! LoggedInState) {
      context.read<AuthBloc>().add(IsUserLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String userName = "User";
            String userRole = "No Department";
            
            if (authState is LoggedInState) {
              userName = authState.authEntity.name;
              userRole = authState.authEntity.departmentName ?? "No Department";
            }

            return BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeError) {
                  return Center(child: Text(state.message));
                } else if (state is HomeLoaded) {
                  final homeData = state.homeData;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: findWidth(screenWidth, 20),
                      vertical: findHeight(screenHeight, 16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(
                          name: userName,
                          role: userRole,
                          imageUrl: "",
                          onProfileTap: () => context.go(RouteNames.profileScreen),
                        ),
                    SizedBox(height: findHeight(screenHeight, 24)),
                    ActionButtonsRow(
                      onRecordTap: () {},
                    ),
                    SizedBox(height: findHeight(screenHeight, 24)),
                    const QuoteCard(),
                    SizedBox(height: findHeight(screenHeight, 24)),

                    // Overview Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Overview",
                          fontSize: findFontSize(screenWidth, 18),
                          color: AppColors.textHeadline,
                          fontWeight: FontWeight.w700,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CustomText(
                            text: "View Report",
                            fontSize: findFontSize(screenWidth, 12),
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: findHeight(screenHeight, 16)),

                    // Stats Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: findWidth(screenWidth, 195),
                            child: StatCard(
                              label: "Total Voice Notes",
                              value: "${homeData.totalTasks}",
                              icon: Container(
                                padding: EdgeInsets.all(findWidth(screenWidth, 10)),
                                decoration: const BoxDecoration(
                                  color: AppColors.background,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.bar_chart_rounded,
                                    color: AppColors.primary,
                                    size: findFontSize(screenWidth, 24)),
                              ),
                              badge: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: findWidth(screenWidth, 8),
                                    vertical: findWidth(screenWidth, 4)),
                                decoration: BoxDecoration(
                                  color: AppColors.success15,
                                  borderRadius: BorderRadius.circular(
                                      findWidth(screenWidth, 12)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.trending_up,
                                        color: AppColors.success,
                                        size: findFontSize(screenWidth, 12)),
                                    SizedBox(width: findWidth(screenWidth, 2)),
                                    CustomText(
                                      text: "12%",
                                      fontSize: findFontSize(screenWidth, 10),
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: findWidth(screenWidth, 16)),
                        Expanded(
                          child: SizedBox(
                            height: findWidth(screenWidth, 195),
                            child: StatCard(
                              label: "Total Members",
                              value: "${homeData.totalDepartmentsMembers}",
                              icon: Container(
                                padding: EdgeInsets.all(findWidth(screenWidth, 10)),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF3E0),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.people_alt_rounded,
                                    color: Color(0xFFFF9800),
                                    size: findFontSize(screenWidth, 24)),
                              ),
                              footer: SizedBox(
                                height: findWidth(screenWidth, 24),
                                child: Stack(
                                  children: [
                                    _buildAvatar(
                                        screenWidth,
                                        0,
                                        "S",
                                        const Color(0xFFE3F2FD),
                                        const Color(0xFF1976D2)),
                                    _buildAvatar(
                                        screenWidth,
                                        findWidth(screenWidth, 16),
                                        "H",
                                        const Color(0xFFF3E5F5),
                                        const Color(0xFF7B1FA2)),
                                    _buildAvatar(
                                        screenWidth,
                                        findWidth(screenWidth, 32),
                                        "E",
                                        const Color(0xFFE8F5E9),
                                        const Color(0xFF388E3C)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: findHeight(screenHeight, 24)),
                    RecentTasksList(
                      onViewAllTap: () {},
                      tasks: homeData.listOfPendingTasks,
                    ),
                    SizedBox(height: findHeight(screenHeight, 20)),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        );
       },
      ),
      ),
    );
  }

  Widget _buildAvatar(double screenWidth, double left, String initial,
      Color bgColor, Color textColor) {
    return Positioned(
      left: left,
      child: Container(
        width: findWidth(screenWidth, 24),
        height: findWidth(screenWidth, 24),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: CustomText(
            text: initial,
            fontSize: findFontSize(screenWidth, 10),
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}


