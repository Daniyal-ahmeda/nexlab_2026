class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<dynamic>> errors;
  const ValidationException({this.message = 'Validation failed', this.errors = const {}});

  @override
  String toString() => message;
}
