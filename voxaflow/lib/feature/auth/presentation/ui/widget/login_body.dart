import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:voxflow/core/widget/input_widgets.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';
import 'package:voxflow/feature/auth/presentation/state/login_visibility_cubit.dart';
import 'package:voxflow/routes/route_names.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => LoginVisibilityCubit(),
      child: Container(
        width: findWidth(screenWidth, screenWidth),
        padding: EdgeInsets.symmetric(horizontal: findWidth(screenWidth, 20)),
        child: Column(
          children: [
          SizedBox(height: findHeight(screenHeight, 20)),
          SizedBox(
            width: findWidth(screenWidth, screenWidth - 40),
            child: CustomText(
              text: "Log In",
              color: AppColors.textHeadline,
              fontSize: findFontSize(screenWidth, 32),
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: findHeight(screenHeight, 20)),
          SizedBox(
            width: findWidth(screenWidth, screenWidth - 40),
            child: CustomText(
              text: "Email Address",
              color: AppColors.textHeadline,
              fontSize: findFontSize(screenWidth, 16),
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: findHeight(screenHeight, 10)),
          TextInputField(
            hintText: "Enter your email",
            borderColor: AppColors.border,
            onChanged: (value) {
              context.read<AuthBloc>().add(
                AuthInputEvent(value: value, type: "email"),
              );
            },

            focusedBorderColor: AppColors.borderDark,
            borderRadius: findWidth(screenWidth, 16),
            hintStyle: TextStyle(
              color: AppColors.textDefault.withOpacity(0.8),
              fontSize: findFontSize(screenWidth, 14),
              fontWeight: FontWeight.w400,
            ),
            textStyle: TextStyle(
              fontFamily: "Inter",
              fontSize: findFontSize(screenWidth, 14),
              color: AppColors.textHeadline,
            ),
            fillColor: AppColors.white,
            contentPaddingHorizontal: findWidth(screenWidth, 20),
            contentPaddingVertical: findHeight(screenHeight, 18),
          ),
          SizedBox(height: findHeight(screenHeight, 20)),
          SizedBox(
            width: findWidth(screenWidth, screenWidth - 40),
            child: CustomText(
              text: "Password",
              color: AppColors.textHeadline,
              fontSize: findFontSize(screenWidth, 16),
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: findHeight(screenHeight, 10)),
          BlocBuilder<LoginVisibilityCubit, LoginVisibilityState>(
            builder: (context, visibilityState) {
              return AppPasswordField(
                hintText: "Enter your password",
                borderColor: AppColors.border,
                focusedBorderColor: AppColors.borderDark,
                onChanged: (value) {
                  context.read<AuthBloc>().add(
                    AuthInputEvent(value: value, type: "password"),
                  );
                },
                borderRadius: findWidth(screenWidth, 16),
                hintStyle: TextStyle(
                  color: AppColors.textDefault.withOpacity(0.8),
                  fontSize: findFontSize(screenWidth, 14),
                  fontWeight: FontWeight.w400,
                ),
                textStyle: TextStyle(
                  fontFamily: "Inter",
                  fontSize: findFontSize(screenWidth, 14),
                  color: AppColors.textHeadline,
                ),
                fillColor: AppColors.white,
                contentPadding: findWidth(screenWidth, 19),
                isObscure: visibilityState.isPasswordObscured,
                onToggleVisibility: () {
                  context.read<LoginVisibilityCubit>().togglePasswordVisibility();
                },
              );
            },
          ),
          SizedBox(height: findHeight(screenHeight, 20)),
          SizedBox(
            width: findWidth(screenWidth, screenWidth - 40),
            child: GestureDetector(
              onTap: () {
                context.push(RouteNames.forgetScreen);
              },
              child: CustomText(
                text: "Forgot Password?",
                color: AppColors.primary,
                fontSize: findFontSize(screenWidth, 14),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          SizedBox(height: findHeight(screenHeight, 40)),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return GestureDetector(
                onTap: () {
                  if(authState is AuthLoadingState) return;
                  context.read<AuthBloc>().add(LogInUser());
                  
                },
                child: Container(
                  width: findWidth(screenWidth, screenWidth - 40),
                  padding: EdgeInsets.symmetric(
                    horizontal: findWidth(screenWidth, 10),
                    vertical: findHeight(screenHeight, 16),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      findWidth(screenWidth, 20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.gradientButton.withAlpha(200),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child:authState is AuthLoadingState? Center(child: CircularProgressIndicator()): Center(
                    child: CustomText(
                      text: "Log In",
                      color: AppColors.white,
                      fontSize: findFontSize(screenWidth, 24),
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: findHeight(screenHeight, 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Don't have an account? ",
                color: AppColors.textDefault,
                fontSize: findFontSize(screenWidth, 14),
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: () {
                  context.push(RouteNames.signUpScreen);
                },
                child: CustomText(
                  text: "Sign Up",
                  color: AppColors.primary,
                  fontSize: findFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
