abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache operation failed.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection detected.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please verify credentials.']);
}

class ValidationFailure extends Failure {
  final Map<String, List<dynamic>> errors;
  const ValidationFailure({String message = 'Validation failed', this.errors = const {}}) : super(message);
}
