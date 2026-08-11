

import 'package:go_router/go_router.dart';
import 'package:voxflow/feature/auth/presentation/ui/screen/splash_screen.dart';
import 'package:voxflow/feature/auth/presentation/ui/screen/forget_screen.dart';
import 'package:voxflow/feature/auth/presentation/ui/screen/login_screen.dart';
import 'package:voxflow/feature/auth/presentation/ui/screen/signup_screen.dart';
import 'package:voxflow/feature/auth/presentation/ui/screen/otp_screen.dart';
import 'package:voxflow/feature/auth/presentation/ui/screen/reset_password.dart';
import 'package:voxflow/feature/main/presentation/ui/screen/main_wrapper_screen.dart';
import 'package:voxflow/feature/memo/presentation/ui/screen/new_memo_screen.dart';
import 'package:voxflow/feature/submit_task/presentation/ui/screen/submit_task_screen.dart';
import 'package:voxflow/feature/task/presentation/ui/screen/task_screen.dart';
import 'package:voxflow/feature/task/presentation/ui/screen/task_detail_screen.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';
import 'package:voxflow/feature/profile/presentation/ui/screen/profile_screen.dart';
import 'package:voxflow/feature/admin/presentation/screen/admin_directory_screen.dart';
import 'package:voxflow/feature/admin/presentation/screen/admin_departments_screen.dart';
import 'package:voxflow/feature/admin/presentation/screen/edit_profile_screen.dart';
import 'package:voxflow/feature/admin/domain/entity/user_entity.dart';
import 'package:voxflow/feature/admin/presentation/screen/admin_main_wrapper.dart'; // Import AdminMainWrapper
import 'package:voxflow/routes/route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: RouteNames.loginScreen, builder: (context, state) => const LoginScreen()),
    GoRoute(path: RouteNames.forgetScreen, builder: (context, state) => const ForgetScreen()),
    // Add other routes here
    GoRoute(path: RouteNames.otpScreen, builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      final email = args != null && args.containsKey('email') ? args['email'] as String : '';
      final redirectUrl = args != null && args.containsKey('redirectUrl') ? args['redirectUrl'] as String : '';
      return OtpScreen(email: email, redirectUrl: redirectUrl);
    }),
    // Reset Password Screen route 
    GoRoute(path: RouteNames.resetPasswordScreen, builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      final email = args != null && args.containsKey('email') ? args['email'] as String : '';
      return ResetPasswordScreen(email: email);
    }),
    GoRoute(path: RouteNames.signUpScreen, builder: (context, state) => const SignUpScreen()),
    // Home Screen route (Switched to MainWrapperScreen)
    GoRoute(path: RouteNames.homeScreen, builder: (context, state) => const MainWrapperScreen()),
    // New Memo Screen route
    GoRoute(path: RouteNames.newMemoScreen, builder: (context, state) => const NewMemoScreen()),
    // Submit Task Screen route
    GoRoute(path: RouteNames.submitTaskScreen, builder: (context, state) => const SubmitTaskScreen()),
    // Task Detail Screen route
    GoRoute(path: RouteNames.taskDetailScreen, builder: (context, state) {
      if (state.extra is Map<String, dynamic>) {
        final args = state.extra as Map<String, dynamic>;
        final task = args['task'] as TaskEntity;
        final isReadOnly = args['isReadOnly'] as bool? ?? false;
        return TaskDetailScreen(task: task, isReadOnly: isReadOnly);
      }
      final task = state.extra as TaskEntity; // API fallback
      return TaskDetailScreen(task: task);
    }),
    // Profile Screen route
    GoRoute(path: RouteNames.profileScreen, builder: (context, state) => const ProfileScreen()),
    // Admin Screen route
    GoRoute(path: RouteNames.adminScreen, builder: (context, state) => const AdminMainWrapper(initialIndex: 1)), // Users tab
    // Edit Profile Screen route
    GoRoute(path: RouteNames.editProfileScreen, builder: (context, state) {
      final user = state.extra as UserEntity;
      return EditProfileScreen(user: user);
    }),
    // Departments Screen route
    GoRoute(path: RouteNames.departmentsScreen, builder: (context, state) => const AdminMainWrapper(initialIndex: 0)), // Departments tab
  ]
);