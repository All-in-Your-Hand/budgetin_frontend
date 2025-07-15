import 'package:flutter/foundation.dart';

/// Environment configuration for the application
/// This class handles environment variables and provides the backend URL
class EnvironmentConfig {
  EnvironmentConfig._();

  /// Backend API URL - uses environment variable or defaults to localhost for development
  static const String _backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// Check if running in debug mode
  static bool get isDebug => kDebugMode;

  /// Get the backend URL
  /// In production (Vercel), this will use the BACKEND_URL environment variable
  /// In development, it defaults to localhost
  static String get backendUrl => _backendUrl;

  /// Get the API base URL
  static String get apiBaseUrl => '$backendUrl/api';

  /// Get the auth base URL (for endpoints that don't follow the /api pattern)
  static String get authBaseUrl => backendUrl;

  /// Get environment info for debugging
  static String get environmentInfo => '''
Backend URL: $backendUrl
API Base URL: $apiBaseUrl
Debug Mode: $isDebug
''';
}
