/// Exception thrown when routing fails
class RouteException implements Exception {
  /// Creates a new [RouteException]
  const RouteException(this.message, [this.originalError]);

  /// The error message describing what went wrong
  final String message;

  /// The original error that caused this exception
  final Object? originalError;

  @override
  String toString() => 'RouteException: $message${originalError != null ? '\nCaused by: $originalError' : ''}';
}
