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
import 'package:voxflow/routes/route_names.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String redirectUrl;
  const OtpScreen({super.key, required this.email, required this.redirectUrl});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill email in Bloc if available, though OtpScreen doesn't have email input field, it uses email prop.
    // AuthBloc confirmOTP uses 'email' and 'otp' from its state.
    // I need to set email in AuthBloc state!
    // Since AuthBloc is shared (implied by previous usage context.read), I should set it.
    context.read<AuthBloc>().add(AuthInputEvent(value: widget.email, type: "email"));

    _otpController.addListener(() {
      context.read<AuthBloc>().add(AuthInputEvent(value: _otpController.text, type: "otp"));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            print(widget.redirectUrl);
            print(widget.email);
            context.replace(widget.redirectUrl, extra: {
              'email': widget.email,
              'redirectUrl': widget.redirectUrl,
            });
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ResendOtpSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            
            // Timer is handled internally by AppOtpField now
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
                BackNavigator(),
                SizedBox(height: findHeight(screenHeight, 20)),
                LoginHeader(
                  hederText: "Verify Code",
                  disc:
                      "Please enter the code we just sent to email ${widget.email}",
                ),
                SizedBox(height: findHeight(screenHeight, 20)),
                CustomText(
                  text: "Enter OTP",
                  fontSize: findFontSize(screenWidth, 14),
                  color: AppColors.textHeadline,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: findHeight(screenHeight, 10)),
                AppOtpField(
                  controller: _otpController,
                  initialTimerInSeconds: 60,
                  onResend: () {

                    context.read<AuthBloc>().add(ResendOTP());
                  },
                  borderColor: AppColors.border,
                  focusedBorderColor: AppColors.borderDark,
                  borderRadius: findWidth(screenWidth, 16),
                  fillColor: AppColors.white,
                  contentPaddingHorizontal: findWidth(
                    screenWidth,
                    20,
                  ),
                  contentPaddingVertical: findHeight(
                    screenHeight,
                    20,
                  ),
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
                ),
                SizedBox(height: findHeight(screenHeight, 55)),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      onTap: () {
                        context.read<AuthBloc>().add(ConfirmOTP());
                      },
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
                      loadingText: "Checking...",
                      isLoading: state is AuthLoadingState,
                      child: CustomText(
                        text: "Verify",
                        fontSize: findFontSize(screenWidth, 14),
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                ),
                SizedBox(height: findHeight(screenHeight, 55)),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Already have an account?  ",
                        fontSize: findFontSize(screenWidth, 16),
                        color: AppColors.textDefault,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go(RouteNames.loginScreen);
                        },
                        child: CustomText(
                          text: "Login Here!",
                          fontSize: findFontSize(screenWidth, 16),
                          color: AppColors.textHeadline,
                          fontWeight: FontWeight.w800,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
