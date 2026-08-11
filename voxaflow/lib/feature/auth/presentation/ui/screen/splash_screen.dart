import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';
import 'package:voxflow/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use a slight delay to ensure the UI builds before triggered, 
    // and to show the splash logo for at least a moment.
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
         context.read<AuthBloc>().add(IsUserLogin());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedInState) {
          final role = state.authEntity.role.toLowerCase();
          if (role.contains("admin")) {
            context.go(RouteNames.adminScreen);
          } else {
            context.go(RouteNames.homeScreen);
          }
        } else if (state is AuthErrorState) {
           // Not logged in or error checking token -> Go to login
           context.go(RouteNames.loginScreen);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/images/image.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
