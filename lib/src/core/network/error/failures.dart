/// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure({required this.message});
}

/// Represents a failure that occurred during server communication
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

/// Represents a failure that occurred during cache operations
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Represents a failure that occurred during network operations
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

/// Represents a failure that occurred during validation
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}
