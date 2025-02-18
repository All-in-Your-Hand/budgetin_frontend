/// Exception thrown when dependency injection fails
class DependencyInjectionException implements Exception {
  /// Creates a new [DependencyInjectionException]
  const DependencyInjectionException(this.message, [this.originalError]);

  /// The error message describing what went wrong
  final String message;

  /// The original error that caused this exception
  final Object? originalError;

  @override
  String toString() =>
      'DependencyInjectionException: $message${originalError != null ? '\nCaused by: $originalError' : ''}';
}
