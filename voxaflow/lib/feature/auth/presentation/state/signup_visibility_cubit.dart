import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpVisibilityState {
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;

  SignUpVisibilityState({
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });
}

class SignUpVisibilityCubit extends Cubit<SignUpVisibilityState> {
  SignUpVisibilityCubit() : super(SignUpVisibilityState());

  void togglePasswordVisibility() {
    emit(SignUpVisibilityState(
      isPasswordObscured: !state.isPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    emit(SignUpVisibilityState(
      isPasswordObscured: state.isPasswordObscured,
      isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
    ));
  }
}
