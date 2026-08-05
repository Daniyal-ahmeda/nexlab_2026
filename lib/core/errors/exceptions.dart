class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<dynamic>> errors;
  const ValidationException({this.message = 'Validation failed', this.errors = const {}});
}
