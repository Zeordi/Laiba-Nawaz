


abstract class AuthEvent{}

class LogInUser extends AuthEvent{}

class LogOutUser extends AuthEvent{}

class SignUpUser extends AuthEvent{}

class IsUserLogin extends AuthEvent{}

class AuthInputEvent extends AuthEvent{
  final String value;
  final String type;
  AuthInputEvent({required this.value, required this.type});
}

class ForgotPasswordEvent extends AuthEvent{
}

class ConfirmOTP extends AuthEvent{}

class ResendOTP extends AuthEvent{}

class ResetPassword extends AuthEvent{}

class ClearAuthEvent extends AuthEvent{}