import 'package:flutter/material.dart';

/// Provider class for managing the sidebar state.
/// This provider handles the collapsible state of the main sidebar.
class SidebarProvider extends ChangeNotifier {
  /// Whether the sidebar is currently collapsed
  bool _isCollapsed = false;

  /// Gets whether the sidebar is currently collapsed
  bool get isCollapsed => _isCollapsed;

  /// Toggles the sidebar between collapsed and expanded states
  void toggleCollapsed() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }

  /// Expands the sidebar.
  void expand() {
    if (_isCollapsed) {
      _isCollapsed = false;
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
}
