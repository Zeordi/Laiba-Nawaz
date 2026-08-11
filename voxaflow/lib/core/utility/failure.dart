


abstract class Failure{
  final String message;
  Failure({required this.message});
}

class ConnectionError extends Failure{
  ConnectionError(String message) : super(message: message);
}


class ServerError extends Failure{
  ServerError(String message) : super(message: message);
}

class UnauthorizedError extends Failure{
  UnauthorizedError(String message): super(message: message);
}


class NotLoginError extends Failure{
  NotLoginError(String message) : super(message: message);
}