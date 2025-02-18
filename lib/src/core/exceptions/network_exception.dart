/// A custom exception class for handling network-related errors in the application.
/// This exception provides information about network failures including an error message
/// and an optional HTTP status code.
class NetworkException implements Exception {
  /// The error message describing the network exception.
  final String message;

  /// The HTTP status code associated with the network error.
  /// This can be null if the error occurred before receiving a response.
  final int? statusCode;

  /// Creates a new [NetworkException] instance.
  ///
  /// [message] is required and describes the error that occurred.
  /// [statusCode] is optional and represents the HTTP status code if available.
  const NetworkException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message (Status Code: $statusCode)';
}
