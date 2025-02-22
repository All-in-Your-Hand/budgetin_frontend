import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'right_sidebar_provider.dart';

/// Provider class for managing the sidebar state.
/// This provider handles the collapsible state of the main sidebar.
class SidebarProvider extends ChangeNotifier {
  /// Whether the sidebar is currently collapsed
  bool _isCollapsed = false;

  /// Gets whether the sidebar is currently collapsed
  bool get isCollapsed => _isCollapsed;

  /// The width of the sidebar when expanded
  static const double expandedWidth = 300.0;

  /// The width of the sidebar when collapsed
  static const double collapsedWidth = 85.0;

  /// Toggles the sidebar between collapsed and expanded states
  void toggleCollapsed(BuildContext context) {
    _isCollapsed = !_isCollapsed;

    // On small screens, collapse the right sidebar when expanding this one
    if (!_isCollapsed) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < expandedWidth + RightSidebarProvider.expandedWidth) {
        context.read<RightSidebarProvider>().collapse();
      }
    }

    notifyListeners();
  }

  /// Expands the sidebar.
  void expand(BuildContext context) {
    if (_isCollapsed) {
      _isCollapsed = false;

      // On small screens, collapse the right sidebar when expanding this one
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < expandedWidth + RightSidebarProvider.expandedWidth) {
        context.read<RightSidebarProvider>().collapse();
      }

      notifyListeners();
    }
  }

  /// Collapses the sidebar.
  void collapse() {
    if (!_isCollapsed) {
      _isCollapsed = true;
      notifyListeners();
    }
  }

  void initializeForScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Collapse if screen can't fit both sidebars
    if (width < expandedWidth + RightSidebarProvider.expandedWidth) {
      _isCollapsed = true;
      notifyListeners();
    }
  }
}
