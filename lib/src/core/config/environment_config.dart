import 'package:flutter/foundation.dart';

/// Environment configuration for the application
/// This class handles environment variables and provides different configurations
/// for development, staging, and production environments
class EnvironmentConfig {
  EnvironmentConfig._();

  /// Environment types
  static const String _development = 'development';
  static const String _staging = 'staging';
  static const String _production = 'production';

  /// Current environment - defaults to development
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: _development,
  );

  /// Backend API URL - uses environment variable or defaults to localhost
  static const String _backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// Check if running in development mode
  static bool get isDevelopment => _environment == _development;

  /// Check if running in staging mode
  static bool get isStaging => _environment == _staging;

  /// Check if running in production mode
  static bool get isProduction => _environment == _production;

  /// Check if running in debug mode
  static bool get isDebug => kDebugMode;

  /// Get the backend URL for the current environment
  static String get backendUrl {
    if (isProduction) {
      return _backendUrl;
    } else if (isStaging) {
      return _backendUrl;
    } else {
      // Development - use localhost for web, 10.0.2.2 for Android
      return kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
    }
  }

  /// Get the API base URL
  static String get apiBaseUrl => '$backendUrl/api';

  /// Get the auth base URL (for endpoints that don't follow the /api pattern)
  static String get authBaseUrl => backendUrl;

  /// Get environment info for debugging
  static String get environmentInfo => '''
Environment: $_environment
Backend URL: $backendUrl
API Base URL: $apiBaseUrl
Debug Mode: $isDebug
''';
}
