import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordVisibilityState {
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;

  ResetPasswordVisibilityState({
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });

  ResetPasswordVisibilityState copyWith({
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
  }) {
    return ResetPasswordVisibilityState(
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured: isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
    );
  }
}

class ResetPasswordVisibilityCubit extends Cubit<ResetPasswordVisibilityState> {
  ResetPasswordVisibilityCubit() : super(ResetPasswordVisibilityState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }
}
