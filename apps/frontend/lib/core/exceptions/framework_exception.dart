// lib/core/exceptions/framework_exception.dart

/// Base exception class for framework errors
class FrameworkException implements Exception {
  const FrameworkException({
    required this.message,
    this.code,
    this.details,
    this.originalError,
    this.context,
  });

  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  final Object? originalError;
  final String? context;

  @override
  String toString() => 'FrameworkException: $message';
}

/// Validation exception
class ValidationException extends FrameworkException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
    super.originalError,
    super.context,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Network exception
class NetworkException extends FrameworkException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
    super.originalError,
    super.context,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Authentication exception
class AuthenticationException extends FrameworkException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
    super.originalError,
    super.context,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Entity not found exception
class EntityNotFoundException extends FrameworkException {
  const EntityNotFoundException({
    required super.message,
    super.code,
    super.details,
    super.originalError,
    super.context,
  });

  @override
  String toString() => 'EntityNotFoundException: $message';
}

/// Operation failed exception
class OperationFailedException extends FrameworkException {
  const OperationFailedException({
    required super.message,
    super.code,
    super.details,
    super.originalError,
    super.context,
  });

  @override
  String toString() => 'OperationFailedException: $message';
}
