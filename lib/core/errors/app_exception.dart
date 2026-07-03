/// DisciplineOS Custom Exceptions
/// Domain-specific error types
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message';
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
  });
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
  });
}

class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException({
    required super.message,
    super.code,
    this.errors,
  });
}

class AIException extends AppException {
  const AIException({
    required super.message,
    super.code,
  });
}
