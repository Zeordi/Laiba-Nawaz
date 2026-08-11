import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_button.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/core/widget/input_widgets.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';
import 'package:voxflow/feature/auth/presentation/ui/widget/auth_header.dart';
import 'package:voxflow/feature/auth/presentation/ui/widget/back_navigator.dart';
import 'package:voxflow/feature/auth/presentation/state/reset_password_visibility_cubit.dart';
import 'package:voxflow/routes/route_names.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthInputEvent(value: widget.email, type: "email"));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => ResetPasswordVisibilityCubit(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              context.go(RouteNames.loginScreen);
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
          child: Container(
        padding: EdgeInsets.only(
          right: findWidth(screenWidth, 20),
          left: findWidth(screenWidth, 20),
          bottom: findHeight(screenHeight, 10),
          top: findHeight(screenHeight, 20),
        ),
        width: screenWidth,
        height: screenHeight,
        color: AppColors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackNavigator(
                  
                ),
                SizedBox(height: findHeight(screenHeight, 40)),
                LoginHeader(
                  hederText: "Reset Password",
                  disc: "Set a strong password to Keep your account secure.",
                ),
                SizedBox(height: findHeight(screenHeight, 60)),
                CustomText(
                  text: "Password",
                  fontSize: findFontSize(screenWidth, 14),
                  color: AppColors.textHeadline,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: findHeight(screenHeight, 10)),
                BlocBuilder<ResetPasswordVisibilityCubit, ResetPasswordVisibilityState>(
                  builder: (context, visibilityState) {
                    return AppPasswordField(
                      hintText: "Enter your password",
                      onChanged: (value) {


                        context.read<AuthBloc>().add(AuthInputEvent(value: value, type: "newPassword"));
                      },
                      borderColor: AppColors.border,
                      focusedBorderColor: AppColors.borderDark,
                      borderRadius: findWidth(screenWidth, 16),
                      hintStyle: TextStyle(
                        color: AppColors.textDefault.withOpacity(0.8),
                        fontSize: findFontSize(screenWidth, 14),
                        fontWeight: FontWeight.w400,
                      ),
                      textStyle: TextStyle(
                        fontSize: findFontSize(screenWidth, 14),
                        color: AppColors.textHeadline,
                      ),
                      fillColor: AppColors.white,
                      contentPadding: findWidth(screenWidth, 19),
                      isObscure: visibilityState.isPasswordObscured,
                      onToggleVisibility: () {
                        context.read<ResetPasswordVisibilityCubit>().togglePasswordVisibility();
                      },
                    );
                  },
                ),
                SizedBox(height: findHeight(screenHeight, 20)),
                CustomText(
                  text: "Confirm Password",
                  fontSize: findFontSize(screenWidth, 14),
                  color: AppColors.textHeadline,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: findHeight(screenHeight, 10)),
                BlocBuilder<ResetPasswordVisibilityCubit, ResetPasswordVisibilityState>(
                  builder: (context, visibilityState) {
                    return AppPasswordField(
                      hintText: "Confirm Password",
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthInputEvent(value: value, type: "confirmPassword"));
                      },
                      borderColor: AppColors.border,
                      focusedBorderColor: AppColors.borderDark,
                      borderRadius: findWidth(screenWidth, 16),
                      hintStyle: TextStyle(
                        color: AppColors.textDefault.withOpacity(0.8),
                        fontSize: findFontSize(screenWidth, 14),
                        fontWeight: FontWeight.w400,
                      ),
                      textStyle: TextStyle(
                        fontSize: findFontSize(screenWidth, 14),
                        color: AppColors.textHeadline,
                      ),
                      fillColor: AppColors.white,
                      contentPadding: findWidth(screenWidth, 19),
                      isObscure: visibilityState.isConfirmPasswordObscured,
                      onToggleVisibility: () {
                        context.read<ResetPasswordVisibilityCubit>().toggleConfirmPasswordVisibility();
                      },
                    );
                  },
                ),
                SizedBox(height: findHeight(screenHeight, 40)),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      loadingText: "Resetting...",
                      isLoading: state is AuthLoadingState,
                      width: double.infinity,
                      horizontalPudding: findWidth(screenWidth, 8),
                      verticalPudding: findWidth(screenWidth, 20),
                      fillColor: AppColors.primary,
                      borderColor: AppColors.primary,
                      gradientColor: [
                        AppColors.primary,
                        AppColors.gradientButton.withAlpha(200)
                      ],
                      borderWidth: 0.0,
                      radius: findWidth(screenWidth, 16),
                      onTap: () {
                        if(state is AuthLoadingState) return;
                        context.read<AuthBloc>().add(AuthInputEvent(value: widget.email, type: "email"));
                        context.read<AuthBloc>().add(ResetPassword());
                      },
                      child: CustomText(
                        text: "Finish",
                        fontSize: findFontSize(screenWidth, 14),
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
