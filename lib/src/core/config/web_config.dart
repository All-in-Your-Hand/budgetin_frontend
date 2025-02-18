import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Configuration class for web-specific settings and optimizations
class WebConfig {
  /// Initialize web-specific configurations
  static void initialize() {
    if (!kIsWeb) return;
    // Web-specific initializations that don't require context
  }

  /// Get web-specific constraints for responsive layout
  static BoxConstraints getWebConstraints(BoxConstraints constraints) {
    if (!kIsWeb) return constraints;

    // Limit maximum width for better readability on wide screens
    return constraints.copyWith(
      maxWidth: constraints.maxWidth.clamp(0.0, 1200.0),
    );
  }

  /// Get web-specific padding
  static EdgeInsets getWebPadding(BuildContext context) {
    if (!kIsWeb) return EdgeInsets.zero;

    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      final horizontalPadding = (width - 1200) / 2;
      return EdgeInsets.symmetric(horizontal: horizontalPadding);
    }
    return EdgeInsets.zero;
  }
}
