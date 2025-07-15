import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'environment_config.dart';
import 'web_config.dart';
import 'web_scroll_behavior.dart';

/// Application configuration class
class AppConfig {
  /// Initialize all configurations
  static void initialize() {
    WidgetsFlutterBinding.ensureInitialized();

    // Log environment info in debug mode
    if (kDebugMode) {
      print('AppConfig: ${EnvironmentConfig.environmentInfo}');
    }

    // Web-specific configurations
    if (kIsWeb) {
      WebConfig.initialize();
    }
  }

  /// Get the global app configurations
  static MaterialApp getConfiguredApp(Widget app) {
    return MaterialApp(
      scrollBehavior: WebScrollBehavior(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: WebScrollBehavior(),
          child: child!,
        );
      },
      home: app,
    );
  }
}
