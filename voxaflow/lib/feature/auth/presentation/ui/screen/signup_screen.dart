import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_button.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/core/widget/input_widgets.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';
import 'package:voxflow/feature/auth/presentation/state/signup_visibility_cubit.dart';
import 'package:voxflow/routes/route_names.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        create: (context) => SignUpVisibilityCubit(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SignUpState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to OTP after successful registration
              context.pushReplacement(RouteNames.otpScreen, extra: {
                "email": state.email,
                "redirectUrl": RouteNames.loginScreen,
              });
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is AuthInputError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.only(
                    left: findWidth(screenWidth, 20),
                    right: findWidth(screenWidth, 20),
                    top: findHeight(screenHeight, 60),
                    bottom: findHeight(screenHeight, 40),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            IconsaxPlusLinear.voice_square,
                            color: AppColors.white,
                            size: findWidth(screenWidth, 32),
                          ),
                          SizedBox(width: findWidth(screenWidth, 10)),
                          CustomText(
                            text: "LUCEMORA",
                            color: AppColors.white,
                            fontSize: findFontSize(screenWidth, 28),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: findHeight(screenHeight, 10)),
                      CustomText(
                        text: "Enterprise Voice Intelligence",
                        color: AppColors.textLight,
                        fontSize: findFontSize(screenWidth, 16),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),

                // Form Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: findWidth(screenWidth, 20)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: findHeight(screenHeight, 30)),
                        CustomText(
                          text: "Create Account",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 28),
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: findHeight(screenHeight, 30)),

                        // Full Name
                        CustomText(
                          text: "Full Name",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 14),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: findHeight(screenHeight, 8)),
                        TextInputField(
                          hintText: "John Doe",
                          prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                          textInputType: TextInputType.name,
                          onChanged: (value) {
                            context.read<AuthBloc>().add(AuthInputEvent(value: value, type: "name"));
                          },
                        ),
                        SizedBox(height: findHeight(screenHeight, 20)),

                        // Email
                        CustomText(
                          text: "Email Address",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 14),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: findHeight(screenHeight, 8)),
                        TextInputField(
                          hintText: "name@company.com",
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                          onChanged: (value) {
                            context.read<AuthBloc>().add(AuthInputEvent(value: value, type: "email"));
                          },
                        ),
                        SizedBox(height: findHeight(screenHeight, 20)),

                        // Password
                        CustomText(
                          text: "Password",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 14),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: findHeight(screenHeight, 8)),
                        BlocBuilder<SignUpVisibilityCubit, SignUpVisibilityState>(
                          builder: (context, visibilityState) {
                            return AppPasswordField(
                              hintText: "Create password",
                              isObscure: visibilityState.isPasswordObscured,
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                              onToggleVisibility: () {
                                context.read<SignUpVisibilityCubit>().togglePasswordVisibility();
                              },
                              onChanged: (value) {
                                context.read<AuthBloc>().add(AuthInputEvent(value: value, type: "password"));
                              },
                            );
                          },
                        ),
                        SizedBox(height: findHeight(screenHeight, 20)),

                        // Confirm Password
                        CustomText(
                          text: "Confirm Password",
                          color: AppColors.textHeadline,
                          fontSize: findFontSize(screenWidth, 14),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: findHeight(screenHeight, 8)),
                        BlocBuilder<SignUpVisibilityCubit, SignUpVisibilityState>(
                          builder: (context, visibilityState) {
                            return AppPasswordField(
                              hintText: "Confirm password",
                              isObscure: visibilityState.isConfirmPasswordObscured,
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                              onToggleVisibility: () {
                                context.read<SignUpVisibilityCubit>().toggleConfirmPasswordVisibility();
                              },
                              onChanged: (value) {
                                context.read<AuthBloc>().add(AuthInputEvent(value: value, type: "confirmPassword"));
                              },
                            );
                          },
                        ),
                        SizedBox(height: findHeight(screenHeight, 40)),

                        // Create Account Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              width: double.infinity,
                              horizontalPudding: findWidth(screenWidth, 8),
                              verticalPudding: findWidth(screenWidth, 16),
                              fillColor: AppColors.primary,
                              borderColor: AppColors.primary,
                              radius: findWidth(screenWidth, 12),
                              isLoading: state is AuthLoadingState,
                              loadingText: "Creating...",
                              gradientColor: [
                                AppColors.primary,
                                AppColors.gradientButton.withAlpha(200)
                              ],
                              onTap: () {
                                context.read<AuthBloc>().add(SignUpUser());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add_alt_1, color: Colors.white, size: findFontSize(screenWidth, 20)),
                                  SizedBox(width: 10),
                                  CustomText(
                                    text: "Create Account",
                                    color: Colors.white,
                                    fontSize: findFontSize(screenWidth, 16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: findHeight(screenHeight, 30)),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Already have an account? ",
                              color: AppColors.textDefault,
                              fontSize: findFontSize(screenWidth, 14),
                              fontWeight: FontWeight.w500,
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go(RouteNames.loginScreen);
                              },
                              child: CustomText(
                                text: "Log In",
                                color: AppColors.primary,
                                fontSize: findFontSize(screenWidth, 14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: findHeight(screenHeight, 20)),
                        
                        // Terms
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "By registering, you agree to our Terms of Service and Privacy Policy.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: findFontSize(screenWidth, 12),
                            ),
                          ),
                        ),
                         SizedBox(height: findHeight(screenHeight, 40)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
