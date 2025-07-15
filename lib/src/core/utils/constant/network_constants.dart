import '../../config/environment_config.dart';

/// Network constants for the application.
class NetworkConstants {
  NetworkConstants._();

  /// Base URL for the API - uses environment configuration
  static String get baseUrl => EnvironmentConfig.apiBaseUrl;

  /// Android base URL - uses environment configuration
  static String get androidBaseUrl => EnvironmentConfig.apiBaseUrl;

  /// API version
  static const String apiVersion = 'v0';

  /// Full API URL with version
  static String get apiUrl => '$baseUrl/$apiVersion';

  /// Timeout duration for API requests (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// Auth endpoints - these don't use /api/v0, they use the base backend URL
  static String get authRegisterEndpoint => '${EnvironmentConfig.backendUrl}/auth/register';
  static String get authLoginEndpoint => '${EnvironmentConfig.backendUrl}/auth/login';

  static String get transactionEndpoint => '$apiUrl/transactions';
  static String get userEndpoint => '$apiUrl/users';
  static String get accountEndpoint => '$apiUrl/accounts';

  /// Account endpoints
  static String getAccountsByUserId(String userId) => '$accountEndpoint/$userId';

  /// Transaction endpoints
  static String getTransactionsByUserId(String userId) => '$transactionEndpoint/$userId';
}
