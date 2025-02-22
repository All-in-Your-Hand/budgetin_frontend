import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom scroll behavior for web platform
class WebScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return kIsWeb ? const ClampingScrollPhysics() : const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (!kIsWeb) return child;

    // For web platform, show scrollbars
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true, // Always show scrollbars on web
      thickness: 8.0,
      child: child,
    );
  }
}
