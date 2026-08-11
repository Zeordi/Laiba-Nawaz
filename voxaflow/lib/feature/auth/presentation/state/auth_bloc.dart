



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/core/utility/check_email.dart';
import 'package:voxflow/feature/auth/domain/use_case/auth_user_case.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_event.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUserCase useCase;
  AuthBloc({required this.useCase}) : super(AuthInitialState()) {
    String email = "";
    String password = "";
    String newPassword = "";
    String confirmPassword = "";
    String otp = "";
    String name = "";
    String departmentId = "1"; // Default as per requirement if not in UI

    on<AuthInputEvent>((event, emit) {
      if (event.type == "email") {
        email = event.value;
      } else if (event.type == "password") {
        password = event.value;
      } else if (event.type == "otp") {
        otp = event.value;
      } else if (event.type == "newPassword") {
        newPassword = event.value;
      } else if (event.type == "confirmPassword") {
        confirmPassword = event.value;
      } else if (event.type == "name") {
        name = event.value;
      }
    });

    on<SignUpUser>((event, emit) async {
      if (name.isEmpty) {
        emit(AuthInputError(type: "name", message: "Name can't be empty"));
        return;
      }
      if (email.isEmpty) {
        emit(AuthInputError(type: "email", message: "Email can't be empty"));
        return;
      } else if (!isValidEmail(email)) {
        emit(AuthInputError(type: "email", message: "Please enter a valid email"));
        return;
      } else if (password.isEmpty) {
        emit(AuthInputError(type: "password", message: "Password can't be empty"));
        return;
      } else if (password.length < 6) {
        emit(AuthInputError(type: "password", message: "Password must be at least 6 characters"));
        return;
      } else if (confirmPassword.isEmpty) {
        emit(AuthInputError(type: "confirmPassword", message: "Confirm Password can't be empty"));
        return;
      } else if (confirmPassword != password) {
        emit(AuthInputError(type: "confirmPassword", message: "Passwords do not match"));
        return;
      }

      emit(AuthLoadingState());
      final result = await useCase.signUpUser(name, email, password, departmentId);
      result.fold((left) {
        emit(AuthErrorState(message: left.message));
      }, (right) {
        final tempEmail = email; 
        // email = ""; // Keep email for potential reuse or pass it securely
        password = "";
        otp = "";
        newPassword = "";
        confirmPassword = "";
        name = "";
        emit(SignUpState(message: "Account Created Successfully", email: tempEmail)); 
      });
    });

    on<LogInUser>(
      (event, emit) async {
        if(email.isEmpty){
          emit(AuthInputError(type: "email", message: "Email can't be empty"));
          return;
        }
        else if(!isValidEmail(email)){
          emit(AuthInputError(type: "email", message: "Please enter a valid email"));
          return;
        }
        else if(password.isEmpty){
          emit(AuthInputError(type: "password", message: "Password can't be empty"));
          return;
        }
        emit(AuthLoadingState());
        final result = await useCase.logInUser(email, password);
        result.fold(
          (left) {
            emit(AuthErrorState(message: left.message));
          }, 
          (right) {
            email = "";
            password ="";
            otp ="";
            newPassword = "";
            confirmPassword = "";
            emit(LoggedInState(authEntity: right));
          });
      }
    );

    on<ForgotPasswordEvent>(
      (event, emit) async {
        if(email.isEmpty) {
          emit(AuthInputError(type: "email", message: "Email can't be empty"));
          return;
        }
        else if(!isValidEmail(email)){
          emit(AuthInputError(message: "Invalid Email Address", type: "email"));
          return;
        }
        emit(AuthLoadingState());
        final result = await useCase.forgotPassword(email);
        result.fold(
          (left) => emit(AuthErrorState(message: left.message)), 
          (right) {
            final tempEmail = email;
            email = "";

            password ="";
            otp ="";
            newPassword = "";
            confirmPassword = "";
            emit(AuthSuccessState(email: tempEmail));
          });
      }
    );

    on<LogOutUser>(
      (event, emit) async {
        emit(AuthLoadingState());
        await useCase.logOutUser();
        emit(LoggedOutState());
      }
    );

    on<ClearAuthEvent>(
      (event, emit) {
        email = "";
        password = "";
        otp = "";
        newPassword = "";
        confirmPassword = "";
        emit(AuthInitialState());
      }
    );

    on<ConfirmOTP>(
      (event, emit) async {
        if(email.isEmpty) {
          emit(AuthErrorState(message: "Timeout. Please try again."));
          return;
        }
        else if(otp.isEmpty){
          emit(AuthInputError(type: "otp", message: "OTP can't be empty"));
          return;
        }
        else if(otp.length != 6) {
          emit(AuthInputError(type: "otp", message: "Invalid OTP"));
          return;
        }
        emit(AuthLoadingState());
        final result = await useCase.confirmOTP(email, otp);
        result.fold(
          (left) => emit(AuthErrorState(message: left.message)), 
          (right) {
            final tempEmail = email;
            email = "";
            password = "";
            otp = "";
            newPassword = "";
            confirmPassword = "";
            emit(AuthSuccessState(email: tempEmail, ));
          });
      }
    );
    on<ResendOTP>(
      (event, emit) async {
        if (email.isEmpty) {
          emit(AuthErrorState(message: "Email is required to resend OTP."));
          return;
        }
        emit(AuthLoadingState());
        final result = await useCase.resendVerificationCode(email);
        result.fold(
          (left) => emit(AuthErrorState(message: left.message)),
          (right) => emit(ResendOtpSuccessState(message: "OTP Resent Successfully")),
        );
      }
    );

    on<ResetPassword>(
      (event, emit) async {
        if(email.isEmpty) {
          emit(AuthErrorState(message: "Timeout. Please try again."));
          return;
        }
        else if(newPassword.isEmpty){
          emit(AuthInputError(type: "newPassword", message: "Password can't be empty"));
          return;
        }
        else if(newPassword.length < 6){
          emit(AuthInputError(type: "newPassword", message: "Password must be at least 6 characters"));
          return;
        }
        else if(confirmPassword != newPassword){
          emit(AuthInputError(type: "confirmPassword", message: "Passwords do not match"));
          return;

        }
        emit(AuthLoadingState());
        final result = await useCase.resetPassword(email, newPassword);
        result.fold(
          (left) => emit(AuthErrorState(message: left.message)), 
          (right) {
            email = "";
            password ="";
            otp ="";
            newPassword = "";
            confirmPassword = "";
            emit(AuthSuccessState());
          });
      }
    );

    on<IsUserLogin>(
      (event, emit) async {
        emit(AuthLoadingState());
        final result = await useCase.isLogin();
        result.fold(
          (left) => emit(AuthErrorState(message: left.message)), 
          (right) => emit(LoggedInState(authEntity: right)));
      }
    );
  }
}