import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';
import 'package:voxflow/feature/auth/presentation/ui/widget/login_body.dart';
import 'package:voxflow/routes/route_names.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedInState) {
            if (state.authEntity.role == "admin") {
              context.go(RouteNames.adminScreen);
            } else {
              context.go(RouteNames.homeScreen);
            }
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthInputError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
          color: AppColors.white,
          child: Column(
            children: [
            Container(
              padding: EdgeInsets.only(
                left: findWidth(screenWidth, 20),
                right: findWidth(screenWidth, 20),
                top: findHeight(screenHeight, 150),
                bottom: findHeight(screenHeight, 50),
              ),
              width: screenWidth,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(findWidth(screenWidth, 25)),
                  bottomRight: Radius.circular(findWidth(screenWidth, 25)),
                ),
              ),
              child: Column(
                children: [
                   // ... existing header code ...
                  SizedBox(
                    width: findWidth(screenWidth, screenWidth - 40),
                    child: Row(
                      children: [
                        SizedBox(
                          width: findWidth(screenWidth, 40),
                          child: Center(
                            child: Icon(
                              IconsaxPlusLinear.voice_square,
                              color: AppColors.white,
                              size: findWidth(screenWidth, 40),
                            ),
                          ),
                        ),
                        SizedBox(width: findFontSize(screenWidth, 10)),
                        SizedBox(
                          child: CustomText(
                            text: "LUCEMORA",
                            color: AppColors.white,
                            fontSize: findFontSize(screenWidth, 36),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: findWidth(screenWidth, screenWidth - 40),
                    child: CustomText(
                      text: "Enterprise Voice Intelligence",
                      color: AppColors.textLight,
                      fontSize: findFontSize(screenWidth, 18),
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  
                ],
              ),
            ),
            LoginBody(),
            SizedBox(height: findHeight(screenHeight, 20)), // Extra spacing at bottom
          ],
        ),
      ),
    ),
    ));
  }
}
