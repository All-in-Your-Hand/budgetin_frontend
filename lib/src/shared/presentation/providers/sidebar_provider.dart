import 'package:flutter/material.dart';

/// Provider that manages the sidebar state
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
}
