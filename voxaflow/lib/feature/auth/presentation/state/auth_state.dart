


import 'package:voxflow/feature/auth/domain/entity/auth_entity.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState{}

class LoggedInState extends AuthState{
  final AuthEntity authEntity;
  LoggedInState({required this.authEntity});
}

class AuthLoadingState extends AuthState{}

class AuthErrorState extends AuthState{
  final String message;
  AuthErrorState({required this.message});
}

class LoggedOutState extends AuthState{}

class SignUpState extends AuthState{
  final String message;
  final String email;
  SignUpState({required this.message, required this.email});
}

class AuthInputError extends AuthState{
  final String type;
  final String message;
  AuthInputError({required this.message, required this.type});
}

class AuthSuccessState extends AuthState{
  final String email;
  AuthSuccessState({this.email = "email"});
}

class ResendOtpSuccessState extends AuthState{
  final String message;
  final String email;
  ResendOtpSuccessState({required this.message, this.email = "email"});
}

