import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:budgetin_frontend/src/core/config/environment_config.dart';

void main() {
  group('EnvironmentConfig Tests', () {
    test('should return correct environment values', () {
      // Test environment detection
      expect(EnvironmentConfig.isDebug, kDebugMode);

      // Test that we can access the backend URL
      expect(EnvironmentConfig.backendUrl, isNotEmpty);
      expect(EnvironmentConfig.apiBaseUrl, isNotEmpty);
      expect(EnvironmentConfig.authBaseUrl, isNotEmpty);
    });

    test('should generate valid URLs', () {
      final backendUrl = EnvironmentConfig.backendUrl;
      final apiBaseUrl = EnvironmentConfig.apiBaseUrl;
      final authBaseUrl = EnvironmentConfig.authBaseUrl;

      // URLs should not be empty
      expect(backendUrl, isNotEmpty);
      expect(apiBaseUrl, isNotEmpty);
      expect(authBaseUrl, isNotEmpty);

      // API base URL should contain the backend URL
      expect(apiBaseUrl, contains(backendUrl));
      expect(apiBaseUrl, endsWith('/api'));

      // Auth base URL should be the same as backend URL
      expect(authBaseUrl, equals(backendUrl));
    });

    test('should provide environment info', () {
      final info = EnvironmentConfig.environmentInfo;
      expect(info, isNotEmpty);
      expect(info, contains('Environment:'));
      expect(info, contains('Backend URL:'));
      expect(info, contains('API Base URL:'));
      expect(info, contains('Debug Mode:'));
    });
  });
}
