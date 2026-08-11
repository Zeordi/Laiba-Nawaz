import 'package:flutter_bloc/flutter_bloc.dart';

class LoginVisibilityState {
  final bool isPasswordObscured;

  LoginVisibilityState({this.isPasswordObscured = true});
}

class LoginVisibilityCubit extends Cubit<LoginVisibilityState> {
  LoginVisibilityCubit() : super(LoginVisibilityState());

  void togglePasswordVisibility() {
    emit(LoginVisibilityState(isPasswordObscured: !state.isPasswordObscured));
  }
}
