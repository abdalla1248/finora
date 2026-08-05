/// Base class for all application exceptions.
abstract class AppException implements Exception {
  final String message;
  final Object? originalError;

  const AppException(this.message, [this.originalError]);

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.originalError]);
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.originalError]);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class AuthException extends AppException {
  const AuthException(super.message, [super.originalError]);
}
