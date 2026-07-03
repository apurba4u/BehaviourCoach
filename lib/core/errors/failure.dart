import 'package:equatable/equatable.dart';

/// DisciplineOS Failure Types
/// Used with Either pattern for error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class AIFailure extends Failure {
  const AIFailure({required super.message, super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.code});
}
