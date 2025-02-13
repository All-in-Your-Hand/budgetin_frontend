/// Network constants for the application.
class NetworkConstants {
  NetworkConstants._();

  /// Base URL for the API
  static const String baseUrl = 'http://localhost:8080/api';
  static const String testUserId = '67ad2cd59bd7312e431e1444';

  /// API version
  static const String apiVersion = 'v0';

  /// Full API URL with version
  static const String apiUrl = '$baseUrl/$apiVersion';

  /// Timeout duration for API requests (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// Common API endpoints
  static const String authEndpoint = '$apiUrl/auth';
  static const String transactionEndpoint = '$apiUrl/transactions';
  static const String userEndpoint = '$apiUrl/users';
  static const String accountEndpoint = '$apiUrl/accounts';

  /// Transaction endpoints
  static String getTransactionsByUserId(String userId) =>
      '$transactionEndpoint/$userId';
}
